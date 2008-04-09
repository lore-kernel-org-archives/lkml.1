Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbYDIP6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbYDIP6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYDIP6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:58:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54576 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYDIP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:58:11 -0400
To: akpm@linux-foundation.org, jens.axboe@oracle.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch] fix infinite loop in generic_file_splice_read()
Message-Id: <E1JjcgO-0004q2-VJ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Apr 2008 17:57:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generic_file_splice_read() goes into an infinite loop if it races with
truncation.  I've found this with fsx-linux on NFS over fuse.

Perhaps the whole while() loop is bogus, but I can't tell from a
cursory glance at __generic_file_splice_read() if it will return zero
only on EOF, or it can do that for other reasons as well.  In the
latter case the loop is obviously needed.

This simplistic patch fixes the issue for me.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

Index: linux/fs/splice.c
===================================================================
--- linux.orig/fs/splice.c	2008-04-02 13:34:58.000000000 +0200
+++ linux/fs/splice.c	2008-04-09 17:35:06.000000000 +0200
@@ -481,19 +481,20 @@ ssize_t generic_file_splice_read(struct 
 {
 	ssize_t spliced;
 	int ret;
-	loff_t isize, left;
-
-	isize = i_size_read(in->f_mapping->host);
-	if (unlikely(*ppos >= isize))
-		return 0;
-
-	left = isize - *ppos;
-	if (unlikely(left < len))
-		len = left;
 
 	ret = 0;
 	spliced = 0;
 	while (len && !spliced) {
+		loff_t isize, left;
+
+		isize = i_size_read(in->f_mapping->host);
+		if (unlikely(*ppos >= isize))
+			return 0;
+
+		left = isize - *ppos;
+		if (unlikely(left < len))
+			len = left;
+
 		ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
 
 		if (ret < 0)
