Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYGZHSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYGZHSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 03:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYGZHSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 03:18:30 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:21988 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYGZHSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 03:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ApFz0bWQtJRpEceFZTKKXUwFJQlu0a1tv05LfNTqgYQdD2+UKzYpJZu6P/W4vkQ26K
         byQEkn1wwIS5zSgIEp4tmkIHAmZYinwp7Wcr/86TTDZsK95DIasg3r2crj8VDQQ80oZN
         GdjLFkYxG2Ki3op6+4cGRhPxxpiR73vGiSMf4=
Date: Sat, 26 Jul 2008 11:18:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] proc: fix inode number bogorithmetic
Message-ID: <20080726071828.GA5115@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Id which proc gets from IDR for inode number and id which proc removes
from IDR do not match. E.g. 0x11a transforms into 0x8000011a.

Which stayed unnoticed for a long time because, surprise, idr_remove()
masks out that high bit before doing anything.

All of this due to "| ~MAX_ID_MASK" in release_inode_number().

I still don't understand how it's supposed to work, because "| ~MASK"
is not an inversion for "& MAX" operation.

So, use just one nice, working addition. Make start offset unsigned int,
while I'm at it. It's longness is not used anywhere.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -303,7 +303,7 @@ out:
 static DEFINE_IDR(proc_inum_idr);
 static DEFINE_SPINLOCK(proc_inum_lock); /* protects the above */
 
-#define PROC_DYNAMIC_FIRST 0xF0000000UL
+#define PROC_DYNAMIC_FIRST 0xF0000000U
 
 /*
  * Return an inode number between PROC_DYNAMIC_FIRST and
@@ -311,7 +311,7 @@ static DEFINE_SPINLOCK(proc_inum_lock); /* protects the above */
  */
 static unsigned int get_inode_number(void)
 {
-	int i, inum = 0;
+	unsigned int i;
 	int error;
 
 retry:
@@ -326,21 +326,18 @@ retry:
 	else if (error)
 		return 0;
 
-	inum = (i & MAX_ID_MASK) + PROC_DYNAMIC_FIRST;
-
-	/* inum will never be more than 0xf0ffffff, so no check
-	 * for overflow.
-	 */
-
-	return inum;
+	if (i > UINT_MAX - PROC_DYNAMIC_FIRST) {
+		spin_lock(&proc_inum_lock);
+		idr_remove(&proc_inum_idr, i);
+		spin_unlock(&proc_inum_lock);
+	}
+	return PROC_DYNAMIC_FIRST + i;
 }
 
 static void release_inode_number(unsigned int inum)
 {
-	int id = (inum - PROC_DYNAMIC_FIRST) | ~MAX_ID_MASK;
-
 	spin_lock(&proc_inum_lock);
-	idr_remove(&proc_inum_idr, id);
+	idr_remove(&proc_inum_idr, inum - PROC_DYNAMIC_FIRST);
 	spin_unlock(&proc_inum_lock);
 }
 
-- 
1.5.4.5


