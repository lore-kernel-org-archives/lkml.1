Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZBPH0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZBPH0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZBPHZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:25:52 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:43004 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZBPHZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:25:51 -0500
Subject: [PATCH 1/3] block: Add block_flush_device()
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com,
       fernando@kic.ac.jp, rwheeler@redhat.com, linux-fsdevel@vger.kernel.org
In-Reply-To: <1234768181.32677.7.camel@sebastian.kern.oss.ntt.co.jp>
References: <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090116163039.GE10617@duck.suse.cz>
	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
	 <1234435245.15433.19.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090215224659.GG10706@mini-me.lan>
	 <1234768181.32677.7.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Mon, 16 Feb 2009 16:25:47 +0900
Message-Id: <1234769147.32677.19.camel@sebastian.kern.oss.ntt.co.jp>
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

diff -urNp linux-2.6.29-rc4-orig/fs/buffer.c linux-2.6.29-rc4/fs/buffer.c
--- linux-2.6.29-rc4-orig/fs/buffer.c	2009-02-16 14:45:11.000000000 +0900
+++ linux-2.6.29-rc4/fs/buffer.c	2009-02-16 14:53:26.000000000 +0900
@@ -165,6 +165,17 @@ void end_buffer_write_sync(struct buffer
 	put_bh(bh);
 }
 
+/* Issue flush of write caches on the block device */
+int block_flush_device(struct super_block *sb)
+{
+	int ret = 0;
+
+	ret = blkdev_issue_flush(sb->s_bdev, NULL);
+
+	return (ret == -EOPNOTSUPP) ? 0 : ret;
+}
+EXPORT_SYMBOL(block_flush_device);
+
 /*
  * Write out and wait upon all the dirty data associated with a block
  * device via its mapping.  Does not take the superblock lock.
diff -urNp linux-2.6.29-rc4-orig/include/linux/buffer_head.h linux-2.6.29-rc4/include/linux/buffer_head.h
--- linux-2.6.29-rc4-orig/include/linux/buffer_head.h	2009-02-16 14:45:12.000000000 +0900
+++ linux-2.6.29-rc4/include/linux/buffer_head.h	2009-02-16 14:48:28.000000000 +0900
@@ -238,6 +238,7 @@ int nobh_write_end(struct file *, struct
 int nobh_truncate_page(struct address_space *, loff_t, get_block_t *);
 int nobh_writepage(struct page *page, get_block_t *get_block,
                         struct writeback_control *wbc);
+int block_flush_device(struct super_block *sb);
 
 void buffer_init(void);
 


