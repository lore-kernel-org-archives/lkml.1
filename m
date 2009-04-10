Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbZDJM2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbZDJM2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbZDJM2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:28:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34848 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZDJM2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:28:05 -0400
Date: Fri, 10 Apr 2009 14:27:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [RFC -tip] x86: do_IRQ - send APIC EOI for x86-32 on irq
	without handler v3
Message-ID: <20090410122750.GR21506@elte.hu>
References: <20090409181802.GC7558@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409181802.GC7558@lenovo>
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


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Ingo, I've checked the sources and as far as I see
> we could NOP'ify apic->write indeed but I have
> an internal feeling that this will bring us more problem
> in future (for example it could be the following scenario:
> some screwed APIC would require cleaning of LVT's or
> IRR after resume regardless if it was initialized
> or not at all). Mostly I mean that the idea of making
> apic->write NOP'ified is quite elegant indeed but
> cut off the subset of apic operations (we need
> apic->read anyway) somehow bothering me from inside :)

it's as if assigned a special type of 'dummy apic' struct apic. It 
wont cause problems down the line: we use the new APIC driver 
infrastructure to abstract out quirks.

one small detail:

> +/* Ack APIC irq if it's enabled only */
> +static inline void ack_APIC_irq_safe(void)
> +{
> +#ifdef CONFIG_X86_LOCAL_APIC
> +	if (cpu_has_apic)
> +		ack_APIC_irq();
> +#endif

we dont need the cpu_has_apic check there, do we? In the 
!cpu_has_apic the ->write method should be a dummy.

> -#ifdef CONFIG_X86_64
> -		if (!disable_apic)
> -			ack_APIC_irq();
> -#endif
> -
> +		ack_APIC_irq_safe();

Please keep the ack_APIC_irq() name - it is inherently safe to call 
it if we always give it a meaningful ->write method.

	Ingo
