Return-Path: <linux-kernel-owner+w=401wt.eu-S1161608AbXEDShu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161608AbXEDShu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161532AbXEDShu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:37:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:24730 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161608AbXEDSht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N0W0d1HAZN62SrieJf2tY2yvhEuQYlshuZPFUWXB14xWwIxFwsxFwoA6zMpGejsPZoeDAKJNUVz3mL/vMhkxxM5w7Tn+zPEgWbZmVe0d0TViXnU/BoHUkMRtD3AaFrlMzXM94hO1J1Mk3t3GcD4qT5ZM9fKCM8m9WrqaJ6Zw7fc=
Message-ID: <8f8ff01d0705041137q28720f76j15b0b4abf585302f@mail.gmail.com>
Date: Fri, 4 May 2007 22:37:42 +0400
From: "Alexey Starikovskiy" <aystarik@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] [RFT][PATCH] swsusp: Change code ordering related to ACPI
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Pavel Machek" <pavel@ucw.cz>, "Marcus Better" <marcus@better.se>
In-Reply-To: <8f8ff01d0705041136r18315079w13f95dc3c627a53b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705041143.02451.rjw@sisk.pl>
	 <8f8ff01d0705041136r18315079w13f95dc3c627a53b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I meant executing _WAK _after_ resume of devices...

Alex.

On 5/4/07, Alexey Starikovskiy <aystarik@gmail.com> wrote:
> Doing _WAK (from pm_finish) before device_resume will brake almost all
> ACPI devices.
>
> Regards,
> Alex.
>
> On 5/4/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > The change of the hibernation/suspend code ordering made before 2.6.21 has
> > caused some systems to have problems related to ACPI.  In particular, the
> > 'platform' hibernation mode doesn't work any more on some systems.
> >
> > It has been confirmed that the appended patch fixes the problem, but it's not
> > certain if this changes don't break some other systems.  For this reason, all
> > users of hibernation (swsusp, uswsusp) are gently requested to verify if this
> > patch doesn't break their systems.
> >
> > Greetings,
> > Rafael
> >
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > The current code ordering in the hibernation code paths causes some systems to
> > have problems.  It has been confirmed by testers that these problems do not
> > appear if the acpi_pm_finish() function (called via platform_finish()) is
> > executed after device_suspend().
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  kernel/power/disk.c |    4 ++--
> >  kernel/power/user.c |    8 ++++----
> >  2 files changed, 6 insertions(+), 6 deletions(-)
> >
> > Index: linux-2.6.21/kernel/power/disk.c
> > ===================================================================
> > --- linux-2.6.21.orig/kernel/power/disk.c       2007-05-04 10:31:51.000000000 +0200
> > +++ linux-2.6.21/kernel/power/disk.c    2007-05-04 10:32:12.000000000 +0200
> > @@ -195,9 +195,9 @@ int hibernate(void)
> >
> >         if (in_suspend) {
> >                 enable_nonboot_cpus();
> > -               platform_finish();
> >                 device_resume();
> >                 resume_console();
> > +               platform_finish();
> >                 pr_debug("PM: writing image.\n");
> >                 error = swsusp_write();
> >                 if (!error)
> > @@ -214,9 +214,9 @@ int hibernate(void)
> >   Enable_cpus:
> >         enable_nonboot_cpus();
> >   Resume_devices:
> > -       platform_finish();
> >         device_resume();
> >         resume_console();
> > +       platform_finish();
> >   Thaw:
> >         mutex_unlock(&pm_mutex);
> >         unprepare_processes();
> > Index: linux-2.6.21/kernel/power/user.c
> > ===================================================================
> > --- linux-2.6.21.orig/kernel/power/user.c       2007-05-04 10:31:51.000000000 +0200
> > +++ linux-2.6.21/kernel/power/user.c    2007-05-04 10:32:12.000000000 +0200
> > @@ -169,11 +169,11 @@ static inline int snapshot_suspend(int p
> >         }
> >         enable_nonboot_cpus();
> >   Resume_devices:
> > +       device_resume();
> > +       resume_console();
> >         if (platform_suspend)
> >                 platform_finish();
> >
> > -       device_resume();
> > -       resume_console();
> >   Finish:
> >         mutex_unlock(&pm_mutex);
> >         return error;
> > @@ -201,11 +201,11 @@ static inline int snapshot_restore(int p
> >
> >         enable_nonboot_cpus();
> >   Resume_devices:
> > +       device_resume();
> > +       resume_console();
> >         if (platform_suspend)
> >                 platform_finish();
> >
> > -       device_resume();
> > -       resume_console();
> >   Finish:
> >         pm_restore_console();
> >         mutex_unlock(&pm_mutex);
> > _______________________________________________
> > linux-pm mailing list
> > linux-pm@lists.linux-foundation.org
> > https://lists.linux-foundation.org/mailman/listinfo/linux-pm
> >
>
