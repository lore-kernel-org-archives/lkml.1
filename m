Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYGJOI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYGJOI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYGJOIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:08:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbYGJOIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:08:20 -0400
Date: Thu, 10 Jul 2008 10:06:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paul Menage <menage@google.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Message-ID: <20080710140624.GB3782@redhat.com>
References: <20080701191126.GA17376@redhat.com> <6599ad830807100207q26cf2416qb8d38d1d715b5ba0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830807100207q26cf2416qb8d38d1d715b5ba0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 02:07:11AM -0700, Paul Menage wrote:
> Hi Vivek,
> 
> On Tue, Jul 1, 2008 at 12:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > - netlink is not a reliable protocol.
> >        - Messages can be dropped and one can loose message. That means a
> >          newly forked process might never go into right group as meant.
> 
> One way that you could avoid the unreliability would be to not use
> netlink, but instead use cgroups itself.
> 
> What we're looking for is a way to easily distinguish between
> processes that are in the right cgroups, and processes that might be
> in the wrong cgroups. Additionally, we want the children of such
> processes to inherit the same status until we've dealt with them, and
> not be able to change their status themselves.
> 
> That sounds a bit like a cgroup. How about the following?
> 
> - create a cgroup subsystem called "setuid".
> 
> - have a uid_changed() hook called by sys_setuid() and friends; this
> hook would simply attach current to the root cgroup in the "setuid"
> hierarchy if it wasn't already in that cgroup (which can be determined
> with a couple of dereferences from current and no locking, so not
> slowing down the normal case).
> 
> - userspace uses this by:
> 
> mount the setuid hierarchy, e.g. at /mnt/setuid
> create a child cgroup /mnt/setuid/processed
> while true:
>   wait for /mnt/setuid/tasks to be non-empty
>   read a pid from /mnt/setuid/tasks
>   move that pid to the appropriate cgroups in memory/cpu/etc
> hierarchies if necessary
>   move that pid to /mnt/setuid/processed/tasks
> 
> i.e. any pid in the root cgroup of the setuid hierarchy is one that
> needs attention and may need to be moved to different cgroups
> 
> A couple of enhancements to make this more usable might include:
> 
> - adding an API (via a new syscall or an eventfd?) to wait for a
> cgroup to be non-empty, to avoid having to poll /mnt/setuid/tasks more
> than necessary
> 
> - allow the user to designate certain processes and their children as
> uninteresting so that their setuid calls don't trigger them being
> moved back to the root (perhaps indicated via membership of an
> "ignored" cgroup in the setuid hierarchy?)
> 
> This should be more reliable than netlink since it doesn't involve
> userspace having to keep up with a stream of events - we're not
> queuing up events, we're just shifting process group memberships.
> 
> Similar approaches could be used for a "setgid" hierarchy and an
> "execve" hierarchy.

This looks interesting. So above method should solve atleast the
reliability issue of event transport to user space. Got few thougts.

- Hopefully number of hiearchies will not explode as we will be
  mounting one hierarchies per event type (uid change, gid change,
  exec, maybe fork etc.).

- IIUC, it does not solve the concern of delay. So after setuid, or exec,
  tasks continues to run into existing cgroup until user space daemon
  processes the event and moves the task into right cgroup. More on this
  in reply to your other mail.

Thanks
Vivek
