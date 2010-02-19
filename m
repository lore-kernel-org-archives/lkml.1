Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0BSRO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:14:59 -0500
Received: from kroah.org ([198.145.64.141]:57436 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab0BSRAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:24 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:37 2010
Message-Id: <20100219163237.355115816@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Junichi Nomura <j-nomura@ce.jp.nec.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [25/93] freeze_bdev: dont deactivate successfully frozen MS_RDONLY sb
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

commit 4b06e5b9ad8abb20105b2b25e42c509ebe9b2d76 upstream.

Thanks Thomas and Christoph for testing and review.
I removed 'smp_wmb()' before up_write from the previous patch,
since up_write() should have necessary ordering constraints.
(I.e. the change of s_frozen is visible to others after up_write)
I'm quite sure the change is harmless but if you are uncomfortable
with Tested-by/Reviewed-by on the modified patch, please remove them.

If MS_RDONLY, freeze_bdev should just up_write(s_umount) instead of
deactivate_locked_super().
Also, keep sb->s_frozen consistent so that remount can check the frozen state.

Otherwise a crash reported here can happen:
http://lkml.org/lkml/2010/1/16/37
http://lkml.org/lkml/2010/1/28/53

This patch should be applied for 2.6.32 stable series, too.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Thomas Backlund <tmb@mandriva.org>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -246,7 +246,8 @@ struct super_block *freeze_bdev(struct block_device *bdev)
 	if (!sb)
 		goto out;
 	if (sb->s_flags & MS_RDONLY) {
-		deactivate_locked_super(sb);
+		sb->s_frozen = SB_FREEZE_TRANS;
+		up_write(&sb->s_umount);
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
 		return sb;
 	}
@@ -307,7 +308,7 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 	BUG_ON(sb->s_bdev != bdev);
 	down_write(&sb->s_umount);
 	if (sb->s_flags & MS_RDONLY)
-		goto out_deactivate;
+		goto out_unfrozen;
 
 	if (sb->s_op->unfreeze_fs) {
 		error = sb->s_op->unfreeze_fs(sb);
@@ -321,11 +322,11 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 		}
 	}
 
+out_unfrozen:
 	sb->s_frozen = SB_UNFROZEN;
 	smp_wmb();
 	wake_up(&sb->s_wait_unfrozen);
 
-out_deactivate:
 	if (sb)
 		deactivate_locked_super(sb);
 out_unlock:


