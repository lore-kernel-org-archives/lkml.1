Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbXE1K7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbXE1K7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXE1K7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:59:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:51696 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbXE1K7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ayitEa50nDncY9aXN38PJbI0iwif6jZYSFD+u47tRl5ZwQzBSXFdtrVDSoB/XE/WjmDHzFb/e7TSVDBr5BxLNH5I8EEz67XjMzPAnuJ8ROtaHrJR8WH18DsqE+xsjWoD71o3NYIAAX8dOBLmfTVQnCUok082INxsO8OmHsd8g2E=
Message-ID: <4a3acf9f0705280359s2d4d507bs97d060889f44ba41@mail.gmail.com>
Date: Mon, 28 May 2007 18:59:31 +0800
From: "=?GB2312?B?xNq6y9e319k=?=" <kerneltrack@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: question about __block_commit_write
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all.
   In the snippet code, I add a printk into block_commit_write, I want
to get the bh's block number and device number . I recompiled it in
2.4.20. But I surprise that mutliple output lines are the same.

static int __block_commit_write(struct inode *inode, struct page
*page,  unsigned from, unsigned to)
{
 unsigned block_start, block_end;
 int partial = 0, need_balance_dirty = 0;
 unsigned blocksize;
 struct buffer_head *bh, *head;

 blocksize = 1 << inode->i_blkbits;

 for(bh = head = page->buffers, block_start = 0;
     bh != head || !block_start;
     block_start=block_end, bh = bh->b_this_page) {
  block_end = block_start + blocksize;
  if (block_end <= from || block_start >= to) {
   if (!buffer_uptodate(bh))
    partial = 1;
  } else {
@+   printk(KERN_ERR"dev is %d, blocknr is %d\n", bh->b_dev, bh->b_blocknr);
   set_bit(BH_Uptodate, &bh->b_state);
   if (!atomic_set_buffer_dirty(bh)) {
    __mark_dirty(bh);
    buffer_insert_inode_data_queue(bh, inode);
    need_balance_dirty = 1;
   }
  }
 }

 if (need_balance_dirty)
  balance_dirty();
 /*
  * is this a partial write that happened to make all buffers
  * uptodate then we can optimize away a bogus readpage() for
  * the next read(). Here we 'discover' wether the page went
  * uptodate as a result of this (potentially partial) write.
  */
 if (!partial)
  SetPageUptodate(page);
 return 0;
}


The ouput is following :
dev is 5640, blocknr is 14223
dev is 5640, blocknr is 14223
dev is 5640, blocknr is 14223
dev is 5640, blocknr is 14223
dev is 5640, blocknr is 14223
dev is 5640, blocknr is 14223
.....




I do not know why happened like these?
