Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZHSULo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZHSULo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 16:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZHSULo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 16:11:44 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43369 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZHSULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:11:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=aFDu/zFkWczEOKaMNlHdf2GsmoDTRblSXZEqLkKpWzCaTql4ocG1xzuBu5ALY02y5m
         UnH5gDWvlZLwKFotwwKKeM1OOiy8LIa0BifCUWesPU8T+A7vZqHBPbVbSr1m0C44R8/k
         D+cN1TPDqg5gokt7um1uYKEh9lyUP2Uaw3WGk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] ali5451: fix timeout handling in snd_ali_{codecs,timer}_ready()
Date: Wed, 19 Aug 2009 22:09:50 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc6-dirty; KDE/4.2.4; i686; ; )
Cc: Jack Byer <ojbyer@usa.net>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908192209.50994.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ali5451: fix timeout handling in snd_ali_{codecs,timer}_ready()

Modify loops in such way that the register value is checked also after
the timeout condition, just in case the heavy interrupt load etc. caused
the thread to sleep for the time period exceeding the timeout value.

While at it remove an extra ALI_STIMER read from snd_ali_stimer_ready().

Reported-by: Jack Byer <ojbyer@usa.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 sound/pci/ali5451/ali5451.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: b/sound/pci/ali5451/ali5451.c
===================================================================
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -314,8 +314,11 @@ static int snd_ali_codec_ready(struct sn
 		res = snd_ali_5451_peek(codec,port);
 		if (!(res & 0x8000))
 			return 0;
+		if (!time_after_eq(end_time, jiffies))
+			break;
 		schedule_timeout_uninterruptible(1);
-	} while (time_after_eq(end_time, jiffies));
+	} while (1);
+
 	snd_ali_5451_poke(codec, port, res & ~0x8000);
 	snd_printdd("ali_codec_ready: codec is not ready.\n ");
 	return -EIO;
@@ -327,15 +330,17 @@ static int snd_ali_stimer_ready(struct s
 	unsigned long dwChk1,dwChk2;
 	
 	dwChk1 = snd_ali_5451_peek(codec, ALI_STIMER);
-	dwChk2 = snd_ali_5451_peek(codec, ALI_STIMER);
 
 	end_time = jiffies + msecs_to_jiffies(250);
 	do {
 		dwChk2 = snd_ali_5451_peek(codec, ALI_STIMER);
 		if (dwChk2 != dwChk1)
 			return 0;
+		if (!time_after_eq(end_time, jiffies))
+			break;
 		schedule_timeout_uninterruptible(1);
-	} while (time_after_eq(end_time, jiffies));
+	} while (1);
+
 	snd_printk(KERN_ERR "ali_stimer_read: stimer is not ready.\n");
 	return -EIO;
 }
