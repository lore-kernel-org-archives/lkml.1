Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbXKMC71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbXKMC71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 21:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbXKMC7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 21:59:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:59494 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbXKMC7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 21:59:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Z46z7/awT8a1AWZtiWuC7FxuvwbmaOizcgxPXf7NoMTg3tjN0km8NAEMiXBHJmwarfwoJVat2U3jTUzPaxui3VpB3Gg6KKtU78io6B+lHn9963cKhWPLEhW1Kx3zqjxvjTqR1ahDp5dItcuGGteGQZMhEeMezMncVoyPVDJCPVw=
Message-ID: <47391300.7070604@gmail.com>
Date: Tue, 13 Nov 2007 05:59:12 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] loop cleanup in fs/namespace.c
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

Although the following non-idiomatic and quite cumbersome C language construct

label:
	if (condition) {
		// DO HARD WORK
		goto label;
	}

is equivalent to a simple while loop

while (condition) {
	// DO HARD WORK
}

it was the "label-if-goto label" approach chosen to implement the loop in the mntput_no_expire() routine located in `fs/namespace.c'.

The patch enclosed to this message changes the goto-based loop to a while-based one, not only saving us two lines of code, but also making the implementation idiomatic and thus more readable.

Thanks,

Dmitri

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

--
diff --git a/fs/namespace.c b/fs/namespace.c
index 0608388..6a0cee1 100644
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
@@ -290,7 +289,6 @@ repeat:
 		spin_unlock(&vfsmount_lock);
 		acct_auto_close_mnt(mnt);
 		security_sb_umount_close(mnt);
-		goto repeat;
 	}
 }
 
