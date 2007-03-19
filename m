Return-Path: <linux-kernel-owner+w=401wt.eu-S1030599AbXCSVlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030599AbXCSVlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030611AbXCSVls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:41:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965045AbXCSVlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:41:31 -0400
Date: Mon, 19 Mar 2007 14:39:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Daniel Drake <dsd@gentoo.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Francois Romieu <romieu@fr.zoreil.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 17/31] r8169: fix a race between PCI probe and dev_open
Message-ID: <20070319213942.GS9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="r8169-fix-a-race-between-pci-probe-and-dev_open.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

Initialize the timer with the rest of the private-struct.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1369,11 +1369,7 @@ static inline void rtl8169_request_timer
 	    (tp->phy_version >= RTL_GIGA_PHY_VER_H))
 		return;
 
-	init_timer(timer);
-	timer->expires = jiffies + RTL8169_PHY_TIMEOUT;
-	timer->data = (unsigned long)(dev);
-	timer->function = rtl8169_phy_timer;
-	add_timer(timer);
+	mod_timer(timer, jiffies + RTL8169_PHY_TIMEOUT);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -1686,6 +1682,10 @@ rtl8169_init_one(struct pci_dev *pdev, c
 	tp->mmio_addr = ioaddr;
 	tp->align = rtl_cfg_info[ent->driver_data].align;
 
+	init_timer(&tp->timer);
+	tp->timer.data = (unsigned long) dev;
+	tp->timer.function = rtl8169_phy_timer;
+
 	spin_lock_init(&tp->lock);
 
 	rc = register_netdev(dev);

-- 
