Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYKDXjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYKDXjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYKDXhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:37:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:51815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058AbYKDXhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:37:53 -0500
Date: Tue, 4 Nov 2008 15:31:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 07/57] ALSA: hda - Add reboot notifier
Message-ID: <20081104233111.GH659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-reboot-notifier.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit 0cbf00980f0fc4cc064a15ab3dfce19b5fae9130 upstream

The current snd-hda-intel driver seems blocking the power-off on some
devices like eeepc.  Although this is likely a BIOS problem, we can add
a workaround by disabling IRQ lines before power-off operation.
This patch adds the reboot notifier to achieve it.

The detailed problem description is found in bug#11889:
    http://bugme.linux-foundation.org/show_bug.cgi?id=11889

Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -45,6 +45,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/mutex.h>
+#include <linux/reboot.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 #include "hda_codec.h"
@@ -385,6 +386,9 @@ struct azx {
 
 	/* for pending irqs */
 	struct work_struct irq_pending_work;
+
+	/* reboot notifier (for mysterious hangup problem at power-down) */
+	struct notifier_block reboot_notifier;
 };
 
 /* driver types */
@@ -1890,12 +1894,36 @@ static int azx_resume(struct pci_dev *pc
 
 
 /*
+ * reboot notifier for hang-up problem at power-down
+ */
+static int azx_halt(struct notifier_block *nb, unsigned long event, void *buf)
+{
+	struct azx *chip = container_of(nb, struct azx, reboot_notifier);
+	azx_stop_chip(chip);
+	return NOTIFY_OK;
+}
+
+static void azx_notifier_register(struct azx *chip)
+{
+	chip->reboot_notifier.notifier_call = azx_halt;
+	register_reboot_notifier(&chip->reboot_notifier);
+}
+
+static void azx_notifier_unregister(struct azx *chip)
+{
+	if (chip->reboot_notifier.notifier_call)
+		unregister_reboot_notifier(&chip->reboot_notifier);
+}
+
+/*
  * destructor
  */
 static int azx_free(struct azx *chip)
 {
 	int i;
 
+	azx_notifier_unregister(chip);
+
 	if (chip->initialized) {
 		azx_clear_irq_pending(chip);
 		for (i = 0; i < chip->num_streams; i++)
@@ -2250,6 +2278,7 @@ static int __devinit azx_probe(struct pc
 	pci_set_drvdata(pci, card);
 	chip->running = 1;
 	power_down_all_codecs(chip);
+	azx_notifier_register(chip);
 
 	dev++;
 	return err;

-- 
