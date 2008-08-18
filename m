Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbYHRT0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbYHRT0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760897AbYHRTZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:25:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:47296 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760891AbYHRTZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:25:55 -0400
Date: Mon, 18 Aug 2008 12:19:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 03/49] usb-serial: dont release unregistered minors
Message-ID: <20080818191918.GD10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-serial-don-t-release-unregistered-minors.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 0282b7f2a874e72c18fcd5a112ccf67f71ba7f5c upstream

This patch (as1121) fixes a bug in the USB serial core.  When a device
is unregistered, the core will give back its minors -- even if the
device hasn't been assigned any!

The patch reserves the highest minor value (255) to mean that no minor
was assigned.  It also removes some dead code and does a small style
fixup.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |    7 +++----
 include/linux/usb/serial.h      |    3 ++-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -119,9 +119,6 @@ static void return_serial(struct usb_ser
 
 	dbg("%s", __FUNCTION__);
 
-	if (serial == NULL)
-		return;
-
 	for (i = 0; i < serial->num_ports; ++i) {
 		serial_table[serial->minor + i] = NULL;
 	}
@@ -140,7 +137,8 @@ static void destroy_serial(struct kref *
 	serial->type->shutdown(serial);
 
 	/* return the minor range that this device had */
-	return_serial(serial);
+	if (serial->minor != SERIAL_TTY_NO_MINOR)
+		return_serial(serial);
 
 	for (i = 0; i < serial->num_ports; ++i)
 		serial->port[i]->open_count = 0;
@@ -635,6 +633,7 @@ static struct usb_serial * create_serial
 	serial->interface = interface;
 	kref_init(&serial->kref);
 	mutex_init(&serial->disc_mutex);
+	serial->minor = SERIAL_TTY_NO_MINOR;
 
 	return serial;
 }
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -18,7 +18,8 @@
 #include <linux/mutex.h>
 
 #define SERIAL_TTY_MAJOR	188	/* Nice legal number now */
-#define SERIAL_TTY_MINORS	255	/* loads of devices :) */
+#define SERIAL_TTY_MINORS	254	/* loads of devices :) */
+#define SERIAL_TTY_NO_MINOR	255	/* No minor was assigned */
 
 /* The maximum number of ports one device can grab at once */
 #define MAX_NUM_PORTS		8

-- 
