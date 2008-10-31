Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYJaJVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYJaJVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYJaJVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:21:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34624 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYJaJVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:21:34 -0400
Date: Fri, 31 Oct 2008 10:21:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] Add io-mapping functions to dynamically map large
	device apertures
Message-ID: <20081031092125.GC14127@elte.hu>
References: <1225392985-6832-1-git-send-email-eric@anholt.net> <1225392985-6832-2-git-send-email-eric@anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225392985-6832-2-git-send-email-eric@anholt.net>
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


* Eric Anholt <eric@anholt.net> wrote:

> From: Keith Packard <keithp@keithp.com>
> 
> Graphics devices have large PCI apertures which would consume a significant
> fraction of a 32-bit address space if mapped during driver initialization.
> Using ioremap at runtime is impractical as it is too slow. This new set of
> interfaces uses atomic mappings on 32-bit processors and a large static
> mapping on 64-bit processors to provide reasonable 32-bit performance and
> optimal 64-bit performance.
> 
> The current implementation sits atop the io_map_atomic fixmap-based mechanism
> for 32-bit processors.
> 
> This includes some editorial suggestions from Randy Dunlap for
> Documentation/io-mapping.txt
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> Signed-off-by: Eric Anholt <eric@anholt.net>
> ---
>  Documentation/io-mapping.txt |   76 +++++++++++++++++++++++++++
>  include/linux/io-mapping.h   |  118 ++++++++++++++++++++++++++++++++++++++++++

I've applied your three patches to tip/core/resources for testing, 
thanks!

One small detail:

> +++ b/include/linux/io-mapping.h

> +#ifdef CONFIG_X86_64

it's ugly and inflexible to put x86 dependencies into generic headers. 
(even though with a high likelyhood 32-bit x86 will be the only arch 
to ever implement the iomap_atomic() APIs)

Instead please add a HAVE_ATOMIC_IOMAP define to arch/x86/Kconfig:

 config HAVE_ATOMIC_IOMAP
         def_bool y
         depends on X86_32

... and use #ifndef HAVE_ATOMIC_IOMAP in include/linux/io-mapping.h 
instead of #ifdef CONFIG_X86_64.

( Other 32-bit architectures which need an atomic iomap implementation
  for address space reasons can then implement the iomap_atomic*() 
  APIs too and set this same flag, to gain the same generic io_mapping
  implementation. )

Please send this cleanup as a delta patch, ontop of your three 
patches.

	Ingo
