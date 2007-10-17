Return-Path: <linux-kernel-owner+w=401wt.eu-S936489AbXJQCqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936489AbXJQCqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXJQCqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:46:15 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:52781 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbXJQCqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=na4+mLZ8FnO8CKVbita5Wo76NNFgVfdQf6Dn4/HVmifRfgHierxPtCTvBLaiEbEGYC7pXMxiwecIPK36FXw6ihHTAEDmZRh8JNjEd1j71GbQ7fkCLaxkSZZJudn8orP63XB5nCAMQMq9c63fjjHGHfdF8aVb53FTzlV+q/3Y0a8=
Message-ID: <2cd57c900710161946h4396029eoe75522119370309@mail.gmail.com>
Date: Wed, 17 Oct 2007 10:46:12 +0800
From: "Qi Yong" <qiiyoong@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] swsusp: Use platform mode by default
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Starikovskiy" <alexey_y_starikovskiy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org, "Stefan Seyfried" <seife@suse.de>
In-Reply-To: <alpine.LFD.0.98.0705110912290.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200611011323.14830.rjw@sisk.pl>
	 <200611012240.13412.len.brown@intel.com>
	 <2cd57c900705110136r11f23797gdf09df36559c6a3b@mail.gmail.com>
	 <200705111121.51704.rjw@sisk.pl>
	 <alpine.LFD.0.98.0705110912290.3986@woody.linux-foundation.org>
X-Google-Sender-Auth: 3d639717472ba3fc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 11 May 2007, Rafael J. Wysocki wrote:
> >
> > We're working on fixing the breakage, but currently it's difficult, because
> > none of my testboxes has problems with the 'platform' hibernation and I
> > cannot reproduce the reported issues.
>
> The rule for anything ACPI-related has been: no regressions.
>
> It doesn't matter if something fixes 10 boxes, if it breaks a single one,
> it's going to get reverted.
>
> We had much too much of the "two steps forward, one step back" dance with
> ACPI a few years ago, which is the reason that rule got installed (and
> which is why it's ACPI-only: in some other subsystems we accept the fact
> that sometimes we don't know how to fix some hardware issue, but the new
> situation is at least better than the old one).
>
> I agree that it can be aggravating to know that you can fix a problem for
> some people, but then being limited by the fact that it breaks for others.
> But beign able to *rely* on something that used to work is just too
> important, and with ACPI, you can never make a good judgement of which way
> works better (since it really just depends on some random firmware issues
> that we have zero visibility into).
>
> Also, quite often, it may *seem* like something fixes more boxes than it
> breaks, but it's because people report *breakage* only, and then a few
> months later it turns out that it's exactly the other way around: now it's
> a hundred people who report breakage with the *new* code, and the reason
> people thought it fixed more than it broke was that the people for whom
> the old code worked fine obviously never reported it!
>
> So this is why "a single regression is considered more important than ten
> fixes" - because a single regressionr report tends to actually be just the
> first indication of a lot of people who simply haven't tested the new code
> yet! People for whom the old code is broken are more likely to test new
> things.
>
> So I'd just suggest changing the default back to PM_DISK_SHUTDOWN (but
> leave the "pm_ops->enter" testing in place - ie not reverting the other
> commits in the series).
>
> The patch would look something like this. Coywolf, does this fix it for
> you?
>

Yes, it fixes my problem.

(Sorry for this long delayed report. I didn't get the chance to test
and reboot my box.)

This quick test explains me the problem that we should not set
hibernation_mode to HIBERNATION_PLATFORM if it is not !ops". I will
post a formal patch later.

diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index eb72255..8e52553 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -62,7 +62,7 @@ void hibernation_set_ops(struct hibernation_ops *ops)
        mutex_lock(&pm_mutex);
        hibernation_ops = ops;
        if (ops)
-               hibernation_mode = HIBERNATION_PLATFORM;
+               ;
        else if (hibernation_mode == HIBERNATION_PLATFORM)
                hibernation_mode = HIBERNATION_SHUTDOWN;

>                         Linus
>
> ---
>  kernel/power/disk.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/power/disk.c b/kernel/power/disk.c
> index b5f0543..f6aa06e 100644
> --- a/kernel/power/disk.c
> +++ b/kernel/power/disk.c
> @@ -60,9 +60,9 @@ void hibernation_set_ops(struct hibernation_ops *ops)
>         }
>         mutex_lock(&pm_mutex);
>         hibernation_ops = ops;
> -       if (ops)
> -               hibernation_mode = HIBERNATION_PLATFORM;
> -       else if (hibernation_mode == HIBERNATION_PLATFORM)
> +
> +       /* Turn off HIBERNATION_PLATFORM if we no longer have any platform ops */
> +       if (!ops && hibernation_mode == HIBERNATION_PLATFORM)
>                 hibernation_mode = HIBERNATION_SHUTDOWN;
>
>         mutex_unlock(&pm_mutex);
>


-- 
Qi Yong
