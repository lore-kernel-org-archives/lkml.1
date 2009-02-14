Return-Path: <linux-kernel-owner+w=401wt.eu-S1762150AbZBNBLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150AbZBNBLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZBNBBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:53 -0500
Received: from kroah.org ([198.145.64.141]:39734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753404AbZBNBBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:50 -0500
Date: Fri, 13 Feb 2009 16:59:00 -0800
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
       alan@lxorguk.ukuu.org.uk, Alex Williamson <alex.williamson@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 28/47] tun: Fix unicast filter overflow
Message-ID: <20090214005900.GC11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tun-fix-unicast-filter-overflow.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Williamson <alex.williamson@hp.com>

[ Upstream commit cfbf84fcbcda98bb91ada683a8dc8e6901a83ebd ]

Tap devices can make use of a small MAC filter set via the
TUNSETTXFILTER ioctl.  The filter has a set of exact matches
plus a hash for imperfect filtering of additional multicast
addresses.  The current code is unbalanced, adding unicast
addresses to the multicast hash, but only checking the hash
against multicast addresses.  This results in the filter
dropping unicast addresses that overflow the exact filter.
The fix is simply to disable the filter by leaving count set
to zero if we find non-multicast addresses after the exact
match table is filled.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tun.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -157,10 +157,16 @@ static int update_filter(struct tap_filt
 
 	nexact = n;
 
-	/* The rest is hashed */
+	/* Remaining multicast addresses are hashed,
+	 * unicast will leave the filter disabled. */
 	memset(filter->mask, 0, sizeof(filter->mask));
-	for (; n < uf.count; n++)
+	for (; n < uf.count; n++) {
+		if (!is_multicast_ether_addr(addr[n].u)) {
+			err = 0; /* no filter */
+			goto done;
+		}
 		addr_hash_set(filter->mask, addr[n].u);
+	}
 
 	/* For ALLMULTI just set the mask to all ones.
 	 * This overrides the mask populated above. */

