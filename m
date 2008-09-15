Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbYIOKXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbYIOKXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 06:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYIOKW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 06:22:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53696 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYIOKW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 06:22:56 -0400
Date: Mon, 15 Sep 2008 13:22:54 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: sfrench@samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: don't use GFP_KERNEL with GFP_NOFS
Message-ID: <Pine.LNX.4.64.0809151322240.17322@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

GFP_KERNEL and GFP_NOFS are mutually exclusive. If you combine them, you end up
with plain GFP_KERNEL which can deadlock in cases where you really want
GFP_NOFS.

Cc: Steve French <sfrench@samba.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/cifs/misc.c      |    6 ++----
 fs/cifs/transport.c |    3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 4b17f8f..654d972 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -150,8 +150,7 @@ cifs_buf_get(void)
    but it may be more efficient to always alloc same size
    albeit slightly larger than necessary and maxbuffersize
    defaults to this and can not be bigger */
-	ret_buf = (struct smb_hdr *) mempool_alloc(cifs_req_poolp,
-						   GFP_KERNEL | GFP_NOFS);
+	ret_buf = mempool_alloc(cifs_req_poolp, GFP_NOFS);
 
 	/* clear the first few header bytes */
 	/* for most paths, more is cleared in header_assemble */
@@ -188,8 +187,7 @@ cifs_small_buf_get(void)
    but it may be more efficient to always alloc same size
    albeit slightly larger than necessary and maxbuffersize
    defaults to this and can not be bigger */
-	ret_buf = (struct smb_hdr *) mempool_alloc(cifs_sm_req_poolp,
-						   GFP_KERNEL | GFP_NOFS);
+	ret_buf = mempool_alloc(cifs_sm_req_poolp, GFP_NOFS);
 	if (ret_buf) {
 	/* No need to clear memory here, cleared in header assemble */
 	/*	memset(ret_buf, 0, sizeof(struct smb_hdr) + 27);*/
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 000ac50..80ab4c8 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -50,8 +50,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct cifsSesInfo *ses)
 		return NULL;
 	}
 
-	temp = (struct mid_q_entry *) mempool_alloc(cifs_mid_poolp,
-						    GFP_KERNEL | GFP_NOFS);
+	temp = mempool_alloc(cifs_mid_poolp, GFP_NOFS);
 	if (temp == NULL)
 		return temp;
 	else {
-- 
1.5.4.3

