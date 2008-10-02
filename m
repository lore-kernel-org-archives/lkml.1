Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYJBTpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYJBTpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYJBTpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:45:07 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:5208 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbYJBTpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:content-disposition:from:date:cc:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=MXuMr5onXNS/pIwmOfYr4Mqe/K61gOaiKxtJQI1CAUbF6dYZWL7od5q8ga/096wlTw
         Oxru9bdTjF3wZe0juEu+ZI5Muv/2vDIRQyQoPNCI1XSgHKuNRZbAFWpRmGTdUFD1CNIz
         RS/QwCYo/nSWU0n10gWxJ0L92vhRoMg7DISfw=
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Sigmatel stac92hd71b7 low HP volume
Content-Disposition: inline
From: Klaas De Craemer <klaasdc@gmail.com>
Date: Thu, 2 Oct 2008 21:45:03 +0200
Cc: perex@perex.cz
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200810022145.03535.klaasdc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Below is my patch for an issue on Dell E6500 notebooks with the Sigmatel stac92hd71b7 codec. In the default snd-hda-intel configuration, the sound going to the headphone jack goes comes directly from the DAC, resulting in very low volume output. The patch changes the codec's widget connections so that the internal mixer is put in between and sets its input amplifiers to the maximum value. The output to the internal speaker port has been left untouched.
I have tested this and it gives a much better output.

Klaas De Craemer


diff -uNr linux-2.6.26.5/sound/pci/hda/patch_sigmatel.c linux-2.6.26.5.new/sound/pci/hda/patch_sigmatel.c
--- linux-2.6.26.5/sound/pci/hda/patch_sigmatel.c	2008-09-08 19:40:20.000000000 +0200
+++ linux-2.6.26.5.new/sound/pci/hda/patch_sigmatel.c	2008-10-02 20:08:51.000000000 +0200
@@ -624,6 +624,22 @@
 	{}
 };
 
+static struct hda_verb stac92hd71b7_core_init[] = {
+	/* set master volume and direct control */
+	{ 0x28, AC_VERB_SET_VOLUME_KNOB_CONTROL, 0xff},
+	/* connect headphone jack to mixer */
+	{ 0x0a, AC_VERB_SET_CONNECT_SEL, 0x02},
+	/* unmute right and left channels for nodes 0x0a, 0xd, 0x0f */
+	{ 0x0a, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{ 0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{ 0x0f, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+
+	/* Increase mixer volume for the two dac's */
+	{ 0x17, 0x370, 0x7f },
+	{ 0x17, 0x371, 0x7f },
+	{}
+};
+
 static struct hda_verb stac92hd71bxx_core_init[] = {
 	/* set master volume and direct control */
 	{ 0x28, AC_VERB_SET_VOLUME_KNOB_CONTROL, 0xff},
@@ -3642,6 +3658,10 @@
 		spec->mixer = stac92hd71bxx_mixer;
 		spec->init = stac92hd71bxx_core_init;
 		break;
+	case 0x111d76b2: /* Dell E6500 stac92hd71b7 configuration */
+		spec->mixer = stac92hd71bxx_mixer;
+		spec->init = stac92hd71b7_core_init;
+		break;
 	default:
 		spec->mixer = stac92hd71bxx_analog_mixer;
 		spec->init = stac92hd71bxx_analog_core_init;
