Return-Path: <linux-kernel-owner+w=401wt.eu-S933522AbZFQNfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbZFQNfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933483AbZFQNfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:35:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32881 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933481AbZFQNfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:35:22 -0400
Subject: [PATCH 2.6.30-stable] jfs: fix regression preventing coalescing of
 extents
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: "stable@kernel.org" <stable@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 08:35:21 -0500
Message-Id: <1245245721.7926.4.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pick up this patch for the 2.6.30 stable branch.  It has been
committed to mainline as f7c52fd17a7dda42fc9e88c2b2678403419bfe63.
    
Commit fec1878fe952b994125a3be7c94b1322db586f3b caused a regression in
which contiguous blocks being allocated to the end of an extent were
getting a new extent created.  This typically results in files entirely
made up of 1-block extents even though the blocks are contiguous on
disk.
    
Apparently grub doesn't handle a jfs file being fragmented into too many
extents, since it refuses to boot a kernel from jfs that was created by
the 2.6.30 kernel.
    
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Reported-by: Alex <alevkovich@tut.by>

diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
index bbbd5f2..41d6045 100644
--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -391,6 +391,7 @@ int extHint(struct inode *ip, s64 offset, xad_t * xp)
 		}
 		XADaddress(xp, xaddr);
 		XADlength(xp, xlen);
+		XADoffset(xp, prev);
 		/*
 		 * only preserve the abnr flag within the xad flags
 		 * of the returned hint.

-- 
David Kleikamp
IBM Linux Technology Center

