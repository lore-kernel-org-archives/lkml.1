Return-Path: <linux-kernel-owner+w=401wt.eu-S1764360AbXGZJct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764360AbXGZJct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbXGZJcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:32:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33456 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbXGZJcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:32:41 -0400
Subject: Re: [bug] SLUB & freeing locks [was: Re: 2.6.23-rc1: known
	regressions with patches]
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1185441963.8197.67.camel@twins>
References: <46A47940.7030801@googlemail.com>
	 <20070726091048.GA7366@elte.hu>  <1185441963.8197.67.camel@twins>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 11:32:33 +0200
Message-Id: <1185442353.8197.71.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 11:26 +0200, Peter Zijlstra wrote:
> On Thu, 2007-07-26 at 11:10 +0200, Ingo Molnar wrote:
> > there's a new regression:
> > 
> > SLUB does not seem to call debug_check_no_locks_freed() - hence on SLUB 
> > we will not notice certain types of freeing races. (such as freeing an 
> > object still locked and used on another CPU.) SLAB does this corretly.

Oh, nm, it doesn't call debug_check_no_locks_freed() at all.

This should do I guess.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -1656,6 +1656,7 @@ static void __always_inline slab_free(st
 	unsigned long flags;
 
 	local_irq_save(flags);
+	debug_check_no_locks_freed(object, s->size);
 	if (likely(page == s->cpu_slab[smp_processor_id()] &&
 						!SlabDebug(page))) {
 		object[page->offset] = page->lockless_freelist;


