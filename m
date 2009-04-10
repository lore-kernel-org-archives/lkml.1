Return-Path: <linux-kernel-owner+w=401wt.eu-S1763230AbZDJBoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763230AbZDJBoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933689AbZDJBnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:43:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54334 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932211AbZDJBnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:43:47 -0400
Message-ID: <49DEA47F.9070701@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 09:44:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: tiwai@suse.de
CC: perex@perex.cz, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] sound/pci: use memdup_user()
References: <49DEA405.3070900@cn.fujitsu.com>
In-Reply-To: <49DEA405.3070900@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open-coded memdup_user().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 sound/pci/emu10k1/emufx.c |   41 +++++++++++++----------------------------
 1 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
index 191e1cd..4b302d8 100644
--- a/sound/pci/emu10k1/emufx.c
+++ b/sound/pci/emu10k1/emufx.c
@@ -2493,24 +2493,17 @@ static int snd_emu10k1_fx8010_ioctl(struct snd_hwdep * hw, struct file *file, un
 	case SNDRV_EMU10K1_IOCTL_CODE_POKE:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		icode = kmalloc(sizeof(*icode), GFP_KERNEL);
-		if (icode == NULL)
-			return -ENOMEM;
-		if (copy_from_user(icode, argp, sizeof(*icode))) {
-			kfree(icode);
-			return -EFAULT;
-		}
+
+		icode = memdup_user(argp, sizeof(*icode));
+		if (IS_ERR(icode))
+			return PTR_ERR(icode);
 		res = snd_emu10k1_icode_poke(emu, icode);
 		kfree(icode);
 		return res;
 	case SNDRV_EMU10K1_IOCTL_CODE_PEEK:
-		icode = kmalloc(sizeof(*icode), GFP_KERNEL);
-		if (icode == NULL)
-			return -ENOMEM;
-		if (copy_from_user(icode, argp, sizeof(*icode))) {
-			kfree(icode);
-			return -EFAULT;
-		}
+		icode = memdup_user(argp, sizeof(*icode));
+		if (IS_ERR(icode))
+			return PTR_ERR(icode);
 		res = snd_emu10k1_icode_peek(emu, icode);
 		if (res == 0 && copy_to_user(argp, icode, sizeof(*icode))) {
 			kfree(icode);
@@ -2519,24 +2512,16 @@ static int snd_emu10k1_fx8010_ioctl(struct snd_hwdep * hw, struct file *file, un
 		kfree(icode);
 		return res;
 	case SNDRV_EMU10K1_IOCTL_PCM_POKE:
-		ipcm = kmalloc(sizeof(*ipcm), GFP_KERNEL);
-		if (ipcm == NULL)
-			return -ENOMEM;
-		if (copy_from_user(ipcm, argp, sizeof(*ipcm))) {
-			kfree(ipcm);
-			return -EFAULT;
-		}
+		ipcm = memdup_user(argp, sizeof(*ipcm));
+		if (IS_ERR(ipcm))
+			return PTR_ERR(ipcm);
 		res = snd_emu10k1_ipcm_poke(emu, ipcm);
 		kfree(ipcm);
 		return res;
 	case SNDRV_EMU10K1_IOCTL_PCM_PEEK:
-		ipcm = kzalloc(sizeof(*ipcm), GFP_KERNEL);
-		if (ipcm == NULL)
-			return -ENOMEM;
-		if (copy_from_user(ipcm, argp, sizeof(*ipcm))) {
-			kfree(ipcm);
-			return -EFAULT;
-		}
+		ipcm = memdup_user(argp, sizeof(*ipcm));
+		if (IS_ERR(ipcm))
+			return PTR_ERR(ipcm);
 		res = snd_emu10k1_ipcm_peek(emu, ipcm);
 		if (res == 0 && copy_to_user(argp, ipcm, sizeof(*ipcm))) {
 			kfree(ipcm);
-- 
1.5.4.rc3

