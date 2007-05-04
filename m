Return-Path: <linux-kernel-owner+w=401wt.eu-S1161523AbXEDSgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161523AbXEDSgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161599AbXEDSgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:36:44 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:8735 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161603AbXEDSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DkZD5k+47EuDsdLfUsD91fRs7FulNDk3IH1MQfB3+YEnZE1DpYYwSv3NS78kwZzbQd/rOIaO/YoMc42IdC1IImc9grToUVgZ6ToMxnM6vImJ4+L7BEYUH0T7rCeMJxDuL/MtRx8B1cPYUeDMTIcGGkOr0azN0V21khG12yfSwgw=
Message-ID: <8f8ff01d0705041136r18315079w13f95dc3c627a53b@mail.gmail.com>
Date: Fri, 4 May 2007 22:36:41 +0400
From: "Alexey Starikovskiy" <aystarik@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] [RFT][PATCH] swsusp: Change code ordering related to ACPI
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Pavel Machek" <pavel@ucw.cz>, "Marcus Better" <marcus@better.se>
In-Reply-To: <200705041143.02451.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705041143.02451.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Doing _WAK (from pm_finish) before device_resume will brake almost all
ACPI devices.

Regards,
Alex.

On 5/4/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> The change of the hibernation/suspend code ordering made before 2.6.21 has
> caused some systems to have problems related to ACPI.  In particular, the
> 'platform' hibernation mode doesn't work any more on some systems.
>
> It has been confirmed that the appended patch fixes the problem, but it's not
> certain if this changes don't break some other systems.  For this reason, all
> users of hibernation (swsusp, uswsusp) are gently requested to verify if this
> patch doesn't break their systems.
>
> Greetings,
> Rafael
>
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The current code ordering in the hibernation code paths causes some systems to
> have problems.  It has been confirmed by testers that these problems do not
> appear if the acpi_pm_finish() function (called via platform_finish()) is
> executed after device_suspend().
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/disk.c |    4 ++--
>  kernel/power/user.c |    8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> Index: linux-2.6.21/kernel/power/disk.c
> ===================================================================
> --- linux-2.6.21.orig/kernel/power/disk.c       2007-05-04 10:31:51.000000000 +0200
> +++ linux-2.6.21/kernel/power/disk.c    2007-05-04 10:32:12.000000000 +0200
> @@ -195,9 +195,9 @@ int hibernate(void)
>
>         if (in_suspend) {
>                 enable_nonboot_cpus();
> -               platform_finish();
>                 device_resume();
>                 resume_console();
> +               platform_finish();
>                 pr_debug("PM: writing image.\n");
>                 error = swsusp_write();
>                 if (!error)
> @@ -214,9 +214,9 @@ int hibernate(void)
>   Enable_cpus:
>         enable_nonboot_cpus();
>   Resume_devices:
> -       platform_finish();
>         device_resume();
>         resume_console();
> +       platform_finish();
>   Thaw:
>         mutex_unlock(&pm_mutex);
>         unprepare_processes();
> Index: linux-2.6.21/kernel/power/user.c
> ===================================================================
> --- linux-2.6.21.orig/kernel/power/user.c       2007-05-04 10:31:51.000000000 +0200
> +++ linux-2.6.21/kernel/power/user.c    2007-05-04 10:32:12.000000000 +0200
> @@ -169,11 +169,11 @@ static inline int snapshot_suspend(int p
>         }
>         enable_nonboot_cpus();
>   Resume_devices:
> +       device_resume();
> +       resume_console();
>         if (platform_suspend)
>                 platform_finish();
>
> -       device_resume();
> -       resume_console();
>   Finish:
>         mutex_unlock(&pm_mutex);
>         return error;
> @@ -201,11 +201,11 @@ static inline int snapshot_restore(int p
>
>         enable_nonboot_cpus();
>   Resume_devices:
> +       device_resume();
> +       resume_console();
>         if (platform_suspend)
>                 platform_finish();
>
> -       device_resume();
> -       resume_console();
>   Finish:
>         pm_restore_console();
>         mutex_unlock(&pm_mutex);
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
>
