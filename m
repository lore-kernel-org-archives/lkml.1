Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYGWTAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYGWTAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 15:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYGWTAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 15:00:40 -0400
Received: from soda.ext.ti.com ([198.47.26.145]:38243 "EHLO soda.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbYGWTAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 15:00:39 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: "Wei, Gang" <gang.wei@intel.com>,
       Linux Power Management List <linux-pm@lists.osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jul 2008 13:59:55 -0500
Subject: RE: [linux-pm] [RFC-PATCH] Improve Menu Governor Prediction of
 interrupted C states.
Thread-Topic: [linux-pm] [RFC-PATCH] Improve Menu Governor Prediction of
 interrupted C states.
Thread-Index: Acjl9NwKQ0on4gDvSK+0rYSuOpnIRwFzHyfwAE0rc+A=
Message-ID: <13B9B4C6EF24D648824FF11BE8967162035C046A40@dlee02.ent.ti.com>
References: <13B9B4C6EF24D648824FF11BE8967162035BEA0EDF@dlee02.ent.ti.com>
 <094BCE01AFBE9646AF220B0B3F367AAB034DBB7A@pdsmsx413.ccr.corp.intel.com>
In-Reply-To: <094BCE01AFBE9646AF220B0B3F367AAB034DBB7A@pdsmsx413.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

I'll give it a try and make some measurements.  It will probable be a week before I can give any feed back.  Its good to see others are looking at this.

Thanks,
Richard W.

> I also found current cpuidle Menu governor should have some problems
> while predicting next non-expected break-event after some expected
> break-events. The measured_us/elapsed_us/predicted_us will become
> larger
> and larger once (measured_us + BREAK_FUZZ >= data->expected_us -
> target->exit_latency). The major point is that it should be
> last_residency, not measured_us, that need to be used to do comparing
> and distinguish between expected & non-expected events.
>
> Below is my draft patch (not tested) for this. It is simple and should
> also be effective for high interrupt rates case.
>
> Jimmy
>
> Signed-off-by: Wei Gang <gang.wei@intel.com>
>
> diff --git a/drivers/cpuidle/governors/menu.c
> b/drivers/cpuidle/governors/menu.c
> index 78d77c5..dea5250 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -80,18 +80,19 @@ static void menu_reflect(struct cpuidle_device
> *dev)
>         if (!(target->flags & CPUIDLE_FLAG_TIME_VALID))
>                 measured_us = USEC_PER_SEC / HZ;
>
> +       /* if wrapping, set to max uint (-1) */
> +       measured_us = (data->elapsed_us < measured_us) ? measured_us :
> -1;
> +
>         /* Predict time remaining until next break event */
> -       if (measured_us + BREAK_FUZZ < data->expected_us -
> target->exit_latency) {
> -               data->predicted_us = max(measured_us,
> data->last_measured_us);
> +       data->predicted_us = max(measured_us, data->last_measured_us);
> +
> +       /* Distinguish between expected & non-expected events */
> +       if (cpuidle_get_last_residency(dev) + BREAK_FUZZ
> +               < data->expected_us - target->exit_latency) {
>                 data->last_measured_us = measured_us;
>                 data->elapsed_us = 0;
> -       } else {
> -               if (data->elapsed_us < data->elapsed_us + measured_us)
> -                       data->elapsed_us = measured_us;
> -               else
> -                       data->elapsed_us = -1;
> -               data->predicted_us = max(measured_us,
> data->last_measured_us);
> -       }
> +       } else
> +               data->elapsed_us = measured_us;
>  }
>
>  /**
>
>
> On Tuesday, July 15, 2008 5:02 AM, Woodruff, Richard wrote:
> > Hi,
> >
> > Any comments on the following?
> >
> > I'm finding with high interrupt rates for some USB devices the menu
> governor
> > guesses wrong enough that throughput drops.
> >
> > With the below tweak tests with fixed data sizes which were taking
> 12s
> to
> > complete drop back to 9s.  Also my standby idle doesn't change
> before
> and
> > after activity with our with out the patch.
> >
> > What it does is simply timestamp incoming irqs, then in the menu
> governor
> > will use current & last irq time delta to refine its guess as to how
> long
> > sleep will happen.
> >
> > Regards,
> > Richard W.
