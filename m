Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZKJDVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZKJDVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 22:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbZKJDV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 22:21:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:36952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbZKJDV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 22:21:28 -0500
Date: Tue, 10 Nov 2009 03:19:44 GMT
From: tip-bot for Soeren Sandmann <sandmann@daimi.au.dk>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sandmann@redhat.com,
       sandmann@daimi.au.dk, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, sandmann@redhat.com, tglx@linutronix.de,
       sandmann@daimi.au.dk, mingo@elte.hu
In-Reply-To: <ye8vdhz8krw.fsf@camel23.daimi.au.dk>
References: <ye8vdhz8krw.fsf@camel23.daimi.au.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE
Message-ID: <tip-d4515646699b6ad7b1a98ceb871296b957f3ef47@git.kernel.org>
Git-Commit-ID: d4515646699b6ad7b1a98ceb871296b957f3ef47
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4515646699b6ad7b1a98ceb871296b957f3ef47
Gitweb:     http://git.kernel.org/tip/d4515646699b6ad7b1a98ceb871296b957f3ef47
Author:     Soeren Sandmann <sandmann@daimi.au.dk>
AuthorDate: Wed, 28 Oct 2009 18:56:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 04:15:47 +0100

highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE

Previously calling debug_kmap_atomic() with these types would
cause spurious warnings.

(triggered by SysProf using perf events)

Signed-off-by: Soeren Sandmann Pedersen <sandmann@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: a.p.zijlstra@chello.nl
Cc: <stable@kernel.org> # .31.x
LKML-Reference: <ye8vdhz8krw.fsf@camel23.daimi.au.dk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
