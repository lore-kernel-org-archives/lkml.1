Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbYEMUSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbYEMUSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762090AbYEMUOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:14:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:38241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762081AbYEMUOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:14:33 -0400
Date: Tue, 13 May 2008 13:12:03 -0700
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
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 14/37] macvlan: Fix memleak on device removal/crash on
	module removal
Message-ID: <20080513201203.GO31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="macvlan-fix-memleak-on-device-removal-crash-on-module-removal.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Patrick McHardy <kaber@trash.net>

[ Upstream commit: 7312096454b6cd71267eaa3d0efb408e449e9ff3 ]

As noticed by Ben Greear, macvlan crashes the kernel when unloading the
module. The reason is that it tries to clean up the macvlan_port pointer
on the macvlan device itself instead of the underlying device. A non-NULL
pointer is taken as indication that the macvlan_handle_frame_hook is
valid, when receiving the next packet on the underlying device it tries
to call the NULL hook and crashes.

Clean up the macvlan_port on the correct device to fix this.

Signed-off-by; Patrick McHardy <kaber@trash.net>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/macvlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -450,7 +450,7 @@ static void macvlan_dellink(struct net_d
 	unregister_netdevice(dev);
 
 	if (list_empty(&port->vlans))
-		macvlan_port_destroy(dev);
+		macvlan_port_destroy(port->dev);
 }
 
 static struct rtnl_link_ops macvlan_link_ops __read_mostly = {

-- 
