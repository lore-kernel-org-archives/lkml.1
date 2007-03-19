Return-Path: <linux-kernel-owner+w=401wt.eu-S1030666AbXCSVr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030666AbXCSVr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030591AbXCSVrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:47:35 -0400
Received: from mail.suse.de ([195.135.220.2]:55968 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030651AbXCSVm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:42:28 -0400
Date: Mon, 19 Mar 2007 14:40:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 25/31] Input: i8042 - really suppress ACK/NAK during panic blink
Message-ID: <20070319214040.GA9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-i8042-really-suppress-ack-nak-during-panic-blink.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dtor@insightbb.com>

Input: i8042 - really suppress ACK/NAK during panic blink

On some boxes panic blink procedure manages to send both bytes
to keyboard contoller before getting first ACK so we need to
make i8042_suppress_kbd_ack a counter instead of boolean.

Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/input/serio/i8042.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -371,7 +371,7 @@ static irqreturn_t i8042_interrupt(int i
 	if (unlikely(i8042_suppress_kbd_ack))
 		if (port_no == I8042_KBD_PORT_NO &&
 		    (data == 0xfa || data == 0xfe)) {
-			i8042_suppress_kbd_ack = 0;
+			i8042_suppress_kbd_ack--;
 			goto out;
 		}
 
@@ -838,13 +838,14 @@ static long i8042_panic_blink(long count
 	led ^= 0x01 | 0x04;
 	while (i8042_read_status() & I8042_STR_IBF)
 		DELAY;
-	i8042_suppress_kbd_ack = 1;
+	dbg("%02x -> i8042 (panic blink)", 0xed);
+	i8042_suppress_kbd_ack = 2;
 	i8042_write_data(0xed); /* set leds */
 	DELAY;
 	while (i8042_read_status() & I8042_STR_IBF)
 		DELAY;
 	DELAY;
-	i8042_suppress_kbd_ack = 1;
+	dbg("%02x -> i8042 (panic blink)", led);
 	i8042_write_data(led);
 	DELAY;
 	last_blink = count;

-- 
