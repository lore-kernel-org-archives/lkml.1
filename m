Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbZFIHTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbZFIHTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZFIHT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:19:26 -0400
Received: from sputnik.urmx.de ([88.198.51.18]:48377 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZFIHT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:19:26 -0400
X-Greylist: delayed 1308 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2009 03:19:26 EDT
From: Dirk Eibach <eibach@gdsys.de>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Dirk Eibach <eibach@gdsys.de>
Subject: [PATCH] char: prevent opening unavailable ports in moxa.c
Date: Tue,  9 Jun 2009 08:57:36 +0200
Message-Id: <1244530656-32766-1-git-send-email-eibach@gdsys.de>
X-SafeGuard_MailGateway: Version: 5.60.2.9315 SGMG Date: 20090609065739Z
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.0.180; VDF: 7.1.4.71; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In moxa.c there are 32 minor numbers reserved for each device. The
number of ports actually available per device is stored in
moxa_board_conf->numPorts. This number is not considered in moxa_open().
Opening a port that is not available results in a kernel oops.
This patch adds a test to moxa_open() that prevents opening unavailable
ports.

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
---
 drivers/char/moxa.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 4a4cab7..65b6ff2 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -1184,6 +1184,11 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 		return -ENODEV;
 	}
 
+	if (port % MAX_PORTS_PER_BOARD >= brd->numPorts) {
+		mutex_unlock(&moxa_openlock);
+		return -ENODEV;
+	}
+
 	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
 	ch->port.count++;
 	tty->driver_data = ch;
-- 
1.5.6.5

