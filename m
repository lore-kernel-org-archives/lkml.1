Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbZCWKQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbZCWKQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbZCWKQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:16:09 -0400
Received: from mailsit.unilogicnetworks.net ([62.133.206.125]:52763 "EHLO
	mail.unilogicnetworks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbZCWKQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:16:07 -0400
Subject: [PATCH] alsa: Intel HDA output and align Ids.
From: "Pascal de Bruijn | Unilogic Networks B.V." 
	<pascal@unilogicnetworks.net>
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Content-Type: text/plain
Organization: Unilogic Networks B.V.
Date: Mon, 23 Mar 2009 11:15:59 +0100
Message-Id: <1237803359.11871.23.camel@carnifex>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does two things:
 Output Intel HDA Function Id in /proc/asound/cardX/codec#X
 Align Vendor/Subsystem/Revision Ids to 8 characters, front-padded with zeros

Before:
 Vendor Id: 0x11d41884
 Subsystem Id: 0x103c281a
 Revision Id: 0x100100

After:
 Function Id: 0x1
 Vendor Id: 0x11d41884
 Subsystem Id: 0x103c281a
 Revision Id: 0x0100100

As report on the Kernel Bugzilla #12888

Signed-off-by: Pascal de Bruijn <pascal@unilogicnetworks.net>

diff -Nurp linux-2.6.29-rc8-orig/sound/pci/hda/hda_codec.c linux-2.6.29-rc8-func/sound/pci/hda/hda_codec.c
--- linux-2.6.29-rc8-orig/sound/pci/hda/hda_codec.c	2009-03-20 16:05:15.000000000 +0100
+++ linux-2.6.29-rc8-func/sound/pci/hda/hda_codec.c	2009-03-23 10:37:30.000000000 +0100
@@ -647,9 +647,9 @@ static void /*__devinit*/ setup_fg_nodes
 
 	total_nodes = snd_hda_get_sub_nodes(codec, AC_NODE_ROOT, &nid);
 	for (i = 0; i < total_nodes; i++, nid++) {
-		unsigned int func;
-		func = snd_hda_param_read(codec, nid, AC_PAR_FUNCTION_TYPE);
-		switch (func & 0xff) {
+		codec->function_id = snd_hda_param_read(codec, nid,
+						AC_PAR_FUNCTION_TYPE) & 0xff;
+		switch (codec->function_id) {
 		case AC_GRP_AUDIO_FUNCTION:
 			codec->afg = nid;
 			break;
diff -Nurp linux-2.6.29-rc8-orig/sound/pci/hda/hda_codec.h linux-2.6.29-rc8-func/sound/pci/hda/hda_codec.h
--- linux-2.6.29-rc8-orig/sound/pci/hda/hda_codec.h	2009-03-20 16:05:15.000000000 +0100
+++ linux-2.6.29-rc8-func/sound/pci/hda/hda_codec.h	2009-03-20 16:10:07.000000000 +0100
@@ -739,6 +739,7 @@ struct hda_codec {
 	hda_nid_t mfg;	/* MFG node id */
 
 	/* ids */
+	u32 function_id;
 	u32 vendor_id;
 	u32 subsystem_id;
 	u32 revision_id;
diff -Nurp linux-2.6.29-rc8-orig/sound/pci/hda/hda_proc.c linux-2.6.29-rc8-func/sound/pci/hda/hda_proc.c
--- linux-2.6.29-rc8-orig/sound/pci/hda/hda_proc.c	2009-03-20 16:05:15.000000000 +0100
+++ linux-2.6.29-rc8-func/sound/pci/hda/hda_proc.c	2009-03-20 16:10:07.000000000 +0100
@@ -467,8 +467,9 @@ static void print_codec_info(struct snd_
 	snd_iprintf(buffer, "Codec: %s\n",
 		    codec->name ? codec->name : "Not Set");
 	snd_iprintf(buffer, "Address: %d\n", codec->addr);
-	snd_iprintf(buffer, "Vendor Id: 0x%x\n", codec->vendor_id);
-	snd_iprintf(buffer, "Subsystem Id: 0x%x\n", codec->subsystem_id);
+	snd_iprintf(buffer, "Function Id: 0x%x\n", codec->function_id);
+	snd_iprintf(buffer, "Vendor Id: 0x%08x\n", codec->vendor_id);
+	snd_iprintf(buffer, "Subsystem Id: 0x%08x\n", codec->subsystem_id);
 	snd_iprintf(buffer, "Revision Id: 0x%x\n", codec->revision_id);
 
 	if (codec->mfg)


