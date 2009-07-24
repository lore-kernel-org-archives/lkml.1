Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbZGXFoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbZGXFoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 01:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZGXFoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 01:44:18 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:57562 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZGXFoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 01:44:17 -0400
Date: Fri, 24 Jul 2009 14:44:16 +0900 (JST)
Message-Id: <20090724.144416.71112906.ryov@valinux.co.jp>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Xen-devel] Re: [PATCH 7/9] blkio-cgroup-v9: Page tracking
 hooks
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <5971c26b399a97f51dd10ea497617733.squirrel@webmail-b.css.fujitsu.com>
References: <20090723164935.e97a3ccf.kamezawa.hiroyu@jp.fujitsu.com>
	<20090723.190253.226783703.ryov@valinux.co.jp>
	<5971c26b399a97f51dd10ea497617733.squirrel@webmail-b.css.fujitsu.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Ryo Tsuruta wrote:
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> >> > dm-ioband gives high priority to I/O for swap-out by checking whethe=
> r
> >> > PG_swapcache flag is set on the I/O page, regardless of the assigned
> >> > I/O bandwidth, and the bandwidth consumed for swap-out is charged to
> >> > the owner of the pages as a debt.
> >> > How about this approach?
> >>
> >> I don't think it's reasonable. Why I/O device, scheduler should know
> >> about
> >> such mm-related information ? I think layering is wrong.
> >
> > I think that urgent I/O requests such as swap-out should be notified
> > by setting a special flag in the struct bio, but there is no such
> > mechanism at this time. That is why dm-ioband uses this approach.
> >
> >> And your approatch cannot be a workaround.
> >>
> >> In follwing _typical_ case,
> >>
> >>   - A process does small logging to /var/log/mylog, once in a sec.
> >>     but it uses some amount of cold memory or shmem.
> >>
> >> This process's logging will be delayed _unexpectedly_ by some buggy
> >> process
> >> which does memory leak.
> >
> > Do you mean that the delay in logging is caused since the small process
> > is swapped out unexpectedly by the buggy processes?
> I don't write "small process", "small logging".
> Buggy process does swap-out and cosumes someone else's bandwidth, then,
> loggind will be delayed. Important here is throttle bandwidth consumed by
> buggy prorcess, not other's.

Thank you for explaining it.

> > How about using memory cgroup to prevent the small process from swap-ou=
> t?
> It never be help if memcg is not configured.

blkio-cgroup is recommended to use with memcg. I think that it can be
a good solution to resolve such problem.

> My point is "don't allow anyone to use bandwidth of others."
> Considering job isolation, a thread who requests swap-out should be charg=
> ed
> against bandwidth.

>From another perspective, the swap-out is caused since the buggy
process uses a large amount of memory, so it can be considered as 
the bandwidth of logging process is used due to the buggy process.

Please consider the following case. If a thread who requests swap-out
is charged, the thread is charged other threads' I/O.

   (1)                          --------      (2)
   Process A                   |        |     Process B
   mmaps a large area in   --> | memory | <-- tries to allocate a page.
   the memory and writes       |        |
   data to there.               --------     (3)
                                   |         To get a free page,
                                   |         the data written by Proc.A
                                   |         is written out to the disk.
                                   V         The I/O is done by using
                                ---------    Proc.B's bandwidth.
                               |  disk   |   
                                ---------

Thus I think that page owners should be charged against bandwidth.

Thanks,
Ryo Tsuruta
