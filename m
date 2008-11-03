Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYKCIhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYKCIhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYKCIhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:37:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35563 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbYKCIhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:37:40 -0500
Date: Mon, 3 Nov 2008 09:37:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keithp@keithp.com>
Cc: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add io-mapping functions to dynamically map large
	device apertures
Message-ID: <20081103083727.GA11730@elte.hu>
References: <1225392985-6832-1-git-send-email-eric@anholt.net> <1225392985-6832-2-git-send-email-eric@anholt.net> <20081031092125.GC14127@elte.hu> <1225472369.10543.27.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225472369.10543.27.camel@koto.keithp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Keith Packard <keithp@keithp.com> wrote:

> On Fri, 2008-10-31 at 10:21 +0100, Ingo Molnar wrote:
> 
> > it's ugly and inflexible to put x86 dependencies into generic headers. 
> > (even though with a high likelyhood 32-bit x86 will be the only arch 
> > to ever implement the iomap_atomic() APIs)
> > 
> > Instead please add a HAVE_ATOMIC_IOMAP define to arch/x86/Kconfig:
> > 
> >  config HAVE_ATOMIC_IOMAP
> >          def_bool y
> >          depends on X86_32
> > 
> > ... and use #ifndef HAVE_ATOMIC_IOMAP in include/linux/io-mapping.h 
> > instead of #ifdef CONFIG_X86_64.
> 
> Just to clarify the issue here: there are two separate 
> implementations of the io_mapping API -- one for 'large address 
> space' machines where ioremap_wc can handle the typical graphics 
> aperture within the kernel virtual map, and the other using 
> iomap_atomic_prot_pfn for machines with puny address spaces.
> 
> All large address space machines can provide the io_mapping API 
> without any archtecture-specific support. For efficient 32-bit 
> io_mapping support, we require the new iomap_atomic_prot_pfn 
> function.
> 
> So, it seems like what I want to do is use the large address space 
> code on any machine which supports it, and then use the 
> iomap_atomic_prot_pfn version for small address space machines which 
> have the iomap_atomic_prot_pfn function.

Correct.

> What I think you're suggesting is to just assume that machines 
> without iomap_atomic_prot_pfn have address spaces large enough to 
> support the ioremap_wc path. The alternative is to create a third 
> (slow) path (which I did before the iomap_atomic_prot_pfn API was 
> introduced) that uses ioremap_wc at run time for small address space 
> machines without iomap_atomic_prot_pfn.
> 
> Let me know which you'd prefer and I'll get a patch out ASAP.

Please lets keep it simple: i.e. always use ioremap_wc() when there's 
no iomap_atomic_prot_pfn() 32-bit API provided.

( and by all means ioremap_wc() will just work fine on most 32-bit
  architectures out of box: they dont go about trying to map hundreds 
  of megabytes of graphics aperture. If they nevertheless need it, 
  they can implement iomap_atomic_prot_pfn() to add support. )

	Ingo
