Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZFSPv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZFSPv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZFSPvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:51:48 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:42355 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZFSPvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:51:48 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] floppy: fix lock imbalance
Date: Fri, 19 Jun 2009 17:51:39 +0200
Message-Id: <1245426699-4386-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A crappy macro prevents us unlocking on a fail path.

Expand the macro and unlock appropriatelly.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/block/floppy.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 862b40c..91b7530 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3327,7 +3327,10 @@ static inline int set_geometry(unsigned int cmd, struct floppy_struct *g,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		mutex_lock(&open_lock);
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1)) {
+			mutex_unlock(&open_lock);
+			return -EINTR;
+		}
 		floppy_type[type] = *g;
 		floppy_type[type].name = "user format";
 		for (cnt = type << 2; cnt < (type << 2) + 4; cnt++)
-- 
1.6.3.2

