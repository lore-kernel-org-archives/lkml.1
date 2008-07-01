Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbYGATNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbYGATNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759159AbYGATNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:13:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758614AbYGATNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:13:15 -0400
Date: Tue, 1 Jul 2008 15:11:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       kamezawa.hiroyu@jp.fujitsu.com, Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC] How to handle the rules engine for cgroups
Message-ID: <20080701191126.GA17376@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While development is going on for cgroup and various controllers, we also
need a facility so that an admin/user can specify the group creation and
also specify the rules based on which tasks should be placed in respective
groups. Group creation part will be handled by libcg which is already
under development. We still need to tackle the issue of how to specify
the rules and how these rules are enforced (rules engine).

I have gathered few views, with regards to how rule engine can possibly be
implemented, I am listing these down.

Proposal 1
==========
Let user space daemon hanle all that. Daemon will open a netlink socket
and receive the notifications for various kernel events. Daemon will
also parse appropriate admin specified rules config file and place the
processes in right cgroup based on rules as and when events happen.

I have written a prototype user space program which does that. Program 
can be found here. Currently it is in very crude shape.

http://people.redhat.com/vgoyal/misc/rules-engine-daemon/user-id-based-namespaces.patch

Various people have raised two main issues with this approach.

- netlink is not a reliable protocol.
	- Messages can be dropped and one can loose message. That means a
	  newly forked process might never go into right group as meant.

- How to handle delays in rule exectuion?
	- For example, if an "exec" happens and by the time process is moved to
	 right group, it might have forked off few more processes or might
	 have done quite some amount of memory allocation which will be
   	 charged to the wring group. Or, newly exec process might get
 	 killed in existing cgroup because of lack of memory (despite the
	 fact that destination cgroup has sufficient memory).

Proposal 2
==========
Implement one or more kernel modules which will implement the rule engine.
User space program can parse the config files and pass it to module.
Kernel will be patched only on select points to look for the rules (as
provided by modules). Very minimal code running inside the kernel if there
are no rules loaded.

Concerns:
- Rules can become complex and we don't want to handle that complexity in
  kernel.

Pros:
- Reliable and precise movement of tasks in right cgroup based on rules.

Proposal 3
==========
How about if additional parameters can be passed to system calls and one
can pass destination cgroup as additional parameter. Probably something
like sys_indirect proposal. Maybe glibc can act as a wrapper to pass
additional parameter so that applications don't need any modifications.

Concerns:
========
- Looks like sys_indirect interface for passing extra flags was rejected.
- Requires extra work in glibc which can also involve parsing of rule
  files. :-(

Proposal 4
==========
Some vauge thoughts are there regarding how about kind of freezing the
process or thread upon fork, exec and unfreeze it once the thread has been
placed in right cgroup. 

Concerns:
========
- Requires reliable netlink protocol otherwise there is a possibility that
  a task never gets unfrozen.
- On what basis does one freeze a thread. There might not be any rules to
  process for that thread we will unnecessarily delay it.


Please provide your inputs regarding what's the best way to handle the
rules engine.

To me, letting the rules live in separate module/modules seems to be a
reasonable way to move forward which will provide reliable and timely
execution of rules and by making it modular, we can remove most of the
complexity from core kernel code.

Thanks
Vivek
