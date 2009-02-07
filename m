Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbZBGAHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbZBGAHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZBGAGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:06:54 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34881 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbZBGAGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:06:54 -0500
Date: Fri, 6 Feb 2009 18:06:51 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: [PATCH] eCryptfs: Regression in unencrypted filename symlinks
Message-ID: <20090207000649.GA10560@boomer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The addition of filename encryption caused a regression in unencrypted
filename symlink support.  ecryptfs_copy_filename() is used when dealing
with unencrypted filenames and it reported that the new, copied filename
was a character longer than it should have been.

This caused the return value of readlink() to count the NULL byte of the
symlink target.  Most applications don't care about the extra NULL byte,
but a version control system (bzr) helped in discovering the bug.

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
---
 fs/ecryptfs/crypto.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index c01e043..f6caeb1 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1716,7 +1716,7 @@ static int ecryptfs_copy_filename(char **copied_name, size_t *copied_name_size,
 {
 	int rc = 0;
 
-	(*copied_name) = kmalloc((name_size + 2), GFP_KERNEL);
+	(*copied_name) = kmalloc((name_size + 1), GFP_KERNEL);
 	if (!(*copied_name)) {
 		rc = -ENOMEM;
 		goto out;
@@ -1726,7 +1726,7 @@ static int ecryptfs_copy_filename(char **copied_name, size_t *copied_name_size,
 						 * in printing out the
 						 * string in debug
 						 * messages */
-	(*copied_name_size) = (name_size + 1);
+	(*copied_name_size) = name_size;
 out:
 	return rc;
 }
-- 
1.5.3.7

