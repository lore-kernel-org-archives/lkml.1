Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYG2Ame@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYG2Ame (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYG2Am0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:42:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbYG2AmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:42:25 -0400
Date: Mon, 28 Jul 2008 17:39:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linuxfoundation.org,
       torvalds@linuxfoundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: do not overrun page table ranges in gup
In-Reply-To: <alpine.LFD.1.10.0807281721200.3486@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807281737480.3486@nehalem.linux-foundation.org>
References: <20080728184947.GA5041@martell.zuzino.mipt.ru> <20080728185316.GA19479@martell.zuzino.mipt.ru> <87y73l5zlj.fsf_-_@saeurebad.de> <87tze95yrk.fsf@saeurebad.de> <alpine.LFD.1.10.0807281721200.3486@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Jul 2008, Linus Torvalds wrote:
> 
> So no, the right fix would be to align 'start' first, which means that 
> everything else (including 'end') will be page-aligned. Aligning just one 
> or the other is very very wrong.

Does this work?

Not pretty, but it stands _some_ chance of being correct.

		Linus


---
 arch/x86/mm/gup.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 3085f25..007bb06 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -223,14 +223,17 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages)
 {
 	struct mm_struct *mm = current->mm;
-	unsigned long end = start + (nr_pages << PAGE_SHIFT);
-	unsigned long addr = start;
+	unsigned long addr, len, end;
 	unsigned long next;
 	pgd_t *pgdp;
 	int nr = 0;
 
+	start &= PAGE_MASK;
+	addr = start;
+	len = (unsigned long) nr_pages << PAGE_SHIFT;
+	end = start + len;
 	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
-					start, nr_pages*PAGE_SIZE)))
+					start, len)))
 		goto slow_irqon;
 
 	/*
