Return-Path: <linux-kernel-owner+w=401wt.eu-S1761292AbYFDMOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292AbYFDMOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760779AbYFDMKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:61174 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760770AbYFDMKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=Si8qIs9kLWXOydpsr/XKbCW3I+wsD/ovyxx2dx7isH271/fvW+TrrhXRU4XSISHCZP
         LS/b4ZMu87IoCmkxR6SuEzn1qLe31xc951wWLQqz95W2jBa4IniyaDRNd8n68hhDz/vT
         3DbZuhZeuDvOJfYuwLYaNzqlnihU4GqtHHXeo=
Message-Id: <20080604115808.548356272@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:46 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Subject: [patch -v3 13/22] dcdbas: use memory_read_from_buffer
Content-Disposition: inline; filename=dcdbas-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
---
 drivers/firmware/dcdbas.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

Index: 2.6-git/drivers/firmware/dcdbas.c
===================================================================
--- 2.6-git.orig/drivers/firmware/dcdbas.c
+++ 2.6-git/drivers/firmware/dcdbas.c
@@ -34,6 +34,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
+#include <linux/fs.h>
 #include <asm/io.h>
 
 #include "dcdbas.h"
@@ -152,20 +153,11 @@ static ssize_t smi_data_read(struct kobj
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
 {
-	size_t max_read;
 	ssize_t ret;
 
 	mutex_lock(&smi_data_lock);
-
-	if (pos >= smi_data_buf_size) {
-		ret = 0;
-		goto out;
-	}
-
-	max_read = smi_data_buf_size - pos;
-	ret = min(max_read, count);
-	memcpy(buf, smi_data_buf + pos, ret);
-out:
+	ret = memory_read_from_buffer(buf, count, &pos, smi_data_buf,
+					smi_data_buf_size);
 	mutex_unlock(&smi_data_lock);
 	return ret;
 }

-- 
