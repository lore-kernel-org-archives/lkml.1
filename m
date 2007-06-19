Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbXFTEM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbXFTEM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 00:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbXFTEMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 00:12:15 -0400
Received: from tomts1-srv.bellnexxia.net ([209.226.175.113]:39943 "EHLO
	tomts1-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbXFTEMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 00:12:14 -0400
Date: Tue, 19 Jun 2007 17:10:49 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       mingo@redhat.com
Cc: mbligh@google.com
Subject: [PATCH] Workaround change_page_attr() and global_flush_tlb() df_list inconsistency on i386
Message-ID: <20070619211049.GA9234@Krystal>
References: <20070619170914.GA30623@Krystal> <20070619200136.GA4943@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070619200136.GA4943@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:09:16 up 22 days,  5:47,  2 users,  load average: 1.40, 1.47, 1.13
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> Looking more closely into the code to find the cause of the
> change_page_addr()/global_flush_tlb() inconsistency, I see where the
> problem could be:
> 
> In arch/i386/mm/pageattr.c:
> __change_page_attr adds the page to the df_list for deferred removal
> when it is replaced by a large page (going back to the normal flags).
> This list is walked by global_flush_tlb(); it calls flush_map() and
> __free_page for each of these pages.
> 
> flush_map() is the only call that ends up doing a clflush/wbinvd and
> __flush_tlb_all() on every cpu. However, this is only done when there
> are pages recombined in a large page. It never happens when we set the
> page flags to something unusual in __change_page_attr().
> 
> The x86_64 implementation seems to work around this issue by doing a
> flush_map() independently of the deferred_pages list. It will therefore
> call __flush_tlb_all(), which should flush the TLB, but even there, I
> wonder if it should call clflush on the pages that had their flags
> modified by __change_page_attr() ?
> 
> Some input about the best way to fix this (adding the modified pages to
> the deferred list in __change_page_attr() or flushing all the TLBs, and
> all caches, independently of the deferred pages list in
> global_flush_tlb()) would be appreciated. If we add the pages that
> simply had their flags modified to the df_list, would it be ok to issue
> a __free_page on them ?
> 


Workaround change_page_attr() and global_flush_tlb() df_list inconsistency on i386

global_flush_tlb() does not flush the tlb of pages that had their flags changed
by change_page_attr(). It only deals with the pages that are set back to their
normal flags.

Waiting for comments about a cleaner fix, this one does the job.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/mm/pageattr.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/arch/i386/mm/pageattr.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/pageattr.c	2007-06-19 15:34:14.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/pageattr.c	2007-06-19 16:49:52.000000000 -0400
@@ -232,6 +232,8 @@
 			flush_map(page_address(pg));
 		__free_page(pg);
 	}
+	/* Workaround change page attr list missing entries */
+	flush_map(NULL);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
