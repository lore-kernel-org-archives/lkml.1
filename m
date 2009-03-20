Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbZCTNYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbZCTNYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZCTNYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:24:09 -0400
Received: from mailsit.unilogicnetworks.net ([62.133.206.125]:45829 "EHLO
	mail.unilogicnetworks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZCTNYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:24:08 -0400
X-Greylist: delayed 1387 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2009 09:24:07 EDT
Subject: [PATCH] alsa: Intel HDA output and align Ids.
From: "Pascal de Bruijn | Unilogic Networks B.V." 
	<pascal@unilogicnetworks.net>
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Content-Type: text/plain
Organization: Unilogic Networks B.V.
Date: Fri, 20 Mar 2009 14:00:56 +0100
Message-Id: <1237554056.6305.9.camel@carnifex>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Output Intel HDA Function Id in /proc/asound/cardX/codec#X
Align Vendor/Subsystem/Revision Ids to 8 characters, front-padded with zeros

As submitted to Kernel Bugzilla #12888

Signed-off-by: Pascal de Bruijn <pascal@unilogicnetworks.net>

diff -Nurp linux-2.6.28.8-orig/sound/pci/hda/hda_codec.c linux-2.6.28.8-func/sound/pci/hda/hda_codec.c
--- linux-2.6.28.8-orig/sound/pci/hda/hda_codec.c	2009-03-17 01:50:03.000000000 +0100
+++ linux-2.6.28.8-func/sound/pci/hda/hda_codec.c	2009-03-17 10:39:45.000000000 +0100
@@ -519,9 +519,8 @@ static void __devinit setup_fg_nodes(str
 
 	total_nodes = snd_hda_get_sub_nodes(codec, AC_NODE_ROOT, &nid);
 	for (i = 0; i < total_nodes; i++, nid++) {
-		unsigned int func;
-		func = snd_hda_param_read(codec, nid, AC_PAR_FUNCTION_TYPE);
-		switch (func & 0xff) {
+		codec->function_id = snd_hda_param_read(codec, nid, AC_PAR_FUNCTION_TYPE) & 0xff;
+		switch (codec->function_id) {
 		case AC_GRP_AUDIO_FUNCTION:
 			codec->afg = nid;
 			break;
diff -Nurp linux-2.6.28.8-orig/sound/pci/hda/hda_codec.h linux-2.6.28.8-func/sound/pci/hda/hda_codec.h
--- linux-2.6.28.8-orig/sound/pci/hda/hda_codec.h	2009-03-17 01:50:03.000000000 +0100
+++ linux-2.6.28.8-func/sound/pci/hda/hda_codec.h	2009-03-17 10:39:45.000000000 +0100
@@ -693,6 +693,7 @@ struct hda_codec {
 	hda_nid_t mfg;	/* MFG node id */
 
 	/* ids */
+	u32 function_id;
 	u32 vendor_id;
 	u32 subsystem_id;
 	u32 revision_id;
diff -Nurp linux-2.6.28.8-orig/sound/pci/hda/hda_proc.c linux-2.6.28.8-func/sound/pci/hda/hda_proc.c
--- linux-2.6.28.8-orig/sound/pci/hda/hda_proc.c	2009-03-17 01:50:03.000000000 +0100
+++ linux-2.6.28.8-func/sound/pci/hda/hda_proc.c	2009-03-17 10:40:08.000000000 +0100
@@ -520,9 +520,10 @@ static void print_codec_info(struct snd_
 	snd_hda_get_codec_name(codec, buf, sizeof(buf));
 	snd_iprintf(buffer, "Codec: %s\n", buf);
 	snd_iprintf(buffer, "Address: %d\n", codec->addr);
-	snd_iprintf(buffer, "Vendor Id: 0x%x\n", codec->vendor_id);
-	snd_iprintf(buffer, "Subsystem Id: 0x%x\n", codec->subsystem_id);
-	snd_iprintf(buffer, "Revision Id: 0x%x\n", codec->revision_id);
+	snd_iprintf(buffer, "Function Id: 0x%x\n", codec->function_id);
+	snd_iprintf(buffer, "Vendor Id: 0x%08x\n", codec->vendor_id);
+	snd_iprintf(buffer, "Subsystem Id: 0x%08x\n", codec->subsystem_id);
+	snd_iprintf(buffer, "Revision Id: 0x%08x\n", codec->revision_id);
 
 	if (codec->mfg)
 		snd_iprintf(buffer, "Modem Function Group: 0x%x\n", codec->mfg);



