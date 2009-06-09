Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZFIOdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZFIOdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZFIOdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:33:46 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:54134 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZFIOdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:33:46 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Dirk Eibach <eibach@gdsys.de>
Subject: [PATCH 1/1] Char: moxa, prevent opening unavailable ports
Date: Tue,  9 Jun 2009 16:33:01 +0200
Message-Id: <1244557981-9443-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Eibach <eibach@gdsys.de>

In moxa.c there are 32 minor numbers reserved for each device. The
number of ports actually available per device is stored in
moxa_board_conf->numPorts. This number is not considered in moxa_open().
Opening a port that is not available results in a kernel oops.
This patch adds a test to moxa_open() that prevents opening unavailable
ports.

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
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
1.6.3.2

