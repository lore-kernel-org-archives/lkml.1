Return-Path: <linux-kernel-owner+w=401wt.eu-S934377AbZDJBnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbZDJBnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763073AbZDJBmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:42:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62554 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762914AbZDJBmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:42:52 -0400
Message-ID: <49DEA448.1000408@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 09:43:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: tiwai@suse.de
CC: perex@perex.cz, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] sound/isa: use memdup_user()
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
 sound/isa/sb/sb16_csp.c               |   19 ++++++++++---------
 sound/isa/wavefront/wavefront_fx.c    |   14 +++++---------
 sound/isa/wavefront/wavefront_synth.c |   11 +++++------
 3 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/sound/isa/sb/sb16_csp.c b/sound/isa/sb/sb16_csp.c
index 49037d0..bdc8dde 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -684,15 +684,16 @@ static int snd_sb_csp_load(struct snd_sb_csp * p, const unsigned char *buf, int
  
 static int snd_sb_csp_load_user(struct snd_sb_csp * p, const unsigned char __user *buf, int size, int load_flags)
 {
-	int err = -ENOMEM;
-	unsigned char *kbuf = kmalloc(size, GFP_KERNEL);
-	if (kbuf) {
-		if (copy_from_user(kbuf, buf, size))
-			err = -EFAULT;
-		else
-			err = snd_sb_csp_load(p, kbuf, size, load_flags);
-		kfree(kbuf);
-	}
+	int err;
+	unsigned char *kbuf;
+
+	kbuf = memdup_user(buf, size);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	err = snd_sb_csp_load(p, kbuf, size, load_flags);
+
+	kfree(kbuf);
 	return err;
 }
 
diff --git a/sound/isa/wavefront/wavefront_fx.c b/sound/isa/wavefront/wavefront_fx.c
index a4345fc..2bb1cee 100644
--- a/sound/isa/wavefront/wavefront_fx.c
+++ b/sound/isa/wavefront/wavefront_fx.c
@@ -202,15 +202,11 @@ snd_wavefront_fx_ioctl (struct snd_hwdep *sdev, struct file *file,
 					    "> 512 bytes to FX\n");
 				return -EIO;
 			}
-			page_data = kmalloc(r.data[2] * sizeof(short), GFP_KERNEL);
-			if (!page_data)
-				return -ENOMEM;
-			if (copy_from_user (page_data,
-					    (unsigned char __user *) r.data[3],
-					    r.data[2] * sizeof(short))) {
-				kfree(page_data);
-				return -EFAULT;
-			}
+			page_data = memdup_user((unsigned char __user *)
+						r.data[3],
+						r.data[2] * sizeof(short));
+			if (IS_ERR(page_data))
+				return PTR_ERR(page_data);
 			pd = page_data;
 		}
 
diff --git a/sound/isa/wavefront/wavefront_synth.c b/sound/isa/wavefront/wavefront_synth.c
index beb312c..5d4ff48 100644
--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -1664,12 +1664,11 @@ snd_wavefront_synth_ioctl (struct snd_hwdep *hw, struct file *file,
 		break;
 
 	case WFCTL_WFCMD:
-		wc = kmalloc(sizeof(*wc), GFP_KERNEL);
-		if (! wc)
-			return -ENOMEM;
-		if (copy_from_user (wc, argp, sizeof (*wc)))
-			err = -EFAULT;
-		else if (wavefront_synth_control (acard, wc) < 0)
+		wc = memdup_user(argp, sizeof(*wc));
+		if (IS_ERR(wc))
+			return PTR_ERR(wc);
+
+		if (wavefront_synth_control (acard, wc) < 0)
 			err = -EIO;
 		else if (copy_to_user (argp, wc, sizeof (*wc)))
 			err = -EFAULT;
-- 
1.5.4.rc3

