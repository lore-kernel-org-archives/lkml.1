Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYKQHe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYKQHe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbYKQHVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:41 -0500
Received: from kroah.org ([198.145.64.141]:38666 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755586AbYKQHVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:35 -0500
Date: Sun, 16 Nov 2008 23:16:47 -0800
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
       alan@lxorguk.ukuu.org.uk, Geoff Levand <geoffrey.levand@am.sony.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 37/46] USB: Fix PS3 USB shutdown problems
Message-ID: <20081117071647.GL29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-ps3-usb-shutdown-problems.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Geoff Levand <geoffrey.levand@am.sony.com>

commit ddcb01ff9bf49c4dbbb058423559f7bc90b89374 upstream.

Add ehci_shutdown() or ohci_shutdown() calls to the USB
PS3 bus glue.  ehci_shutdown() and ohci_shutdown() do some
controller specific cleanups not done by usb_remove_hcd().

Fixes errors on shutdown or reboot similar to these:

  ps3-ehci-driver sb_07: HC died; cleaning up
  irq 51: nobody cared (try booting with the "irqpoll" option)

Related bugzilla reports:

  http://bugzilla.kernel.org/show_bug.cgi?id=11819
  http://bugzilla.terrasoftsolutions.com/show_bug.cgi?id=317

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-ps3.c |    1 +
 drivers/usb/host/ohci-ps3.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-ps3.c
+++ b/drivers/usb/host/ehci-ps3.c
@@ -205,6 +205,7 @@ static int ps3_ehci_remove(struct ps3_sy
 
 	tmp = hcd->irq;
 
+	ehci_shutdown(hcd);
 	usb_remove_hcd(hcd);
 
 	ps3_system_bus_set_driver_data(dev, NULL);
--- a/drivers/usb/host/ohci-ps3.c
+++ b/drivers/usb/host/ohci-ps3.c
@@ -192,7 +192,7 @@ fail_start:
 	return result;
 }
 
-static int ps3_ohci_remove (struct ps3_system_bus_device *dev)
+static int ps3_ohci_remove(struct ps3_system_bus_device *dev)
 {
 	unsigned int tmp;
 	struct usb_hcd *hcd =
@@ -205,6 +205,7 @@ static int ps3_ohci_remove (struct ps3_s
 
 	tmp = hcd->irq;
 
+	ohci_shutdown(hcd);
 	usb_remove_hcd(hcd);
 
 	ps3_system_bus_set_driver_data(dev, NULL);

-- 
