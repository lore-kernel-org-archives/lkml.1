Return-Path: <linux-kernel-owner+w=401wt.eu-S1765657AbYEGVx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765657AbYEGVx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYEGVxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:53:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:39730 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbYEGVxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:53:41 -0400
Subject: Re: ALSA vs. non coherent DMA
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Timur Tabi <timur@freescale.com>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <4821BB0E.80000@freescale.com>
References: <1210032508.21644.129.camel@pasglop>
	 <s5hmyn3d7d5.wl%tiwai@suse.de>  <4821BB0E.80000@freescale.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 07:53:11 +1000
Message-Id: <1210197191.1421.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 09:22 -0500, Timur Tabi wrote:
> Takashi Iwai wrote:
> 
> > This is a mmap of the data record to be shared in realtime with apps.
> > The app updates its data pointer (appl_ptr) on the mmapped buffer
> > while the driver updates the data (e.g. DMA position, called hwptr) on
> > the fly on the mmapped record.  Due to its real-time nature, it has to
> > be coherent -- at least, it was a problem on ARM.
> 
> This doesn't sound like a coherency problem to me, and least not one you'd find
> on PowerPC.  Both the driver and the application run on the host CPU, so there
> shouldn't be any coherency problem.  My understanding is that a "non coherent"
> platform is one where the host CPU isn't aware when a *hardware device* writes
> directly to memory, e.g. via DMA.

Yes, precisely. I was about to make a reply here. There is some
confusion at least in terminology, in Alsa. This is not DMA coherency,
though it is a problem with virtually tagged data caches that some archs
such as ARM have.

So this is ok for all PowerPC since they all have a physically tagged
data cache.

The real problem -is- still the DMA coherency issue and as I see it, is
two fold:

 - mmap'ing of the result of dma_alloc_coherent() doesn't work. There
are two issues at play here, one is the pgprot that -must- be set to
uncached for such a mapping on non coherent architectures (and non
coherent architectures only), and the other is our virt_to_page() that
will puke on virtual addresses coming from dma_alloc_coherent().

 - mmap'ing of SG lists for non coherent DMA. There the problem is a
mixture of how Alsa allocate the SG buffers mixes with the previous
problem.

I think it's never valid to create an SG list with the output of
dma_alloc_coherent though. We would need a dma_alloc_sg() for that...

sglists are made of pages, thus allocated with GFP, and later DMA mapped
with dma_map_*, however this brings a whole other set of issues/constra
ints such as bouce bufferring on some MMU less platforms if the memory
happens to come out of the wrong place. Also, such mapped buffers are
-not- coherent as they must not be modified via their virtual address
while mapped, -unless- they are also mapped in kernel and/or user space
(vmap & mmap) using some kind of "coherent" attributes such as
pgprot_noncached. (and provided that is possible at all in kernel place
for archs like MIPS).

I don't have an easy answer there, it seems the bogosity roots deep in
alsa, at least for the SG bits. For the non-SG bits, we can probably
work around with an accessor to get the right pgprot and maybe some
variant of virt_to_page() (dma_virt_to_page() ?) that would walk the
kernel page tables to obtain the pfn.

Ben.


