Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbYDAU0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbYDAU0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758455AbYDAU0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:26:12 -0400
Received: from gherkin.frus.com ([192.158.254.49]:35655 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942AbYDAU0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:26:11 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47F279E7.60801@uwo.ca> "from Tyson Whitehead at Apr 1, 2008 02:07:35
 pm"
To: Tyson Whitehead <twhitehe@uwo.ca>
Date: Tue, 1 Apr 2008 15:26:05 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Michael Cree <mcree@orcon.net.nz>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080401202605.70554DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tyson Whitehead wrote:
> Okay.  I finally got everything tested on my Miata.  Unless I missed 
> something, the es1888_init routine only gets compiled in with 
> CONFIG_ALPHA_MIATA.

The current arch/alpha/kernel/Makefile build logic shows es1888.o built
as part of CONFIG_ALPHA_GENERIC, but if that option isn't enabled, then
enabling any of the following configuration options will cause es1888.o
to be built:

CONFIG_ALPHA_DP264
CONFIG_ALPHA_SHARK
CONFIG_ALPHA_MIATA

> As I've been using the debian generic kernel (i.e., 
> CONFIG_ALPHA_GENERIC), I have never relied on this routine for anything.
> 
> I did discover, however, when I compiled my own kernel (2.6.25-rc5) with 
> CONFIG_ALPHA_MIATA, things stopped working.  Specifically, I no longer 
> got any interupts (with or without the es1888_init patch and with or 
> without the alternative es188xx interupt patch) associated with either 
> the builtin sound card (es1888) or the IDE controller (CMD646).

Interesting.  I *seldom* use the Debian generic kernel.  It's available,
and I install updated versions when they are released, but all of my
testing has been with kernels built from the standard kernel.org sources
with CONFIG_ALPHA_MIATA enabled.

> With CONFIG_ALPHA_GENERIC I only get one interupt with the es18xx driver 
> unless I applied to "alternative interupt" handling code.  Further, 
> sometime between 2.6.14 and 2.6.16, mpg321 (using the alsa driver) 
> started generating "Bad page state in process 'mpg321' ... Trying to fix 
> it up, but a reboot is needed" kernel messages.

This is consistent with what I remember you reporting when we were
looking at this back in the 2.6.14 timeframe.  I was reporting the "bad
page state" problems with 2.6.22-rc6 and -rc7.  In my case, the trigger
was a different application, but only happened when snd_es18xx was
loaded.  Hugh Dickins suggested it was a regression introduced in
2.6.15 that I had managed to successfully avoid tripping on :-).  The
analysis went something like this:

sound/isa/es18xx.c:
	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV, ...
led us to sound/core/memalloc.c:
	res = dma_alloc_coherent(dev, PAGE_SIZE << pg, dma, gfp_flags);
where __GFP_COMP was carefully included in gfp_flags to avoid the
kinds of problems I was seeing (replacing the pre-2.6.15 use of
PageReserved).

Hugh said we could blame him or Nick for removing the special
PageReserved usage, or the Alpha for ignoring gfp_flags in the
following:

  #define dma_alloc_coherent(dev, size, addr, gfp)      \
                pci_alloc_consistent(alpha_gendev_to_pci(dev), size, addr)

The workaround (until the official patch was issued) was a small patch
against arch/alpha/kernel/pci_iommu.c:pci_alloc_consistent() that
replaced "gfp_t gfp = GFP_ATOMIC;" with "gfp_t gfp = GFP_ATOMIC|__GFP_COMP;".
That eliminated the "bad page state" errors for me, and I don't recall
what the official patch was.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
