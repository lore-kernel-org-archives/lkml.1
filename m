Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbYBEKdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbYBEKdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYBEKdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:33:33 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37009 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbYBEKdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:33:32 -0500
Date: Tue, 5 Feb 2008 03:33:28 -0700
From: dann frazier <dannf@hp.com>
To: Willy TARREAU <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] 2.4: [SCSI] aacraid: Fix security hole
Message-ID: <20080205103327.GB1792@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a 2.4 backport of a linux-2.6 change by Alan Cox.
(commit 60395bb60e0b5e4e0808ac8eb07a92f6c9cdea1f)

It has been build-tested only (I don't have the hardware).
CVE-2007-4308 was assigned for this issue.

Commit log from 2.6 follows.

  On the SCSI layer ioctl path there is no implicit permissions check for
  ioctls (and indeed other drivers implement unprivileged ioctls). aacraid
  however allows all sorts of very admin only things to be done so should
  check.
---
 drivers/scsi/aacraid/linit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Signed-off-by: dann frazier <dannf@hp.com>

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 57d0a40..c6d7bdf 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -683,6 +683,8 @@ static int aac_cfg_release(struct inode * inode, struct file * file )
 static int aac_cfg_ioctl(struct inode * inode,  struct file * file, unsigned int cmd, unsigned long arg )
 {
 	struct aac_dev *dev = aac_devices[MINOR(inode->i_rdev)];
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
 	return aac_do_ioctl(dev, cmd, (void *)arg);
 }
 
-- 
1.5.4

