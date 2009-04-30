Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbZD3R1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbZD3R1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764598AbZD3RIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:02 -0400
Received: from kroah.org ([198.145.64.141]:56384 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764401AbZD3RHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:45 2009
Message-Id: <20090430165745.029921955@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:34 -0700
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
       alan@lxorguk.ukuu.org.uk, Jonathan McDowell <noodles@earth.li>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 45/88] usb gadget: fix ethernet link reports to ethtool
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0077-usb-gadget-fix-ethernet-link-reports-to-ethtool.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jonathan McDowell <noodles@earth.li>

upstream commit: 237e75bf1e558f7330f8deb167fa3116405bef2c

The g_ether USB gadget driver currently decides whether or not there's a
link to report back for eth_get_link based on if the USB link speed is
set. The USB gadget speed is however often set even before the device is
enumerated. It seems more sensible to only report a "link" if we're
actually connected to a host that wants to talk to us. The patch below
does this for me - tested with the PXA27x UDC driver.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/gadget/u_ether.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -175,12 +175,6 @@ static void eth_get_drvinfo(struct net_d
 	strlcpy(p->bus_info, dev_name(&dev->gadget->dev), sizeof p->bus_info);
 }
 
-static u32 eth_get_link(struct net_device *net)
-{
-	struct eth_dev	*dev = netdev_priv(net);
-	return dev->gadget->speed != USB_SPEED_UNKNOWN;
-}
-
 /* REVISIT can also support:
  *   - WOL (by tracking suspends and issuing remote wakeup)
  *   - msglevel (implies updated messaging)
@@ -189,7 +183,7 @@ static u32 eth_get_link(struct net_devic
 
 static struct ethtool_ops ops = {
 	.get_drvinfo = eth_get_drvinfo,
-	.get_link = eth_get_link
+	.get_link = ethtool_op_get_link,
 };
 
 static void defer_kevent(struct eth_dev *dev, int flag)


