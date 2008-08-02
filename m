Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbYHBTrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbYHBTrs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbYHBTrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:47:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:48447 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbYHBTrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:47:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Yxo62OqK5rbsNPKWD0ofWE3c9CUH+dAq/vpoVoHZBNwe19RaFHGLGoKRSMUWP0E+BL
         dNxFlOIl5mMui5rplbKDetq1M0EFf9efepdU0YznIl5263IwgG1eA7+UgtQBDJCHcSBJ
         YjLLFj0qjASQilk2ixu/5typ635uJ0vO/54wM=
From: Oliver Pinter <oliver.pntr@gmail.com>
To: Jon Tollefson <kniht@linux.vnet.ibm.com>, stable@kernel.org
Subject: [RFC, 2.6.26.2-rc1] fs: check for statfs overflow
Date: Sat, 2 Aug 2008 21:59:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Nishanth Aravamudan <nacc@us.ibm.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oliver Pinter <oliver.pntr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808022159.18575.oliver.pntr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f4a67cceee4a6f5ed38011a698c9e34747270ae5 Mon Sep 17 00:00:00 2001
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Date: Wed, 23 Jul 2008 21:27:55 -0700
Subject: [PATCH] fs: check for statfs overflow

[ Upstream commit f4a67cceee4a6f5ed38011a698c9e34747270ae5 ]

Adds a check for an overflow in the filesystem size so if someone is
checking with statfs() on a 16G blocksize hugetlbfs in a 32bit binary that
it will report back EOVERFLOW instead of a size of 0.

Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/compat.c b/fs/compat.c
index ed43e17..b466042 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -197,8 +197,8 @@ static int put_compat_statfs(struct compat_statfs __user *ubuf, struct kstatfs *
 {
 	
 	if (sizeof ubuf->f_blocks == 4) {
-		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail) &
-		    0xffffffff00000000ULL)
+		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail |
+		     kbuf->f_bsize | kbuf->f_frsize) & 0xffffffff00000000ULL)
 			return -EOVERFLOW;
 		/* f_files and f_ffree may be -1; it's okay
 		 * to stuff that into 32 bits */
@@ -271,8 +271,8 @@ out:
 static int put_compat_statfs64(struct compat_statfs64 __user *ubuf, struct kstatfs *kbuf)
 {
 	if (sizeof ubuf->f_blocks == 4) {
-		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail) &
-		    0xffffffff00000000ULL)
+		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail |
+		     kbuf->f_bsize | kbuf->f_frsize) & 0xffffffff00000000ULL)
 			return -EOVERFLOW;
 		/* f_files and f_ffree may be -1; it's okay
 		 * to stuff that into 32 bits */
diff --git a/fs/open.c b/fs/open.c
index a99ad09..bb98d2f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -64,7 +64,8 @@ static int vfs_statfs_native(struct dentry *dentry, struct statfs *buf)
 		memcpy(buf, &st, sizeof(st));
 	else {
 		if (sizeof buf->f_blocks == 4) {
-			if ((st.f_blocks | st.f_bfree | st.f_bavail) &
+			if ((st.f_blocks | st.f_bfree | st.f_bavail |
+			     st.f_bsize | st.f_frsize) &
 			    0xffffffff00000000ULL)
 				return -EOVERFLOW;
 			/*
