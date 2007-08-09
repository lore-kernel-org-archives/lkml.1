Return-Path: <linux-kernel-owner+w=401wt.eu-S938803AbXHIPjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938803AbXHIPjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965644AbXHIPi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:38:57 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:44819 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965636AbXHIPi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:38:56 -0400
Date: Thu, 9 Aug 2007 16:37:35 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: kernel BUG at mm/swap_state.c:78!
In-Reply-To: <200708091711.53898.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.64.0708091633540.8627@blonde.wat.veritas.com>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
 <200708091711.53898.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAbS5rb3psb3dza2lAdHV4bGFuZC5wbABucGlnZ2luQHN1c2UuZGUAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Mariusz Kozlowski wrote:
> Hello,
> 
> 	Nothing unusual happening, allmodconfig compiling etc.
> Not sure why it says kernel was tainted though ... hmmm.
> 
> ------------[ cut here ]------------
> kernel BUG at mm/swap_state.c:78!
> invalid opcode: 0000 [#1]
> PREEMPT 
> Modules linked in: orinoco_cs orinoco hermes pl2303 usbserial pcmcia 8250_pci 8250 serial_core yenta_socket rsrc_nonstatic pcmcia_core 8139too
> CPU:    0
> EIP:    0060:[<c01504b7>]    Tainted: P        VLI
> EFLAGS: 00010246   (2.6.23-rc2-mm1 #1)
> EIP is at __add_to_swap_cache+0xc6/0xd7
> eax: 40000000   ebx: c11285c0   ecx: 000000d0   edx: 00000283
> esi: c11285c0   edi: 00000283   ebp: c1858f90   esp: c1858f84
> ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
> Process kprefetchd (pid: 236, ti=c1858000 task=c18d14d0 task.ti=c1858000)
> Stack: 00000283 c11285c0 c3d5a3c8 c1858fa0 c01504ea c11285c0 00000000 c1858fcc 
>        c015307c 00000001 00000007 00000002 00000002 00000283 00000000 fffffffc 
>        00000000 c0152d5c c1858fe0 c0127f2e c0127ef8 00000000 00000000 00000000 
> Call Trace:
>  [<c010456a>] show_trace_log_lvl+0x1a/0x30
>  [<c0104629>] show_stack_log_lvl+0xa9/0xd5
>  [<c010486e>] show_registers+0x219/0x38d
>  [<c0104ae6>] die+0x104/0x23e
>  [<c0419bd3>] do_trap+0x83/0xad
>  [<c0104edf>] do_invalid_op+0x88/0x92
>  [<c04199b2>] error_code+0x6a/0x70
>  [<c01504ea>] add_to_swap_cache+0x22/0x58
>  [<c015307c>] kprefetchd+0x320/0x364
>  [<c0127f2e>] kthread+0x36/0x58
>  [<c0104233>] kernel_thread_helper+0x7/0x14
>  =======================
> INFO: lockdep is turned off.
> Code: 0f 89 7b 0c 83 05 fc c9 53 c0 01 8b 13 c1 ea 1e 8d 04 12 01 d0 c1 e0 03 29 d0 c1 e0 05 ff 80 b8 c0 53 c0 ff 05 34 1d 68 c0 eb 96 <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 8b 53 0c eb be 55 89 e5 56 
> EIP: [<c01504b7>] __add_to_swap_cache+0xc6/0xd7 SS:ESP 0068:c1858f84

Don't worry about reproducing untainted, I got the same earlier
and was just preparing and testing the hotfix: here it is...


Nick's mm-clarify-__add_to_swap_cache-locking.patch is fine for mainline,
but soon generates a "kernel BUG at mm/swap_state.c:78!" when it meets
mm-implement-swap-prefetching.patch in 2.6.23-rc2-mm1.  We could add a
fix to the latter, but I think it's better to adjust Nick's, so that
it's right for whichever tree it's in: move the responsibility to
SetPageLocked from read_swap_cache_async to add_to_swap_cache.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/swap_state.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- 2.6.23-rc2-mm1/mm/swap_state.c	2007-08-09 13:15:36.000000000 +0100
+++ linux/mm/swap_state.c	2007-08-09 14:40:27.000000000 +0100
@@ -100,15 +100,18 @@ int add_to_swap_cache(struct page *page,
 {
 	int error;
 
+	BUG_ON(PageLocked(page));
 	if (!swap_duplicate(entry)) {
 		INC_CACHE_INFO(noent_race);
 		return -ENOENT;
 	}
+	SetPageLocked(page);
 	error = __add_to_swap_cache(page, entry, GFP_KERNEL);
 	/*
 	 * Anon pages are already on the LRU, we don't run lru_cache_add here.
 	 */
 	if (error) {
+		ClearPageLocked(page);
 		swap_free(entry);
 		if (error == -EEXIST)
 			INC_CACHE_INFO(exist_race);
@@ -345,7 +348,6 @@ struct page *read_swap_cache_async(swp_e
 								vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
-			SetPageLocked(new_page);/* could be non-atomic op */
 		}
 
 		/*
@@ -369,9 +371,7 @@ struct page *read_swap_cache_async(swp_e
 		}
 	} while (err != -ENOENT && err != -ENOMEM);
 
-	if (new_page) {
-		ClearPageLocked(new_page);
+	if (new_page)
 		page_cache_release(new_page);
-	}
 	return found_page;
 }
