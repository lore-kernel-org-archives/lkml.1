Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXL0S5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXL0S5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbXL0S5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:57:35 -0500
Received: from smtp-out.google.com ([216.239.33.17]:42249 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbXL0S5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:57:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=mx2RpdZzPGf5VT7ijogAuQvvqp46/kzmSHVMjUprer1nG4OoV77mWkKwmel5/vDkC
	sWJsP+Ahj+1uBQW/qOShQ==
Message-ID: <3f1a065b0712271057s150b62f8nb11ebc28dc55f811@mail.gmail.com>
Date: Thu, 27 Dec 2007 10:57:20 -0800
From: "Russell Leidich" <rml@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20071225140413.e8b4f2cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071217185453.C4597CC562@localhost>
	 <20071225140413.e8b4f2cd.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Andrew.  I have a few questions on your comments...

On Dec 25, 2007 2:04 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > +     unsigned int apic_lv_therm;
> > +
> > +     /* Set up APIC_LVTTHMR to issue THERMAL_APIC_VECTOR. */
> > +     apic_lv_therm = apic_read(APIC_LVTTHMR);
> > +     /*
> > +      * See if some agent other than this routine has already initialized
> > +      * APIC_LVTTHMR, i.e. if it's unmasked, but not equal to the value that
> > +      * we would have programmed, had we been here before on this core.
> > +      */
> > +     if ((!(apic_lv_therm & APIC_LVT_MASKED)) && ((apic_lv_therm &
> > +             (APIC_MODE_MASK | APIC_VECTOR_MASK)) != (APIC_DM_FIXED |
> > +             THERMAL_APIC_VECTOR))) {
> > +             unsigned int cpu = smp_processor_id();
>
> afaict this function is called while the calling thread is running
> preemptibly.  This smp_processor_id() call should have generated a runtime
> warning if it was tested with all debug options enabled?

I thought that the whole point of on_each_cpu(&thermal_apic_init,
NULL, 1, 0) was to ensure that thermal_apic_init() runs
(nonpreemptibly) on each core.  No?

> > +static void default_smp_thermal_interrupt(void) {}
>
> static void default_smp_thermal_interrupt(void)
> {
> }
>
> please.
>
>
> Can this function ever actually be called?

My colleauge was concerned that we have a do-nothing handler in case
we get a spurious thermal interrupt.  In my view, there's no point
programming for the possibility of broken hardware.  On the other
hand, I do need some sort of indirection to bind the entry.S thermal
handler from assembly language to either Intel or AMD C code.  Trouble
is, at compiletime, we might have both Intel and AMD support
installed, but only one of them should actually receive the interrupt
at runtime.  So I think I need to do runtime binding, unless I want to
do CPUID inside the ISR.  What do you think?

-- 
Russell Leidich
