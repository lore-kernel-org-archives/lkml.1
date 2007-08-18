Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbXHRTES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbXHRTES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 15:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbXHRTEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 15:04:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:50184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845AbXHRTDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 15:03:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [1/4] x86_64: Fail dma_alloc_coherent on dma less devices
Date: Sat, 18 Aug 2007 21:03:25 +0200
User-Agent: KMail/1.9.6
Cc: Muli Ben-Yehuda <muli@il.ibm.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Andrew Morton <akpm@linux-foundation.org>, patches@x86-64.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Takashi Iwai <tiwai@suse.de>
References: <20070815240.194452000@suse.de> <20070815004034.4AB7814DC8@wotan.suse.de> <alpine.LFD.0.999.0708181003430.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708181003430.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708182103.25461.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 August 2007 19:22:18 Linus Torvalds wrote:
> 
> Hmm. I think this is wrong. 
> 
> Why? Because the regular 32-bit x86 code does this all completely 
> differently, and doesn't use dma_mask at all. Instead, it _only_ uses 
> dev->coherent_dma_mask (which, considering the name of the function, 
> would seem to make sense).

Yes, see my discussion with Alan. Likely this needs to be handled
in the caller to really fix the problem (pata_pcmcia oopsing when
it passes a DMA incapable pcmcia device to dma_alloc_coherent) 

Another possible fix proposed by James was to give the pcmcia
devices a dma_mask of 0 which would also work.

> Considering that the oops comes from this:
> 
>         /* Kludge to make it bug-to-bug compatible with i386. i386
>            uses the normal dma_mask for alloc_coherent. */
>         dma_mask &= *dev->dma_mask;

> 
> and that that code is *old*, and comes from when this file was called 
> arch/x86_64/kernel/pci-gart.c, and the comment doesn't seem to even be 

It might be outdated or it might now. The kludge was needed for Alsa because old
i386 ignored the consistent mask and they didn't always set it correctly, but that 
should be obsolete now? I'm not quite sure because sound devices
are not always well tested on large memory systems which are the only
ones who show this problem. Takashi, do you know if all alsa drivers
set consistent mask correctly now?

But I didn't want to touch that that late -- can do it for .24.

Still failing is probably correct in this case so I included the patch.

-Andi
