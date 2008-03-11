Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbYCKR0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbYCKR0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYCKR03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:26:29 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:47162 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYCKR02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:26:28 -0400
Date: Tue, 11 Mar 2008 14:26:24 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
Message-ID: <20080311142624.1dbd3af5@mandriva.com.br>
In-Reply-To: <20080310180843.GC28780@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org>
	<20080307175148.3a49d8d3@mandriva.com.br>
	<20080308004654.GQ7365@one.firstfloor.org>
	<20080310150316.752e4489@mandriva.com.br>
	<20080310180843.GC28780@one.firstfloor.org>
Organization: Mandriva
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 10 Mar 2008 19:08:43 +0100
Andi Kleen <andi@firstfloor.org> escreveu:

| > you have or only the subset you posted?
| 
| Best you test all together. The subsets are independent
| (as in kernel should work with any subset of them), but 
| they all clean up DMA memory related issues.

 Ok, now it works with the test case fixed:

"""
testing mask alloc upto 24 bits
verify & free
mask fffff
mask 1fffff
mask 3fffff
mask 7fffff
mask ffffff
done
"""

 Do you remember the BUG_ON() I was getting because of the
sound card driver [1] ?

 It seems to me that the problem is that it's setting
__GFP_COMP. The following patch fixes it for me:

"""
Index: linux-2.6.24/sound/core/memalloc.c
===================================================================
--- linux-2.6.24.orig/sound/core/memalloc.c
+++ linux-2.6.24/sound/core/memalloc.c
@@ -218,7 +218,6 @@ static void *snd_malloc_dev_pages(struct
 	snd_assert(dma != NULL, return NULL);
 	pg = get_order(size);
 	gfp_flags = GFP_KERNEL
-		| __GFP_COMP	/* compound page lets parts be mapped */
 		| __GFP_NORETRY /* don't trigger OOM-killer */
 		| __GFP_NOWARN; /* no stack trace print - this call is non-critical */
 	res = dma_alloc_coherent(dev, PAGE_SIZE << pg, dma, gfp_flags);
"""

 Also, I think you forgot to protect the __free_pages_mask()
call with "#ifdef CONFIG_MASK_ALLOC" in patch mask-compat.

 Question: let's say that the devices I have consumes only
5MB of the whole reserved pool (16MB), of course that it's
ok to reduce the pool to 5MB, right?

 I have more machines to test this stuff...

[1] http://users.mandriva.com.br/~lcapitulino/tmp/minicom.cap

-- 
Luiz Fernando N. Capitulino
