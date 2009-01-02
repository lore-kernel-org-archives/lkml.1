Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbZABSh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbZABSh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZABShU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:37:20 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:50912 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZABShT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:37:19 -0500
Date: Fri, 2 Jan 2009 19:37:14 +0100
From: Arjan Opmeer <arjan@opmeer.net>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Alexander E. Patrakov" <patrakov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Message-ID: <20090102183714.GA24438@adopmeer.homeip.net>
References: <gj4r8h$okm$1@ger.gmane.org> <20081229185619.GA18394@adopmeer.homeip.net> <200901020107.54740.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901020107.54740.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: 2.6.28 thinks that my PS/2 mouse is a touchpad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 01:07:54AM +0100, Denys Vlasenko wrote:
> On Monday 29 December 2008 19:56, Arjan Opmeer wrote:
> > On Sat, Dec 27, 2008 at 02:06:29PM +0500, Alexander E. Patrakov wrote:
> > > 
> > > Linux-2.6.28, as compiled by Arch Linux developers, thinks that my
> > > PS/2 mouse (a cheap M-BT58 optical wheel mouse by Logitech) is
> > > actually a touchpad.  This makes it unusable.  Adding the "proto=imps"
> > > parameter to the psmouse module helps.
> > 
> > > CONFIG_MOUSE_PS2_ELANTECH=y
> > 
> > Oh dear. The first victim of this driver... :(
> > 
> > As we can see below the mouse gets detected as an Elantech touchpad.
> > This means that it reacts to the Elantech magic knock with the exact
> > same response we expect from a real Elantech touchpad.
> 
> I am affected too. I am getting:
> 
> input: AT Translated Set 2 keyboard as /class/input/input2
> elantech.c: Elantech version query result 0x00, 0x01, 0x64.
> elantech.c: assuming hardware version 1, firmware version 0.100
> elantech.c: Synaptics capabilities query result 0x00, 0x02, 0x64.
> input: ETPS/2 Elantech Touchpad as /class/input/input3

So how about we try to solve it by duplicating the version query in
elantech_detect() and check for sane values. Dmitry, do you think something
like this would be acceptable?


Arjan

--- elantech.c.ORIG	2008-12-29 19:35:01.000000000 +0100
+++ elantech.c.NEW2	2009-01-02 19:26:01.000000000 +0100
@@ -556,6 +556,22 @@ int elantech_detect(struct psmouse *psmo
 		return -1;
 	}
 
+	/*
+	 * There are Logitech mice that react to the magic knock exactly
+	 * like an Elantech touchpad would, so do a version query here to
+	 * try to distinguish the two
+	 */
+	if (synaptics_send_cmd(psmouse, ETP_FW_VERSION_QUERY, param)) {
+		pr_err("elantech.c: failed to query firmware version.\n");
+		return -1;
+	}
+	pr_info("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
+		param[0], param[1], param[2]);
+	if (param[0] == 0 || param[1] != 0) {
+		pr_info("elantech.c: Probably not a real Elantech touchpad. Aborting.\n");
+		return -1;
+	}
+
 	if (set_properties) {
 		psmouse->vendor = "Elantech";
 		psmouse->name = "Touchpad";
@@ -610,14 +626,12 @@ int elantech_init(struct psmouse *psmous
 		etd->parity[i] = etd->parity[i & (i - 1)] ^ 1;
 
 	/*
-	 * Find out what version hardware this is
+	 * Do the version query again so we can store the result
 	 */
 	if (synaptics_send_cmd(psmouse, ETP_FW_VERSION_QUERY, param)) {
 		pr_err("elantech.c: failed to query firmware version.\n");
 		goto init_fail;
 	}
-	pr_info("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
-		param[0], param[1], param[2]);
 	etd->fw_version_maj = param[0];
 	etd->fw_version_min = param[2];
 
