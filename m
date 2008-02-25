Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbYBYEt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbYBYEt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 23:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYBYEtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 23:49:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:15549 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbYBYEtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 23:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Pk7WiXQyCwfuyn6cxBRv1VrvFiEDwbGiSOzQUVQUMcPDcxdNyJF8zN9Xoj8voP6yVmeaDQgpAWBS5/2thfIFPfYUWB23895KIlOlFETsFgoViVoCGgu8B9oMnz92llGXWrqSZrqUhXL6TqBM3I/z2ZNfOY4mHCGOb3IjdiBOP7I=
Subject: [PATCH] radeon: fix integer as NULL pointer warnings in
	radeon_mem.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Keith Whitwell <keith@tungstengraphics.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 20:49:24 -0800
Message-Id: <1203914964.1767.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/drm/radeon_mem.c:91:23: warning: Using plain integer as NULL pointer
drivers/char/drm/radeon_mem.c:116:28: warning: Using plain integer as NULL pointer
drivers/char/drm/radeon_mem.c:124:28: warning: Using plain integer as NULL pointer
drivers/char/drm/radeon_mem.c:177:26: warning: Using plain integer as NULL pointer
drivers/char/drm/radeon_mem.c:177:53: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/drm/radeon_mem.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/drm/radeon_mem.c b/drivers/char/drm/radeon_mem.c
index 78b34fa..4af5286 100644
--- a/drivers/char/drm/radeon_mem.c
+++ b/drivers/char/drm/radeon_mem.c
@@ -88,7 +88,7 @@ static struct mem_block *alloc_block(struct mem_block *heap, int size,
 
 	list_for_each(p, heap) {
 		int start = (p->start + mask) & ~mask;
-		if (p->file_priv == 0 && start + size <= p->start + p->size)
+		if (p->file_priv == NULL && start + size <= p->start + p->size)
 			return split_block(p, start, size, file_priv);
 	}
 
@@ -113,7 +113,7 @@ static void free_block(struct mem_block *p)
 	/* Assumes a single contiguous range.  Needs a special file_priv in
 	 * 'heap' to stop it being subsumed.
 	 */
-	if (p->next->file_priv == 0) {
+	if (p->next->file_priv == NULL) {
 		struct mem_block *q = p->next;
 		p->size += q->size;
 		p->next = q->next;
@@ -121,7 +121,7 @@ static void free_block(struct mem_block *p)
 		drm_free(q, sizeof(*q), DRM_MEM_BUFS);
 	}
 
-	if (p->prev->file_priv == 0) {
+	if (p->prev->file_priv == NULL) {
 		struct mem_block *q = p->prev;
 		q->size += p->size;
 		q->next = p->next;
@@ -174,7 +174,7 @@ void radeon_mem_release(struct drm_file *file_priv, struct mem_block *heap)
 	 * 'heap' to stop it being subsumed.
 	 */
 	list_for_each(p, heap) {
-		while (p->file_priv == 0 && p->next->file_priv == 0) {
+		while (p->file_priv == NULL && p->next->file_priv == NULL) {
 			struct mem_block *q = p->next;
 			p->size += q->size;
 			p->next = q->next;
-- 
1.5.4.2.200.g99e75



