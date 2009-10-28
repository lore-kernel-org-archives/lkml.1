Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbZJ1R4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbZJ1R4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZJ1R4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:56:33 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:11650 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755430AbZJ1R4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:56:31 -0400
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: [PATCH 2/2] Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE
References: <ye84opj9zgs.fsf@camel23.daimi.au.dk>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 28 Oct 2009 18:56:35 +0100
In-Reply-To: <ye84opj9zgs.fsf@camel23.daimi.au.dk>
Message-ID: <ye8vdhz8krw.fsf@camel23.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-NFIT-RelayAddr: 130.225.16.142
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously calling debug_kmap_atomic() with these types would cause
spurious warnings.

Signed-off-by: Søren Sandmann Pedersen <sandmann@redhat.com>
---
 mm/highmem.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 33587de..9c1e627 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -432,10 +432,15 @@ void debug_kmap_atomic(enum km_type type)
 		return;
 
 	if (unlikely(in_interrupt())) {
-		if (in_irq()) {
+		if (in_nmi()) {
+			if (type != KM_NMI && type != KM_NMI_PTE) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		} else if (in_irq()) {
 			if (type != KM_IRQ0 && type != KM_IRQ1 &&
 			    type != KM_BIO_SRC_IRQ && type != KM_BIO_DST_IRQ &&
-			    type != KM_BOUNCE_READ) {
+			    type != KM_BOUNCE_READ && type != KM_IRQ_PTE) {
 				WARN_ON(1);
 				warn_count--;
 			}
@@ -452,7 +457,9 @@ void debug_kmap_atomic(enum km_type type)
 	}
 
 	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
-			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ) {
+			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ ||
+			type == KM_IRQ_PTE || type == KM_NMI ||
+			type == KM_NMI_PTE ) {
 		if (!irqs_disabled()) {
 			WARN_ON(1);
 			warn_count--;
-- 
1.6.5.1

