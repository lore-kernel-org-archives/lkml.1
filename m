Return-Path: <linux-kernel-owner+w=401wt.eu-S1761110AbZFIKYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbZFIKYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760633AbZFIKTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:19:22 -0400
Received: from kroah.org ([198.145.64.141]:54795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760124AbZFIKTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:19:20 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:00 2009
Message-Id: <20090609094100.241938835@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:23 -0700
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 35/87] usb-serial: fix crash when sub-driver updates firmware
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=usb-serial-fix-crash-when-sub-driver-updates-firmware.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 0a3c8549ea7e94d74a41096d42bc6cdf43d183bf upstream.

This patch (as1244) fixes a crash in usb-serial that occurs when a
sub-driver returns a positive value from its attach method, indicating
that new firmware was loaded and the device will disconnect and
reconnect.  The usb-serial core then skips the step of registering the
port devices; when the disconnect occurs, the attempt to unregister
the ports fails dramatically.

This problem shows up with Keyspan devices and it might affect others
as well.

When the attach method returns a positive value, the patch sets
num_ports to 0.  This tells usb_serial_disconnect() not to try
unregistering any of the ports; instead they are cleaned up by
destroy_serial().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -978,6 +978,7 @@ int usb_serial_probe(struct usb_interfac
 		if (retval > 0) {
 			/* quietly accept this device, but don't bind to a
 			   serial port as it's about to disappear */
+			serial->num_ports = 0;
 			goto exit;
 		}
 	}


