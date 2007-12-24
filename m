Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbXLXTZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbXLXTZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 14:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXLXTZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 14:25:42 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37563 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082AbXLXTZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 14:25:41 -0500
Date: Mon, 24 Dec 2007 11:25:41 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: tlb_finish_mmu() bogisity
In-Reply-To: <alpine.LFD.0.9999.0712231311530.21557@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712241054210.8299@schroedinger.engr.sgi.com>
References: <20071223093241.GR8181@ftp.linux.org.uk>
 <alpine.LFD.0.9999.0712231311530.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2007, Linus Torvalds wrote:

> > What did you intend here?  s/&//, perhaps?
> 
> I think that thing is bogus in other ways. It plays games with 
> "needs_flush", just because it seems to want the generic code to then call 
> "check_pgt_cache()", not because it actually wants any flushing to take 
> place.

It can only free the pages on the quicklist after the flush. So it needs 
to set need_flush to trigger the flush before check_pgt_cache can trim the 
quicklist. If need_flush is not set then pages are freed in 
check_pgt_cache before their TLBs have been flushed.

> Or is there any other reason going on here? That quicklist stuff has been 
> totally broken, it's done too many totally invalid things to really be 
> worth even keeping. We should get rid of that unmaintainable hack, and if 
> it has a real performance upside, we should make it part of the *native* 
> mmu-gather infrastructure, instead of maintaining it as some separate and 
> buggy/unmaintainable piece-of-sh*t code.

Yup as we agreed before it would be best to make the TLB pieces part of 
the native mmu gather infrastructure. But then they vary quite a lot 
between arches.



Quicklist: Remove bogus &

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/include/asm-generic/tlb.h
===================================================================
--- linux-2.6.orig/include/asm-generic/tlb.h	2007-12-24 10:53:52.000000000 -0800
+++ linux-2.6/include/asm-generic/tlb.h	2007-12-24 10:54:01.000000000 -0800
@@ -87,7 +87,7 @@ static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
 #ifdef CONFIG_QUICKLIST
-	tlb->need_flush += &__get_cpu_var(quicklist)[0].nr_pages != 0;
+	tlb->need_flush += __get_cpu_var(quicklist)[0].nr_pages != 0;
 #endif
 	tlb_flush_mmu(tlb, start, end);
 
