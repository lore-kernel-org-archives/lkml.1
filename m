Return-Path: <linux-kernel-owner+w=401wt.eu-S1946232AbXBCChQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946232AbXBCChQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946239AbXBCChA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:37:00 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52788 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946232AbXBCCgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:36:50 -0500
Message-Id: <20070203023909.479963000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:14 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Takashi Iwai <tiwai@suse.de>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Karsten Wiese <annabellesgarden@yahoo.de>,
       Matt Savigear <mcs_jack@savigear.com>, alsa-devel@lists.sourceforge.net,
       Rui Capela <rncbc@rncbc.org>, Karsten Wiese <fzu@wemgehoertderstaat.de>
Subject: [patch 10/59] Repair snd-usb-usx2y over OHCI
Content-Disposition: inline; filename=repair-snd-usb-usx2y-over-ohci.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Karsten Wiese <fzu@wemgehoertderstaat.de>

The previous patch "Repair snd-usb-usx2y for usb 2.6.18" assumed
urb->start_frame roll over beyond MAX_INT for both UHCI & OHCI.
This isn't true until now (kernel 2.6.20).
Fix this by only looking at the common between OHCI & UHCI Frame number
range.
This is for mainline and stable kernels >= 2.6.18.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 sound/usb/usx2y/usbusx2yaudio.c |    2 +-
 sound/usb/usx2y/usx2yhwdeppcm.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19.2.orig/sound/usb/usx2y/usbusx2yaudio.c
+++ linux-2.6.19.2/sound/usb/usx2y/usbusx2yaudio.c
@@ -322,7 +322,7 @@ static void i_usX2Y_urb_complete(struct 
 		usX2Y_error_urb_status(usX2Y, subs, urb);
 		return;
 	}
-	if (likely(urb->start_frame == usX2Y->wait_iso_frame))
+	if (likely((urb->start_frame & 0xFFFF) == (usX2Y->wait_iso_frame & 0xFFFF)))
 		subs->completed_urb = urb;
 	else {
 		usX2Y_error_sequence(usX2Y, subs, urb);
--- linux-2.6.19.2.orig/sound/usb/usx2y/usx2yhwdeppcm.c
+++ linux-2.6.19.2/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -243,7 +243,7 @@ static void i_usX2Y_usbpcm_urb_complete(
 		usX2Y_error_urb_status(usX2Y, subs, urb);
 		return;
 	}
-	if (likely(urb->start_frame == usX2Y->wait_iso_frame))
+	if (likely((urb->start_frame & 0xFFFF) == (usX2Y->wait_iso_frame & 0xFFFF)))
 		subs->completed_urb = urb;
 	else {
 		usX2Y_error_sequence(usX2Y, subs, urb);

--
