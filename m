Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbXL1Hh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbXL1Hh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 02:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbXL1HhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 02:37:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbXL1HhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 02:37:07 -0500
Date: Thu, 27 Dec 2007 23:34:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Russell Leidich" <rml@google.com>
Cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Message-Id: <20071227233419.d1adf3f3.akpm@linux-foundation.org>
In-Reply-To: <3f1a065b0712271057s150b62f8nb11ebc28dc55f811@mail.gmail.com>
References: <20071217185453.C4597CC562@localhost>
	<20071225140413.e8b4f2cd.akpm@linux-foundation.org>
	<3f1a065b0712271057s150b62f8nb11ebc28dc55f811@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007 10:57:20 -0800 "Russell Leidich" <rml@google.com> wrote:

> Thanks Andrew.  I have a few questions on your comments...
> 
> On Dec 25, 2007 2:04 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > +     unsigned int apic_lv_therm;
> > > +
> > > +     /* Set up APIC_LVTTHMR to issue THERMAL_APIC_VECTOR. */
> > > +     apic_lv_therm = apic_read(APIC_LVTTHMR);
> > > +     /*
> > > +      * See if some agent other than this routine has already initialized
> > > +      * APIC_LVTTHMR, i.e. if it's unmasked, but not equal to the value that
> > > +      * we would have programmed, had we been here before on this core.
> > > +      */
> > > +     if ((!(apic_lv_therm & APIC_LVT_MASKED)) && ((apic_lv_therm &
> > > +             (APIC_MODE_MASK | APIC_VECTOR_MASK)) != (APIC_DM_FIXED |
> > > +             THERMAL_APIC_VECTOR))) {
> > > +             unsigned int cpu = smp_processor_id();
> >
> > afaict this function is called while the calling thread is running
> > preemptibly.  This smp_processor_id() call should have generated a runtime
> > warning if it was tested with all debug options enabled?
> 
> I thought that the whole point of on_each_cpu(&thermal_apic_init,
> NULL, 1, 0) was to ensure that thermal_apic_init() runs
> (nonpreemptibly) on each core.  No?

oh, OK.

> > > +static void default_smp_thermal_interrupt(void) {}
> >
> > static void default_smp_thermal_interrupt(void)
> > {
> > }
> >
> > please.
> >
> >
> > Can this function ever actually be called?
> 
> My colleauge was concerned that we have a do-nothing handler in case
> we get a spurious thermal interrupt.  In my view, there's no point
> programming for the possibility of broken hardware.  On the other
> hand, I do need some sort of indirection to bind the entry.S thermal
> handler from assembly language to either Intel or AMD C code.  Trouble
> is, at compiletime, we might have both Intel and AMD support
> installed, but only one of them should actually receive the interrupt
> at runtime.  So I think I need to do runtime binding, unless I want to
> do CPUID inside the ISR.  What do you think?

If it "can't happen" then we can just leave the vector pointing at 0 until
it gets set up properly.  But nobody ever got fired for mistrusting
hardware (and BIOS) so perhaps what we should do is to leave that there, but
make it emit a suitable diagnostic?  A printk_ratelimit()ed one, probably.

