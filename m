Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbZLPPwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbZLPPwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZLPPww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:52:52 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39503 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbZLPPwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:52:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SeRI425mM/0Hs6SCKUOYKj1+LcbKqUnXQqe/XDej7UucAa05MlwV+c1+Axd6WD/MVr
         N632iQ4V09Yr2PcESovVHFCOYLzqnSGkuwqfvWst+6aVx03dIZAS+FVoag+tNZoN0lil
         7cLt9izDM81vQlVcEfcdCp3EdzFP8RJ6wXI/Y=
Message-ID: <4B2902C3.3080606@gmail.com>
Date: Wed, 16 Dec 2009 16:54:43 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sound/oss/pss: Fix test of unsigned in pss_reset_dsp()
 and pss_download_boot()
References: <4B28085A.6020101@gmail.com> <s5hr5qvf7rt.wl%tiwai@suse.de>
In-Reply-To: <s5hr5qvf7rt.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

limit and jiffies are unsigned so the test did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

>> -	for (i = 0; i < 32768 && (limit-jiffies >= 0); i++)
>> +	for (i = 0; i < 32768 && (limit >= jiffies); i++)
> 
> No, it should use time_after_eq(limit, jiffies) instead.
> 
> 
> thanks,
> 
> Takashi
> 

Ok,

diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 83f5ee2..e19dd5d 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -269,7 +269,7 @@ static int pss_reset_dsp(pss_confdata * devc)
 	unsigned long   i, limit = jiffies + HZ/10;
 
 	outw(0x2000, REG(PSS_CONTROL));
-	for (i = 0; i < 32768 && (limit-jiffies >= 0); i++)
+	for (i = 0; i < 32768 && time_after_eq(limit, jiffies); i++)
 		inw(REG(PSS_CONTROL));
 	outw(0x0000, REG(PSS_CONTROL));
 	return 1;
@@ -369,11 +369,11 @@ static int pss_download_boot(pss_confdata * devc, unsigned char *block, int size
 		outw(0, REG(PSS_DATA));
 
 		limit = jiffies + HZ/10;
-		for (i = 0; i < 32768 && (limit - jiffies >= 0); i++)
+		for (i = 0; i < 32768 && time_after_eq(limit, jiffies); i++)
 			val = inw(REG(PSS_STATUS));
 
 		limit = jiffies + HZ/10;
-		for (i = 0; i < 32768 && (limit-jiffies >= 0); i++)
+		for (i = 0; i < 32768 && time_after_eq(limit, jiffies); i++)
 		{
 			val = inw(REG(PSS_STATUS));
 			if (val & 0x4000)
