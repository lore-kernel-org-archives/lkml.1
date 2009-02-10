Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZBJUxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZBJUxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZBJUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:53:38 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:41829 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217AbZBJUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:53:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ARhAVfIlF3YI+kFKAO6/XGAs7ZhuNUVmh+fH3jqz4em93e5q8+fS1s+jZ4D4iHl1fG
         ouEHmu2nMaSgeabNeXvSFQgoHsa+b9pdH9tCQIQU5YS5xhQd12qtHfssEP7LPVBXFkAr
         lb9xv8Z4YwwbfinaXrNSbQ9sCqBiPozx8agRk=
Message-ID: <4991E812.80606@gmail.com>
Date: Tue, 10 Feb 2009 21:48:18 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
CC: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] drm: count reaches -1, tested 0
References: <498EEB42.1050509@gmail.com> <4990ACA7.2080100@shipmail.org>
In-Reply-To: <4990ACA7.2080100@shipmail.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Hellström wrote:

> This code is about to be abandoned, but if we're going to fix it,
> instead of pushing the problem to then next while loop, what about
> 
> while (count && condition)
>    count--;
> 
> Can you redo the patch based on that?

Very well reviewed, thanks. Like this?
------------------->8-----------------------8<------------------------

With a postfix decrement in the test count will reach -1 rather than 0,
subsequent tests fail.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/gpu/drm/via/via_dma.c b/drivers/gpu/drm/via/via_dma.c
index 7a339db..029c22a 100644
--- a/drivers/gpu/drm/via/via_dma.c
+++ b/drivers/gpu/drm/via/via_dma.c
@@ -481,11 +481,12 @@ static int via_wait_idle(drm_via_private_t * dev_priv)
 {
 	int count = 10000000;
 
-	while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && count--);
+	while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && --count)
+		;
 
-	while (count-- && (VIA_READ(VIA_REG_STATUS) &
-			   (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY |
-			    VIA_3D_ENG_BUSY))) ;
+	while (count && (VIA_READ(VIA_REG_STATUS) & (VIA_CMD_RGTR_BUSY |
+					VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)))
+		count--;
 	return count;
 }
 
@@ -705,7 +706,7 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
 	switch (d_siz->func) {
 	case VIA_CMDBUF_SPACE:
 		while (((tmp_size = via_cmdbuf_space(dev_priv)) < d_siz->size)
-		       && count--) {
+		       && --count) {
 			if (!d_siz->wait) {
 				break;
 			}
@@ -717,7 +718,7 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
 		break;
 	case VIA_CMDBUF_LAG:
 		while (((tmp_size = via_cmdbuf_lag(dev_priv)) > d_siz->size)
-		       && count--) {
+		       && --count) {
 			if (!d_siz->wait) {
 				break;
 			}
