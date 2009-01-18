Return-Path: <linux-kernel-owner+w=401wt.eu-S933373AbZAROfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373AbZAROfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 09:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZAROe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 09:34:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:63208 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbZAROe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 09:34:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Urpsjo7KR0yZLUDcRrHopZuTs9c5AXalQ7VG70Yu3Ld66K5l7plM8K460ZDkCfeBh/
         MWx1kqwbqYXndYPdewsPpYFGAZRb40Pbi+mO6A9W7ygdRoap6zf5m0Uj9dMtsrCpfWPn
         HsB858j43e45JRTtGJgDK5CjZor2ZSFwzH6Y8=
Message-ID: <49733E0F.7030305@gmail.com>
Date: Sun, 18 Jan 2009 15:34:55 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: mail@davidkiliani.de, g.gebhardt@meilhaus.de, Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: unsigned won't get negative after subtraction
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also contains a fix I sent earlier, I'm not sure how split this patch,
but this is about the second hunk.

vi drivers/staging/meilhaus/me6000_ao.h +112
typedef struct me6000_ao_subdevice {
...
        unsigned int ao_idx;
...
};

Since unsigned, it won't get negative after subtraction.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/staging/meilhaus/me6000_ao.c b/drivers/staging/meilhaus/me6000_ao.c
index 94f0123..dcb3526 100644
--- a/drivers/staging/meilhaus/me6000_ao.c
+++ b/drivers/staging/meilhaus/me6000_ao.c
@@ -1063,7 +1063,7 @@ static int me6000_ao_io_stream_config(me_subdevice_t * subdevice,
 	}
 
 	if (flags & ME_IO_STREAM_CONFIG_HARDWARE_ONLY) {
-		if (!flags & ME_IO_STREAM_CONFIG_WRAPAROUND) {
+		if (!(flags & ME_IO_STREAM_CONFIG_WRAPAROUND)) {
 			PERROR
 			    ("Hardware ME_IO_STREAM_CONFIG_HARDWARE_ONLY has to be with ME_IO_STREAM_CONFIG_WRAPAROUND.\n");
 			return ME_ERRNO_INVALID_FLAGS;
@@ -2825,10 +2825,11 @@ int inline ao_stop_immediately(me6000_ao_subdevice_t * instance)
 	int i;
 	uint32_t single_mask;
 
-	single_mask =
-	    (instance->ao_idx - ME6000_AO_SINGLE_STATUS_OFFSET <
-	     0) ? 0x0000 : (0x0001 << (instance->ao_idx -
-				       ME6000_AO_SINGLE_STATUS_OFFSET));
+	if (instance->ao_idx < ME6000_AO_SINGLE_STATUS_OFFSET)
+		single_mask = 0x0000;
+	else
+		single_mask = 0x0001 << (instance->ao_idx -
+				ME6000_AO_SINGLE_STATUS_OFFSET);
 
 	timeout =
 	    (instance->hardware_stop_delay >
