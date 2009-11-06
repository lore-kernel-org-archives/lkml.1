Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbZKFVo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbZKFVo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 16:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbZKFVo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 16:44:27 -0500
Received: from ja.ssi.bg ([217.79.71.194]:53349 "EHLO u.domain.uli"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753590AbZKFVo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 16:44:26 -0500
Date: Fri, 6 Nov 2009 23:44:53 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@u.domain.uli
To: Takashi Iwai <tiwai@suse.de>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb-audio: fix combine_word problem
Message-ID: <Pine.LNX.4.58.0911062329380.7491@u.domain.uli>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Fix combine_word problem where first octet is not
read properly. The only affected place seems to be the
INPUT_TERMINAL type. Before now, sound controls can be created
with the output terminal's name which is a fallback mechanism
used only for unknown input terminal types. For example,
Line can wrongly appear as Speaker. After the change it
should appear as Line.

	The side effect of this change can be that users
can expect the wrong control name in their scripts or
programs while now we return the correct one.

	Probably, these defines should use get_unaligned_le16 and
friends.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---

diff -urp v2.6.31/linux/sound/usb/usbaudio.h linux/sound/usb/usbaudio.h
--- v2.6.31/linux/sound/usb/usbaudio.h	2009-06-13 10:53:59.000000000 +0300
+++ linux/sound/usb/usbaudio.h	2009-11-06 22:38:00.000000000 +0200
@@ -210,7 +210,7 @@ struct snd_usb_midi_endpoint_info {
 /*
  */
 
-#define combine_word(s)    ((*s) | ((unsigned int)(s)[1] << 8))
+#define combine_word(s)    ((*(s)) | ((unsigned int)(s)[1] << 8))
 #define combine_triple(s)  (combine_word(s) | ((unsigned int)(s)[2] << 16))
 #define combine_quad(s)    (combine_triple(s) | ((unsigned int)(s)[3] << 24))
 
