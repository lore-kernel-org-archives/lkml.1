Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYKTJcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYKTJcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYKTJcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:32:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52704 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbYKTJcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:32:16 -0500
Date: Thu, 20 Nov 2008 10:31:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 36 of 38] xen: route hardware irqs via Xen
Message-ID: <20081120093159.GA6885@elte.hu>
References: <patchbomb.1226603398@abulafia.goop.org> <00079eee3818aa0205e2.1226603434@abulafia.goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00079eee3818aa0205e2.1226603434@abulafia.goop.org>
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


> +#ifdef CONFIG_XEN_PCI
> +	irq = xen_register_gsi(gsi, triggering, polarity);
> +	if ((int)irq >= 0)
> +		return irq;
> +#endif

why not change irq to 'int' and avoid the cast?

also, please eliminate the #ifdef by turning xen_register_gsi() into a 
'return -1' inline on !CONFIG_XEN_PCI.

> +#ifdef CONFIG_XEN_PCI
> +	xen_pci_init();
> +#endif

hide the #ifdef in a header please. (like you already properly do for
xen_setup_pirqs())

> +	if (rc != 0) {
>  		if (!probing_irq(irq))
>  			printk(KERN_INFO "Failed to obtain physical IRQ %d\n",
>  			       irq);
> +		dump_stack();

generally it's better to use WARN() or WARN_ONCE() to get good debug 
feedback and stackdumps. (they also document the reason for the dump)

> @@ -523,8 +526,6 @@
>  	} else
>  		irq = find_unbound_irq();
>  
> -	spin_unlock(&irq_mapping_update_lock);
> -
>  	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
>  				      handle_level_irq, "pirq");

hm, looks like a stray bugfix?

	Ingo
