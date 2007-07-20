Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbXGTGo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbXGTGo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbXGTGor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:44:47 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:57911 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752614AbXGTGoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:44:46 -0400
Subject: Re: [PATCH 1/1][RESEND] Driver for the Atmel on-chip SSC on AT32AP
	and AT91.
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
To: Andrew Victor <andrew@sanpeople.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kernel-avr32 <kernel@avr32linux.org>,
       David Brownell <david-b@pacbell.net>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Hans-Christian Egtvedt <egtvedt@samfundet.no>
In-Reply-To: <1184833759.15007.33.camel@fuzzie.sanpeople.com>
References: <469E6C00.3060506@atmel.com>
	 <1184833759.15007.33.camel@fuzzie.sanpeople.com>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 08:44:28 +0200
Message-Id: <1184913868.16760.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-07-19 at 10:29 +0200, Andrew Victor wrote:
> hi Hans-Christian,
> 
> > This driver is used in the ALSA sound driver for the AT73C213 external DAC on
> > the ATSTK1000 development board for AVR32. This sound driver will be submitted
> > soon.
> 
> Seems to be more of an SCC unit allocation library, but OK.

Correct, makes it easier for other modules to request the SSC peripheral
and get access to the registers and irq.

The AT73C213 sound driver was submitted to the alsa-dev list.

> I've also forwarded a copy of the patch to Frank Mandarino
> <fmandarino@endrelia.com> for his comments.  He maintains the current
> AT91 SSC & ALSA support.  <sound/soc/at91/>
>
> > +/* SSC Receive Clock Mode Register */
> > +#define SSC_RCMR			0x00000010
> > +#define SSC_RCMR_CKG_SIZE			 2
> > +#define SSC_RCMR_CKG_OFFSET			 6
> > +#define SSC_RCMR_CKI_SIZE			 1
> > +#define SSC_RCMR_CKI_OFFSET			 5
> > +#define SSC_RCMR_CKO_SIZE			 3
> 
> I'm personally not a fan of the register & bit definition format the
> AVR32 driver seem to use.
> Can we not rather move the existing include/asm-arm/arch-at91/at91_ssc.h
> to somewhere shared as atmel_ssc.h ?

I disagree, by using the model above the user does not have to know the
bit field offsets as they will need with the defines in
include/asm-arm/arch-at91/at91_ssc.h.

Just an example from sound/soc/at91/at91-ssc.c

rcmr =	  (( ssc_p->rcmr_period		<< 24) & AT91_SSC_PERIOD)
			| (( 1				<< 16) & AT91_SSC_STTDLY)
			| (( AT91_SSC_START_FALLING_RF	     ) & AT91_SSC_START)
			| (( AT91_SSC_CK_RISING		     ) & AT91_SSC_CKI)
			| (( AT91_SSC_CKO_NONE		     ) & AT91_SSC_CKO)
			| (( AT91_SSC_CKS_DIV		     ) & AT91_SSC_CKS);

Would with the header style for atmel-ssc be:

rcmr = SSC_BF(RCMR_PERIOD, ssc_p->rcmr_period)
		| SSC_BF(RCMR_STTDLY, 1)
		| SSC_BF(RCMR_START, 4)
		| SSC_BF(RCMR_CKI, 1)
		| SSC_BF(RCMR_CKO, 0)
		| SSC_BF(RCMR_CKS, 0);

I find the latter more readable and compact, the user also does not need
to know the offset of the different bit-fields.

I agree that describing names for the different bit-fields is nice.
Similar to the way the AVR32 standalone headers are built up.

-- 
With kind regards,

Hans-Christian Egtvedt, siv.ing. (M.Sc.)
Applications Engineer - AVR32 System Solutions - Atmel Norway

