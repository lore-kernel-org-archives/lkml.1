Return-Path: <linux-kernel-owner+w=401wt.eu-S934477AbZLKEtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbZLKEtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760856AbZLKEgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:20 -0500
Received: from kroah.org ([198.145.64.141]:52914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759486AbZLKEfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:45 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:35 2009
Message-Id: <20091211042734.391001793@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>
Subject: [15/90] ext4: Restore wbc->range_start in ext4_da_writepages()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0015-ext4-Restore-wbc-range_start-in-ext4_da_writepages.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit de89de6e0cf4b1eb13f27137cf2aa40d287aabdf)

To solve a lock inversion problem, we implement part of the
range_cyclic algorithm in ext4_da_writepages().  (See commit 2acf2c26
for more details.)

As part of that change wbc->range_start was modified by ext4's
writepages function, which causes its callers to get confused since
they aren't expecting the filesystem to modify it.  The simplest fix
is to save and restore wbc->range_start in ext4_da_writepages.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2750,6 +2750,7 @@ static int ext4_da_writepages(struct add
 	long pages_skipped;
 	int range_cyclic, cycled = 1, io_done = 0;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
+	loff_t range_start = wbc->range_start;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
 	trace_ext4_da_writepages(inode, wbc);
@@ -2918,6 +2919,7 @@ out_writepages:
 	if (!no_nrwrite_index_update)
 		wbc->no_nrwrite_index_update = 0;
 	wbc->nr_to_write -= nr_to_writebump;
+	wbc->range_start = range_start;
 	trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
 	return ret;
 }


