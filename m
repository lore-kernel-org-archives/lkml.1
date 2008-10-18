Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYJRTIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYJRTIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYJRTDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:03:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:47357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbYJRTDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:03:31 -0400
Date: Sat, 18 Oct 2008 11:34:26 -0700
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
       alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 13/17] usb gadget: cdc ethernet notification bugfix
Message-ID: <20081018183426.GN14035@suse.de>
References: <20081018182721.521723254@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-gadget-cdc-ethernet-notification-bugfix.patch"
In-Reply-To: <20081018183334.GA14035@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Brownell <dbrownell@users.sourceforge.net>

commit 29bac7b7661bbbdbbd32bc1e6cedca22f260da7f upstream

Bugfix for the new CDC Ethernet code:  as part of activating the
network interface's USB link, make sure its link management code
knows whether the interface is open or not.

Without this fix, the link won't work right when it's brought up
before the link is active ... because the initial notification it
sends will have the wrong link state (down, not up).  Makes it
hard to bridge these links (on the host side), among other things.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/u_ether.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -873,6 +873,13 @@ struct net_device *gether_connect(struct
 		spin_lock(&dev->lock);
 		dev->port_usb = link;
 		link->ioport = dev;
+		if (netif_running(dev->net)) {
+			if (link->open)
+				link->open(link);
+		} else {
+			if (link->close)
+				link->close(link);
+		}
 		spin_unlock(&dev->lock);
 
 		netif_carrier_on(dev->net);

-- 
