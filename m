Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbXDTKDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbXDTKDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767040AbXDTKDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:03:07 -0400
Received: from topsns2.0.225.230.202.in-addr.arpa ([202.230.225.126]:65132
	"EHLO topsns2.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754443AbXDTKDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:03:05 -0400
X-Greylist: delayed 1416 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2007 06:03:05 EDT
Date: Fri, 20 Apr 2007 18:39:20 +0900 (JST)
Message-Id: <20070420.183920.128619859.nemoto@toshiba-tops.co.jp>
To: fxzhang@ict.ac.cn
Cc: ralf@linux-mips.org, tiansm@lemote.com, perex@suse.cz,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, zhangfx@lemote.com
Subject: Re: [PATCH 16/16] alsa sound support for mips
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4626276E.3000303@ict.ac.cn>
References: <11766507674145-git-send-email-tiansm@lemote.com>
	<20070418135412.GG3938@linux-mips.org>
	<4626276E.3000303@ict.ac.cn>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 22:13:02 +0800, Fuxin Zhang <fxzhang@ict.ac.cn> wrote:
> >> +#if defined(__mips__) && defined(CONFIG_DMA_NONCOHERENT)
> >> +	/* all mmap using uncached mode */
> >> +	area->vm_page_prot = pgprot_noncached(area->vm_page_prot);
> >> +	area->vm_flags |= ( VM_RESERVED | VM_IO);
> >>     
> >
> > VM_RESERVED will prevent the buffer from being freed.  I assume that is
> > another workaround for some kernel subsystem blowing up when being fed a
> > pointer to an uncached RAM address?  This smells like a memory leak.
> >
> >   
> Oh, VM_RESERVED should be a memory leak problem, we can remove it.
> I don't remember any case of other subsystem's problem, just did not 
> think much
> to add those flags.

I think pgprot_noncached() is needed because user mapping for a DMA
buffer (runtime->dma_area) should be uncache.  If so, doing this in
snd_pcm_mmap() looks a bit suspicious.  It seems snd_pcm_mmap_data()
is a place to do such an adjustment.  But for now, both
snd_pcm_mmap_status() and snd_pcm_mmap_control() returns -ENXIO for
MIPS so this is not a real problem.

And I wonder if VM_IO is really needed.  The area is a DMA buffer,
_not_ a memory mapped IO area, isn't it?

> > I would suggest to get rid of this ifdef with a new arch-specific function
> > like vmap_io_buffer which will do whatever a platform seems fit for this
> > case?
> >   
> I think arch-specific function is the correct way, but don't know what 
> the alsa gods think.

JFYI, there were some discussions on this topic a while ago:

http://lkml.org/lkml/2006/1/25/117

and I'v seen MIPS version of dma_mmap_coherent(), etc. somewhere...

---
Atsushi Nemoto
