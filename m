Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbZC3MgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbZC3MgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZC3MgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:36:07 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:54040 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbZC3MgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:36:05 -0400
Message-ID: <49D0BCB2.30202@oss.ntt.co.jp>
Date: Mon, 30 Mar 2009 21:36:02 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org,
       bzolnier@gmail.com
Subject: [PATCH 7/7] reiserfs: propagate issue-flush error code
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp>
In-Reply-To: <49D0B535.2010106@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkdev_issue_flush() may fail (i.e. due to media error on FLUSH CACHE
command execution) so its users should check for the return value.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.29-orig/fs/reiserfs/file.c linux-2.6.29/fs/reiserfs/file.c
--- linux-2.6.29-orig/fs/reiserfs/file.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/fs/reiserfs/file.c	2009-03-30 16:19:19.000000000 +0900
@@ -146,8 +146,9 @@ static int reiserfs_sync_file(struct fil
  	reiserfs_write_lock(p_s_inode->i_sb);
  	barrier_done = reiserfs_commit_for_inode(p_s_inode);
  	reiserfs_write_unlock(p_s_inode->i_sb);
-	if (barrier_done != 1 && reiserfs_barrier_flush(p_s_inode->i_sb))
-		blkdev_issue_flush(p_s_inode->i_sb->s_bdev, NULL);
+	if (!n_err && barrier_done != 1 &&
+			reiserfs_barrier_flush(p_s_inode->i_sb))
+		n_err = block_flush_device(p_s_inode->i_sb->s_bdev);
  	if (barrier_done < 0)
  		return barrier_done;
  	return (n_err < 0) ? -EIO : 0;
