Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZKUWKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZKUWKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 17:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbZKUWKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 17:10:33 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:64188 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875AbZKUWKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 17:10:23 -0500
X-Authuid: nmarci
Message-ID: <4B08654E.1050609@freemail.hu>
Date: Sat, 21 Nov 2009 23:10:22 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jaya Kumar <jayakumar.alsa@gmail.com>
CC: cocci@diku.dk, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] cs5535audio: remove redundant zero fill
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32711; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The buffer is first zeroed out by memset(). Then strncpy() is used to
fill the content. The strncpy() function also pads the string till the
end of the specified length, which is redundant. The strncpy() does not
ensures that the string will be properly closed with 0. Use strlcpy()
instead.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression buffer;
expression size;
expression str;
@@
	memset(buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer, str, sizeof(buffer)
	);
@@
expression buffer;
expression size;
expression str;
@@
	memset(&buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	&buffer, str, sizeof(buffer));
@@
expression buffer;
identifier field;
expression size;
expression str;
@@
	memset(buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer->field, str, sizeof(buffer->field)
	);
@@
expression buffer;
identifier field;
expression size;
expression str;
@@
	memset(&buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer.field, str, sizeof(buffer.field));
// </smpl>

On strncpy() vs strlcpy() see http://www.gratisoft.us/todd/papers/strlcpy.html .

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -u -p a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c 2009-09-10 00:13:59.000000000 +0200
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c 2009-11-21 22:18:57.000000000 +0100
@@ -156,13 +156,13 @@ int __devinit olpc_quirks(struct snd_car
 	/* drop the original AD1888 HPF control */
 	memset(&elem, 0, sizeof(elem));
 	elem.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-	strncpy(elem.name, "High Pass Filter Enable", sizeof(elem.name));
+	strlcpy(elem.name, "High Pass Filter Enable", sizeof(elem.name));
 	snd_ctl_remove_id(card, &elem);

 	/* drop the original V_REFOUT control */
 	memset(&elem, 0, sizeof(elem));
 	elem.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-	strncpy(elem.name, "V_REFOUT Enable", sizeof(elem.name));
+	strlcpy(elem.name, "V_REFOUT Enable", sizeof(elem.name));
 	snd_ctl_remove_id(card, &elem);

 	/* add the OLPC-specific controls */
