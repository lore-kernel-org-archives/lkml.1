Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbXLHFw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbXLHFw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 00:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbXLHFwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 00:52:50 -0500
Received: from mail1.g-b.net ([64.191.66.247]:53417 "EHLO mail1.g-b.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbXLHFwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 00:52:49 -0500
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Dec 2007 00:52:49 EST
Message-ID: <475A2ECA.6090508@g-b.net>
Date: Sat, 08 Dec 2007 05:42:34 +0000
From: Albert Graham <agraham@g-b.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: mchehab@infradead.org
CC: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] V4L/DVB: SAA7134: Enable remote control support for Avermedia
 M102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Albert Graham <agraham@g-b.net>

Signed-off-by: Albert Graham <agraham@g-b.net>

[PATCH] V4L/DVB: SAA7134: Enable remote control support for Avermedia M102

This patch enabled the IR remote control for the Avermedia M102 (card=110), 
which appears to be the same IR as the already supported device on the 
Avermedia AVerTV GO 007 FM (card=57) model, the code is two one liners which enable the
 IR for this device (subsystem: 1461:f31e)

I understand that this IR RC was previously supported by the lirc_gpio which is no longer
 supported in the kernel. The dmesg below show the device being detected and it works a expected.


dmesg output:

saa7133[0]: found at 0000:0a:04.0, rev: 209, irq: 23, latency: 64, mmio: 0xb3006000
saa7133[0]: subsystem: 1461:f31e, board: Avermedia M102 [card=110,autodetected]
saa7133[0]: board init: gpio is 7f0

---> input: saa7134 IR (Avermedia M102) as /class/input/input8 <-----

saa7133[0]: i2c eeprom 00: 61 14 1e f3 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff d1 fe ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 1-004b: chip found @ 0x96 (saa7133[0])
tuner 1-004b: setting tuner address to 61
tuner 1-004b: type set to tda8290+75
firewire_core: created new fw device fw0 (0 config rom retries, S400)
tuner 1-004b: setting tuner address to 61
tuner 1-004b: type set to tda8290+75

lspci -v:

0a:04.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
        Subsystem: Avermedia Technologies Inc Unknown device f31e
        Flags: bus master, medium devsel, latency 64, IRQ 23
        Memory at b3006000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [40] Power Management version 2

uname -r:
2.6.23.8-63.local.fc8



diff -uNrp a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
--- a/drivers/media/video/saa7134/saa7134-cards.c       2007-10-09 21:31:38.000000000 +0100
+++ b/drivers/media/video/saa7134/saa7134-cards.c       2007-12-08 05:38:17.000000000 +0000
@@ -4440,6 +4440,7 @@ int saa7134_board_init1(struct saa7134_d
                break;
        case SAA7134_BOARD_AVERMEDIA_M102:
                /* enable tuner */
+               dev->has_remote = SAA7134_REMOTE_GPIO;
                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x8c040007, 0x8c040007);
                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0c0007cd, 0x0c0007cd);
                break;
diff -uNrp a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
--- a/drivers/media/video/saa7134/saa7134-input.c       2007-10-09 21:31:38.000000000 +0100
+++ b/drivers/media/video/saa7134/saa7134-input.c       2007-12-08 05:38:17.000000000 +0000
@@ -246,6 +246,7 @@ int saa7134_input_init1(struct saa7134_d
        case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
        case SAA7134_BOARD_AVERMEDIA_STUDIO_507:
        case SAA7134_BOARD_AVERMEDIA_GO_007_FM:
+        case SAA7134_BOARD_AVERMEDIA_M102:
                ir_codes     = ir_codes_avermedia;
                mask_keycode = 0x0007C8;
                mask_keydown = 0x000010;

----------- END -----------------




