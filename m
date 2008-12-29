Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbYL2TSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbYL2TSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 14:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYL2TSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 14:18:09 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:39341 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYL2TSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 14:18:07 -0500
X-Greylist: delayed 1303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2008 14:18:07 EST
Date: Mon, 29 Dec 2008 19:56:19 +0100
From: Arjan Opmeer <arjan@opmeer.net>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Message-ID: <20081229185619.GA18394@adopmeer.homeip.net>
References: <gj4r8h$okm$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gj4r8h$okm$1@ger.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: 2.6.28 thinks that my PS/2 mouse is a touchpad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 02:06:29PM +0500, Alexander E. Patrakov wrote:
> 
> Linux-2.6.28, as compiled by Arch Linux developers, thinks that my PS/2
> mouse (a cheap M-BT58 optical wheel mouse by Logitech) is actually a
> touchpad.  This makes it unusable.  Adding the "proto=imps" parameter to
> the psmouse module helps.

> CONFIG_MOUSE_PS2_ELANTECH=y

Oh dear. The first victim of this driver... :(

As we can see below the mouse gets detected as an Elantech touchpad. This
means that it reacts to the Elantech magic knock with the exact same
response we expect from a real Elantech touchpad.

I see no way to prevent this from happening.

> elantech.c: Elantech version query result 0x00, 0x01, 0x64.
> elantech.c: assuming hardware version 1, firmware version 0.100
> elantech.c: Synaptics capabilities query result 0x00, 0x02, 0x64.

However, all version query results I have seen from Elantech touchpads have
a non-zero first byte and a zero second byte. So we could test for that to
prevent this mouse from being detected as a touchpad.

Dmitry, do you think something like this is sufficient?

--- elantech.c.ORIG	2008-12-29 19:35:01.000000000 +0100
+++ elantech.c.NEW	2008-12-29 19:38:59.000000000 +0100
@@ -618,6 +618,10 @@ int elantech_init(struct psmouse *psmous
 	}
 	pr_info("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
 		param[0], param[1], param[2]);
+	if (param[0] == 0 || param[1] != 0) {
+		pr_info("elantech.c: Probably not a real Elantech touchpad. Aborting.\n");
+		goto init_fail;
+	}
 	etd->fw_version_maj = param[0];
 	etd->fw_version_min = param[2];


Arjan

