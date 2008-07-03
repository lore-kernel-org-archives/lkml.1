Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbYGCBVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbYGCBVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 21:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYGCBVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 21:21:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46894 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYGCBVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:21:07 -0400
Date: Thu, 3 Jul 2008 10:19:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Message-Id: <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080701191126.GA17376@redhat.com>
References: <20080701191126.GA17376@redhat.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 15:11:26 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> Hi,
> 
> While development is going on for cgroup and various controllers, we also
> need a facility so that an admin/user can specify the group creation and
> also specify the rules based on which tasks should be placed in respective
> groups. Group creation part will be handled by libcg which is already
> under development. We still need to tackle the issue of how to specify
> the rules and how these rules are enforced (rules engine).
> 
> I have gathered few views, with regards to how rule engine can possibly be
> implemented, I am listing these down.
> 
> Proposal 1
> ==========
> Let user space daemon hanle all that. Daemon will open a netlink socket
> and receive the notifications for various kernel events. Daemon will
> also parse appropriate admin specified rules config file and place the
> processes in right cgroup based on rules as and when events happen.
> 
> I have written a prototype user space program which does that. Program 
> can be found here. Currently it is in very crude shape.
> 
> http://people.redhat.com/vgoyal/misc/rules-engine-daemon/user-id-based-namespaces.patch
> 
> Various people have raised two main issues with this approach.
> 
> - netlink is not a reliable protocol.
> 	- Messages can be dropped and one can loose message. That means a
> 	  newly forked process might never go into right group as meant.
> 
> - How to handle delays in rule exectuion?
> 	- For example, if an "exec" happens and by the time process is moved to
> 	 right group, it might have forked off few more processes or might
> 	 have done quite some amount of memory allocation which will be
>    	 charged to the wring group. Or, newly exec process might get
>  	 killed in existing cgroup because of lack of memory (despite the
> 	 fact that destination cgroup has sufficient memory).
> 
Hmm, can't we rework the process event connector to use some reliable
fast interface besides netlink ? (I mean an interface like eventpoll.)
(Or enhance netlink ? ;)

Because "a child inherits parent's" rule is very strong, I think the amount
of events we have to check is much less than we get report. Can't we add some
filter/assumption here ?

BTW, the placement of proc_exec_connector() is not too late ? It seems memory for
creating exec-image is charged to original group...

Thanks,
-Kame

