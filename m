Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbZLGAMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbZLGAMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758374AbZLGAMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:51 -0500
Received: from kroah.org ([198.145.64.141]:34237 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758280AbZLGAMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:42 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:44 2009
Message-Id: <20091207000643.892734717@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Soeren Sandmann Pedersen <sandmann@redhat.com>, a.p.zijlstra@chello.nl,
       Ingo Molnar <mingo@elte.hu>
Subject: [022/119] highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=highmem-fix-debug_kmap_atomic-to-also-handle-km_irq_pte-km_nmi-and-km_nmi_pte.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Soeren Sandmann <sandmann@daimi.au.dk>

commit d4515646699b6ad7b1a98ceb871296b957f3ef47 upstream.

Previously calling debug_kmap_atomic() with these types would
cause spurious warnings.

(triggered by SysProf using perf events)

Signed-off-by: Soeren Sandmann Pedersen <sandmann@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: a.p.zijlstra@chello.nl
LKML-Reference: <ye8vdhz8krw.fsf@camel23.daimi.au.dk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/highmem.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -432,10 +432,15 @@ void debug_kmap_atomic(enum km_type type
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
@@ -452,7 +457,9 @@ void debug_kmap_atomic(enum km_type type
 	}
 
 	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
-			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ) {
+			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ ||
+			type == KM_IRQ_PTE || type == KM_NMI ||
+			type == KM_NMI_PTE ) {
 		if (!irqs_disabled()) {
 			WARN_ON(1);
 			warn_count--;


