Return-Path: <linux-kernel-owner+w=401wt.eu-S965164AbXBFQl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbXBFQl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965140AbXBFQl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:41:27 -0500
Received: from styx.suse.cz ([82.119.242.94]:36426 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965164AbXBFQl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:41:26 -0500
Date: Tue, 6 Feb 2007 17:44:59 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jbohac@suse.cz, Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 1/9] Fix HPET init race
Message-ID: <20070206164459.GA7271@dwarf.suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <20070201103753.357427000@jet.suse.cz> <20070201183450.6d37d443.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201183450.6d37d443.akpm@osdl.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 06:34:50PM -0800, Andrew Morton wrote:
> On Thu, 01 Feb 2007 10:59:53 +0100 jbohac@suse.cz wrote:
> 
> > Fix a race in the initialization of HPET, which might result in a 
> > 5 minute lockup on boot.
> > 
> 
> What race?  Please always describe bugs when fixing them.

If the value of the HPET_T0_CMP register is reached and exceeded
by the value of the HPET_COUNTER register after HPET_T0_CMP is
read into trigger, but before the first iteration of the while,
the while loop will iterate "endlessly" until the HPET overlaps
eventually (in as much as 5 minutes).

> > 
> > Index: linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
> > ===================================================================
> > --- linux-2.6.20-rc5.orig/arch/x86_64/kernel/apic.c
> > +++ linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
> > @@ -764,10 +767,12 @@ static void setup_APIC_timer(unsigned in
> >  
> >  	/* wait for irq slice */
> >   	if (vxtime.hpet_address && hpet_use_timer) {
> > - 		int trigger = hpet_readl(HPET_T0_CMP);
> > - 		while (hpet_readl(HPET_COUNTER) >= trigger)
> > - 			/* do nothing */ ;
> > - 		while (hpet_readl(HPET_COUNTER) <  trigger)
> > +		int trigger;
> > +		do
> > +			trigger = hpet_readl(HPET_T0_CMP);
> > +		while (hpet_readl(HPET_COUNTER) >= trigger);
> > +
> 
> Is this signedness-safe and wraparound-safe?  It might be better to make
> `trigger' unsigned and do
> 
> 	while (hpet_readl(HPET_COUNTER) - trigger >= 0)


Yes, making trigger unsigned is a good idea (although having it
signed would probably never cause any problem, because this is
called during boot and it takes ~2 minutes for HPET to overflow
the s32)

But no, looping while the unsigned result is >= 0 does not seem
that good an idea to me ;-)

An updated patch follows. It is still not wraparound safe (a
lockup would still happen if it's called ~5 minutes after boot, but
this should never happen -- it's called early during boot)

--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/apic.c	2007-02-06 16:56:00.000000000 +0100
+++ linux-2.6.20-rc5/arch/x86_64/kernel/apic.c	2007-02-06 17:26:42.000000000 +0100
@@ -764,10 +764,12 @@ static void setup_APIC_timer(unsigned in
 
 	/* wait for irq slice */
  	if (vxtime.hpet_address && hpet_use_timer) {
- 		int trigger = hpet_readl(HPET_T0_CMP);
- 		while (hpet_readl(HPET_COUNTER) >= trigger)
- 			/* do nothing */ ;
- 		while (hpet_readl(HPET_COUNTER) <  trigger)
+		u32 trigger;
+		do
+			trigger = hpet_readl(HPET_T0_CMP);
+		while (hpet_readl(HPET_COUNTER) >= trigger);
+
+		while (hpet_readl(HPET_COUNTER) <  trigger)
  			/* do nothing */ ;
  	} else {
 		int c1, c2;


-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

