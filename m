Return-Path: <linux-kernel-owner+w=401wt.eu-S1751217AbXBUMVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbXBUMVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 07:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbXBUMVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 07:21:25 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47793 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbXBUMVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 07:21:24 -0500
Date: Wed, 21 Feb 2007 14:21:22 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: jsipek@fsl.cs.sunysb.edu, linux-kernel@vger.kernel.org
Subject: [PATCH] unionfs: fix memory leak when calling krealloc
Message-ID: <Pine.LNX.4.64.0702211418590.20432@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

We must not overwrite the same pointer that is passed to krealloc() 
because it can return NULL without freeing the buffer.  Fixes a memory 
leak introduced by me.

Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/unionfs/copyup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: 2.6/fs/unionfs/copyup.c
===================================================================
--- 2.6.orig/fs/unionfs/copyup.c	2007-02-21 14:15:30.000000000 +0200
+++ 2.6/fs/unionfs/copyup.c	2007-02-21 14:16:19.000000000 +0200
@@ -658,11 +658,14 @@
 
 		/* grow path table */
 		if (count == num_dentry) {
-			path = krealloc(path, kmalloc_size * 2, GFP_KERNEL);
-			if (!path) {
+			void *p;
+
+			p = krealloc(path, kmalloc_size * 2, GFP_KERNEL);
+			if (!p) {
 				hidden_dentry = ERR_PTR(-ENOMEM);
 				goto out;
 			}
+			path = p;
 			kmalloc_size = ksize(path);
 			num_dentry = kmalloc_size / sizeof(struct dentry *);
 		}
