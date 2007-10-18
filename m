Return-Path: <linux-kernel-owner+w=401wt.eu-S1763979AbXJRJvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763979AbXJRJvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761313AbXJRJuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:50:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51549 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760989AbXJRJux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:50:53 -0400
Date: Thu, 18 Oct 2007 11:50:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] snd: fix build bug with CONFIG_SND_HDA_CODEC_SIGMATEL=y &&
	!CONFIG_SND_HDA_GENERIC
Message-ID: <20071018095042.GA21361@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_05,UPPERCASE_25_50 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0167]
	0.4 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


fix build bug introduced with the recent sound merge:

-------------->
Subject: snd: fix build bug with CONFIG_SND_HDA_CODEC_SIGMATEL=y && !CONFIG_SND_HDA_GENERIC
From: Ingo Molnar <mingo@elte.hu>

randconfig build testing found this build bug:

 sound/built-in.o: In function `patch_stac9872':
 patch_sigmatel.c:(.text+0x6d6e7): undefined reference to `snd_hda_parse_generic_codec'

patch_sigmatel.c depends on SND_HDA_GENERIC, for snd_hda_parse_generic_codec().

to make it selectable, reorder SND_HDA_CODEC_SIGMATEL to after
SND_HDA_GENERIC.

with this fixed, the kernel builds fine.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 sound/pci/Kconfig |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux/sound/pci/Kconfig
===================================================================
--- linux.orig/sound/pci/Kconfig
+++ linux/sound/pci/Kconfig
@@ -525,14 +525,6 @@ config SND_HDA_CODEC_ANALOG
 	  Say Y here to include Analog Device HD-audio codec support in
 	  snd-hda-intel driver, such as AD1986A.
 
-config SND_HDA_CODEC_SIGMATEL
-	bool "Build IDT/Sigmatel HD-audio codec support"
-	depends on SND_HDA_INTEL
-	default y
-	help
-	  Say Y here to include IDT (Sigmatel) HD-audio codec support in
-	  snd-hda-intel driver, such as STAC9200.
-
 config SND_HDA_CODEC_VIA
 	bool "Build VIA HD-audio codec support"
 	depends on SND_HDA_INTEL
@@ -581,6 +573,15 @@ config SND_HDA_GENERIC
 	  Say Y here to enable the generic HD-audio codec parser
 	  in snd-hda-intel driver.
 
+config SND_HDA_CODEC_SIGMATEL
+	bool "Build IDT/Sigmatel HD-audio codec support"
+	depends on SND_HDA_INTEL
+	select SND_HDA_GENERIC
+	default y
+	help
+	  Say Y here to include IDT (Sigmatel) HD-audio codec support in
+	  snd-hda-intel driver, such as STAC9200.
+
 config SND_HDA_POWER_SAVE
 	bool "Aggressive power-saving on HD-audio"
 	depends on SND_HDA_INTEL && EXPERIMENTAL
