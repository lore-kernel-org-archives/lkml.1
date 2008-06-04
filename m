Return-Path: <linux-kernel-owner+w=401wt.eu-S1762690AbYFDMRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690AbYFDMRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760939AbYFDMLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:11:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:20551 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760936AbYFDMLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:11:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=JqCHQ1HKR+r4wG4IvLHixN+F75s6ft6aOoZlbjzgWqZoO0ynbnuvU0Qg+BPTBE+3cH
         8EW1U3lVw7Q8epuU3OoavGYU7N9VksYEevtp/ynuzUvLSBCY+lDLKL5DaptYDZ3f5VDN
         DYCHuaixkeR6oE/3XceZOoSAuu/hjCHQ0UnHg=
Message-Id: <20080604115839.844712587@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:52 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [patch -v3 19/22] s390/cio: use memory_read_from_buffer
Content-Disposition: inline; filename=cio-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/cio/chp.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: 2.6-git/drivers/s390/cio/chp.c
===================================================================
--- 2.6-git.orig/drivers/s390/cio/chp.c
+++ 2.6-git/drivers/s390/cio/chp.c
@@ -15,6 +15,7 @@
 #include <linux/wait.h>
 #include <linux/mutex.h>
 #include <linux/errno.h>
+#include <linux/fs.h>
 #include <asm/chpid.h>
 #include <asm/sclp.h>
 
@@ -141,21 +142,14 @@ static ssize_t chp_measurement_chars_rea
 {
 	struct channel_path *chp;
 	struct device *device;
-	unsigned int size;
 
 	device = container_of(kobj, struct device, kobj);
 	chp = to_channelpath(device);
 	if (!chp->cmg_chars)
 		return 0;
 
-	size = sizeof(struct cmg_chars);
-
-	if (off > size)
-		return 0;
-	if (off + count > size)
-		count = size - off;
-	memcpy(buf, chp->cmg_chars + off, count);
-	return count;
+	return memory_read_from_buffer(buf, count, &off,
+				chp->cmg_chars, sizeof(struct cmg_chars));
 }
 
 static struct bin_attribute chp_measurement_chars_attr = {

-- 
