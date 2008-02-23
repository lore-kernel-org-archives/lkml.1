Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYBWOZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYBWOZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYBWOZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:25:44 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:49205 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbYBWOZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:25:43 -0500
X-SBRS: 2.8
X-MesageID: 43206277
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,395,1199682000"; 
   d="scan'208";a="43206277"
Date: Sat, 23 Feb 2008 15:24:55 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       eklhad@comcast.net
Subject: Re: input: put ledstate in the keyboard notifier
Message-ID: <20080223142455.GH4244@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	eklhad@comcast.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, I just noticed that Karl Dahlke's patch to provide the ledstate got
into -mm.  Unfortunately, it is a bit bogus, see patch below, to be
applied on top of Karl's one.

Samuel


Keyboard notification ledstate fixes.

In keyboard notifications, use kbd->ledflagstate instead of
getledstate() since that's what the keyboard layer is supposed to use.

Update param.ledstate again between key handler call and notifying
KBD_POST_KEYSYM, since key handlers may update the led state.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux/drivers/char/keyboard.c.orig	2008-02-23 15:14:29.000000000 +0100
+++ linux/drivers/char/keyboard.c	2008-02-23 15:20:25.000000000 +0100
@@ -1240,7 +1240,7 @@
 	}
 
 	param.shift = shift_final = (shift_state | kbd->slockstate) ^ kbd->lockstate;
-	param.ledstate = getledstate();
+	param.ledstate = kbd->ledflagstate;
 	key_map = key_maps[shift_final];
 
 	if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_KEYCODE, &param) == NOTIFY_STOP || !key_map) {
@@ -1289,6 +1289,7 @@
 
 	(*k_handler[type])(vc, keysym & 0xff, !down);
 
+	param.ledstate = kbd->ledflagstate;
 	atomic_notifier_call_chain(&keyboard_notifier_list, KBD_POST_KEYSYM, &param);
 
 	if (type != KT_SLOCK)
