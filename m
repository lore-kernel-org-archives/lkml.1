Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYAWGoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYAWGoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 01:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYAWGof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 01:44:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49484
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753728AbYAWGoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 01:44:34 -0500
Date: Tue, 22 Jan 2008 22:44:42 -0800 (PST)
Message-Id: <20080122.224442.142676954.davem@davemloft.net>
To: kernel@nn7.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: 24rc8: unregister_netdevice: waiting for ... to become free.
 Usage count = 1?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1201070541.22958.53.camel@localhost>
References: <1201070541.22958.53.camel@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Soeren Sonnenburg <kernel@nn7.de>
Date: Wed, 23 Jan 2008 07:42:21 +0100

> Dear all,
> 
> since some 2.6.24rc version I suddenly experience such messages on
> console when trying to shutdown a vpn connection:
> 
> unregister_netdevice: waiting for tun0 to become free. Usage count = 1
> 
> or when removing an usb wlan dongle (although it was ifconfig wlan0
> down'd before)

Current GIT already has a fix for this, attached below:

[NEIGH]: Revert 'Fix race between neigh_parms_release and neightbl_fill_parms'

Commit 9cd40029423701c376391da59d2c6469672b4bed (Fix race between
neigh_parms_release and neightbl_fill_parms) introduced device
reference counting regressions for several people, see:

	http://bugzilla.kernel.org/show_bug.cgi?id=9778

for example.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index cc8a2f1..29b8ee4 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1316,6 +1316,8 @@ void neigh_parms_release(struct neigh_table *tbl, struct neigh_parms *parms)
 			*p = parms->next;
 			parms->dead = 1;
 			write_unlock_bh(&tbl->lock);
+			if (parms->dev)
+				dev_put(parms->dev);
 			call_rcu(&parms->rcu_head, neigh_rcu_free_parms);
 			return;
 		}
@@ -1326,8 +1328,6 @@ void neigh_parms_release(struct neigh_table *tbl, struct neigh_parms *parms)
 
 void neigh_parms_destroy(struct neigh_parms *parms)
 {
-	if (parms->dev)
-		dev_put(parms->dev);
 	kfree(parms);
 }
 
