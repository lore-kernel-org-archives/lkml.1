Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbZBLKjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbZBLKjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZBLKjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:39:00 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45948 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbZBLKi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:38:59 -0500
Subject: block: Add block_flush_device()
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com,
       fernando@kic.ac.jp
In-Reply-To: <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
References: <20090114165952.GH6222@mit.edu>
	 <1232021211.14626.19.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090115234544.GA7579@duck.suse.cz>
	 <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090116163039.GE10617@duck.suse.cz>
	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 12 Feb 2009 19:38:57 +0900
Message-Id: <1234435137.15433.13.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper function that should be used by filesystems that need
to flush the underlying block device on fsync()/fdatasync().

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.29-rc3-orig/fs/buffer.c linux-2.6.29-rc3/fs/buffer.c
--- linux-2.6.29-rc3-orig/fs/buffer.c	2009-01-29 09:47:51.000000000 +0900
+++ linux-2.6.29-rc3/fs/buffer.c	2009-01-29 20:11:29.000000000 +0900
@@ -165,6 +165,24 @@ void end_buffer_write_sync(struct buffer
 	put_bh(bh);
 }
 
+/* Issue flush of write caches on the block device */
+int block_flush_device(struct super_block *sb)
+{
+	int ret = 0;
+
+	if (!(sb->s_flags & MS_FLUSHONFSYNC))
+		return ret;
+
+	ret = blkdev_issue_flush(sb->s_bdev, NULL);
+
+	if (ret == -EOPNOTSUPP)
+		return 0;
+
+	return ret;
+}
+EXPORT_SYMBOL(block_flush_device);
+
+
 /*
  * Write out and wait upon all the dirty data associated with a block
  * device via its mapping.  Does not take the superblock lock.
diff -urNp linux-2.6.29-rc3-orig/include/linux/buffer_head.h linux-2.6.29-rc3/include/linux/buffer_head.h
--- linux-2.6.29-rc3-orig/include/linux/buffer_head.h	2009-01-29 09:47:51.000000000 +0900
+++ linux-2.6.29-rc3/include/linux/buffer_head.h	2009-01-29 19:26:33.000000000 +0900
@@ -238,6 +238,7 @@ int nobh_write_end(struct file *, struct
 int nobh_truncate_page(struct address_space *, loff_t, get_block_t *);
 int nobh_writepage(struct page *page, get_block_t *get_block,
                         struct writeback_control *wbc);
+int block_flush_device(struct super_block *sb);
 
 void buffer_init(void);
 


