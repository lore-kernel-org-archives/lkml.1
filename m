Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbXK2STt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbXK2STt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571AbXK2STg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:19:36 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:54030 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbXK2STf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:19:35 -0500
Message-ID: <474F02B2.6010406@tiscali.nl>
Date: Thu, 29 Nov 2007 19:19:30 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH?] OSS: fix operator precedence in return of btaudio_dsp_ioctl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, is /sound/oss/* still maintained?

#define HWBASE_AD (448000)
...
with if(bta->analog) evaluating to true bta->decimation may range
from 15 to 5
...
HWBASE_AD*4/bta->decimation>>bta->sampleshift

which is equivalent to 

((HWBASE_AD * 4)/bta->decimation) >> bta->sampleshift

actually may evaluate to something like:

(1792000 / 15 ) >> bta->sampleshift

Isn't intended (HWBASE_AD * 4)/(bta->decimation >> bta->sampleshift)?
Then consider the patch below.
--
Fix operator precedence in return

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/sound/oss/btaudio.c b/sound/oss/btaudio.c
index 4d5cf05..2a5cace 100644
--- a/sound/oss/btaudio.c
+++ b/sound/oss/btaudio.c
@@ -661,7 +661,8 @@ static int btaudio_dsp_ioctl(struct inode *inode, struct file *file,
 		/* fall through */
         case SOUND_PCM_READ_RATE:
 		if (bta->analog) {
-			return put_user(HWBASE_AD*4/bta->decimation>>bta->sampleshift, p);
+			return put_user((HWBASE_AD * 4) /
+				(bta->decimation >> bta->sampleshift), p);
 		} else {
 			return put_user(bta->rate, p);
 		}
