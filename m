Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZEXLJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZEXLJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 07:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZEXLJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 07:09:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60456 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZEXLJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 07:09:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: INFO: possible circular locking dependency at cleanup_workqueue_thread
Date: Sun, 24 May 2009 13:09:13 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Alan Stern <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com> <200905240120.30336.rjw@sisk.pl> <20090524112943.041935da@linux-lm>
In-Reply-To: <20090524112943.041935da@linux-lm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905241309.14253.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 May 2009, Ming Lei wrote:
> ÓÚ Sun, 24 May 2009 01:20:29 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> Ð´µÀ:
> 
> > On Saturday 23 May 2009, Johannes Berg wrote:
> > > On Sat, 2009-05-23 at 00:23 +0200, Rafael J. Wysocki wrote:
> > > 
> > > > > I just arrived at the same conclusion, heh. I can't say I
> > > > > understand these changes though, the part about calling the
> > > > > platform differently may make sense, but calling why disable
> > > > > non-boot CPUs at a different place?
> > > > 
> > > > Because the ordering of platform callbacks and cpu[_up()|_down()]
> > > > is also important, at least on resume.
> > > > 
> > > > In principle we can call device_pm_unlock() right before calling
> > > > disable_nonboot_cpus() and take the lock again right after calling
> > > > enable_nonboot_cpus(), if that helps.
> > > 
> > > Probably, unless the cpu_add_remove_lock wasn't a red herring after
> > > all. I'd test, but I don't have much time today, will be travelling
> > > tomorrow and be at UDS all week next week so I don't know when I'll
> > > get to it -- could you provide a patch and also attach it to
> > > http://bugzilla.kernel.org/show_bug.cgi?id=13245 please? Miles (the
> > > reporter of that bug) has been very helpful in testing before.
> > 
> > OK
> > 
> > The patch is appended for reference (Alan, please have a look; I
> > can't recall why exactly we have called device_pm_lock() from the
> > core suspend/hibernation code instead of acquiring the lock locally
> > in drivers/base/power/main.c) and I'll attach it to the bug entry too.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Do not hold dpm_list_mtx while disabling/enabling
> > nonboot CPUs
> > 
> > We shouldn't hold dpm_list_mtx while executing
> > [disable|enable]_nonboot_cpus(), because theoretically this may lead
> > to a deadlock as shown by the following example (provided by Johannes
> > Berg):
> > 
> > CPU 3       CPU 2                     CPU 1
> >                                       suspend/hibernate
> >             something:
> >             rtnl_lock()               device_pm_lock()
> >                                        -> mutex_lock(&dpm_list_mtx)
> > 
> >             mutex_lock(&dpm_list_mtx)
> > 
> > linkwatch_work
> >  -> rtnl_lock()
> >                                       disable_nonboot_cpus()
> >                                        -> flush CPU 3 workqueue
> > 
> > Fortunately, device drivers are supposed to stop any activities that
> > might lead to the registration of new device objects and/or to the
> > removal of the existing ones way before disable_nonboot_cpus() is
> > called, so it shouldn't be necessary to hold dpm_list_mtx over the
> > entire late part of device suspend and early part of device resume.
> > 
> > Thus, during the late suspend and the early resume of devices acquire
> > dpm_list_mtx only when dpm_list is going to be traversed and release
> > it right after that.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/base/power/main.c |    4 ++++
> >  kernel/kexec.c            |    2 --
> >  kernel/power/disk.c       |   21 +++------------------
> >  kernel/power/main.c       |    7 +------
> >  4 files changed, 8 insertions(+), 26 deletions(-)
> > 
> 
> I try to apply the patch against lastest next tree(2009-05-22), but
> "patch -p1" is failured:
> 
> 
> [lm@linux-lm linux-2.6]$ patch -p1 <  ../patch_rx/INFO_possible_circular_locking_dependency_at_cleanup_workqueue_thread.patch 
> patching file kernel/power/disk.c
> Hunk #1 succeeded at 215 with fuzz 2.
> Hunk #3 succeeded at 278 with fuzz 1.
> Hunk #4 FAILED at 343.
> Hunk #5 succeeded at 396 with fuzz 2 (offset -4 lines).
> Hunk #6 FAILED at 454.
> Hunk #7 succeeded at 485 with fuzz 2.
> 2 out of 7 hunks FAILED -- saving rejects to file kernel/power/disk.c.rej
> patching file kernel/power/main.c
> Hunk #1 succeeded at 289 with fuzz 1 (offset 18 lines).
> patching file drivers/base/power/main.c
> Hunk #3 succeeded at 616 with fuzz 2.
> Hunk #4 succeeded at 625 with fuzz 2.
> patching file kernel/kexec.c
> Hunk #1 succeeded at 1451 with fuzz 2.
> Hunk #2 succeeded at 1488 with fuzz 2.

The patch applies to the mainline, since it'll be a 2.6.30 candidate if it's
confirmed to fix the problem.

Thanks,
Rafael
