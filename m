Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbZCAOOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbZCAOOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZCAONv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:13:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:5614 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbZCAONu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:13:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=E5YLA/7eq5wx7ZzBtp2nqJ8bP6xCqhiaw6MPfPo07kiO+srPPK1YsqoavQGyANsPFT
         lFiziTZDXttU1D4lLBqQ4v/mrOwOvG9UAYclplGivf2DGrQWeCJlJRAC8iwWafkNIgXf
         wBQTT6xptECA6t2v41cY1HFSjlbmT3RmQHShA=
Date: Sun, 1 Mar 2009 16:13:43 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Stuart Bennett <stuart@freedesktop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] x86 mmiotrace: improve handling of secondary faults
Message-ID: <20090301161343.7603a1fe@daedalus.pq.iki.fi>
In-Reply-To: <20090301160643.05a2219b@daedalus.pq.iki.fi>
References: <20090301160643.05a2219b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bea20d8a6f5444286372d102bb6abbf7313aca6e Mon Sep 17 00:00:00 2001
From: Stuart Bennett <stuart@freedesktop.org>
Date: Thu, 5 Feb 2009 11:02:02 +0000
Subject: [PATCH] x86 mmiotrace: improve handling of secondary faults

Upgrade some kmmio.c debug messages to warnings.
Allow secondary faults on probed pages to fall through, and only log
secondary faults that are not due to non-present pages.

Patch edited by Pekka Paalanen.

Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/kmmio.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index d297775..4c66bd3 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -232,28 +232,32 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 
 	ctx = &get_cpu_var(kmmio_ctx);
 	if (ctx->active) {
-		disarm_kmmio_fault_page(faultpage);
 		if (addr == ctx->addr) {
 			/*
-			 * On SMP we sometimes get recursive probe hits on the
-			 * same address. Context is already saved, fall out.
+			 * A second fault on the same page means some other
+			 * condition needs handling by do_page_fault(), the
+			 * page really not being present is the most common.
 			 */
-			pr_debug("kmmio: duplicate probe hit on CPU %d, for "
-						"address 0x%08lx.\n",
-						smp_processor_id(), addr);
-			ret = 1;
-			goto no_kmmio_ctx;
-		}
-		/*
-		 * Prevent overwriting already in-flight context.
-		 * This should not happen, let's hope disarming at least
-		 * prevents a panic.
-		 */
-		pr_emerg("kmmio: recursive probe hit on CPU %d, "
+			pr_debug("kmmio: secondary hit for 0x%08lx CPU %d.\n",
+					addr, smp_processor_id());
+
+			if (!faultpage->old_presence)
+				pr_info("kmmio: unexpected secondary hit for "
+					"address 0x%08lx on CPU %d.\n", addr,
+					smp_processor_id());
+		} else {
+			/*
+			 * Prevent overwriting already in-flight context.
+			 * This should not happen, let's hope disarming at
+			 * least prevents a panic.
+			 */
+			pr_emerg("kmmio: recursive probe hit on CPU %d, "
 					"for address 0x%08lx. Ignoring.\n",
 					smp_processor_id(), addr);
-		pr_emerg("kmmio: previous hit was at 0x%08lx.\n",
-					ctx->addr);
+			pr_emerg("kmmio: previous hit was at 0x%08lx.\n",
+						ctx->addr);
+			disarm_kmmio_fault_page(faultpage);
+		}
 		goto no_kmmio_ctx;
 	}
 	ctx->active++;
@@ -305,7 +309,7 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
 
 	if (!ctx->active) {
-		pr_debug("kmmio: spurious debug trap on CPU %d.\n",
+		pr_warning("kmmio: spurious debug trap on CPU %d.\n",
 							smp_processor_id());
 		goto out;
 	}
-- 
1.6.0.6

