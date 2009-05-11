Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZEKJ1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZEKJ1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbZEKJ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:27:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44699 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511AbZEKJ1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:27:11 -0400
Date: Mon, 11 May 2009 11:26:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ed Swierk <eswierk@aristanetworks.com>
Subject: Re: [PATCH] x86: read apic id if it is not acpi_lapic -v2
Message-ID: <20090511092655.GC26444@elte.hu>
References: <20090430084145.GD21699@elte.hu> <49FBD0A2.4030309@kernel.org> <20090502070254.GA4791@lenovo> <49FC85A9.2070702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FC85A9.2070702@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> @@ -1590,21 +1591,32 @@ void __init init_apic_mappings(void)
>  	} else
>  		apic_phys = mp_lapic_addr;
>  
> -	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
> +	/* lets check if we may to NOP'ify apic operations */
> +	if (!cpu_has_apic) {
> +		pr_info("APIC: disable apic facility\n");
> +		apic_disable();
> +		return;
> +	}
> +
> +	/*
> +	 * acpi lapic path already map that address in
> +	 * acpi_register_lapic_address()
> +	 */
>  	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
>  				APIC_BASE, apic_phys);
> +	if (acpi_lapic)
> +		return;

why do we return here? We should sanity-check the APIC ID even if we 
come from ACPI.

	Ingo
