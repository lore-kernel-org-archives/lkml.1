Return-Path: <linux-kernel-owner+w=401wt.eu-S1761042AbXEOFpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761042AbXEOFpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 01:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbXEOFpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 01:45:23 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:48588 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524AbXEOFpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 01:45:20 -0400
Message-ID: <46494851.4020006@gmail.com>
Date: Tue, 15 May 2007 07:42:41 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pete Clements <clem@clem.clem-digital.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: 2.6.22-rc1 lost snd_4236 device
References: <200705131623.l4DGNqta003015@clem.clem-digital.net>
In-Reply-To: <200705131623.l4DGNqta003015@clem.clem-digital.net>
Content-Type: multipart/mixed;
 boundary="------------080109060902050003030109"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080109060902050003030109
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 05/13/2007 06:23 PM, Pete Clements wrote:

> Fyi:
> With 2.6.22-rc1 get following when loading sound device module. Introduced
> with 2.6.21-git16.
> 
> FATAL: Error inserting snd_cs4236 (/lib/modules/2.6.22-rc1/kernel/sound/isa/cs423x/snd-cs4236.ko): No such device
> FATAL: Error running install command for snd_cs4236

Yup; the conversion of the mixed legacy/pnp ALSA drivers to the isa_bus 
framework is not quite right. Wants the attached.

Takashi, this needs to go to Linus. Can you make sure it gets there? This is 
against -linus HEAD.

Signed-off-by: Rene Herman <rene.herman@gmail.com>

Rene.

--------------080109060902050003030109
Content-Type: text/plain;
 name="alsa_isa_registered.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="alsa_isa_registered.diff"

diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index 214d65d..f471f8a 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -109,6 +109,7 @@ module_param_array(wssdma, int, NULL, 0444);
 MODULE_PARM_DESC(wssdma, "DMA for CMI8330 WSS driver.");
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
 #endif
 
@@ -686,14 +687,18 @@ static int __init alsa_card_cmi8330_init(void)
 	int err;
 
 	err = isa_register_driver(&snd_cmi8330_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_card_driver(&cmi8330_pnpc_driver);
 	if (!err)
 		pnp_registered = 1;
+
+	if (isa_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_cmi8330_exit(void)
@@ -701,8 +706,10 @@ static void __exit alsa_card_cmi8330_exit(void)
 #ifdef CONFIG_PNP
 	if (pnp_registered)
 		pnp_unregister_card_driver(&cmi8330_pnpc_driver);
+
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_cmi8330_driver);
+		isa_unregister_driver(&snd_cmi8330_driver);
 }
 
 module_init(alsa_card_cmi8330_init)
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index 87f1392..1a14f33 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -127,6 +127,7 @@ module_param_array(dma2, int, NULL, 0444);
 MODULE_PARM_DESC(dma2, "DMA2 # for " IDENT " driver.");
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnpc_registered;
 #ifdef CS4232
 static int pnp_registered;
@@ -770,9 +771,9 @@ static int __init alsa_card_cs423x_init(void)
 	int err;
 
 	err = isa_register_driver(&cs423x_isa_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
+	if (!err)
+		isa_registered = 1;
 #ifdef CS4232
 	err = pnp_register_driver(&cs4232_pnp_driver);
 	if (!err)
@@ -781,8 +782,14 @@ static int __init alsa_card_cs423x_init(void)
 	err = pnp_register_card_driver(&cs423x_pnpc_driver);
 	if (!err)
 		pnpc_registered = 1;
-#endif /* CONFIG_PNP */
-	return 0;
+#ifdef CS4232
+	if (pnp_registered)
+		err = 0;
+#endif
+	if (isa_registered)
+		err = 0;
+#endif
+	return err;
 }
 
 static void __exit alsa_card_cs423x_exit(void)
@@ -794,8 +801,9 @@ static void __exit alsa_card_cs423x_exit(void)
 	if (pnp_registered)
 		pnp_unregister_driver(&cs4232_pnp_driver);
 #endif
-#endif /* CONFIG_PNP */
-	isa_unregister_driver(&cs423x_isa_driver);
+	if (isa_registered)
+#endif
+		isa_unregister_driver(&cs423x_isa_driver);
 }
 
 module_init(alsa_card_cs423x_init)
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index d2a9c7d..f7732bf 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -2036,7 +2036,9 @@ module_param_array(dma2, int, NULL, 0444);
 MODULE_PARM_DESC(dma2, "DMA 2 # for ES18xx driver.");
 
 #ifdef CONFIG_PNP
-static int pnp_registered, pnpc_registered;
+static int isa_registered;
+static int pnp_registered;
+static int pnpc_registered;
 
 static struct pnp_device_id snd_audiodrive_pnpbiosids[] = {
 	{ .id = "ESS1869" },
@@ -2466,18 +2468,22 @@ static int __init alsa_card_es18xx_init(void)
 	int err;
 
 	err = isa_register_driver(&snd_es18xx_isa_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
-
 #ifdef CONFIG_PNP
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_driver(&es18xx_pnp_driver);
 	if (!err)
 		pnp_registered = 1;
+
 	err = pnp_register_card_driver(&es18xx_pnpc_driver);
 	if (!err)
 		pnpc_registered = 1;
+
+	if (isa_registered || pnp_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_es18xx_exit(void)
@@ -2487,8 +2493,9 @@ static void __exit alsa_card_es18xx_exit(void)
 		pnp_unregister_card_driver(&es18xx_pnpc_driver);
 	if (pnp_registered)
 		pnp_unregister_driver(&es18xx_pnp_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_es18xx_isa_driver);
+		isa_unregister_driver(&snd_es18xx_isa_driver);
 }
 
 module_init(alsa_card_es18xx_init)
diff --git a/sound/isa/gus/interwave.c b/sound/isa/gus/interwave.c
index 3e46572..0220cdb 100644
--- a/sound/isa/gus/interwave.c
+++ b/sound/isa/gus/interwave.c
@@ -135,6 +135,7 @@ struct snd_interwave {
 
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
 
 static struct pnp_card_device_id snd_interwave_pnpids[] = {
@@ -934,15 +935,18 @@ static int __init alsa_card_interwave_init(void)
 	int err;
 
 	err = isa_register_driver(&snd_interwave_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
-	/* ISA PnP cards */
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_card_driver(&interwave_pnpc_driver);
 	if (!err)
 		pnp_registered = 1;
+
+	if (isa_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_interwave_exit(void)
@@ -950,8 +954,9 @@ static void __exit alsa_card_interwave_exit(void)
 #ifdef CONFIG_PNP
 	if (pnp_registered)
 		pnp_unregister_card_driver(&interwave_pnpc_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_interwave_driver);
+		isa_unregister_driver(&snd_interwave_driver);
 }
 
 module_init(alsa_card_interwave_init)
diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
index 48743eb..61a323c 100644
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -92,6 +92,7 @@ module_param_array(opl3sa3_ymode, int, NULL, 0444);
 MODULE_PARM_DESC(opl3sa3_ymode, "Speaker size selection for 3D Enhancement mode: Desktop/Large Notebook/Small Notebook/HiFi.");
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
 static int pnpc_registered;
 #endif
@@ -967,17 +968,22 @@ static int __init alsa_card_opl3sa2_init(void)
 	int err;
 
 	err = isa_register_driver(&snd_opl3sa2_isa_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_driver(&opl3sa2_pnp_driver);
 	if (!err)
 		pnp_registered = 1;
+
 	err = pnp_register_card_driver(&opl3sa2_pnpc_driver);
 	if (!err)
 		pnpc_registered = 1;
+
+	if (isa_registered || pnp_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_opl3sa2_exit(void)
@@ -987,8 +993,9 @@ static void __exit alsa_card_opl3sa2_exit(void)
 		pnp_unregister_card_driver(&opl3sa2_pnpc_driver);
 	if (pnp_registered)
 		pnp_unregister_driver(&opl3sa2_pnp_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_opl3sa2_isa_driver);
+		isa_unregister_driver(&snd_opl3sa2_isa_driver);
 }
 
 module_init(alsa_card_opl3sa2_init)
diff --git a/sound/isa/sb/sb16.c b/sound/isa/sb/sb16.c
index 2a19b0a..c4ba24b 100644
--- a/sound/isa/sb/sb16.c
+++ b/sound/isa/sb/sb16.c
@@ -129,6 +129,7 @@ MODULE_PARM_DESC(seq_ports, "Number of sequencer ports for WaveTable synth.");
 #endif
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
 #endif
 
@@ -702,15 +703,18 @@ static int __init alsa_card_sb16_init(void)
 	int err;
 
 	err = isa_register_driver(&snd_sb16_isa_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
-	/* PnP cards at last */
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_card_driver(&sb16_pnpc_driver);
 	if (!err)
 		pnp_registered = 1;
+
+	if (isa_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_sb16_exit(void)
@@ -718,8 +722,9 @@ static void __exit alsa_card_sb16_exit(void)
 #ifdef CONFIG_PNP
 	if (pnp_registered)
 		pnp_unregister_card_driver(&sb16_pnpc_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_sb16_isa_driver);
+		isa_unregister_driver(&snd_sb16_isa_driver);
 }
 
 module_init(alsa_card_sb16_init)
diff --git a/sound/isa/sscape.c b/sound/isa/sscape.c
index 08c1497..9ea417b 100644
--- a/sound/isa/sscape.c
+++ b/sound/isa/sscape.c
@@ -69,7 +69,9 @@ module_param_array(dma, int, NULL, 0444);
 MODULE_PARM_DESC(dma, "DMA # for SoundScape driver.");
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
+
 static struct pnp_card_device_id sscape_pnpids[] = {
 	{ .id = "ENS3081", .devs = { { "ENS0000" } } },
 	{ .id = "" }	/* end */
@@ -1405,22 +1407,21 @@ static struct pnp_card_driver sscape_pnpc_driver = {
 
 static int __init sscape_init(void)
 {
-	int ret;
+	int err;
 
-	/*
-	 * First check whether we were passed any parameters.
-	 * These MUST take precedence over ANY automatic way
-	 * of allocating cards, because the operator is
-	 * S-P-E-L-L-I-N-G it out for us...
-	 */
-	ret = isa_register_driver(&snd_sscape_driver, SNDRV_CARDS);
-	if (ret < 0)
-		return ret;
+	err = isa_register_driver(&snd_sscape_driver, SNDRV_CARDS);
 #ifdef CONFIG_PNP
-	if (pnp_register_card_driver(&sscape_pnpc_driver) == 0)
+	if (!err)
+		isa_registered = 1;
+
+	err = pnp_register_card_driver(&sscape_pnpc_driver);
+	if (!err)
 		pnp_registered = 1;
+
+	if (isa_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit sscape_exit(void)
@@ -1428,8 +1429,9 @@ static void __exit sscape_exit(void)
 #ifdef CONFIG_PNP
 	if (pnp_registered)
 		pnp_unregister_card_driver(&sscape_pnpc_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_sscape_driver);
+		isa_unregister_driver(&snd_sscape_driver);
 }
 
 module_init(sscape_init);
diff --git a/sound/isa/wavefront/wavefront.c b/sound/isa/wavefront/wavefront.c
index 75673f7..83c2fc4 100644
--- a/sound/isa/wavefront/wavefront.c
+++ b/sound/isa/wavefront/wavefront.c
@@ -86,6 +86,7 @@ module_param_array(use_cs4232_midi, bool, NULL, 0444);
 MODULE_PARM_DESC(use_cs4232_midi, "Use CS4232 MPU-401 interface (inaccessibly located inside your computer)");
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
 
 static struct pnp_card_device_id snd_wavefront_pnpids[] = {
@@ -706,14 +707,18 @@ static int __init alsa_card_wavefront_init(void)
 	int err;
 
 	err = isa_register_driver(&snd_wavefront_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_card_driver(&wavefront_pnpc_driver);
 	if (!err)
 		pnp_registered = 1;
+
+	if (isa_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_wavefront_exit(void)
@@ -721,8 +726,9 @@ static void __exit alsa_card_wavefront_exit(void)
 #ifdef CONFIG_PNP
 	if (pnp_registered)
 		pnp_unregister_card_driver(&wavefront_pnpc_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_wavefront_driver);
+		isa_unregister_driver(&snd_wavefront_driver);
 }
 
 module_init(alsa_card_wavefront_init)

--------------080109060902050003030109--
