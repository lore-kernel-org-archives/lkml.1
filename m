Return-Path: <linux-kernel-owner+w=401wt.eu-S933889AbZLOWEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889AbZLOWEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbZLOWE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:04:29 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:23301 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933854AbZLOWE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:04:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=n0TTqdDNGTK3xce/yHlsDs7jMftD4WLpVlY7bphO9+FxUbHvF3R1v7Jjnct3er4wnu
         KpmX+RIRJfetupkV29uScpX72ZWpqY+yBP4bG4bI0yJSCQ1GKbJ/7Lf3hU0Q6ZwitWtI
         aqWEj7/JzJSNWUSFA57vRiN9lzivefX7tXyaI=
Message-ID: <4B28085A.6020101@gmail.com>
Date: Tue, 15 Dec 2009 23:06:18 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sound/oss/pss: Fix test of unsigned in pss_reset_dsp() and
 pss_download_boot()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

limit and jiffies are unsigned so the test does not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 83f5ee2..9325f4d 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -269,7 +269,7 @@ static int pss_reset_dsp(pss_confdata * devc)
 	unsigned long   i, limit = jiffies + HZ/10;
 
 	outw(0x2000, REG(PSS_CONTROL));
-	for (i = 0; i < 32768 && (limit-jiffies >= 0); i++)
+	for (i = 0; i < 32768 && (limit >= jiffies); i++)
 		inw(REG(PSS_CONTROL));
 	outw(0x0000, REG(PSS_CONTROL));
 	return 1;
@@ -369,11 +369,11 @@ static int pss_download_boot(pss_confdata * devc, unsigned char *block, int size
 		outw(0, REG(PSS_DATA));
 
 		limit = jiffies + HZ/10;
-		for (i = 0; i < 32768 && (limit - jiffies >= 0); i++)
+		for (i = 0; i < 32768 && (limit >= jiffies); i++)
 			val = inw(REG(PSS_STATUS));
 
 		limit = jiffies + HZ/10;
-		for (i = 0; i < 32768 && (limit-jiffies >= 0); i++)
+		for (i = 0; i < 32768 && (limit >= jiffies); i++)
 		{
 			val = inw(REG(PSS_STATUS));
 			if (val & 0x4000)
