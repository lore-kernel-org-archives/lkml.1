Return-Path: <linux-kernel-owner+w=401wt.eu-S1761084AbYENP0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084AbYENP0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYENP0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:26:07 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:33074 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYENP0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:26:05 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Date: Wed, 14 May 2008 09:26:04 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
References: <4823AAF2.7070102@keyaccess.nl> <200805131718.40138.bjorn.helgaas@hp.com> <482ADF34.2010004@keyaccess.nl>
In-Reply-To: <482ADF34.2010004@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805140926.05103.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2008 06:46:44 am Rene Herman wrote:
> On 14-05-08 01:18, Bjorn Helgaas wrote:
> 
> > On Tuesday 13 May 2008 11:33:25 am Rene Herman wrote:
> 
> >> No, isa_device is its own thing, on its own isa_bus (*). It has a struct 
> >> device * readily available though...
> >>
> >> (*) drivers/base/isa.c, and explanatory changelog at:
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a5117ba7da37deb09df5eb802dace229b3fb1e9f
> > 
> > Thanks for the nice changelog.
> > 
> > isa_register_driver() currently doesn't set a DMA mask.  Should it?
> 
> If it's going to be useful, definitely. The attached does not just set
> 
>    dev->dma_mask = &dev->coherent_dma_mask
> 
> as in the fallback_dev when dma_alloc_coherent() is passed a NULL device 
> only due to the mask juggling in snd_dma_hack_alloc_coherent() (which 
> wouldn't break, but...) but introduces its own copy in struct isa_dev 
> same as struct pnp_dev. As far as I'm aware, there's no actual reason 
> for keeping it other than that and if the hack could go I'd rather lose 
> the private mask copy again also.
> 
> (the device model still uses a plain u64 by the way but I guess the 
> clean type would be a dma64_addr_t)
> 
> Inlining is whitespace-failing here. Patch itself is trivial...
> 
> > I only see about 35 dma_alloc_coherent() calls that pass NULL.  I 
> > guess even those would be a fair amount of work to change, and I 
> > suppose there would be more that I missed.
> 
> At least the ALSA one isn't passing a literal NULL it seems. But yes, 
> current NULL-hack reinstatement (it's been merged by Linus already) is 
> definitely the correct fix for now.
> 
> Would like a comment on the snd_dma_hack_alloc_coherent thing first (no 
> signoff...) but other than that I'll submit this in preparation for it 
> being useful, I guess?

Yes, I like this patch.
