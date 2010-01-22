Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211Ab0AVSv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab0AVSv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 13:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029Ab0AVSv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 13:51:57 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56115 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab0AVSv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 13:51:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=quCAPaRiCV7EOV/470iZ5ReaY3VR5/uuTt+xraN1nq/s8kDe9+RcOsTxTZf/+7N9Bs
         ibf9f2ZHahxbfz0lV6MMxQcvyQ39P6/Ko1q4bRNTx9glhuNYaxEH6bn/O3BjQSl+b+CP
         FUFb8BbG+ffAc1LXPGpsV/wWTscqi3kXkzOEU=
Message-ID: <4B59F501.6010607@gmail.com>
Date: Fri, 22 Jan 2010 19:57:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mach-pnx4008/dma.c: clean up duplication in pnx4008_dma_split_{head,ll}_entry()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears unnecessary to duplicate these loops.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/arm/mach-pnx4008/dma.c |  198 +++++++++++++++----------------------------
 1 files changed, 67 insertions(+), 131 deletions(-)

diff --git a/arch/arm/mach-pnx4008/dma.c b/arch/arm/mach-pnx4008/dma.c
index 425f718..d9302d3 100644
--- a/arch/arm/mach-pnx4008/dma.c
+++ b/arch/arm/mach-pnx4008/dma.c
@@ -731,78 +731,46 @@ void pnx4008_dma_split_head_entry(struct pnx4008_dma_config * config,
 	}
 	if (num_entries != 0) {
 		struct pnx4008_dma_ll *ll = NULL;
+		struct pnx4008_dma_ll *ll_old;
+		unsigned long ll_dma_old;
 		config->ch_ctrl &= ~0x7ff;
 		config->ch_ctrl |= new_len;
-		if (!config->is_ll) {
-			config->is_ll = 1;
-			while (num_entries) {
-				if (!ll) {
-					config->ll =
-					    pnx4008_alloc_ll_entry(&config->
-								   ll_dma);
-					ll = config->ll;
-				} else {
-					ll->next =
-					    pnx4008_alloc_ll_entry(&ll->
-								   next_dma);
-					ll = ll->next;
-				}
-
-				if (ctrl->si)
-					ll->src_addr =
-					    config->src_addr +
-					    src_width * new_len * count;
-				else
-					ll->src_addr = config->src_addr;
-				if (ctrl->di)
-					ll->dest_addr =
-					    config->dest_addr +
-					    dest_width * new_len * count;
-				else
-					ll->dest_addr = config->dest_addr;
-				ll->ch_ctrl = config->ch_ctrl & 0x7fffffff;
-				ll->next_dma = 0;
-				ll->next = NULL;
-				num_entries--;
-				count++;
-			}
-		} else {
-			struct pnx4008_dma_ll *ll_old = config->ll;
-			unsigned long ll_dma_old = config->ll_dma;
-			while (num_entries) {
-				if (!ll) {
-					config->ll =
-					    pnx4008_alloc_ll_entry(&config->
-								   ll_dma);
-					ll = config->ll;
-				} else {
-					ll->next =
-					    pnx4008_alloc_ll_entry(&ll->
-								   next_dma);
-					ll = ll->next;
-				}
-
-				if (ctrl->si)
-					ll->src_addr =
-					    config->src_addr +
-					    src_width * new_len * count;
-				else
-					ll->src_addr = config->src_addr;
-				if (ctrl->di)
-					ll->dest_addr =
-					    config->dest_addr +
-					    dest_width * new_len * count;
-				else
-					ll->dest_addr = config->dest_addr;
-				ll->ch_ctrl = config->ch_ctrl & 0x7fffffff;
-				ll->next_dma = 0;
-				ll->next = NULL;
-				num_entries--;
-				count++;
+		if (config->is_ll) {
+			ll_old = config->ll;
+			config->ll_dma;
+		}
+		while (num_entries) {
+			if (!ll) {
+				config->ll = pnx4008_alloc_ll_entry(
+						&config->ll_dma);
+				ll = config->ll;
+			} else {
+				ll->next = pnx4008_alloc_ll_entry(
+						&ll-> next_dma);
+				ll = ll->next;
 			}
+
+			if (ctrl->si)
+				ll->src_addr = config->src_addr +
+					src_width * new_len * count;
+			else
+				ll->src_addr = config->src_addr;
+			if (ctrl->di)
+				ll->dest_addr = config->dest_addr +
+					dest_width * new_len * count;
+			else
+				ll->dest_addr = config->dest_addr;
+			ll->ch_ctrl = config->ch_ctrl & 0x7fffffff;
+			ll->next_dma = 0;
+			ll->next = NULL;
+			num_entries--;
+			count++;
+		}
+		if (config->is_ll) {
 			ll->next_dma = ll_dma_old;
 			ll->next = ll_old;
 		}
+		config->is_ll = 1;
 		/* adjust last length/tc */
 		ll->ch_ctrl = config->ch_ctrl & (~0x7ff);
 		ll->ch_ctrl |= old_len - new_len * (count - 1);
@@ -853,75 +821,43 @@ void pnx4008_dma_split_ll_entry(struct pnx4008_dma_ll * cur_ll,
 	}
 	if (num_entries != 0) {
 		struct pnx4008_dma_ll *ll = NULL;
+		struct pnx4008_dma_ll *ll_old;
+		unsigned long ll_dma_old;
 		cur_ll->ch_ctrl &= ~0x7ff;
 		cur_ll->ch_ctrl |= new_len;
-		if (!cur_ll->next) {
-			while (num_entries) {
-				if (!ll) {
-					cur_ll->next =
-					    pnx4008_alloc_ll_entry(&cur_ll->
-								   next_dma);
-					ll = cur_ll->next;
-				} else {
-					ll->next =
-					    pnx4008_alloc_ll_entry(&ll->
-								   next_dma);
-					ll = ll->next;
-				}
-
-				if (ctrl->si)
-					ll->src_addr =
-					    cur_ll->src_addr +
-					    src_width * new_len * count;
-				else
-					ll->src_addr = cur_ll->src_addr;
-				if (ctrl->di)
-					ll->dest_addr =
-					    cur_ll->dest_addr +
-					    dest_width * new_len * count;
-				else
-					ll->dest_addr = cur_ll->dest_addr;
-				ll->ch_ctrl = cur_ll->ch_ctrl & 0x7fffffff;
-				ll->next_dma = 0;
-				ll->next = NULL;
-				num_entries--;
-				count++;
-			}
-		} else {
-			struct pnx4008_dma_ll *ll_old = cur_ll->next;
-			unsigned long ll_dma_old = cur_ll->next_dma;
-			while (num_entries) {
-				if (!ll) {
-					cur_ll->next =
-					    pnx4008_alloc_ll_entry(&cur_ll->
-								   next_dma);
-					ll = cur_ll->next;
-				} else {
-					ll->next =
-					    pnx4008_alloc_ll_entry(&ll->
-								   next_dma);
-					ll = ll->next;
-				}
-
-				if (ctrl->si)
-					ll->src_addr =
-					    cur_ll->src_addr +
-					    src_width * new_len * count;
-				else
-					ll->src_addr = cur_ll->src_addr;
-				if (ctrl->di)
-					ll->dest_addr =
-					    cur_ll->dest_addr +
-					    dest_width * new_len * count;
-				else
-					ll->dest_addr = cur_ll->dest_addr;
-				ll->ch_ctrl = cur_ll->ch_ctrl & 0x7fffffff;
-				ll->next_dma = 0;
-				ll->next = NULL;
-				num_entries--;
-				count++;
+
+		if (cur_ll->next) {
+			ll_old = cur_ll->next;
+			ll_dma_old = cur_ll->next_dma;
+		}
+		while (num_entries) {
+			if (!ll) {
+				cur_ll->next = pnx4008_alloc_ll_entry(
+						&cur_ll->next_dma);
+				ll = cur_ll->next;
+			} else {
+				ll->next = pnx4008_alloc_ll_entry(
+						&ll->next_dma);
+				ll = ll->next;
 			}
 
+			if (ctrl->si)
+				ll->src_addr = cur_ll->src_addr +
+					src_width * new_len * count;
+			else
+				ll->src_addr = cur_ll->src_addr;
+			if (ctrl->di)
+				ll->dest_addr = cur_ll->dest_addr +
+				    dest_width * new_len * count;
+			else
+				ll->dest_addr = cur_ll->dest_addr;
+			ll->ch_ctrl = cur_ll->ch_ctrl & 0x7fffffff;
+			ll->next_dma = 0;
+			ll->next = NULL;
+			num_entries--;
+			count++;
+		}
+		if (cur_ll->next) {
 			ll->next_dma = ll_dma_old;
 			ll->next = ll_old;
 		}
