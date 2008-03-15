Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbYCOMkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbYCOMkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 08:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYCOMkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 08:40:05 -0400
Received: from smtprelay07.ispgateway.de ([80.67.29.7]:32985 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYCOMkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 08:40:01 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Mar 2008 08:40:01 EDT
From: Ingo Oeser <ingo.oeser@rameria.de>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 4/5]  ntp.c code flow clenaups  (from Ingo)
Date: Sat, 15 Mar 2008 13:39:20 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lkml <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       Ingo Molnar <mingo@elte.hu>
References: <1205553852.6122.76.camel@localhost.localdomain> <1205554210.6122.85.camel@localhost.localdomain> <1205554366.6122.88.camel@localhost.localdomain>
In-Reply-To: <1205554366.6122.88.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151339.21101.ingo.oeser@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Saturday 15 March 2008, john stultz wrote:
> Index: linux-2.6/kernel/time/ntp.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/ntp.c	2008-03-14 20:10:41.000000000 -0700
> +++ linux-2.6/kernel/time/ntp.c	2008-03-14 20:43:48.000000000 -0700
> @@ -275,6 +275,87 @@ static void notify_cmos_timer(void)
>  static inline void notify_cmos_timer(void) { }
>  #endif
>  
> +static inline void process_adjtimex_adj_offset(struct timex *txc, long sec)
> +{
> +	if (txc->modes & ADJ_STATUS) {
> +		if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
> +			time_state = TIME_OK;
> +			time_status = STA_UNSYNC;
> +		}
> +		/* only set allowed bits */
> +		time_status &= STA_RONLY;
> +		time_status |= txc->status & ~STA_RONLY;
> +
> +		switch (time_state) {
> +		case TIME_OK:
> +		start_timer:
> +			if (time_status & STA_INS) {
> +				time_state = TIME_INS;
> +				sec += 86400 - sec % 86400;
> +				hrtimer_start(&leap_timer, ktime_set(sec, 0), HRTIMER_MODE_ABS);
> +			} else if (time_status & STA_DEL) {
> +				time_state = TIME_DEL;
> +				sec += 86400 - (sec + 1) % 86400;
> +				hrtimer_start(&leap_timer, ktime_set(sec, 0), HRTIMER_MODE_ABS);
> +			}
> +			break;
> +		case TIME_INS:
> +		case TIME_DEL:
> +			time_state = TIME_OK;
> +			goto start_timer;
> +			break;

I don't understand, why the goto is required here. 

If you move these two cases in front of case "TIME_OK" and
omit the break, you can remove the goto and the label "start_timer".
Don't forget the /* fall through */ comment then.

If you want to keep this patch a simple code movement,
maybe add a later patch to improve this on top of it.


Best Regards

Ingo Oeser
