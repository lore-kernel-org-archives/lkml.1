Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbYGaAWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbYGaAWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760812AbYGaAU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:20:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762882AbYGaAU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:20:57 -0400
Date: Wed, 30 Jul 2008 16:59:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Simon Arlott <simon@fire.lp0.eu>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Hermann Pitton <hermann-pitton@arcor.de>,
       Brian Marete <bgmarete@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 45/62] V4L: saa7134: Copy tuner data earlier to avoid
	overwriting manual tuner type
Message-ID: <20080730235929.GS12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-saa7134-copy-tuner-data-earlier-to-avoid-overwriting-manual-tuner-type.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Simon Arlott <simon@fire.lp0.eu>

V4L: saa7134: Copy tuner data earlier to avoid overwriting manual tuner type

(cherry picked from commit d53687d1d22c3204394658a31654de2f1efb0e8f)

Copy tuner data earlier in init to avoid overwriting manual tuner type

When saa7134_board_init2 runs, it immediately overwrites the
current value (set earlier from module parameter) of tuner_type
with the static values, and then does autodetection. This patch
moves the tuner_addr copy to earlier in saa7134_initdev and
removes the tuner_type copy from saa7134_board_init2.

Autodetection could still potentially change to the wrong tuner
type, but it is now possible to override the default type for
the card again.

My card's tuner is configured with autodetection from eeprom,
so I don't need to manually set the tuner. I've checked that
the autodetection still works for my card.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>
Cc: Brian Marete <bgmarete@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/saa7134/saa7134-cards.c |    3 ---
 drivers/media/video/saa7134/saa7134-core.c  |    5 +++--
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5703,9 +5703,6 @@ int saa7134_board_init2(struct saa7134_d
 	unsigned char buf;
 	int board;
 
-	dev->tuner_type = saa7134_boards[dev->board].tuner_type;
-	dev->tuner_addr = saa7134_boards[dev->board].tuner_addr;
-
 	switch (dev->board) {
 	case SAA7134_BOARD_BMK_MPEX_NOTUNER:
 	case SAA7134_BOARD_BMK_MPEX_TUNER:
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -946,11 +946,12 @@ static int __devinit saa7134_initdev(str
 		dev->board = SAA7134_BOARD_UNKNOWN;
 	}
 	dev->autodetected = card[dev->nr] != dev->board;
-	dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
+	dev->tuner_type = saa7134_boards[dev->board].tuner_type;
+	dev->tuner_addr = saa7134_boards[dev->board].tuner_addr;
 	dev->tda9887_conf = saa7134_boards[dev->board].tda9887_conf;
 	if (UNSET != tuner[dev->nr])
 		dev->tuner_type = tuner[dev->nr];
-		printk(KERN_INFO "%s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
+	printk(KERN_INFO "%s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
 		dev->name,pci_dev->subsystem_vendor,
 		pci_dev->subsystem_device,saa7134_boards[dev->board].name,
 		dev->board, dev->autodetected ?

-- 
