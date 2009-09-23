Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZIWONg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZIWONg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZIWONe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:13:34 -0400
Received: from server1.wserver.cz ([82.113.45.157]:53606 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbZIWONb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:13:31 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] Char: vt_ioctl, fix BKL imbalance
Date: Wed, 23 Sep 2009 16:13:42 +0200
Message-Id: <1253715222-6643-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1253715222-6643-1-git-send-email-jirislaby@gmail.com>
References: <1253715222-6643-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found (again) a BKL imbalance in vt_ioctl.

It's easily triggerable by ioctl(dev_tty_fd, VT_SETACTIVATE, NULL);

Introduced by "vt: add an activate and lock".

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/char/vt_ioctl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 29c651a..6b36ee5 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -981,8 +981,10 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 			goto eperm;
 
 		if (copy_from_user(&vsa, (struct vt_setactivate __user *)arg,
-						sizeof(struct vt_setactivate)))
-			return -EFAULT;
+					sizeof(struct vt_setactivate))) {
+			ret = -EFAULT;
+			goto out;
+		}
 		if (vsa.console == 0 || vsa.console > MAX_NR_CONSOLES)
 			ret = -ENXIO;
 		else {
-- 
1.6.4.2

