Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbXHVI4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbXHVI4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbXHVIwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:49 -0400
Received: from 1wt.eu ([62.212.114.60]:1938 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbXHVIwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:47 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083953.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:38:59 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Alan Cox <alan@redhat.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 15/58] aacraid: fix security hole
Content-Disposition: inline; filename=0015-aacraid-fix-security-hole.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On the SCSI layer ioctl path there is no implicit permissions check for
ioctls (and indeed other drivers implement unprivileged ioctls). aacraid
however allows all sorts of very admin only things to be done so should
check.

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Mark Salyzyn <mark_salyzyn@adaptec.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/scsi/aacraid/linit.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index d2cf875..3d5cff7 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -539,6 +539,8 @@ static int aac_cfg_open(struct inode *inode, struct file *file)
 static int aac_cfg_ioctl(struct inode *inode,  struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
 	return aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
 }
 
@@ -592,6 +594,8 @@ static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 
 static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
 	return aac_compat_do_ioctl((struct aac_dev *)file->private_data, cmd, arg);
 }
 #endif
-- 
1.5.2.5

-- 
