Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYCKTgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYCKTgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYCKTgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:36:35 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:51234 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYCKTge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:36:34 -0400
Date: Tue, 11 Mar 2008 16:36:30 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
Message-ID: <20080311163630.776484a1@mandriva.com.br>
In-Reply-To: <20080311184926.GI27593@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org>
	<20080307175148.3a49d8d3@mandriva.com.br>
	<20080308004654.GQ7365@one.firstfloor.org>
	<20080310150316.752e4489@mandriva.com.br>
	<20080310180843.GC28780@one.firstfloor.org>
	<20080311142624.1dbd3af5@mandriva.com.br>
	<20080311173540.GG27593@one.firstfloor.org>
	<20080311150048.4376c73a@mandriva.com.br>
	<20080311184926.GI27593@one.firstfloor.org>
Organization: Mandriva
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 11 Mar 2008 19:49:26 +0100
Andi Kleen <andi@firstfloor.org> escreveu:

| > | Oops. Thanks. I'll double check that. mask allocator indeed doesn't
| > | handle __GFP_COMP and nobody should be passing that into dma_alloc_coherent
| > | anyways. But the bug you got was for the small size wasn't it?
| > 
| >  No, it triggers the BUG_ON() which checks the gfp, not the one
| > which checks MASK_MIN_SIZE.
| 
| I see. I misdiagnosed your original problem then. But fixing the 
| size < 16 bytes case was a good idea anyways, someone else would
| have triggered that.

 I see.

| Can you perhaps send me a complete patch fixing that for sound and the 
| __GFP_COMP with description and Signed-off-by etc.? I can add it to my 
| patchkit then and you would be correctly attributed. Otherwise I can do it 
| myself too if you prefer. I'll also do a grep over the tree for other
| such bogus __GFP_COMP users. That was an issue I hadn't considered before.

 Here are you (passed minimal tests).

------
ALSA: Convert snd_malloc_dev_pages() to the mask allocator

The mask allocator do not handle the __GFP_COMP flag and
will BUG_ON() if that flag is passed to it.

Also, we should pass the allocation size in bytes to
dma_alloc_coherent().

Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>

Index: linux-2.6.24/sound/core/memalloc.c
===================================================================
--- linux-2.6.24.orig/sound/core/memalloc.c
+++ linux-2.6.24/sound/core/memalloc.c
@@ -210,20 +210,17 @@ void snd_free_pages(void *ptr, size_t si
 /* allocate the coherent DMA pages */
 static void *snd_malloc_dev_pages(struct device *dev, size_t size, dma_addr_t *dma)
 {
-	int pg;
 	void *res;
 	gfp_t gfp_flags;
 
 	snd_assert(size > 0, return NULL);
 	snd_assert(dma != NULL, return NULL);
-	pg = get_order(size);
 	gfp_flags = GFP_KERNEL
-		| __GFP_COMP	/* compound page lets parts be mapped */
 		| __GFP_NORETRY /* don't trigger OOM-killer */
 		| __GFP_NOWARN; /* no stack trace print - this call is non-critical */
-	res = dma_alloc_coherent(dev, PAGE_SIZE << pg, dma, gfp_flags);
+	res = dma_alloc_coherent(dev, size, dma, gfp_flags);
 	if (res != NULL)
-		inc_snd_pages(pg);
+		inc_snd_pages(get_order(size));
 
 	return res;
 }



-- 
Luiz Fernando N. Capitulino
