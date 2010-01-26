Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520Ab0A0AAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab0A0AAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217Ab0AZXnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:23 -0500
Received: from kroah.org ([198.145.64.141]:35176 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab0AZXnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:21 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:24 2010
Message-Id: <20100126233924.412446312@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Aleksey Kunitskiy <alexey.kv@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [27/98] ALSA: ice1724 - Patch for suspend/resume for ESI Juli@
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aleksey Kunitskiy <alexey.kv@gmail.com>

commit 50d40f187f9182ee8caa1b83f80a0e11e2226baa upstream.

Add proper suspend/resume code for Juli@ cards. Based on ice1724
suspend/resume work of Igor Chernyshev.
Fixes bug https://bugtrack.alsa-project.org/alsa-bug/view.php?id=4413
Tested on linux-2.6.31.6

Signed-off-by: Aleksey Kunitskiy <alexey.kv@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ice1712/juli.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/sound/pci/ice1712/juli.c
+++ b/sound/pci/ice1712/juli.c
@@ -504,6 +504,31 @@ static int __devinit juli_add_controls(s
 }
 
 /*
+ * suspend/resume
+ * */
+
+#ifdef CONFIG_PM
+static int juli_resume(struct snd_ice1712 *ice)
+{
+	struct snd_akm4xxx *ak = ice->akm;
+	struct juli_spec *spec = ice->spec;
+	/* akm4358 un-reset, un-mute */
+	snd_akm4xxx_reset(ak, 0);
+	/* reinit ak4114 */
+	snd_ak4114_reinit(spec->ak4114);
+	return 0;
+}
+
+static int juli_suspend(struct snd_ice1712 *ice)
+{
+	struct snd_akm4xxx *ak = ice->akm;
+	/* akm4358 reset and soft-mute */
+	snd_akm4xxx_reset(ak, 1);
+	return 0;
+}
+#endif
+
+/*
  * initialize the chip
  */
 
@@ -646,6 +671,13 @@ static int __devinit juli_init(struct sn
 	ice->set_spdif_clock = juli_set_spdif_clock;
 
 	ice->spdif.ops.open = juli_spdif_in_open;
+
+#ifdef CONFIG_PM
+	ice->pm_resume = juli_resume;
+	ice->pm_suspend = juli_suspend;
+	ice->pm_suspend_enabled = 1;
+#endif
+
 	return 0;
 }
 


