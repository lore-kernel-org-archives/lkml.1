Return-Path: <linux-kernel-owner+w=401wt.eu-S1764301AbZGAAxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764301AbZGAAxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761425AbZGAAee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:34 -0400
Received: from kroah.org ([198.145.64.141]:60208 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761396AbZGAAea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:20 2009
Message-Id: <20090701002420.426675306@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dirk Eibach <eibach@gdsys.de>, Jiri Slaby <jirislaby@gmail.com>
Subject: [patch 026/108] char: moxa, prevent opening unavailable ports
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=char-moxa-prevent-opening-unavailable-ports.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dirk Eibach <eibach@gdsys.de>

commit a90b037583d5f1ae3e54e9c687c79df82d1d34a4 upstream.

In moxa.c there are 32 minor numbers reserved for each device.  The number
of ports actually available per device is stored in
moxa_board_conf->numPorts.  This number is not considered in moxa_open().
Opening a port that is not available results in a kernel oops.  This patch
adds a test to moxa_open() that prevents opening unavailable ports.

[akpm@linux-foundation.org: avoid multiple returns]
Signed-off-by: Dirk Eibach <eibach@gdsys.de>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/moxa.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -1184,6 +1184,11 @@ static int moxa_open(struct tty_struct *
 		return -ENODEV;
 	}
 
+	if (port % MAX_PORTS_PER_BOARD >= brd->numPorts) {
+		retval = -ENODEV;
+		goto out_unlock;
+	}
+
 	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
 	ch->port.count++;
 	tty->driver_data = ch;
@@ -1208,8 +1213,8 @@ static int moxa_open(struct tty_struct *
 				moxa_close_port(tty);
 	} else
 		ch->port.flags |= ASYNC_NORMAL_ACTIVE;
+out_unlock:
 	mutex_unlock(&moxa_openlock);
-
 	return retval;
 }
 


