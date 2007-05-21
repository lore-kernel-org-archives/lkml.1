Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbXEURln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbXEURln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbXEURlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:41:36 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55517 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbXEURlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:41:36 -0400
Date: Mon, 21 May 2007 18:41:12 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 21 May 2007 17:41:34.0416 (UTC) FILETIME=[46599500:01C79BCF]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBjbGFtZXRlckBzZ2kuY29tAHNyaWhhcml2aWpheWFyYWdoYXZhbkB5YWhvby5jb20uYXUAb3h5bW9yb25Ad2FzdGUub3JnAGplbnMuYXhib2VAb3JhY2xlLmNvbQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Christoph Lameter wrote:
> On Sun, 20 May 2007, Srihari Vijayaraghavan wrote:
> 
> > With no CONFIG_SLUB_DEBUG, things have slightly improved. No more panic. Good.
> > Serial console is working. Good. But there is another problem:
> 
> > Freeing unused kernel memory: 308k freed
> > BUG: spinlock bad magic on CPU#1, init/1
> >  lock: ffff81011ec0a100, .magic: ffff8101, .owner: <none>/-1, .owner_cpu: -1
> > 
> > Call Trace:
> >  [<ffffffff802fc516>] _raw_spin_lock+0x22/0xf6
> >  [<ffffffff8026f684>] vma_adjust+0x219/0x454
> >  [<ffffffff8026f684>] vma_adjust+0x219/0x454
> >  [<ffffffff8026fe0d>] vma_merge+0x147/0x1f4
> >  [<ffffffff80270b55>] do_mmap_pgoff+0x414/0x7c7
> >  [<ffffffff8040aa34>] _spin_unlock_irq+0x24/0x27
> >  [<ffffffff8020f528>] sys_mmap+0xe5/0x110
> >  [<ffffffff80209dde>] system_call+0x7e/0x83
> 
> Hmmmm..... We have seen this before
> 
> http://marc.info/?l=linux-kernel&m=117891943401284&w=2

Yes, sounded the same to me too: I couldn't reproduce it or see anything
wrong in the code back then.  But Srihari's info about CONFIG_DEBUG_SLUB
off has helped a lot: I was then able to reproduce it on my x86_64, and
after a lot of staring at the code, the problem became obvious...

[PATCH] slub: fix size adjustment when SLUB_DEBUG off

SLUB was corrupting the anon_vma's spinlock when not configured for
SLUB_DEBUG: the size adjustment necessary for SLAB_DESTROY_BY_RCU or
constructor was inside the CONFIG_SLUB_DEBUG appropriate for poisoning.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
 mm/slub.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- 2.6.22-rc2/mm/slub.c	2007-05-21 13:13:20.000000000 +0100
+++ linux/mm/slub.c	2007-05-21 18:05:57.000000000 +0100
@@ -1917,16 +1917,26 @@ static int calculate_sizes(struct kmem_c
 	 */
 	s->inuse = size;
 
+	if ((flags & SLAB_DESTROY_BY_RCU) || s->ctor) {
+		/*
+		 * Relocate free pointer after the object if it is not
+		 * permitted to overwrite the first word of the object on
+		 * kmem_cache_free.
+		 *
+		 * This is the case if we do RCU or have a constructor.
+		 */
+		s->offset = size;
+		size += sizeof(void *);
+	}
+
 #ifdef CONFIG_SLUB_DEBUG
-	if (((flags & (SLAB_DESTROY_BY_RCU | SLAB_POISON)) ||
-		s->ctor)) {
+	if (s->flags & __OBJECT_POISON) {
 		/*
 		 * Relocate free pointer after the object if it is not
 		 * permitted to overwrite the first word of the object on
 		 * kmem_cache_free.
 		 *
-		 * This is the case if we do RCU, have a constructor or
-		 * destructor or are poisoning the objects.
+		 * This is the case if we are poisoning the objects.
 		 */
 		s->offset = size;
 		size += sizeof(void *);
