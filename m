Return-Path: <linux-kernel-owner+w=401wt.eu-S1423076AbXBBCfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423076AbXBBCfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 21:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423077AbXBBCfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 21:35:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56852 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030218AbXBBCfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 21:35:16 -0500
Date: Thu, 1 Feb 2007 18:34:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: jbohac@suse.cz
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 1/9] Fix HPET init race
Message-Id: <20070201183450.6d37d443.akpm@osdl.org>
In-Reply-To: <20070201103753.357427000@jet.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
	<20070201103753.357427000@jet.suse.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Feb 2007 10:59:53 +0100 jbohac@suse.cz wrote:

> Fix a race in the initialization of HPET, which might result in a 
> 5 minute lockup on boot.
> 

What race?  Please always describe bugs when fixing them.

> 
> Index: linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
> ===================================================================
> --- linux-2.6.20-rc5.orig/arch/x86_64/kernel/apic.c
> +++ linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
> @@ -764,10 +767,12 @@ static void setup_APIC_timer(unsigned in
>  
>  	/* wait for irq slice */
>   	if (vxtime.hpet_address && hpet_use_timer) {
> - 		int trigger = hpet_readl(HPET_T0_CMP);
> - 		while (hpet_readl(HPET_COUNTER) >= trigger)
> - 			/* do nothing */ ;
> - 		while (hpet_readl(HPET_COUNTER) <  trigger)
> +		int trigger;
> +		do
> +			trigger = hpet_readl(HPET_T0_CMP);
> +		while (hpet_readl(HPET_COUNTER) >= trigger);
> +

Is this signedness-safe and wraparound-safe?  It might be better to make
`trigger' unsigned and do

	while (hpet_readl(HPET_COUNTER) - trigger >= 0)

> +		while (hpet_readl(HPET_COUNTER) <  trigger)
>   			/* do nothing */ ;

ditto.
