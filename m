Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbXKUR5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbXKUR5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 12:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXKUR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 12:57:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:24344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbXKUR5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 12:57:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=wRHpuNsfEBvNJUu47V4ly01U0mUAByH1S6E8+fjopTAYRrZWrS9FZrgU1HRhNoEZafdGZ/NqmLSWOAq04kAGJGMDruwGFBbfYeiJYfzfcijx+bGLYmxjLi0+s2yMyyf5tJ7ES7z/cRfW2D1P7TruUwcdoLX4u/cUYQXSfEHn+m8=
Message-ID: <47447184.6040805@gmail.com>
Date: Wed, 21 Nov 2007 20:57:24 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH]loop cleanup in fs/namespace.c - repost
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

Apparently, the following two C language constructs

while (condition) {
	// DO HARD WORK
}

and

repeat:
	if (condition) {
		// DO HARD WORK
		goto repeat;
	}

are equivalent, but the latter one looks quite cumbersome and is not idiomatic. However, the mntput_no_expire() routine in fs/namespace.c is implemented using the goto-based approach.

The patch given below replaces the goto-loop by a while-based one. Besides, it removes the export for the same routine, because there are no users for it outside of the core VFS code.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
diff --git a/fs/namespace.c b/fs/namespace.c
index 0608388..38b4b4a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -278,8 +278,7 @@ static inline void __mntput(struct vfsmo
 
 void mntput_no_expire(struct vfsmount *mnt)
 {
-repeat:
-	if (atomic_dec_and_lock(&mnt->mnt_count, &vfsmount_lock)) {
+	while (atomic_dec_and_lock(&mnt->mnt_count, &vfsmount_lock)) {
 		if (likely(!mnt->mnt_pinned)) {
 			spin_unlock(&vfsmount_lock);
 			__mntput(mnt);
@@ -290,12 +289,9 @@ repeat:
 		spin_unlock(&vfsmount_lock);
 		acct_auto_close_mnt(mnt);
 		security_sb_umount_close(mnt);
-		goto repeat;
 	}
 }
 
-EXPORT_SYMBOL(mntput_no_expire);
-
 void mnt_pin(struct vfsmount *mnt)
 {
 	spin_lock(&vfsmount_lock);
