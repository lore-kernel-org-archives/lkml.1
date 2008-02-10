Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbYBJOsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbYBJOsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 09:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbYBJOsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 09:48:00 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48450 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYBJOr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 09:47:59 -0500
Date: Sun, 10 Feb 2008 16:47:57 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, stable@kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, bastian@waldi.eu.org, ndenev@gmail.com,
       oliver.pntr@gmail.com
Subject: [PATCH] splice: fix user pointer access in get_iovec_page_array()
Message-ID: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bastian Blank <bastian@waldi.eu.org>

The commit 8811930dc74a503415b35c4a79d14fb0b408a361 ("splice: missing user
pointer access verification") added access_ok() to copy_from_user_mmap_sem()
which only ensures we can copy the struct iovecs from userspace to the kernel
but we also must check whether we can access the actual memory region pointed
to by the struct iovec to close the local root exploit.

Cc: <stable@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Bastian, can I have your Signed-off-by for this, please? Oliver, Niki, can 
you please confirm this closes the hole?

 fs/splice.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c
+++ linux-2.6/fs/splice.c
@@ -1237,6 +1237,9 @@ static int get_iovec_page_array(const st
 		if (unlikely(!base))
 			break;
 
+		if (unlikely(!access_ok(VERIFY_READ, base, len)))
+			break;
+
 		/*
 		 * Get this base offset and number of pages, then map
 		 * in the user pages.
