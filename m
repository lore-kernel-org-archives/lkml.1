Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbYFDMOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbYFDMOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760806AbYFDMKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:36 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:64902 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760793AbYFDMKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=RN3o+ypE8Hfsnql67e0XXAJAAznOXeRfnFQnUIz3x+bsGkVdgS/vA7y3C+y+qYxVwc
         rNsmfNyp21QksjmoNKJHAXooBA3shU9cNMIxxlsuCXDFNFkplKL429evbZJg9nl0K8t4
         wmFScH0y52hMxeVN7Xu/TpwYQUtZIp0JjXrCA=
Message-Id: <20080604115813.346431431@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:47 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Abhay Salunke <abhay_salunke@dell.com>
Subject: [patch -v3 14/22] dell_rbu: use memory_read_from_buffer
Content-Disposition: inline; filename=dell_rbu-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Abhay Salunke <abhay_salunke@dell.com>
---
 drivers/firmware/dell_rbu.c |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

Index: 2.6-git/drivers/firmware/dell_rbu.c
===================================================================
--- 2.6-git.orig/drivers/firmware/dell_rbu.c
+++ 2.6-git/drivers/firmware/dell_rbu.c
@@ -44,6 +44,7 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/dma-mapping.h>
+#include <linux/fs.h>
 
 MODULE_AUTHOR("Abhay Salunke <abhay_salunke@dell.com>");
 MODULE_DESCRIPTION("Driver for updating BIOS image on DELL systems");
@@ -507,11 +508,6 @@ static ssize_t read_packet_data(char *bu
 
 static ssize_t read_rbu_mono_data(char *buffer, loff_t pos, size_t count)
 {
-	unsigned char *ptemp = NULL;
-	size_t bytes_left = 0;
-	size_t data_length = 0;
-	ssize_t ret_count = 0;
-
 	/* check to see if we have something to return */
 	if ((rbu_data.image_update_buffer == NULL) ||
 		(rbu_data.bios_image_size == 0)) {
@@ -519,28 +515,11 @@ static ssize_t read_rbu_mono_data(char *
 			"bios_image_size %lu\n",
 			rbu_data.image_update_buffer,
 			rbu_data.bios_image_size);
-		ret_count = -ENOMEM;
-		goto read_rbu_data_exit;
-	}
-
-	if (pos > rbu_data.bios_image_size) {
-		ret_count = 0;
-		goto read_rbu_data_exit;
+		return -ENOMEM;
 	}
 
-	bytes_left = rbu_data.bios_image_size - pos;
-	data_length = min(bytes_left, count);
-
-	ptemp = rbu_data.image_update_buffer;
-	memcpy(buffer, (ptemp + pos), data_length);
-
-	if ((pos + count) > rbu_data.bios_image_size)
-		/* this was the last copy */
-		ret_count = bytes_left;
-	else
-		ret_count = count;
-      read_rbu_data_exit:
-	return ret_count;
+	return memory_read_from_buffer(buffer, count, &pos,
+			rbu_data.image_update_buffer, rbu_data.bios_image_size);
 }
 
 static ssize_t read_rbu_data(struct kobject *kobj,

-- 
