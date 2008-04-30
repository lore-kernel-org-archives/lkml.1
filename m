Return-Path: <linux-kernel-owner+w=401wt.eu-S1765996AbYD3WnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765996AbYD3WnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYD3WnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:43:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbYD3WnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:43:09 -0400
Message-ID: <4818F513.4080006@zytor.com>
Date: Wed, 30 Apr 2008 15:39:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Arjan van de Ven <arjan@infradead.org>, David Miller <davem@davemloft.net>,
       jeff@garzik.org, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <20080427214837.GA11631@elte.hu>	 <1209335660.3801.79.camel@localhost.localdomain>	 <4815009C.2010809@garzik.org>	 <20080427.154620.177583216.davem@davemloft.net>	 <20080427160120.5788118f@laptopd505.fenrus.org> <1209591844.3774.30.camel@localhost.localdomain>
In-Reply-To: <1209591844.3774.30.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> 
> OK, but look; this is why you broke me.
> 
> The former meaning of ioremap() was give me whatever caching the mtrrs
> set up (assuming you actually have mtrrs.  For voyager, we don't so it
> always meant give me cached memory).
> 

Pre-686 generations of x86 had chipset logic (KEN logic) that did the 
equivalent.  The only change in the 686 was moving this logic into the 
CPU itself.  So no, it didn't always mean "give me cached memory".

> The change broke the QIC ioremap area because it absolutely *requires*
> cached memory.   It drops performance on the Q720 SCSI cards because
> caching was used essentially like write combining to reduce the
> unbursted traffic across the MCA bus.
> 
> When the Voyagers were designed, the only way to get them better
> performace with the slow bus technology was to do a massive amount of
> caching, so they're optimised to the point where every element on the
> voyager bus (sort of like the intel frontside bus) is a primary
> participant in the caching algorithm, and this includes the MCA
> controllers.  So for me, I want every invocation of ioremap to mean
> ioremap_cached() otherwise I don't benefit from the added caches.
> 
> I can fully understand that bus technology has got worse in terms of
> caching since the voyager heydays.  However, I'd rather not be penalised
> for everyone else's hardware failings.  Since the old ioremap is only
> used in the IORESOURCE_CACHABLE case for PCI, and since that used to
> defer to the mtrr settings anyway, it probably does make sense to keep
> it as ioremap_cache() as long as that still defers to the mtrr settings.
> 
> I suppose I could think about an ioremap platform override for voyager
> since, by and large, ioremap_nocache() is the wrong thing on the
> platform.

Sounds like it, or you should just do a global replace of ioremap() with 
ioremap_cache() for the Voyager drivers.

	-hpa
