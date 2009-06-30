Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbZGAAbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbZGAAbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759606AbZGAA36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:29:58 -0400
Received: from kroah.org ([198.145.64.141]:34302 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759367AbZGAA35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:29:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:03:56 2009
Message-Id: <20090701000356.802112344@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 16:59:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dirk Eibach <eibach@gdsys.de>, Jiri Slaby <jirislaby@gmail.com>
Subject: [patch 04/30] char: moxa, prevent opening unavailable ports
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=char-moxa-prevent-opening-unavailable-ports.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1158,6 +1158,11 @@ static int moxa_open(struct tty_struct *
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
@@ -1182,8 +1187,8 @@ static int moxa_open(struct tty_struct *
 				moxa_close_port(ch);
 	} else
 		ch->port.flags |= ASYNC_NORMAL_ACTIVE;
+out_unlock:
 	mutex_unlock(&moxa_openlock);
-
 	return retval;
 }
 


