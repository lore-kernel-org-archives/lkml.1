Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbYGCQE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbYGCQE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYGCQES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:04:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYGCQER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:04:17 -0400
Date: Thu, 3 Jul 2008 11:54:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Rik Van Riel <riel@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Message-ID: <20080703155446.GB9275@redhat.com>
References: <20080701191126.GA17376@redhat.com> <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 10:19:57AM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 1 Jul 2008 15:11:26 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > Hi,
> > 
> > While development is going on for cgroup and various controllers, we also
> > need a facility so that an admin/user can specify the group creation and
> > also specify the rules based on which tasks should be placed in respective
> > groups. Group creation part will be handled by libcg which is already
> > under development. We still need to tackle the issue of how to specify
> > the rules and how these rules are enforced (rules engine).
> > 
> > I have gathered few views, with regards to how rule engine can possibly be
> > implemented, I am listing these down.
> > 
> > Proposal 1
> > ==========
> > Let user space daemon hanle all that. Daemon will open a netlink socket
> > and receive the notifications for various kernel events. Daemon will
> > also parse appropriate admin specified rules config file and place the
> > processes in right cgroup based on rules as and when events happen.
> > 
> > I have written a prototype user space program which does that. Program 
> > can be found here. Currently it is in very crude shape.
> > 
> > http://people.redhat.com/vgoyal/misc/rules-engine-daemon/user-id-based-namespaces.patch
> > 
> > Various people have raised two main issues with this approach.
> > 
> > - netlink is not a reliable protocol.
> > 	- Messages can be dropped and one can loose message. That means a
> > 	  newly forked process might never go into right group as meant.
> > 
> > - How to handle delays in rule exectuion?
> > 	- For example, if an "exec" happens and by the time process is moved to
> > 	 right group, it might have forked off few more processes or might
> > 	 have done quite some amount of memory allocation which will be
> >    	 charged to the wring group. Or, newly exec process might get
> >  	 killed in existing cgroup because of lack of memory (despite the
> > 	 fact that destination cgroup has sufficient memory).
> > 
> Hmm, can't we rework the process event connector to use some reliable
> fast interface besides netlink ? (I mean an interface like eventpoll.)
> (Or enhance netlink ? ;)

I see following text in netlink man page.

"However, reliable transmissions from kernel to user are impossible in
 any case. The kernel can’t send a netlink message if the socket buffer
 is full: the message will be dropped and the kernel and  the userspace
 process will no longer have the same view of kernel state. It is up to
 the application to detect when this  happens  (via  the  ENOBUFS error
 returned by recvmsg(2)) and resynchronize."

So at the end of the day, it looks like unreliability comes from the
fact that we can not allocate memory currently so we will discard the
packet.

Are there alternatives as compared to dropping packets?

- Let sender cache the packet and retry later. So maybe netlink layer
  can return error if packet can not be queued and connector can cache the
  event and try sending it later. (Hopefully later memory situation became
  better because of OOM or some process exited or something else...).

  This looks like a band-aid to handle the temporary congestion kind of
  problems. Will not be able to help if consumer is inherently slow and
  event generation is faster.

This probably can be one possible enhancement to connector, but at the end
of the day, any kind of user space daemon will have to accept the fact
that packets can be dropped, leading to lost events. Detect that situation
(using ENOBUFS) and then let admin know about it (logging). I am not sure
what admin is supposed to do after that.

I am CCing Thomas Graf. He might have a better idea of netlink limitations
and is there a way to overcome these.

> 
> Because "a child inherits parent's" rule is very strong, I think the amount
> of events we have to check is much less than we get report. Can't we add some
> filter/assumption here ?
> 

I am not sure if proc connector currently allows filtering of various
events like fork, exec, exit etc. In a quick look it looks like it
does not. But probably that can be worked out. Even then, it will just
help reduce the number of messages queued for user space on that socket
but will not take away the fact that messages can be dropped under
memory pressure. 

> BTW, the placement of proc_exec_connector() is not too late ? It seems memory for
> creating exec-image is charged to original group...
> 

As of today it should happen because newly execed process will run into
same cgroup as parent.  But that's what probably we need to avoid.
For example, if an admin has created three cgroups "database", "browser"
"others" and a user launches "firefox" from shell (assuming shell is running
originally in "others" cgroup), then any memory allocation for firefox should
come from "browser" cgroup and not from "others".

I am assuming that this will be a requirement for enterprise class
systems. Would be good to know the experiences of people who are already
doing some kind of work load management.

Thanks
Vivek
