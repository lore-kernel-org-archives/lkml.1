Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbZKUIQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbZKUIQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 03:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZKUIQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 03:16:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57160 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbZKUIQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 03:16:47 -0500
Date: Sat, 21 Nov 2009 09:16:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, San Mehat <san@google.com>,
       Daniel Walker <dwalker@fifo99.com>, Iliyan Malchev <malchev@google.com>,
       Greg KH <greg@kroah.com>
Subject: [PATCH 3/3] staging/dream: fix memory leak in camera error path
Message-ID: <20091121081647.GC2597@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cppcheck found that ctrl_pmsm is leaked if the open operation fails.

Signed-off-by: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/camera/msm_camera.c b/drivers/staging/dream/camera/msm_camera.c
index 7d93877..87e118d 100644
--- a/drivers/staging/dream/camera/msm_camera.c
+++ b/drivers/staging/dream/camera/msm_camera.c
@@ -1885,8 +1885,10 @@ static int msm_open_control(struct inode *inode, struct file *filep)
 		return -ENOMEM;
 
 	rc = msm_open_common(inode, filep, 0);
-	if (rc < 0)
+	if (rc < 0) {
+		kfree(ctrl_pmsm);
 		return rc;
+	}
 
 	ctrl_pmsm->pmsm = filep->private_data;
 	filep->private_data = ctrl_pmsm;



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
