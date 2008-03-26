Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYCZPYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYCZPYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYCZPYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:24:34 -0400
Received: from lobo.ruivo.org ([66.92.68.119]:54381 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbYCZPYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:24:33 -0400
Date: Wed, 26 Mar 2008 11:24:17 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] nmi watchdog: handle NMI_IO_APIC on nmi_watchdog
Message-ID: <20080326152417.GE25854@cathedrallabs.org>
References: <20080313180538.GC4620@cathedrallabs.org> <20080321114752.GA25225@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321114752.GA25225@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
> > This patch includes code to handle NMI_IO_APIC enabling/disabling by
> > nmi_watchdog proc file.
> 
> hm:
> 
> > +static void disable_ioapic_nmi_watchdog(void)
> > +{
> > +	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
> > +}
> 
> stop_apic_nmi_watchdog() doesnt currently properly disable the 
> generation of NMIs when they come from an IO-APIC, so this will need 
> more fixes i believe. One approach would be to save the IO-APIC id and 
> pin when the watchdog is set up, and use it later on to poke that 
> IO-APIC register to disable NMI generation there.
the patch I sent has this change:

@@ -270,6 +270,8 @@ void stop_apic_nmi_watchdog(void *unused
                return;
        if (nmi_watchdog == NMI_LOCAL_APIC)
                lapic_watchdog_stop();
+       else
+               __acpi_nmi_disable(NULL);
        __get_cpu_var(wd_enabled) = 0;
        atomic_dec(&nmi_active);
 }

and:
static void __acpi_nmi_disable(void *__unused)
{       
        apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
}

do you think this isn't enough?

-- 
Aristeu

