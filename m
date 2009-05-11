Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbZEKSFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbZEKSFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbZEKSF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:05:29 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37139 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZEKSF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FDI3BZSqTfqB5ucIVeJBbO9NZ1nSy7pqtWZ0kSZ/tJL5Yr1bWRaJ5i4O21g+eFSka8
         y7s7MqN/JJHp9Y5TcIrcy0w4Bi+l66hLMBgMxofbjvkDXglH2XBcgEsJad6fQzlMwAkd
         +baoyFkHF+NJp5sSbLopDtF/fqGq30im7c9bo=
Date: Mon, 11 May 2009 22:05:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: read apic ID in the !acpi_lapic case
Message-ID: <20090511180521.GL4624@lenovo>
References: <49FC85A9.2070702@kernel.org> <tip-4401da6111ac58f94234417427d06a72c4048c74@git.kernel.org> <20090511110234.GH4648@elte.hu> <20090511134140.GH4624@lenovo> <20090511134950.GA949@elte.hu> <4A0863C5.9070206@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0863C5.9070206@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Mon, May 11, 2009 at 10:43:33AM -0700]
...
| >>
| >> x86: apic - fixmap apic address even if apic disabled
| >>
| >> In case if apic were disabled by boot option
| >> we still need read_apic operation. So fixmap
| >> a fake apic area if needed.
| >>
| >> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| >> ---
| >>  arch/x86/kernel/apic/apic.c |   17 +++++++++--------
| >>  1 file changed, 9 insertions(+), 8 deletions(-)
| >>
| >> Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
| >> =====================================================================
| >> --- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
| >> +++ linux-2.6.git/arch/x86/kernel/apic/apic.c
| >> @@ -1591,13 +1591,6 @@ void __init init_apic_mappings(void)
| >>  	} else
| >>  		apic_phys = mp_lapic_addr;
| >>  
| >> -	/* lets check if we may NOP'ify apic operations */
| >> -	if (!cpu_has_apic) {
| >> -		pr_info("APIC: disable apic facility\n");
| >> -		apic_disable();
| >> -		return;
| >> -	}
| >> -
| >>  	/*
| >>  	 * acpi lapic path already maps that address in
| >>  	 * acpi_register_lapic_address()
| >> @@ -1606,7 +1599,15 @@ void __init init_apic_mappings(void)
| >>  		set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
| >>  
| >>  	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
| >> -				APIC_BASE, apic_phys);
| >> +			APIC_BASE, apic_phys);
| >> +
| >> +	/* lets check if we may NOP'ify apic operations */
| >> +	if (!cpu_has_apic) {
| >> +		pr_info("APIC: disable apic facility\n");
| >> +		apic_disable();
| >> +		return;
| >> +	}
| >> +
| > 
| > Will check this - thanks.
| > 
| 
| please check this one instead.
| 
| [PATCH] x86: add native_apic_read_dummy
| 
| when apic is not used ( not there, or disable_apic ), try to install
| dummy read too.
| 
| could save 4k in that case.
| 
| [ Impact: fix bug when try to dump APIC reg ]
| 
| Signed-off-by: Yinghai Lu <yinghai@kernel.org>
| Cc: Cyrill Gorcunov <gorcunov@openvz.org>
| 

Thanks Yinghai, looks really attractive!

But would need a good testing (seems we
rely on read_apic heavily in smp environment
even if it was disabled or not supported).

(btw comment about disable_apic now should
 contain apic->read as well or should be dropped
 completely since all is selfevidence from code
 though this is not that important i believe)

	-- Cyrill
