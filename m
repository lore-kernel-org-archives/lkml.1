Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbXJCXtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbXJCXtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 19:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXJCXtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 19:49:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:51007 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbXJCXtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 19:49:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T4yGn7+FkxbZdAUouFHA6wilRaYMHWH2qe4wKZrRV2qgXLW3YWhng6B8Ze5vAsv2Lr1nUiTV1l8X4e0Pw33s/X0xZimoJadLL+k0Jey+dePeciRl0MDvtg8Vl+EKJpIAi50IvICH9qji+6frI1ghNpPOOQjs3QTnLPyLqkolPCM=
Message-ID: <86802c440710031649n47c9630qf5e8f8fdc569c45e@mail.gmail.com>
Date: Wed, 3 Oct 2007 16:49:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, stable@kernel.org,
       "Greg KH" <greg@kroah.com>, "Chris Wright" <chrisw@sous-sol.org>
In-Reply-To: <20070717154934.GA24231@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org>
	 <20070717154934.GA24231@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> > Ingo Molnar wrote:
> > > Subject: softlockup: fix Xen bogosity
> > > From: Ingo Molnar <mingo@elte.hu>
> > >
> > > this Xen related commit:
> > >
> >
> > Well, not just Xen.  It relates to any virtual environment: kvm,
> > lguest, vmi, xen...  (Not that they all implement a measure of
> > unstolen time.)
> >
> > How about a more descriptive patch title, along the lines of
> > "softlockup watchdog: fix rate limiting"?
>
> uhm, the problem was that it did not work _at all_, not something about
> 'rate limiting'. Yes, i got quite a bit grumpy when i found this,
> because you completely broke the softlockup watchdog via a pretty
> intrusive commit and you apparently didnt even do a minimal check
> whether its functionality was preserved! Updated patch for Andrew/Linus
> and for -stable attached.
>
>         Ingo
>
> ----------------------------->
> Subject: fix the softlockup watchdog to actually work
> From: Ingo Molnar <mingo@elte.hu>
>
> this Xen related commit:
>
>    commit 966812dc98e6a7fcdf759cbfa0efab77500a8868
>    Author: Jeremy Fitzhardinge <jeremy@goop.org>
>    Date:   Tue May 8 00:28:02 2007 -0700
>
>        Ignore stolen time in the softlockup watchdog
>
> broke the softlockup watchdog to never report any lockups. (!)
>
> print_timestamp defaults to 0, this makes the following condition
> always true:
>
>         if (print_timestamp < (touch_timestamp + 1) ||
>
> and we'll in essence never report soft lockups.
>
> apparently the functionality of the soft lockup watchdog was never
> actually tested with that patch applied ...
>
> [this is -stable material too.]
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/softlockup.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> Index: linux/kernel/softlockup.c
> ===================================================================
> --- linux.orig/kernel/softlockup.c
> +++ linux/kernel/softlockup.c
> @@ -79,10 +79,11 @@ void softlockup_tick(void)
>         print_timestamp = per_cpu(print_timestamp, this_cpu);
>
>         /* report at most once a second */
> -       if (print_timestamp < (touch_timestamp + 1) ||
> -               did_panic ||
> -                       !per_cpu(watchdog_task, this_cpu))
> +       if ((print_timestamp >= touch_timestamp &&
> +                       print_timestamp < (touch_timestamp + 1)) ||
> +                       did_panic || !per_cpu(watchdog_task, this_cpu)) {
>                 return;
> +       }
>
>         /* do not print during early bootup: */
>         if (unlikely(system_state != SYSTEM_RUNNING)) {
> -

how about

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 708d488..bbc0292 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -80,7 +80,7 @@ void softlockup_tick(void)
        print_timestamp = per_cpu(print_timestamp, this_cpu);

        /* report at most once a second */
-       if (print_timestamp < (touch_timestamp + 1) ||
+       if (((touch_timestamp - print_timestamp) < 1) ||
                did_panic ||
                        !per_cpu(watchdog_task, this_cpu))


YH
