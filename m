Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab0BSRIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:08:35 -0500
Received: from kroah.org ([198.145.64.141]:57715 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab0BSRA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:56 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:48 2010
Message-Id: <20100219163247.984850788@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [63/93] ALSA: hda - use WARN_ON_ONCE() for zero-division detection
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d6d8bf549393484e906913f02fa3c9518a2819b6 upstream.

Replace the zero-division warning message with WARN_ON_ONCE() per the
advice by Linus.  This shouldn't happen, but if it happens, it's
possible that the bug happens often due to buggy IRQs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1858,12 +1858,9 @@ static int azx_position_ok(struct azx *c
 
 	if (!bdl_pos_adj[chip->dev_index])
 		return 1; /* no delayed ack */
-	if (azx_dev->period_bytes == 0) {
-		printk(KERN_WARNING
-		       "hda-intel: Divide by zero was avoided "
-		       "in azx_dev->period_bytes.\n");
-		return 0;
-	}
+	if (WARN_ONCE(!azx_dev->period_bytes,
+		      "hda-intel: zero azx_dev->period_bytes"))
+		return 0; /* this shouldn't happen! */
 	if (pos % azx_dev->period_bytes > azx_dev->period_bytes / 2)
 		return 0; /* NG - it's below the period boundary */
 	return 1; /* OK, it's fine */


