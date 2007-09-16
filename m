Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbXIPMDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbXIPMDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 08:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbXIPMD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 08:03:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:16048 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXIPMD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 08:03:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=FgNmNaQhMa+0tOYVNgjdjconVyDByjnmbzChoKtH8AfcqVGt+1F0i91HCRwxXhQM78s+VYZRvxVxonTXw7/TIu/7td5layURoLZiGEc80ApH0UgcNDeRk2YS1bDd6RlYJ79IxPxDMG0itljWWK10p77KS/PlJGX9M69awZ2+dFk=
Date: Sun, 16 Sep 2007 20:02:21 +0800
From: lepton <ytht.net@gmail.com>
To: reiserfs-dev@namesys.com
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: [PATCH] 2.6.22.6 reiserfs: work around for dead loop in finish_unfinished
Message-ID: <20070916120221.GA24232@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  There is possible dead loop in finish_unfinished function.
  In most situation, the call chain iput -> ... -> 
  reiserfs_delete_inode -> remove_save_link will success. But for
  some reason such as data corruption, reiserfs_delete_inode fails 
  on reiserfs_do_truncate -> search_for_position_by_key. Then 
  remove_save_link doesn't be called. We always get the same 
  "save_link_key" in the while loop in finish_unfinished function.
  The following patch adds a check for the possible dead loop and 
  just remove save link when deap loop. (against 2.6.22.6)

Signed-off-by: Lepton Wu <ytht.net@gmail.com>

diff -X linux-2.6.22.6/Documentation/dontdiff -pru linux-2.6.22.6/fs/reiserfs/super.c linux-2.6.22.6-lepton/fs/reiserfs/super.c
--- linux-2.6.22.6/fs/reiserfs/super.c	2007-09-14 17:41:15.000000000 +0800
+++ linux-2.6.22.6-lepton/fs/reiserfs/super.c	2007-09-16 19:06:39.000000000 +0800
@@ -144,7 +144,7 @@ static int finish_unfinished(struct supe
 {
 	INITIALIZE_PATH(path);
 	struct cpu_key max_cpu_key, obj_key;
-	struct reiserfs_key save_link_key;
+	struct reiserfs_key save_link_key, last_inode_key;
 	int retval = 0;
 	struct item_head *ih;
 	struct buffer_head *bh;
@@ -165,6 +165,8 @@ static int finish_unfinished(struct supe
 	set_cpu_key_k_offset(&max_cpu_key, ~0U);
 	max_cpu_key.key_length = 3;
 
+	memset(&last_inode_key, 0, sizeof(last_inode_key));
+
 #ifdef CONFIG_QUOTA
 	/* Needed for iput() to work correctly and not trash data */
 	if (s->s_flags & MS_ACTIVE) {
@@ -277,8 +279,16 @@ static int finish_unfinished(struct supe
 			REISERFS_I(inode)->i_flags |= i_link_saved_unlink_mask;
 			/* not completed unlink (rmdir) found */
 			reiserfs_info(s, "Removing %k..", INODE_PKEY(inode));
-			/* removal gets completed in iput */
-			retval = 0;
+			if(memcmp(&last_inode_key, INODE_PKEY(inode),
+				  sizeof(last_inode_key))){
+				last_inode_key = *INODE_PKEY(inode);
+				/* removal gets completed in iput */
+				retval = 0;
+			} else {
+				reiserfs_warning(s, "Dead loop in finish_unfinished detected, just remove save link\n");
+				retval = remove_save_link_only(s, 
+							       &save_link_key, 0);
+			}
 		}
 
 		iput(inode);
