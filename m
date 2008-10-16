Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYJPSFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYJPSFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbYJPSBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:01:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbYJPSBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:01:15 -0400
Date: Thu, 16 Oct 2008 10:56:52 -0700
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
       alan@lxorguk.ukuu.org.uk, Matthew Wilcox <willy@linux.intel.com>,
       Jay Cliburn <jacliburn@bellsouth.net>, Jeff Garzik <jgarzik@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 14/14] netdrvr: atl1e: Dont take the mdio_lock in
	atl1e_probe
Message-ID: <20081016175652.GO12850@suse.de>
References: <20081016174814.734527827@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netdrvr-atl1e-don-t-take-the-mdio_lock-in-atl1e_probe.patch"
In-Reply-To: <20081016175525.GA12850@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Matthew Wilcox <matthew@wil.cx>

commit f382a0a8e9403c6d7f8b2cfa21e41fefb5d0c9bd upstream

Lockdep warns about the mdio_lock taken with interrupts enabled then later
taken from interrupt context.  Initially, I considered changing these
to spin_lock_irq/spin_unlock_irq, but then I looked at atl1e_phy_init()
and saw that it calls msleep().  Sleeping while holding a spinlock is
not allowed either.

In the probe path, we haven't registered the interrupt handler, so
it can't poke at this card yet.  It's before we call register_netdev(),
so I don't think any other threads can reach this card either.  If I'm
right, we don't need a spinlock at all.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1e/atl1e_main.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -2390,9 +2390,7 @@ static int __devinit atl1e_probe(struct 
 	}
 
 	/* Init GPHY as early as possible due to power saving issue  */
-	spin_lock(&adapter->mdio_lock);
 	atl1e_phy_init(&adapter->hw);
-	spin_unlock(&adapter->mdio_lock);
 	/* reset the controller to
 	 * put the device in a known good starting state */
 	err = atl1e_reset_hw(&adapter->hw);

-- 
