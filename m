Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbZLXXFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbZLXXFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 18:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZLXXFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 18:05:20 -0500
Received: from THUNK.ORG ([69.25.196.29]:50316 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZLXXFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 18:05:19 -0500
Date: Thu, 24 Dec 2009 18:05:12 -0500
From: tytso@mit.edu
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Message-ID: <20091224230512.GA32757@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 01:28:34AM +0300, Alexander Beregalov wrote:
> 
> Kernel is 2.6.33-rc1-00366-g2f99f5c
> Ext4 mounts ext3 filesystem
> 
> kernel BUG at fs/ext4/inode.c:1063!

OK, that's this BUG which is triggering:

	if (mdb_free) {
		/* Account for allocated meta_blocks */
		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
		BUG_ON(mdb_free < mdb_claim);  <------- BUG triggered
		mdb_free -= mdb_claim;

Can you replicate this?  If so, I'd like to ask you to replicate with
the following debugging patch applied:

--- fs/ext4/inode.c	2009-12-24 17:55:03.736366001 -0500
+++ fs/ext4/inode.c.new	2009-12-24 18:02:58.556366024 -0500
@@ -1060,6 +1060,10 @@
 	if (mdb_free) {
 		/* Account for allocated meta_blocks */
 		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
+		if (mdb_free < mdb_claim)
+			ext4_msg(inode->i_sb, KERN_ERR, "inode #%lu: "
+				 "mdb_free (%d) < mdb_claim (%d) BUG\n",
+				 inode->i_ino, mdb_free, mdb_claim);
 		BUG_ON(mdb_free < mdb_claim);
 		mdb_free -= mdb_claim;

Then once you get the inode number (suppose it's 12345), please send
the output of the following debugfs commands:

debugfs: stat <12345>
debugfs: ncheck 12345

Thanks!!

					- Ted
