Return-Path: <linux-kernel-owner+w=401wt.eu-S1765712AbZGABMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765712AbZGABMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761588AbZGAAfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:43 -0400
Received: from kroah.org ([198.145.64.141]:60630 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761437AbZGAAfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:40 2009
Message-Id: <20090701002440.077312404@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Prabhanjan Sarnaik <sarnaik@marvell.com>,
       Lennert Buytenhek <buytenh@marvell.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 087/108] mv643xx_eth: fix unicast filter programming in promiscuous mode
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=mv643xx_eth-fix-unicast-filter-programming-in-promiscuous-mode.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Prabhanjan Sarnaik <sarnaik@marvell.com>

commit 6877f54e6a3326c99aaf84b7bff6a3019da0b847 upstream.

The Unicast Promiscious Mode (UPM) bit in the mv643xx_eth port
configuration register doesn't do exactly what its name would suggest:
setting this bit merely enables reception of all unicast frames with a
destination address that differs from our local MAC address in bits
[47:4].  In particular, it doesn't have any effect on unicast frames
with a destination address that matches our MAC address in bits [47:4]
-- these will still be tested against the 16-entry unicast address
filter table.

Therefore, if the interface is set to promiscuous mode, just setting
the unicast promiscuous bit isn't enough -- we need to set all filter
bits in the unicast filter table to 1 as well.

Reported-by: Sachin Sanap <ssanap@marvell.com>
Signed-off-by: Prabhanjan Sarnaik <sarnaik@marvell.com>
Tested-by: Siddarth Gore <gores@marvell.com>
Tested-by: Mahavir Jain <mjain@marvell.com>
Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/mv643xx_eth.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -1751,12 +1751,12 @@ static void mv643xx_eth_program_unicast_
 
 	uc_addr_set(mp, dev->dev_addr);
 
-	port_config = rdlp(mp, PORT_CONFIG);
+	port_config = rdlp(mp, PORT_CONFIG) & ~UNICAST_PROMISCUOUS_MODE;
+
 	nibbles = uc_addr_filter_mask(dev);
 	if (!nibbles) {
 		port_config |= UNICAST_PROMISCUOUS_MODE;
-		wrlp(mp, PORT_CONFIG, port_config);
-		return;
+		nibbles = 0xffff;
 	}
 
 	for (i = 0; i < 16; i += 4) {
@@ -1777,7 +1777,6 @@ static void mv643xx_eth_program_unicast_
 		wrl(mp, off, v);
 	}
 
-	port_config &= ~UNICAST_PROMISCUOUS_MODE;
 	wrlp(mp, PORT_CONFIG, port_config);
 }
 


