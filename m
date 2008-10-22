Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbYJVWWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbYJVWWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYJVWWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:22:31 -0400
Received: from lobo.ruivo.org ([66.92.68.119]:40356 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbYJVWWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:22:30 -0400
X-Greylist: delayed 1929 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 18:22:30 EDT
Date: Wed, 22 Oct 2008 17:50:08 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] nmi watchdog: handle NMI_IO_APIC on nmi_watchdog
Message-ID: <20081022215008.GE28317@cathedrallabs.org>
References: <20080313180538.GC4620@cathedrallabs.org> <20080321114752.GA25225@elte.hu> <20080326152417.GE25854@cathedrallabs.org> <20080326182333.GA11187@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326182333.GA11187@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > stop_apic_nmi_watchdog() doesnt currently properly disable the 
> > > generation of NMIs when they come from an IO-APIC, so this will need 
> > > more fixes i believe. One approach would be to save the IO-APIC id and 
> > > pin when the watchdog is set up, and use it later on to poke that 
> > > IO-APIC register to disable NMI generation there.
> > the patch I sent has this change:
> > 
> > @@ -270,6 +270,8 @@ void stop_apic_nmi_watchdog(void *unused
> >                 return;
> >         if (nmi_watchdog == NMI_LOCAL_APIC)
> >                 lapic_watchdog_stop();
> > +       else
> > +               __acpi_nmi_disable(NULL);
> >         __get_cpu_var(wd_enabled) = 0;
> >         atomic_dec(&nmi_active);
> >  }
> > 
> > and:
> > static void __acpi_nmi_disable(void *__unused)
> > {       
> >         apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
> > }
> > 
> > do you think this isn't enough?
> 
> but this stops all NMIs, not just the IO-APIC generated ones, doesnt it? 
external NMIs would come by LINT1, no?
after reading a lot and talking with Vivek, what I understood was that 8259 is
also connected to LINT0, so timer interrupts would be reported both in
IOAPIC and on LINT0. LVT0 is being configured on setup_nmi() to generate
an NMI. Also, the same timer interrupt would generate an regular interrupt
coming from IOAPIC. Clearing the APIC_DM_NMI on LVT0 would disable the
NMI delivery, but not the regular interrupt.
or am I missing something here?

-- 
Aristeu

