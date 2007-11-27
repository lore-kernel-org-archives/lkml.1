Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbXK0Uz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbXK0Uz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbXK0Uzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:55:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43500 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756793AbXK0Uzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:55:48 -0500
Date: Tue, 27 Nov 2007 12:55:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       mbligh@mbligh.org, val.henson@intel.com
Subject: Re: [PATCH] fix up ext2_fs.h for userspace after reservations
 backport
Message-Id: <20071127125509.7cda1328.akpm@linux-foundation.org>
In-Reply-To: <474B003D.7040908@redhat.com>
References: <474B003D.7040908@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 11:19:57 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> From: Tobias Poschwatta <tp@fonz.de>
> 
> In commit a686cd898bd999fd026a51e90fb0a3410d258ddb:
> 
>  "Val's cross-port of the ext3 reservations code into ext2."
> 
> include/linux/ext2_fs.h got a new function whose return value is only
> defined if __KERNEL__ is defined. Putting #ifdef __KERNEL__ around the
> function seems to help, patch below.
> 
> BR, Tobias
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> ---
> 
> Index: linux-2.6.24-rc1/include/linux/ext2_fs.h
> ===================================================================
> --- linux-2.6.24-rc1.orig/include/linux/ext2_fs.h
> +++ linux-2.6.24-rc1/include/linux/ext2_fs.h
> @@ -563,11 +563,13 @@ enum {
>  					 ~EXT2_DIR_ROUND)
>  #define EXT2_MAX_REC_LEN		((1<<16)-1)
>  
> +#ifdef __KERNEL__
>  static inline ext2_fsblk_t
>  ext2_group_first_block_no(struct super_block *sb, unsigned long group_no)
>  {
>  	return group_no * (ext2_fsblk_t)EXT2_BLOCKS_PER_GROUP(sb) +
>  		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block);
>  }
> +#endif
>  
>  #endif	/* _LINUX_EXT2_FS_H */

I did this instead:

From: Tobias Poschwatta <tp@fonz.de>

In commit a686cd898bd999fd026a51e90fb0a3410d258ddb:

 "Val's cross-port of the ext3 reservations code into ext2."

include/linux/ext2_fs.h got a new function whose return value is only
defined if __KERNEL__ is defined. Putting #ifdef __KERNEL__ around the
function seems to help, patch below.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ext2.h          |    7 +++++++
 include/linux/ext2_fs.h |    7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/ext2_fs.h~fix-up-ext2_fsh-for-userspace-after-reservations-backport include/linux/ext2_fs.h
--- a/include/linux/ext2_fs.h~fix-up-ext2_fsh-for-userspace-after-reservations-backport
+++ a/include/linux/ext2_fs.h
@@ -563,11 +563,4 @@ enum {
 					 ~EXT2_DIR_ROUND)
 #define EXT2_MAX_REC_LEN		((1<<16)-1)
 
-static inline ext2_fsblk_t
-ext2_group_first_block_no(struct super_block *sb, unsigned long group_no)
-{
-	return group_no * (ext2_fsblk_t)EXT2_BLOCKS_PER_GROUP(sb) +
-		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block);
-}
-
 #endif	/* _LINUX_EXT2_FS_H */
diff -puN fs/ext2/ext2.h~fix-up-ext2_fsh-for-userspace-after-reservations-backport fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~fix-up-ext2_fsh-for-userspace-after-reservations-backport
+++ a/fs/ext2/ext2.h
@@ -178,3 +178,10 @@ extern const struct inode_operations ext
 /* symlink.c */
 extern const struct inode_operations ext2_fast_symlink_inode_operations;
 extern const struct inode_operations ext2_symlink_inode_operations;
+
+static inline ext2_fsblk_t
+ext2_group_first_block_no(struct super_block *sb, unsigned long group_no)
+{
+	return group_no * (ext2_fsblk_t)EXT2_BLOCKS_PER_GROUP(sb) +
+		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block);
+}
_

