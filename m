Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYK0KdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYK0KdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYK0KcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:32:21 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:45980 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYK0KcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:18 -0500
Message-Id: <20081127103127.797415689@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:21 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 01/60] vmcp: remove BKL
Content-Disposition: inline; filename=100-vmcp-bkl.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

The vmcp driver uses the session->mutex for concurrent access of the data
structures. Therefore, the BKL in vmcp_open does not protect against any
other function in the driver.
The BLK in vmcp_open would protect concurrent access to the module init
but all necessary steps ave finished before misc_register is called.
We can safely remove the lock_kernel from vcmp.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/vmcp.c |    3 ---
 1 file changed, 3 deletions(-)

Index: quilt-2.6/drivers/s390/char/vmcp.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/vmcp.c
+++ quilt-2.6/drivers/s390/char/vmcp.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <asm/cpcmd.h>
 #include <asm/debug.h>
 #include <asm/uaccess.h>
@@ -41,13 +40,11 @@ static int vmcp_open(struct inode *inode
 	if (!session)
 		return -ENOMEM;
 
-	lock_kernel();
 	session->bufsize = PAGE_SIZE;
 	session->response = NULL;
 	session->resp_size = 0;
 	mutex_init(&session->mutex);
 	file->private_data = session;
-	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

