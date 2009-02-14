Return-Path: <linux-kernel-owner+w=401wt.eu-S1761902AbZBNBLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761902AbZBNBLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:11:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761228AbZBNBBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:51 -0500
Received: from kroah.org ([198.145.64.141]:39708 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760765AbZBNBBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:48 -0500
Date: Fri, 13 Feb 2009 16:58:56 -0800
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 26/47] sungem: Soft lockup in sungem on Netra AC200 when
	switching interface up
Message-ID: <20090214005856.GA11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sungem-soft-lockup-in-sungem-on-netra-ac200-when-switching-interface-up.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ilkka Virta <itvirta@iki.fi>

[ Upstream commit 71822faa3bc0af5dbf5e333a2d085f1ed7cd809f ]

From: Ilkka Virta <itvirta@iki.fi>

In the lockup situation the driver seems to go off in an eternal storm
of interrupts right after calling request_irq(). It doesn't actually
do anything interesting in the interrupt handler. Since connecting the link
afterwards works, something later in initialization must fix this.

Looking at gem_do_start() and gem_open(), it seems that the only thing
done while opening the device after the request_irq(), is a call to
napi_enable().

I don't know what the ordering requirements are for the
initialization, but I boldly tried to move the napi_enable() call
inside gem_do_start() before the link state is checked and interrupts
subsequently enabled, and it seems to work for me. Doesn't even break
anything too obvious...

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sungem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -2205,6 +2205,8 @@ static int gem_do_start(struct net_devic
 
 	gp->running = 1;
 
+	napi_enable(&gp->napi);
+
 	if (gp->lstate == link_up) {
 		netif_carrier_on(gp->dev);
 		gem_set_link_modes(gp);
@@ -2222,6 +2224,8 @@ static int gem_do_start(struct net_devic
 		spin_lock_irqsave(&gp->lock, flags);
 		spin_lock(&gp->tx_lock);
 
+		napi_disable(&gp->napi);
+
 		gp->running =  0;
 		gem_reset(gp);
 		gem_clean_rings(gp);
@@ -2322,8 +2326,6 @@ static int gem_open(struct net_device *d
 	if (!gp->asleep)
 		rc = gem_do_start(dev);
 	gp->opened = (rc == 0);
-	if (gp->opened)
-		napi_enable(&gp->napi);
 
 	mutex_unlock(&gp->pm_mutex);
 
@@ -2460,8 +2462,6 @@ static int gem_resume(struct pci_dev *pd
 
 		/* Re-attach net device */
 		netif_device_attach(dev);
-
-		napi_enable(&gp->napi);
 	}
 
 	spin_lock_irqsave(&gp->lock, flags);

