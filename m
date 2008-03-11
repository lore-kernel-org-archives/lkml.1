Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYCKSBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYCKSBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYCKSAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:00:54 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:52652 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYCKSAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:00:53 -0400
Date: Tue, 11 Mar 2008 15:00:48 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
Message-ID: <20080311150048.4376c73a@mandriva.com.br>
In-Reply-To: <20080311173540.GG27593@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org>
	<20080307175148.3a49d8d3@mandriva.com.br>
	<20080308004654.GQ7365@one.firstfloor.org>
	<20080310150316.752e4489@mandriva.com.br>
	<20080310180843.GC28780@one.firstfloor.org>
	<20080311142624.1dbd3af5@mandriva.com.br>
	<20080311173540.GG27593@one.firstfloor.org>
Organization: Mandriva
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 11 Mar 2008 18:35:40 +0100
Andi Kleen <andi@firstfloor.org> escreveu:

| On Tue, Mar 11, 2008 at 02:26:24PM -0300, Luiz Fernando N. Capitulino wrote:
| > ===================================================================
| > --- linux-2.6.24.orig/sound/core/memalloc.c
| > +++ linux-2.6.24/sound/core/memalloc.c
| > @@ -218,7 +218,6 @@ static void *snd_malloc_dev_pages(struct
| >  	snd_assert(dma != NULL, return NULL);
| >  	pg = get_order(size);
| >  	gfp_flags = GFP_KERNEL
| > -		| __GFP_COMP	/* compound page lets parts be mapped */
| 
| Oops. Thanks. I'll double check that. mask allocator indeed doesn't
| handle __GFP_COMP and nobody should be passing that into dma_alloc_coherent
| anyways. But the bug you got was for the small size wasn't it?

 No, it triggers the BUG_ON() which checks the gfp, not the one
which checks MASK_MIN_SIZE.

 On the other hand I'm not sure whether it does the right thing
(ie, pass size in bytes instead of order) it does:

"""
pg = get_order(size);
[...]
res = dma_alloc_coherent(dev, PAGE_SIZE << pg, dma, gfp_flags);
if (res != NULL)
	inc_snd_pages(pg);
"""

 Maybe it could be changed to:

"""
res = dma_alloc_coherent(dev, size, dma, gfp_flags);
if (res != NULL)
	inc_snd_pages(get_order(size));
"""

 But sound works (simple tests).

| > ok to reduce the pool to 5MB, right?
| 
| Yes, but not leaving any free over is a little risky, someone might need
| more later. But e.g. going down to 8-9MB would be likely possible.

 Ok.

| The long term plan (but that is some time off and a little vague still) 
| would be to let the various subsystem size the mask zone dynamically for 
| their need.

 That sounds cool.

-- 
Luiz Fernando N. Capitulino
