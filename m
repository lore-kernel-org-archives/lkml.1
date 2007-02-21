Return-Path: <linux-kernel-owner+w=401wt.eu-S1751059AbXBUBip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059AbXBUBip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXBUBip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:38:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:34508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbXBUBib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:38:31 -0500
Date: Tue, 20 Feb 2007 17:37:10 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, jacmet@sunsite.dk, jeff@garzik.org
Subject: [patch 06/21] net/smc911x: match up spin lock/unlock
Message-ID: <20070221013710.GG30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-smc911x-match-up-spin-lock-unlock.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Korsgaard <jacmet@sunsite.dk>

smc911x_phy_configure's error handling unconditionally unlocks the
spinlock even if it wasn't locked. Patch fixes it.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/smc911x.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.19.4.orig/drivers/net/smc911x.c
+++ linux-2.6.19.4/drivers/net/smc911x.c
@@ -965,11 +965,11 @@ static void smc911x_phy_configure(void *
 	 * We should not be called if phy_type is zero.
 	 */
 	if (lp->phy_type == 0)
-		 goto smc911x_phy_configure_exit;
+		 goto smc911x_phy_configure_exit_nolock;
 
 	if (smc911x_phy_reset(dev, phyaddr)) {
 		printk("%s: PHY reset timed out\n", dev->name);
-		goto smc911x_phy_configure_exit;
+		goto smc911x_phy_configure_exit_nolock;
 	}
 	spin_lock_irqsave(&lp->lock, flags);
 
@@ -1038,6 +1038,7 @@ static void smc911x_phy_configure(void *
 
 smc911x_phy_configure_exit:
 	spin_unlock_irqrestore(&lp->lock, flags);
+smc911x_phy_configure_exit_nolock:
 	lp->work_pending = 0;
 }
 

--
