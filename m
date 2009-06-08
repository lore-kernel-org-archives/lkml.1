Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZFHTYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZFHTYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZFHTXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:14 -0400
Received: from thunk.org ([69.25.196.29]:39517 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZFHTXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 02/49] vfs: Add BUG_ON for delayed and unwritten flags in submit_bh()
Date: Mon,  8 Jun 2009 15:22:20 -0400
Message-Id: <1244488987-32564-3-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-2-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The BH_Delay and BH_Unwritten flags should never leak out to
submit_bh().  So add some BUG_ON() checks to submit_bh so we can get a
stack trace and determine how and why this might have happened.

(Note that only XFS and ext4 use these buffer head flags, and XFS does
not use submit_bh().  So this patch should only modify behavior for
ext4.)

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/buffer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index aed2977..ad01129 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2933,6 +2933,8 @@ int submit_bh(int rw, struct buffer_head * bh)
 	BUG_ON(!buffer_locked(bh));
 	BUG_ON(!buffer_mapped(bh));
 	BUG_ON(!bh->b_end_io);
+	BUG_ON(buffer_delay(bh));
+	BUG_ON(buffer_unwritten(bh));
 
 	/*
 	 * Mask in barrier bit for a write (could be either a WRITE or a
-- 
1.6.3.2.1.gb9f7d.dirty

