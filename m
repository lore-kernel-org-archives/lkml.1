Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab0COIV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 04:21:29 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:38981 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759829Ab0COIV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 04:21:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=fOghTW5X92846Ami4OjTbkZT6xxuZojsLa6FPdSiZQgU0YO2+HhPQJDLJM2/okUm48
         suZufmLGu93GY9RnWFwEDDpl0ttVDufpDtPqRGiQ5mMtyKN5E3Vo4ocSREcRr64Gup0n
         YSVAFK4Nq2M3CTX2NS8aZlkb9FgYFLC+e4gC8=
Date: Mon, 15 Mar 2010 11:21:13 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Hannes Eder <hannes@hanneseder.net>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] udf: potential integer overflow
Message-ID: <20100315082113.GC18181@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jan Kara <jack@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
	Hannes Eder <hannes@hanneseder.net>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bloc->logicalBlockNum is unsigned so it's never less than zero.

When I saw that, it made me worry that "bloc->logicalBlockNum + count"
could overflow.  That's why I changed the check for less than zero
to an overflow check.  (The test works because "count" is also 
unsigned.)

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
GCC 4.1 apparently optimizes overflow checks like this away, but it should
work for other versions of gcc.  I tested with GCC 4.3.
http://www.fefe.de/intof.html

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 19626e2..9a9378b 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -125,9 +125,8 @@ static void udf_bitmap_free_blocks(struct super_block *sb,
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	partmap = &sbi->s_partmaps[bloc->partitionReferenceNum];
-	if (bloc->logicalBlockNum < 0 ||
-	    (bloc->logicalBlockNum + count) >
-		partmap->s_partition_len) {
+	if (bloc->logicalBlockNum + count < count ||
+	    (bloc->logicalBlockNum + count) > partmap->s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
 			  bloc->logicalBlockNum, 0, bloc->logicalBlockNum,
 			  count, partmap->s_partition_len);
@@ -393,9 +392,8 @@ static void udf_table_free_blocks(struct super_block *sb,
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	partmap = &sbi->s_partmaps[bloc->partitionReferenceNum];
-	if (bloc->logicalBlockNum < 0 ||
-	    (bloc->logicalBlockNum + count) >
-		partmap->s_partition_len) {
+	if (bloc->logicalBlockNum + count < count ||
+	    (bloc->logicalBlockNum + count) > partmap->s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
 			  bloc->logicalBlockNum, 0, bloc->logicalBlockNum, count,
 			  partmap->s_partition_len);
