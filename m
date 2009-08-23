Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbZHWN1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbZHWN1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933644AbZHWN1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:27:37 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35350 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652AbZHWN1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=acDZNQLrrQrNEa0PNTTNZdEFaNUhhVNm4bNJz1rk8/Ow9PqUxegwuoBEYs5SJc3OjS
         8kq36HBqTHDN8hVgDsCFJ2BlkLsGN/AFUonpQdQfuykSSxmB9KCu/CsWS7TCMYkD9toh
         kzgzUBiDcSaPGj8YnOPWog6VxESgN7WjkLyPE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] ali5451: fix timeout handling in snd_ali_{codecs,timer}_ready()
Date: Sun, 23 Aug 2009 15:27:25 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc7-dirty; KDE/4.2.4; i686; ; )
Cc: Jack Byer <ojbyer@usa.net>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
References: <200908192209.50994.bzolnier@gmail.com> <s5hbpmbvvta.wl%tiwai@suse.de>
In-Reply-To: <s5hbpmbvvta.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908231527.25987.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009 08:33:21 Takashi Iwai wrote:
> At Wed, 19 Aug 2009 22:09:50 +0200,
> Bartlomiej Zolnierkiewicz wrote:
> > 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ali5451: fix timeout handling in snd_ali_{codecs,timer}_ready()
> > 
> > Modify loops in such way that the register value is checked also after
> > the timeout condition, just in case the heavy interrupt load etc. caused
> > the thread to sleep for the time period exceeding the timeout value.
> > 
> > While at it remove an extra ALI_STIMER read from snd_ali_stimer_ready().
> > 
> > Reported-by: Jack Byer <ojbyer@usa.net>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  sound/pci/ali5451/ali5451.c |   11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > Index: b/sound/pci/ali5451/ali5451.c
> > ===================================================================
> > --- a/sound/pci/ali5451/ali5451.c
> > +++ b/sound/pci/ali5451/ali5451.c
> > @@ -314,8 +314,11 @@ static int snd_ali_codec_ready(struct sn
> >  		res = snd_ali_5451_peek(codec,port);
> >  		if (!(res & 0x8000))
> >  			return 0;
> > +		if (!time_after_eq(end_time, jiffies))
> > +			break;
> >  		schedule_timeout_uninterruptible(1);
> > -	} while (time_after_eq(end_time, jiffies));
> > +	} while (1);
> 
> Using for (;;) is more generic.  I see your patch keeps the changes
> minimal, but I'm afraid that the result, do {} while(1), can be
> misleading.
> 
> Could you replace with for (;;) ?

Sure, though I don't see a much value added from this operation..

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH v2] ali5451: fix timeout handling in snd_ali_{codecs,timer}_ready()

Modify loops in such way that the register value is checked also after
the timeout condition, just in case the heavy interrupt load etc. caused
the thread to sleep for the time period exceeding the timeout value.

While at it remove an extra ALI_STIMER read from snd_ali_stimer_ready().

Reported-by: Jack Byer <ojbyer@usa.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 sound/pci/ali5451/ali5451.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: b/sound/pci/ali5451/ali5451.c
===================================================================
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -310,12 +310,16 @@ static int snd_ali_codec_ready(struct sn
 	unsigned int res;
 	
 	end_time = jiffies + msecs_to_jiffies(250);
-	do {
+
+	for (;;) {
 		res = snd_ali_5451_peek(codec,port);
 		if (!(res & 0x8000))
 			return 0;
+		if (!time_after_eq(end_time, jiffies))
+			break;
 		schedule_timeout_uninterruptible(1);
-	} while (time_after_eq(end_time, jiffies));
+	}
+
 	snd_ali_5451_poke(codec, port, res & ~0x8000);
 	snd_printdd("ali_codec_ready: codec is not ready.\n ");
 	return -EIO;
@@ -327,15 +331,17 @@ static int snd_ali_stimer_ready(struct s
 	unsigned long dwChk1,dwChk2;
 	
 	dwChk1 = snd_ali_5451_peek(codec, ALI_STIMER);
-	dwChk2 = snd_ali_5451_peek(codec, ALI_STIMER);
-
 	end_time = jiffies + msecs_to_jiffies(250);
-	do {
+
+	for (;;) {
 		dwChk2 = snd_ali_5451_peek(codec, ALI_STIMER);
 		if (dwChk2 != dwChk1)
 			return 0;
+		if (!time_after_eq(end_time, jiffies))
+			break;
 		schedule_timeout_uninterruptible(1);
-	} while (time_after_eq(end_time, jiffies));
+	}
+
 	snd_printk(KERN_ERR "ali_stimer_read: stimer is not ready.\n");
 	return -EIO;
 }


