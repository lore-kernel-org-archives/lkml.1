Return-Path: <linux-kernel-owner+w=401wt.eu-S934937AbYBVVuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937AbYBVVuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbYBVVnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:43:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:60518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933614AbYBVVno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:44 -0500
Date: Fri, 22 Feb 2008 13:40:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Jeff Mahoney <jeffm@suse.com>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 14/23] via-velocity: dont oops on MTU change (resend)
Message-ID: <20080222214040.GO8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="via-velocity-don-t-oops-on-mtu-change.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Stephen Hemminger <shemminger@linux-foundation.org>

mainline: 48f6b053613b62fed7a2fe3255e5568260a8d615

The VIA veloicty driver needs the following to allow changing MTU when down.
The buffer size needs to be computed when device is brought up, not when
device is initialized.  This also fixes a bug where the buffer size was
computed differently on change_mtu versus initial setting.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/via-velocity.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -1075,6 +1075,9 @@ static int velocity_init_rd_ring(struct 
 	int ret = -ENOMEM;
 	unsigned int rsize = sizeof(struct velocity_rd_info) *
 					vptr->options.numrx;
+	int mtu = vptr->dev->mtu;
+
+	vptr->rx_buf_sz = (mtu <= ETH_DATA_LEN) ? PKT_BUF_SZ : mtu + 32;
 
 	vptr->rd_info = kmalloc(rsize, GFP_KERNEL);
 	if(vptr->rd_info == NULL)
@@ -1733,8 +1736,6 @@ static int velocity_open(struct net_devi
 	struct velocity_info *vptr = netdev_priv(dev);
 	int ret;
 
-	vptr->rx_buf_sz = (dev->mtu <= 1504 ? PKT_BUF_SZ : dev->mtu + 32);
-
 	ret = velocity_init_rings(vptr);
 	if (ret < 0)
 		goto out;
@@ -1813,12 +1814,6 @@ static int velocity_change_mtu(struct ne
 		velocity_free_rd_ring(vptr);
 
 		dev->mtu = new_mtu;
-		if (new_mtu > 8192)
-			vptr->rx_buf_sz = 9 * 1024;
-		else if (new_mtu > 4096)
-			vptr->rx_buf_sz = 8192;
-		else
-			vptr->rx_buf_sz = 4 * 1024;
 
 		ret = velocity_init_rd_ring(vptr);
 		if (ret < 0)

-- 
