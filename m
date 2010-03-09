Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0CITUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:20:14 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:39160 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab0CITUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:20:11 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@gmail.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 3/3] input: remove BKL from serio_raw
Date: Tue,  9 Mar 2010 16:19:46 -0300
Message-Id: <1268162386-2745-3-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1268162386-2745-2-git-send-email-cascardo@holoscopio.com>
References: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com>
 <1268162386-2745-2-git-send-email-cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serio_raw open function already uses a mutex.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/input/serio/serio_raw.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 27fdaaf..debe4a1 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -81,10 +81,9 @@ static int serio_raw_open(struct inode *inode, struct file *file)
 	struct serio_raw_list *list;
 	int retval = 0;
 
-	lock_kernel();
 	retval = mutex_lock_interruptible(&serio_raw_mutex);
 	if (retval)
-		goto out_bkl;
+		return retval;
 
 	if (!(serio_raw = serio_raw_locate(iminor(inode)))) {
 		retval = -ENODEV;
@@ -109,8 +108,6 @@ static int serio_raw_open(struct inode *inode, struct file *file)
 
 out:
 	mutex_unlock(&serio_raw_mutex);
-out_bkl:
-	unlock_kernel();
 	return retval;
 }
 
-- 
1.6.6.1

