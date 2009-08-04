Return-Path: <linux-kernel-owner+w=401wt.eu-S932752AbZHDKzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752AbZHDKzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932563AbZHDKzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:55:22 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51719 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbZHDKzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=JnM+RDizaLAy9RZG7JU4tr+Z5UdtVukxLKCKIREQ75kO8OIiyZrHIlLjyoHHD6BSK0
         /BPma/GBZmVboYsctpl5S6oN18d/btm+rhoI/H15infG9aLLMX1T9oamIPv714OrA5UV
         j7X219m6WOuE6wKR1nTb3alywZ8AiBG5zxClc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jack Byer <ojbyer@usa.net>
Subject: Re: Extremely slow IO with a PCMCIA CompactFlash adapter
Date: Tue, 4 Aug 2009 12:54:08 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090731-05372-g784fb81; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andreas Mohr <andi@lisas.de>,
       linux-ide@vger.kernel.org
References: <h51hro$p6j$1@ger.gmane.org> <200908022027.18937.bzolnier@gmail.com> <cdb43e8a0908021825y7d029614pffad28e6dd70f04c@mail.gmail.com>
In-Reply-To: <cdb43e8a0908021825y7d029614pffad28e6dd70f04c@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908041254.08315.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009 03:25:18 Jack Byer wrote:
> >
> > Seems like there is also a bug in ali5451 sound driver..
> >
> > This should help:

[...]

> Those patches do not appear to have worked:

My bad, jiffies checks need to be reversed now (corrected patch attached)..

Please also post output of dmidecode command -- we may try to workaround
the issue by not using IRQ mode in pata_pcmcia for this particular system
and resorting to libata's polling mode instead..

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
