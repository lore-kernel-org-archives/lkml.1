Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0BSRPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:15:39 -0500
Received: from kroah.org ([198.145.64.141]:57427 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab0BSRAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:22 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:36 2010
Message-Id: <20100219163236.615628112@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jody Bruchon <jody@nctritech.com>, Takashi Iwai <tiwai@suse.de>
Subject: [23/93] ALSA: hda-intel: Avoid divide by zero crash
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jody Bruchon <jody@nctritech.com>

commit fed08d036f2aabd8d0c684439de37f8ebec2bbc2 upstream.

On my AMD780V chipset, hda_intel.c can crash the kernel with a divide by
zero
for as-yet unknown reasons. A simple check for zero prevents it, though
the problem that causes it remains. Since the workaround is harmless and
won't affect anyone except victims of this bug, it should be safe;
moreover,
because this crash can be triggered by a user-mode application, there are
denial of service implications on the systems affected by the bug without
the patch.

Signed-off-by: Jody Bruchon <jody@nctritech.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1858,6 +1858,12 @@ static int azx_position_ok(struct azx *c
 
 	if (!bdl_pos_adj[chip->dev_index])
 		return 1; /* no delayed ack */
+	if (azx_dev->period_bytes == 0) {
+		printk(KERN_WARNING
+		       "hda-intel: Divide by zero was avoided "
+		       "in azx_dev->period_bytes.\n");
+		return 0;
+	}
 	if (pos % azx_dev->period_bytes > azx_dev->period_bytes / 2)
 		return 0; /* NG - it's below the period boundary */
 	return 1; /* OK, it's fine */


