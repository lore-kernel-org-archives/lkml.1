Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbYGJPuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbYGJPuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYGJPuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:50:13 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:33373 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750907AbYGJPuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:50:11 -0400
Date: Thu, 10 Jul 2008 21:19:43 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [Libcg-devel] [RFC] How to handle the rules engine for cgroups
Message-ID: <20080710154943.GE18228@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
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

Where I see complications is handling forks happening in that time. It
will take us a long time to ensure that a fork bomb goes into the
correct cgroup as an example.

Also another issue, where does the pid reside in the memory/cpu hierarchy.
If it is not in the correct cgroup at the time of exec, or soon after
exec, the wrong cgroup is getting charged.

I liked the other idea you posted about in the other mail, having
wrappers around. I believe that can be done at distro level, which
should not really be too tough.

Or maybe we can use something like selinux (ok, this really is a shot in
the dark, i should read up before opening my mouth here.)

Thanks,
-- 
regards,
Dhaval
