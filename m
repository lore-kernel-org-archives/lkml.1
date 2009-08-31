Return-Path: <linux-kernel-owner+w=401wt.eu-S1751459AbZHaHmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbZHaHmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 03:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZHaHmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 03:42:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:40822 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbZHaHma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 03:42:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182261669"
Date: Mon, 31 Aug 2009 15:42:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH] slqb: add common slab debug bits
Message-ID: <20090831074221.GA10263@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple copy&paste from slub.c:

- lockdep annotation
- might sleep annotation
- fault injection

CC: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/slqb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-mm.orig/mm/slqb.c	2009-08-28 15:51:15.000000000 +0800
+++ linux-mm/mm/slqb.c	2009-08-28 16:05:33.000000000 +0800
@@ -19,6 +19,7 @@
 #include <linux/ctype.h>
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
+#include <linux/fault-inject.h>
 
 /*
  * TODO
@@ -1541,6 +1542,12 @@ static __always_inline void *slab_alloc(
 
 	gfpflags &= gfp_allowed_mask;
 
+	lockdep_trace_alloc(gfpflags);
+	might_sleep_if(gfpflags & __GFP_WAIT);
+
+	if (should_failslab(s->objsize, gfpflags))
+		return NULL;
+
 again:
 	local_irq_save(flags);
 	object = __slab_alloc(s, gfpflags, node);
