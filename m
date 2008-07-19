Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYGSCQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYGSCQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 22:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYGSCQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 22:16:36 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:44773 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbYGSCQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 22:16:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=XjI4skjO53yqmglUjiySawZV6DNXi/SGZuuTMmvly1XPoTca4qe42l/t9EgUC9BcY0vJEz01oPYW8f7C3cJxWfYmL/nCWY4REFBuEu53ff1zCTN0MYTncjZxZESzPSUb;
Message-ID: <48814E67.80708@simon.arlott.org.uk>
Date: Sat, 19 Jul 2008 03:16:07 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080706)
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
CC: hermann pitton <hermann-pitton@arcor.de>, video4linux-list@redhat.com,
       v4l-dvb list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Brian Marete <bgmarete@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] saa7134: Copy tuner data earlier in init to avoid overwriting
 manual tuner type
References: <6dd519ae0807180428k30abd15eo60fd2856f7a43821@mail.gmail.com>	 <38354.simon.1216381906@5ec7c279.invalid> <1216421799.2666.23.camel@pc10.localdom.local>
In-Reply-To: <1216421799.2666.23.camel@pc10.localdom.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When saa7134_board_init2 runs, it immediately overwrites the current value
(set earlier from module parameter) of tuner_type with the static values,
and then does autodetection. This patch moves the tuner_addr copy to earlier
in saa7134_initdev and removes the tuner_type copy from saa7134_board_init2.

Autodetection could still potentially change to the wrong tuner type, but it
is now possible to override the default type for the card again.

My card's tuner is configured with autodetection from eeprom, so I don't 
need to manually set the tuner. I've checked that the autodetection still 
works for my card.

Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>
Cc: Brian Marete <bgmarete@gmail.com>
Tested-by: Simon Arlott <simon@fire.lp0.eu>
Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
> this restores tuner behavior on the saa7134 driver.
> 
> I can't test XCeive tuners, which load different firmware dynamically.
> Mauro was on them.
> 
> Please send the patch to Mauro and/or provide your signed-off-by.
> 
> This must go to the stable team ASAP as well.
> 
> Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>

drivers/media/video/saa7134/saa7134-cards.c |    3 ---
drivers/media/video/saa7134/saa7134-core.c  |    5 +++--
2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 2618cfa..0227cf9 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5703,9 +5703,6 @@ int saa7134_board_init2(struct saa7134_dev *dev)
	unsigned char buf;
	int board;

-	dev->tuner_type = saa7134_boards[dev->board].tuner_type;
-	dev->tuner_addr = saa7134_boards[dev->board].tuner_addr;
-
	switch (dev->board) {
	case SAA7134_BOARD_BMK_MPEX_NOTUNER:
	case SAA7134_BOARD_BMK_MPEX_TUNER:
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 2c19cd0..69f340d 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -946,11 +946,12 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
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
1.5.6.2

-- 
Simon Arlott

