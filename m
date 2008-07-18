Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbYGRS6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbYGRS6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbYGRS5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:57:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254AbYGRS5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:57:54 -0400
Date: Fri, 18 Jul 2008 14:55:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Message-ID: <20080718185552.GJ11492@redhat.com>
References: <20080701191126.GA17376@redhat.com> <20080718185226.f809281d.kamezawa.hiroyu@jp.fujitsu.com> <4880C731.6090904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4880C731.6090904@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 11:39:13AM -0500, Balbir Singh wrote:
> KAMEZAWA Hiroyuki wrote:
> > On Tue, 1 Jul 2008 15:11:26 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> >> Hi,
> >>
> >> While development is going on for cgroup and various controllers, we also
> >> need a facility so that an admin/user can specify the group creation and
> >> also specify the rules based on which tasks should be placed in respective
> >> groups. Group creation part will be handled by libcg which is already
> >> under development. We still need to tackle the issue of how to specify
> >> the rules and how these rules are enforced (rules engine).
> >>
> > 
> > A different topic.
> > 
> > Recently I'm interested in "How to write userland daemon program
> > to control group subsystem." To implement that effectively, we need
> > some notifier between user <-> kernel.
> > 
> > Can we use "inotify" to catch changes in cgroup (by daemon program) ?
> > 
> > For example, create a new file under memory cgroup
> > ==
> >   /opt/memory_cgroup/group_A/notify_at_memory_reach_limit
> > ==
> > And a user watches the file by inotify.
> > The kernel modify modified-time of notify_at_memory_reach_limit file and call
> > fs/notify_user.c::notify_change() against this inode. He can catchthe event
> > by inotify.
> 
> Won't the time latency be an issue (time between exceeding the limit and the
> user space being notified?).

Does not look like it will be an issue. Of course faster the notification
better it is but there will be some latency. So if we get notified on
memory.failcnt then probably will try to increase the memory limit and 
even if it takes some time should be fine. Anyway, there is no way to avoid
latency and hopefully we are not looking at real time notifications and
responses. :-)

> Since the notification does not use user memory at
> the moment (it will not stress the limits futher :)), provided the notification
> handler is not running under the group that has exceeded its limit. Do we expect
> the user space application to ACK that it's seen the notification? We could use
> a netlink channel as well (in the case that we need two way communication).
> 

Can't think of a reason why user space needs to send an ACK to kernel 
after seeing the event. If we are not using netlink and resorting to
inotify coupled with epoll then we should not loose any events and kernel
need not to be acked back.

Given the fact that netlink can drop packets, I am not sure how good an
option netlink is for cgroup notifications. Is it too hard to stick to
filesystem semantics for notifications? 

Thanks
Vivek
