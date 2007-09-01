Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbXIAAMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbXIAAMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 20:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXIAAMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 20:12:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39574 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbXIAAMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 20:12:07 -0400
Subject: [RFC 2/2] JBD: blocks reservation fix for large block support
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: ext4 development <linux-ext4@vger.kernel.org>
Cc: adilger@clusterfs.com, sho@tnes.nec.co.jp, linux-kernel@vger.kernel.org,
       clameter@sgi.com, linux-fsdevel@vger.kernel.org
In-Reply-To: <1188434857.3799.76.camel@localhost.localdomain>
References: <20070828190551.415127746@sgi.com>
	 <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
	 <1188434857.3799.76.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 31 Aug 2007 17:12:21 -0700
Message-Id: <1188605541.3837.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The blocks per page could be less or quals to 1 with the large block support in VM.
The patch fixed the way to calculate the number of blocks to reserve in journal in the
case blocksize > pagesize.



Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: my2.6/fs/jbd/journal.c
===================================================================
--- my2.6.orig/fs/jbd/journal.c	2007-08-31 13:27:16.000000000 -0700
+++ my2.6/fs/jbd/journal.c	2007-08-31 13:28:18.000000000 -0700
@@ -1611,7 +1611,12 @@ void journal_ack_err(journal_t *journal)
 
 int journal_blocks_per_page(struct inode *inode)
 {
-	return 1 << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
+	int bits = PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits;
+
+	if (bits > 0)
+		return 1 << bits;
+	else
+		return 1;
 }
 
 /*
Index: my2.6/fs/jbd2/journal.c
===================================================================
--- my2.6.orig/fs/jbd2/journal.c	2007-08-31 13:32:21.000000000 -0700
+++ my2.6/fs/jbd2/journal.c	2007-08-31 13:32:30.000000000 -0700
@@ -1612,7 +1612,12 @@ void jbd2_journal_ack_err(journal_t *jou
 
 int jbd2_journal_blocks_per_page(struct inode *inode)
 {
-	return 1 << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
+	int bits = PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits;
+
+	if (bits > 0)
+		return 1 << bits;
+	else
+		return 1;
 }
 
 /*


