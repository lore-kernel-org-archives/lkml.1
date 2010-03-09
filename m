Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0CITUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:20:32 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:39155 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0CITUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:20:08 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@gmail.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 2/3] input: use input_mutex instead of BKL when opening input device
Date: Tue,  9 Mar 2010 16:19:45 -0300
Message-Id: <1268162386-2745-2-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com>
References: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three types of input character devices: mousedev, joydev and
evdev. They all use the same major device and, then, their opening is
multiplexed in input_open_file.

After the BKL pushdown, this multiplexing is protected by the BKL. But
there's already a mutex used for adding and removing to the table
indexed by input_open_file.

So, we use this mutex instead of the BKL. Since it will call the
handlers' open function under the mutex, I've checked that the current
functions do not call input_{un,}register_{handler,device}, which are
the only other functions to take the mutex.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/input/input.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 41168d5..af9c246 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -23,7 +23,6 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
-#include <linux/smp_lock.h>
 #include "input-compat.h"
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
@@ -1881,7 +1880,7 @@ static int input_open_file(struct inode *inode, struct file *file)
 	const struct file_operations *old_fops, *new_fops = NULL;
 	int err;
 
-	lock_kernel();
+	mutex_lock(&input_mutex);
 	/* No load-on-demand here? */
 	handler = input_table[iminor(inode) >> 5];
 	if (!handler || !(new_fops = fops_get(handler->fops))) {
@@ -1909,7 +1908,7 @@ static int input_open_file(struct inode *inode, struct file *file)
 	}
 	fops_put(old_fops);
 out:
-	unlock_kernel();
+	mutex_unlock(&input_mutex);
 	return err;
 }
 
-- 
1.6.6.1

