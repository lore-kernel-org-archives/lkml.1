Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYAPOo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYAPOo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 09:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYAPOoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 09:44:21 -0500
Received: from ns2.suse.de ([195.135.220.15]:58653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbYAPOoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 09:44:20 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Date: Wed, 16 Jan 2008 15:44:15 +0100
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
References: <patchbomb.1200435425@localhost> <478D4197.8060904@goop.org> <20080116142242.GA23993@elte.hu>
In-Reply-To: <20080116142242.GA23993@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161544.15884.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Index: linux-x86.q/include/asm-x86/page.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/page.h
> +++ linux-x86.q/include/asm-x86/page.h
> @@ -11,7 +11,7 @@
>  #ifdef __KERNEL__
>  
>  #define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)


I haven't tested yet, but we looked at that one earlier and I thought
it was ok because 

#define __PHYSICAL_MASK          _AT(phys_addr_t, (_AC(1,ULL) << __PHYSICAL_MASK_SHIFT) - 1)

and 

typedef u64     phys_addr_t;

for PAE. So the expression above should have been already 64bit.



> -#define PTE_MASK		PHYSICAL_PAGE_MASK
> +#define PTE_MASK		(_AT(long, PHYSICAL_PAGE_MASK))

That would mean it is 32bit again because 32bit long is 32bit, but on 32bit 
PAE PTE_MASK definitely needs to be 64bit.

So I would be surprised if the patch works.

The problem seems to be rather that PAGE_MASK does not include the bits above 32bit. 
Something like

#define PHYSICAL_PAGE_MASK (__PHYSICAL_MASK & ~(phys_addr_t)(PAGE_SIZE-1))

should work (untested) 

-Andi
