Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbXIERtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbXIERtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbXIERtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:49:31 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:59279 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbXIERta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:49:30 -0400
From: Bernd Schubert <bs@q-leap.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: patch: improve generic_file_buffered_write() (2nd try 2/2)
Date: Wed, 5 Sep 2007 19:49:28 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       brian@clusterfs.com,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       bs@q-leap.de
References: <200709051546.06224.bs@q-leap.de> <20070905083529.a1c8a0a9.randy.dunlap@oracle.com> <200709051941.56145.bs@q-leap.de>
In-Reply-To: <200709051941.56145.bs@q-leap.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709051949.28585.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I guess when aio was introduced this was probably forgotten. For small chunks 
or synchronous i/o the likehood is correct, but for big data chunks and aio 
the likehood is false.

Signed-off-by: Bernd Schubert <bs@q-leap.de>
Signed-off-by: Goswin von Brederlow <goswin@vonbrederlow.de>

Index: linux-2.6.20.3/mm/filemap.c
===================================================================
--- linux-2.6.20.3.orig/mm/filemap.c	2007-09-05 18:51:59.000000000 +0200
+++ linux-2.6.20.3/mm/filemap.c	2007-09-05 18:53:12.000000000 +0200
@@ -2100,7 +2100,7 @@
 	/*
 	 * handle partial DIO write.  Adjust cur_iov if needed.
 	 */
-	if (likely(nr_segs == 1))
+	if (nr_segs == 1)
 		buf = iov->iov_base + written;
 	else {
 		filemap_set_next_iovec(&cur_iov, &iov_base, written);
@@ -2167,7 +2167,7 @@
 					vmtruncate(inode, isize);
 			}
 		}
-		if (likely(nr_segs == 1))
+		if (nr_segs == 1)
 			copied = filemap_copy_from_user(page, offset,
 							buf, bytes);
 		else
@@ -2213,7 +2213,7 @@
 				count -= copied;
 				pos += copied;
 				buf += copied;
-				if (unlikely(nr_segs > 1)) {
+				if (nr_segs > 1) {
 					filemap_set_next_iovec(&cur_iov,
 							&iov_base, copied);
 					if (count)
