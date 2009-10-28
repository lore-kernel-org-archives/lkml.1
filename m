Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZJ1Rzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZJ1Rzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZJ1Rzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:55:32 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:11543 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755323AbZJ1Rzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:55:32 -0400
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: [PATCH 1/2] Fix race in debug_kmap_atomic() which could cause warn_count to underflow
References: <ye84opj9zgs.fsf@camel23.daimi.au.dk>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 28 Oct 2009 18:55:36 +0100
In-Reply-To: <ye84opj9zgs.fsf@camel23.daimi.au.dk>
Message-ID: <ye8zl7b8ktj.fsf@camel23.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-NFIT-RelayAddr: 130.225.16.142
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debug_kmap_atomic() tries to prevent ever printing more than 10
warnings, but it does so by testing whether an unsigned integer is
equal to 0. However, if the warning is caused by a nested IRQ, then
this counter may underflow and the stream of warnings will never end.

Fix that by using a signed integer instead.

Signed-off-by: Søren Sandmann Pedersen <sandmann@redhat.com>
---
 mm/highmem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 25878cc..33587de 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -426,9 +426,9 @@ void __init page_address_init(void)
 
 void debug_kmap_atomic(enum km_type type)
 {
-	static unsigned warn_count = 10;
+	static int warn_count = 10;
 
-	if (unlikely(warn_count == 0))
+	if (unlikely(warn_count < 0))
 		return;
 
 	if (unlikely(in_interrupt())) {
-- 
1.6.5.1

