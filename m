Return-Path: <linux-kernel-owner+w=401wt.eu-S936007AbZLQBdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936007AbZLQBdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935999AbZLQBch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:32:37 -0500
Received: from kroah.org ([198.145.64.141]:48058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763658AbZLQBUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:41 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:05 2009
Message-Id: <20091217011605.421274510@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [57/90] vlan: Fix register_vlan_dev() error path
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 6b863d1d3239eff0f45c2e6e672f5b56db828db0 ]

In case register_netdevice() returns an error, and a new vlan_group
was allocated and inserted in vlan_group_hash[] we call
vlan_group_free() without deleting group from hash table. Future
lookups can give infinite loops or crashes.

We must delete the vlan_group using RCU safe procedure.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/8021q/vlan.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -287,8 +287,11 @@ out_uninit_applicant:
 	if (ngrp)
 		vlan_gvrp_uninit_applicant(real_dev);
 out_free_group:
-	if (ngrp)
-		vlan_group_free(ngrp);
+	if (ngrp) {
+		hlist_del_rcu(&ngrp->hlist);
+		/* Free the group, after all cpu's are done. */
+		call_rcu(&ngrp->rcu, vlan_rcu_free);
+	}
 	return err;
 }
 


