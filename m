Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbYF0RBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbYF0RBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYF0RBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:01:35 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:45545 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYF0RBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:01:34 -0400
X-Greylist: delayed 1747 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2008 13:01:34 EDT
To: paul@burly.ondioline.org
Cc: marcel@holtmann.org, jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] fix HID quirks for aluminium apple wireless keyboards
References: <87tzfwiguc.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87tzfwiguc.fsf@burly.wgtn.ondioline.org>
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
Date: Fri, 27 Jun 2008 18:32:03 +0200
Message-ID: <87zlp6g7p8.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I applied your patch from http://lkml.org/lkml/2008/6/14/26 but
without HID_QUIRK_APPLE_NUMLOCK_EMULATION to v2.6.25, but on my G4-ppc
iBook the quirk is not found by hidp_setup_quirks.
If I remove the calls to le16_to_cpu from that function it
works on my ppc, looks like some endianness issue, see the second patch. 


diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 519cdb9..f96fb6e 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -676,6 +676,12 @@ static const struct {
 	__u16 idProduct;
 	unsigned quirks;
 } hidp_blacklist[] = {
+	/* Apple Wireless Keyboard, ANSI layout */
+	{ 0x05ac, 0x022c, HID_QUIRK_APPLE_HAS_FN },
+	/* Apple Wireless Keyboard, ISO layout */
+	{ 0x05ac, 0x022d, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
+	/* Apple Wireless Keyboard, JIS layout */
+	{ 0x05ac, 0x022e, HID_QUIRK_APPLE_HAS_FN },
 	/* Apple wireless Mighty Mouse */
 	{ 0x05ac, 0x030c, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
 


diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index f96fb6e..46f5958 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -693,8 +693,8 @@ static void hidp_setup_quirks(struct hid_device *hid)
 	unsigned int n;
 
 	for (n = 0; hidp_blacklist[n].idVendor; n++)
-		if (hidp_blacklist[n].idVendor == le16_to_cpu(hid->vendor) &&
-				hidp_blacklist[n].idProduct == le16_to_cpu(hid->product))
+		if (hidp_blacklist[n].idVendor == hid->vendor &&
+				hidp_blacklist[n].idProduct == hid->product)
 			hid->quirks = hidp_blacklist[n].quirks;
 }
 

--
 Jan Scholz
