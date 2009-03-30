Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbZC3Bg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbZC3Bg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZC3BgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:36:17 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60343 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZC3BgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:36:17 -0400
Message-ID: <49D0220B.3000205@oss.ntt.co.jp>
Date: Mon, 30 Mar 2009 10:36:11 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] block: Add block_flush_device()
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp>
In-Reply-To: <49D01F94.6000101@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper function that should be used by filesystems that need
to flush the underlying block device on fsync()/fdatasync().

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.29-orig/fs/buffer.c linux-2.6.29/fs/buffer.c
--- linux-2.6.29-orig/fs/buffer.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/fs/buffer.c	2009-03-28 20:43:51.000000000 +0900
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
diff -urNp linux-2.6.29-orig/include/linux/buffer_head.h linux-2.6.29/include/linux/buffer_head.h
--- linux-2.6.29-orig/include/linux/buffer_head.h	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/include/linux/buffer_head.h	2009-03-28 20:43:51.000000000 +0900
@@ -238,6 +238,7 @@ int nobh_write_end(struct file *, struct
  int nobh_truncate_page(struct address_space *, loff_t, get_block_t *);
  int nobh_writepage(struct page *page, get_block_t *get_block,
                          struct writeback_control *wbc);
+int block_flush_device(struct super_block *sb);

  void buffer_init(void);

