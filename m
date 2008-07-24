Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYGXLRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYGXLRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYGXLQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:16:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:24086 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYGXLQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:16:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tv5hJSL9abYmJThYKy4iNGkM4DSsVRMDLMHE4Frmdo0PZRLLSayJg8tTt1H0iiKf7r
         XAAxzvOLl1McyNj2dmkcci4UYN7jQFdmh/OBLDpwSzstkubzpq2HxSbEbKLXHpEn3bpb
         OeKVuU7/RUiYQ1TIETxMr03LFCLAa/IN0WRJU=
Date: Thu, 24 Jul 2008 15:16:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() smp-safe
Message-ID: <20080724111631.GA3432@lenovo>
References: <48885DDC.9010003@fujitsu-siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48885DDC.9010003@fujitsu-siemens.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Martin Wilck - Thu, Jul 24, 2008 at 12:47:56PM +0200]
> Hi Thomas and Peter, hi everyone,
>
> Asynchrounous events (e.g.SMIs) which occur during the APIC timer  
> calibration can cause timer miscalibrations, sometimes by large amounts.
>
> This patch fixes this by two separate measures:
>   a) make sure that no significant interruption occurs between APIC and
>      TSC reads
>   b) make sure that the measurement loop isn't significantly longer
>      than originally intended.
>
> I am sorry, due to a misconfiguration of our SMTP server I need to send  
> the patch as attachment.
>
> Martin
>
> -- 
> Martin Wilck
> PRIMERGY System Software Engineer
> FSC IP ESP DEV 6
>
> Fujitsu Siemens Computers GmbH
> Heinz-Nixdorf-Ring 1
> 33106 Paderborn
> Germany
>
> Tel:			++49 5251 8 15113
> Fax:			++49 5251 8 20209
> Email:			mailto:martin.wilck@fujitsu-siemens.com
> Internet:		http://www.fujitsu-siemens.com
> Company Details:	http://www.fujitsu-siemens.com/imprint.html

| Patch: make calibrate_APIC_clock() SMI-safe
| 
| Asynchrounous events (e.g.SMIs) which occur during the APIC timer calibration
| can cause timer miscalibrations, sometimes by large amounts. This patch fixes
| this by two separate measures:
|   a) make sure that no significant interruption occurs between APIC and 
|      TSC reads
|   b) make sure that the measurement loop isn't significantly longer 
|      than originally intended.
| 
| Signed-off-by: Martin Wilck <martin.wilck@fujitsu-siemens.com>
| Signed-off-by: Gerhard Wichert <gerhard.wichert@fujitsu-siemens.com>
| 
| --- linux-2.6.26/arch/x86/kernel/apic_64.c	2008-07-13 23:51:29.000000000 +0200
| +++ linux-2.6.26/arch/x86/kernel/apic_64.c.new	2008-07-24 11:41:24.000000000 +0200
| @@ -314,6 +314,19 @@ static void setup_APIC_timer(void)
|  
|  #define TICK_COUNT 100000000
|  
| +#define MAX_DIFFERENCE 1000UL
| +static inline void __read_tsc_and_apic(unsigned long *tsc, unsigned *apic)
| +{
| +	unsigned long tsc0, tsc1, diff;
| +	do {
| +		rdtscll(tsc0);
| +		*apic = apic_read(APIC_TMCCT);
| +		rdtscll(tsc1);
| +		diff = tsc1 - tsc0;
| +	} while (diff > MAX_DIFFERENCE);
| +	*tsc = tsc0 + (diff >> 1);
| +}
| +
|  static void __init calibrate_APIC_clock(void)
|  {
|  	unsigned apic, apic_start;
| @@ -329,25 +342,37 @@ static void __init calibrate_APIC_clock(
|  	 *
|  	 * No interrupt enable !
|  	 */
| +smi_occured:
|  	__setup_APIC_LVTT(250000000, 0, 0);
|  
| -	apic_start = apic_read(APIC_TMCCT);
|  #ifdef CONFIG_X86_PM_TIMER
|  	if (apic_calibrate_pmtmr && pmtmr_ioport) {
| +		apic_start = apic_read(APIC_TMCCT);
|  		pmtimer_wait(5000);  /* 5ms wait */
|  		apic = apic_read(APIC_TMCCT);
|  		result = (apic_start - apic) * 1000L / 5;
|  	} else
|  #endif
|  	{
| -		rdtscll(tsc_start);
| +		__read_tsc_and_apic(&tsc_start, &apic_start);
|  
|  		do {
| -			apic = apic_read(APIC_TMCCT);
| -			rdtscll(tsc);
| +			__read_tsc_and_apic(&tsc, &apic);
|  		} while ((tsc - tsc_start) < TICK_COUNT &&
|  				(apic_start - apic) < TICK_COUNT);
|  
| +		/*
| +		 * If this takes significantly longer than TICK_COUNT,
| +		 * some interruption must have occured - retry.
| +		 */
| +		if ((tsc - tsc_start) > (TICK_COUNT + TICK_COUNT/1000) ||
| +		    (apic_start - apic) > (TICK_COUNT + TICK_COUNT/1000)) {
| +			printk(KERN_ERR
| +			       "calibrate_APIC_clock: SMI occured? %lx %x",
| +			       tsc - tsc_start, apic_start - apic);
| +			goto smi_occured;
| +		}
| +
|  		result = (apic_start - apic) * 1000L * tsc_khz /
|  					(tsc - tsc_start);
|  	}

Hi, but what if SMI flood happens? We could stuck here forever, don't we?

		- Cyrill -
