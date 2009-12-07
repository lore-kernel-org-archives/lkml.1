Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbZLGAT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbZLGAT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758589AbZLGANv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:51 -0500
Received: from kroah.org ([198.145.64.141]:34628 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758349AbZLGANi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:38 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:55 2009
Message-Id: <20091207000655.196912423@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Krufky <mkrufky@kernellabs.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [082/119] V4L/DVB (13313): saa7134: add support for FORCE_TS_VALID mode for mpeg ts input
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13313-saa7134-add-support-for-force_ts_valid-mode-for-mpeg-ts-input.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Krufky <mkrufky@kernellabs.com>

commit 4007a672abd88091e3cced158ec491d41c0c454c upstream.

When FORCE_TS_VALID mode is enabled, the saa713x will accept MPEG TS input
without requiring TS_VALID set high.  This is required for some new boards
to function properly, due to the hardware design implementation.

The configuration is toggled within the board setup configuration.  Boards
that do not have this bit set will function as before with no change.

Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/saa7134/saa7134-ts.c |    6 ++++--
 drivers/media/video/saa7134/saa7134.h    |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -355,6 +355,7 @@ struct saa7134_board {
 	enum saa7134_mpeg_type  mpeg;
 	enum saa7134_mpeg_ts_type ts_type;
 	unsigned int            vid_port_opts;
+	unsigned int            ts_force_val:1;
 };
 
 #define card_has_radio(dev)   (NULL != saa7134_boards[dev->board].radio.name)
--- a/drivers/media/video/saa7134/saa7134-ts.c
+++ b/drivers/media/video/saa7134/saa7134-ts.c
@@ -262,11 +262,13 @@ int saa7134_ts_start(struct saa7134_dev 
 	switch (saa7134_boards[dev->board].ts_type) {
 	case SAA7134_MPEG_TS_PARALLEL:
 		saa_writeb(SAA7134_TS_SERIAL0, 0x40);
-		saa_writeb(SAA7134_TS_PARALLEL, 0xec);
+		saa_writeb(SAA7134_TS_PARALLEL, 0xec |
+			(saa7134_boards[dev->board].ts_force_val << 4));
 		break;
 	case SAA7134_MPEG_TS_SERIAL:
 		saa_writeb(SAA7134_TS_SERIAL0, 0xd8);
-		saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
+		saa_writeb(SAA7134_TS_PARALLEL, 0x6c |
+			(saa7134_boards[dev->board].ts_force_val << 4));
 		saa_writeb(SAA7134_TS_PARALLEL_SERIAL, 0xbc);
 		saa_writeb(SAA7134_TS_SERIAL1, 0x02);
 		break;


