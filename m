Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbYFDMQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbYFDMQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760560AbYFDMLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:11:12 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:64902 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760926AbYFDMLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=RFZF0YtbmPgBm1sNnQjfFDHsF5M3x7ypTIREPkmJIk3ncaVJuQ1GVGwJLb+AQh1ZYI
         U5GQyU4HXsmGgrjanbT/QHfVXlUjafsExJcUsa2nqrdmKaBNVAMo5+Kl7THcVsMtMm8Z
         DDOqbs/sGjoTXafODiK3iCiyLGKrqcE/w0ntk=
Message-Id: <20080604115844.881301782@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:53 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [patch -v3 20/22] s390: use memory_read_from_buffer
Content-Disposition: inline; filename=s390-ipl-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 arch/s390/kernel/ipl.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

Index: 2.6-git/arch/s390/kernel/ipl.c
===================================================================
--- 2.6-git.orig/arch/s390/kernel/ipl.c
+++ 2.6-git/arch/s390/kernel/ipl.c
@@ -14,6 +14,7 @@
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/ctype.h>
+#include <linux/fs.h>
 #include <asm/ipl.h>
 #include <asm/smp.h>
 #include <asm/setup.h>
@@ -285,14 +286,8 @@ static struct kobj_attribute sys_ipl_dev
 static ssize_t ipl_parameter_read(struct kobject *kobj, struct bin_attribute *attr,
 				  char *buf, loff_t off, size_t count)
 {
-	unsigned int size = IPL_PARMBLOCK_SIZE;
-
-	if (off > size)
-		return 0;
-	if (off + count > size)
-		count = size - off;
-	memcpy(buf, (void *)IPL_PARMBLOCK_START + off, count);
-	return count;
+	return memory_read_from_buffer(buf, count, &off, IPL_PARMBLOCK_START,
+					IPL_PARMBLOCK_SIZE);
 }
 
 static struct bin_attribute ipl_parameter_attr = {
@@ -310,12 +305,7 @@ static ssize_t ipl_scp_data_read(struct 
 	unsigned int size = IPL_PARMBLOCK_START->ipl_info.fcp.scp_data_len;
 	void *scp_data = &IPL_PARMBLOCK_START->ipl_info.fcp.scp_data;
 
-	if (off > size)
-		return 0;
-	if (off + count > size)
-		count = size - off;
-	memcpy(buf, scp_data + off, count);
-	return count;
+	return memory_read_from_buffer(buf, count, &off, scp_data, size);
 }
 
 static struct bin_attribute ipl_scp_data_attr = {

-- 
