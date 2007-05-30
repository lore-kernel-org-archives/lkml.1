Return-Path: <linux-kernel-owner+w=401wt.eu-S1750832AbXE3Ho2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750832AbXE3Ho2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbXE3HoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:44:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXE3HoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:44:20 -0400
Date: Wed, 30 May 2007 03:42:35 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] mm: fix comparisons against unsigned
Message-ID: <20070530074235.GA28866@nostromo.devel.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recent gcc versions emit warnings when unsigned variables are compared < 0 or >= 0.

Signed-off-by: Bill Nottingham <notting@redhat.com>

---

 filemap.c |   34 ++++++++++++++++------------------
 slub.c    |    2 --
 2 files changed, 16 insertions(+), 20 deletions(-)

Patch is noisy due to whitespace.

diff -ru linux-2.6.21-old/mm/filemap.c linux-2.6.21/mm/filemap.c
--- linux-2.6.21-old/mm/filemap.c	2007-05-30 02:53:04.000000000 -0400
+++ linux-2.6.21/mm/filemap.c	2007-05-30 01:43:30.000000000 -0400
@@ -2176,24 +2176,22 @@
 			continue;
 		}
 zero_length_segment:
-		if (likely(copied >= 0)) {
-			if (!status)
-				status = copied;
-
-			if (status >= 0) {
-				written += status;
-				count -= status;
-				pos += status;
-				buf += status;
-				if (unlikely(nr_segs > 1)) {
-					filemap_set_next_iovec(&cur_iov,
-							&iov_base, status);
-					if (count)
-						buf = cur_iov->iov_base +
-							iov_base;
-				} else {
-					iov_base += status;
-				}
+		if (!status)
+			status = copied;
+
+		if (status >= 0) {
+			written += status;
+			count -= status;
+			pos += status;
+			buf += status;
+			if (unlikely(nr_segs > 1)) {
+				filemap_set_next_iovec(&cur_iov,
+						&iov_base, status);
+				if (count)
+					buf = cur_iov->iov_base +
+						iov_base;
+			} else {
+				iov_base += status;
 			}
 		}
 		if (unlikely(copied != bytes))
diff -ru linux-2.6.21-old/mm/slub.c linux-2.6.21/mm/slub.c
--- linux-2.6.21-old/mm/slub.c	2007-05-30 02:53:06.000000000 -0400
+++ linux-2.6.21/mm/slub.c	2007-05-30 01:45:33.000000000 -0400
@@ -1966,8 +1966,6 @@
 	s->size = size;
 
 	s->order = calculate_order(size);
-	if (s->order < 0)
-		return 0;
 
 	/*
 	 * Determine the number of objects per slab
