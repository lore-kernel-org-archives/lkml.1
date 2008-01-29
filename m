Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYA2JfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYA2JfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 04:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYA2JfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 04:35:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYA2JfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 04:35:06 -0500
From: Andi Kleen <ak@suse.de>
To: Yinghai Lu <Yinghai.Lu@sun.com>
Subject: Re: [PATCH 2/2] x86_64: make early_node_mem return align address
Date: Tue, 29 Jan 2008 10:33:29 +0100
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200801290053.45776.yinghai.lu@sun.com> <200801290105.03438.yinghai.lu@sun.com>
In-Reply-To: <200801290105.03438.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801291033.29871.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 10:05, Yinghai Lu wrote:
> [PATCH 2/2] x86_64: make early_node_mem return align address
>
> boot oops when system get 64g or 128g installed

Probably it should just use reserve_early(). Does this patch work?
 
The alignment change is needed at some point too, but only to 
relax the alignment to not force all early allocations to be page
padded.

-Andi

---

Use early reservation for early node data

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/mm/numa_64.c
===================================================================
--- linux.orig/arch/x86/mm/numa_64.c
+++ linux/arch/x86/mm/numa_64.c
@@ -169,8 +169,10 @@ static void * __init early_node_mem(int 
 	unsigned long mem = find_e820_area(start, end, size);
 	void *ptr;
 
-	if (mem != -1L)
+	if (mem != -1L) {
+		reserve_early(mem, mem + size);
 		return __va(mem);
+	}
 	ptr = __alloc_bootmem_nopanic(size,
 				SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS));
 	if (ptr == NULL) {


