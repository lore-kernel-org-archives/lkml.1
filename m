Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbXEKIgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbXEKIgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXEKIgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:36:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:54104 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbXEKIgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aASYb6SwtYgEnTQ/mNYnd5ZSyJ6WoDKHQD4gIDshzrfq9ppaHos3Er4+jGyrS1Zkmx6aUEeLJ0Z1lVdiZbbfucYg9tsINv1RabI3qa2YofRka40OcVPQfPfzHuBIFZeNJZ27L/ck8xR2+TzLp96Jau1D+MmSoCKpj0KCZxk7Vp4=
Message-ID: <2cd57c900705110136r11f23797gdf09df36559c6a3b@mail.gmail.com>
Date: Fri, 11 May 2007 16:36:29 +0800
From: "Coywolf Qi Hunt" <coywolf@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: [PATCH] swsusp: Use platform mode by default
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Starikovskiy" <alexey_y_starikovskiy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org, "Stefan Seyfried" <seife@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200611012240.13412.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200611011323.14830.rjw@sisk.pl>
	 <200611012240.13412.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(This patch is merged in 2.6.20 as commit
9185cfa92507d07ac787bc73d06c42222eec7239)

With this patch, my desktop no longer powers off after hibernate(8).
It just reboots.

This user land fix can restore the old behavior:
echo shutdown > /sys/power/disk

The commit causes user land breakage. Is this behavior on purpose?

thanks,
Qi

On 02/11/06, Len Brown <len.brown@intel.com> wrote:
> Applied.
>
> thanks,
> -Len
>
> On Wednesday 01 November 2006 07:23, Rafael J. Wysocki wrote:
> > It has been reported that on some systems the functionality after a resume
> > from disk is limited if the system is simply powered off during the suspend
> > instead of using the ACPI S4 suspend (aka platform mode).
> >
> > Unfortunately the default is currently to power off the system during the
> > suspend so the users of these systems experience problems after the resume
> > if they don't switch to the platform mode explicitly.  This patch makes swsusp
> > use the platform mode by default to avoid such situations.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  kernel/power/disk.c |    8 +++++---
> >  kernel/power/main.c |    2 +-
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> >
> > Index: linux-2.6.19-rc4-mm1/kernel/power/main.c
> > ===================================================================
> > --- linux-2.6.19-rc4-mm1.orig/kernel/power/main.c
> > +++ linux-2.6.19-rc4-mm1/kernel/power/main.c
> > @@ -29,7 +29,7 @@
> >  DECLARE_MUTEX(pm_sem);
> >
> >  struct pm_ops *pm_ops;
> > -suspend_disk_method_t pm_disk_mode = PM_DISK_SHUTDOWN;
> > +suspend_disk_method_t pm_disk_mode = PM_DISK_PLATFORM;
> >
> >  /**
> >   *   pm_set_ops - Set the global power method table.
> > Index: linux-2.6.19-rc4-mm1/kernel/power/disk.c
> > ===================================================================
> > --- linux-2.6.19-rc4-mm1.orig/kernel/power/disk.c
> > +++ linux-2.6.19-rc4-mm1/kernel/power/disk.c
> > @@ -62,9 +62,11 @@ static void power_down(suspend_disk_meth
> >
> >       switch(mode) {
> >       case PM_DISK_PLATFORM:
> > -             kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> > -             error = pm_ops->enter(PM_SUSPEND_DISK);
> > -             break;
> > +             if (pm_ops && pm_ops->enter) {
> > +                     kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> > +                     error = pm_ops->enter(PM_SUSPEND_DISK);
> > +                     break;
> > +             }
> >       case PM_DISK_SHUTDOWN:
> >               kernel_power_off();
> >               break;
> > -
-- 
Qi Yong
