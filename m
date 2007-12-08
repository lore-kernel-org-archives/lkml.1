Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbXLHUoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbXLHUoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXLHUoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:44:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:39375 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbXLHUo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:44:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=u1xbxiVX8iODSvY7ukvsUUMDhqP7rvlsiRFUUEAKzsrKRJr9LeRgltLX1tZpvu1+eE4u3pmE0ALMZAOwc/MEUcXGTQNOJ3CXOb2E/QnOyULsWdNjdhZor+ZETFh2s8mQiT/JAGxmuhF4h79rAoSCn2SVbcppuHpiEtMTCZh+H6k=
Date: Sat, 8 Dec 2007 21:45:27 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rawmidi: let sparse know what is going on _for real_
Message-ID: <20071208204520.GE5087@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rawmidi: let sparse know what is going on _for real_

snd_rawmidi_kernel_read1/write1 weren't annotated but used
copy_to_user/copy_from_user when one of parameters (kernel) was equal to 0
remove it and add properly annotated parameter

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 sound/core/rawmidi.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index b8e700b..902a79f 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -912,7 +912,8 @@ int snd_rawmidi_receive(struct snd_rawmidi_substream *substream,
 }

 static long snd_rawmidi_kernel_read1(struct snd_rawmidi_substream *substream,
-				     unsigned char *buf, long count, int kernel)
+				     unsigned char __user *userbuf,
+				     unsigned char *kernelbuf, long count)
 {
 	unsigned long flags;
 	long result = 0, count1;
@@ -925,11 +926,11 @@ static long snd_rawmidi_kernel_read1(struct snd_rawmidi_substream *substream,
 		spin_lock_irqsave(&runtime->lock, flags);
 		if (count1 > (int)runtime->avail)
 			count1 = runtime->avail;
-		if (kernel) {
-			memcpy(buf + result, runtime->buffer + runtime->appl_ptr, count1);
-		} else {
+		if (kernelbuf)
+			memcpy(kernelbuf + result, runtime->buffer + runtime->appl_ptr, count1);
+		if (userbuf) {
 			spin_unlock_irqrestore(&runtime->lock, flags);
-			if (copy_to_user((char __user *)buf + result,
+			if (copy_to_user(userbuf + result,
 					 runtime->buffer + runtime->appl_ptr, count1)) {
 				return result > 0 ? result : -EFAULT;
 			}
@@ -949,7 +950,7 @@ long snd_rawmidi_kernel_read(struct snd_rawmidi_substream *substream,
 			     unsigned char *buf, long count)
 {
 	snd_rawmidi_input_trigger(substream, 1);
-	return snd_rawmidi_kernel_read1(substream, buf, count, 1);
+	return snd_rawmidi_kernel_read1(substream, NULL/*userbuf*/, buf, count);
 }

 static ssize_t snd_rawmidi_read(struct file *file, char __user *buf, size_t count,
@@ -990,8 +991,9 @@ static ssize_t snd_rawmidi_read(struct file *file, char __user *buf, size_t coun
 		}
 		spin_unlock_irq(&runtime->lock);
 		count1 = snd_rawmidi_kernel_read1(substream,
-						  (unsigned char __force *)buf,
-						  count, 0);
+						  (unsigned char __user *)buf,
+						  NULL/*kernelbuf*/,
+						  count);
 		if (count1 < 0)
 			return result > 0 ? result : count1;
 		result += count1;
@@ -1132,13 +1134,15 @@ int snd_rawmidi_transmit(struct snd_rawmidi_substream *substream,
 }

 static long snd_rawmidi_kernel_write1(struct snd_rawmidi_substream *substream,
-				      const unsigned char *buf, long count, int kernel)
+				      const unsigned char __user *userbuf,
+				      const unsigned char *kernelbuf,
+				      long count)
 {
 	unsigned long flags;
 	long count1, result;
 	struct snd_rawmidi_runtime *runtime = substream->runtime;

-	snd_assert(buf != NULL, return -EINVAL);
+	snd_assert(kernelbuf != NULL || userbuf != NULL, return -EINVAL);
 	snd_assert(runtime->buffer != NULL, return -EINVAL);

 	result = 0;
@@ -1155,12 +1159,12 @@ static long snd_rawmidi_kernel_write1(struct snd_rawmidi_substream *substream,
 			count1 = count;
 		if (count1 > (long)runtime->avail)
 			count1 = runtime->avail;
-		if (kernel) {
-			memcpy(runtime->buffer + runtime->appl_ptr, buf, count1);
-		} else {
+		if (kernelbuf)
+			memcpy(runtime->buffer + runtime->appl_ptr, kernelbuf + result, count1);
+		else if (userbuf) {
 			spin_unlock_irqrestore(&runtime->lock, flags);
 			if (copy_from_user(runtime->buffer + runtime->appl_ptr,
-					   (char __user *)buf, count1)) {
+					   userbuf + result, count1)) {
 				spin_lock_irqsave(&runtime->lock, flags);
 				result = result > 0 ? result : -EFAULT;
 				goto __end;
@@ -1171,7 +1175,6 @@ static long snd_rawmidi_kernel_write1(struct snd_rawmidi_substream *substream,
 		runtime->appl_ptr %= runtime->buffer_size;
 		runtime->avail -= count1;
 		result += count1;
-		buf += count1;
 		count -= count1;
 	}
       __end:
@@ -1185,7 +1188,7 @@ static long snd_rawmidi_kernel_write1(struct snd_rawmidi_substream *substream,
 long snd_rawmidi_kernel_write(struct snd_rawmidi_substream *substream,
 			      const unsigned char *buf, long count)
 {
-	return snd_rawmidi_kernel_write1(substream, buf, count, 1);
+	return snd_rawmidi_kernel_write1(substream, NULL/*userbuf*/, buf, count);
 }

 static ssize_t snd_rawmidi_write(struct file *file, const char __user *buf,
@@ -1226,8 +1229,9 @@ static ssize_t snd_rawmidi_write(struct file *file, const char __user *buf,
 		}
 		spin_unlock_irq(&runtime->lock);
 		count1 = snd_rawmidi_kernel_write1(substream,
-						   (unsigned char __force *)buf,
-						   count, 0);
+						   (unsigned char __user *)buf,
+						   NULL/*kerneluf*/,
+						   count);
 		if (count1 < 0)
 			return result > 0 ? result : count1;
 		result += count1;
