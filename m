Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbZAFBd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZAFBd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 20:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbZAFBds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 20:33:48 -0500
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:8799 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751199AbZAFBdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 20:33:47 -0500
X-Greylist: delayed 1158 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2009 20:33:47 EST
Date: Tue, 06 Jan 2009 10:33:44 +0900 (JST)
Message-Id: <20090106.103344.134344452.nemoto@toshiba-tops.co.jp>
To: haavard.skinnemoen@atmel.com
Cc: anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, dan.j.williams@intel.com
Subject: Re: dw_dmac driver questions
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090105164847.6fbca375@hskinnemoen-d830>
References: <20090105153024.179c9f29@hskinnemoen-d830>
	<20090106.003558.115932572.anemo@mba.ocn.ne.jp>
	<20090105164847.6fbca375@hskinnemoen-d830>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 16:48:47 +0100, Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> > Well, I'm confused...  I reference atmel-mci for client and dw_dmac
> > for dma engine.  Currently, dw_dmac calls dma_map_sg() and atmel-mci
> > calls dma_unmap_sg().  Do you mean atmel-mci will be changed to call
> > dma_map_sg()?
> 
> Yes, I think it should.
> 
> Preferably, I'd like the client to do both mapping and unmapping in all
> cases since it knows best what's actually needed. For example, some
> drivers may be using DMA-coherent buffers, which don't need to be
> mapped at all.

I see, thanks.

> > > > 4. This is a comment on head of dwc_handle_error().
> > > > 
> > > > 	/*
> > > > 	 * The descriptor currently at the head of the active list is
> > > > 	 * borked. Since we don't have any way to report errors, we'll
> > > > 	 * just have to scream loudly and try to carry on.
> > > > 	 */
> > > > 
> > > > But, the bad descriptor can be at any place of the active list, no ?
> > > > For example, if the active list contained two descriptor and latter
> > > > was broken and tasklet was delayed by some reason, the head of the
> > > > list should be good.  
> > > 
> > > Since dwc_scan_descriptors() was just called, all descriptors that were
> > > completed successfully have been removed from the active list. So the
> > > first entry must be the broken one.  
> > 
> > But the removal from the active list is done in tasklet too.  If the
> > CPU was slow and DMA engine was fast enough, DMA engine will process
> > multiple descriptors before the tasklet called, no ?
> 
> The DMA engine stops if it encounters a bad address.

Yes.  And it does not mean the bad descriptor is at head of the active
queue.

1) driver enqueue desc A to active list and start DMA engine
2) driver enqueue desc B to queue list
3) driver enqueue desc C to queue list  (desc C contains bad address)
4) DMA engine finish desc A and raise interrupt
5) tasklet remove desc A from active list and move desc B and C to active list
6) DMA engine finish desc B and raise interrupt
7) DMA engine abort desc C and raise interrupt
8) tasklet detect error

The point is the order of (7) and (8) cannot be expected.  If (7)
comes first, the head of the active list contains desc B at (8) and
that is not a bad descriptor.

---
Atsushi Nemoto
