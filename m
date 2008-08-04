Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYHDJWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYHDJWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYHDJV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:21:57 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:38608 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbYHDJV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:21:56 -0400
Date: Mon, 04 Aug 2008 18:21:43 +0900 (JST)
Message-Id: <20080804.182143.218269280.nemoto@toshiba-tops.co.jp>
To: Dave Johnson <djohnson@sw.starentnetworks.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: cramfs and named-pipe
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit a97c9bf33f4612e2aed6f000f6b1d268b6814f3c (fix cramfs
making duplicate entries in inode cache) in kernel 2.6.14, named-pipe
on cramfs does not work properly.

It seems the commit make all named-pipe on cramfs share their inode
(and named-pipe buffer).  Is this fix correct?

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 0c3b618..87754ff 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -61,6 +61,9 @@ static int cramfs_iget5_test(struct inode *inode, void *opaque)
 	    (inode->i_rdev != old_decode_dev(cramfs_inode->size)))
 		return 0; /* does not match */
 
+	if (S_ISFIFO(inode->i_mode))
+		return 0; /* does not match */
+
 	return 1; /* matches */
 }
 
