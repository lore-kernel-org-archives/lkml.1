Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068Ab0AZXop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0AZXop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012Ab0AZXob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:44:31 -0500
Received: from kroah.org ([198.145.64.141]:35557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab0AZXo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:28 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:33 2010
Message-Id: <20100126233933.448270279@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:35:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Wilder <dwilder@us.ibm.com>, Roland Dreier <rolandd@cisco.com>
Subject: [95/98] IPoIB: Clear ipoib_neigh.dgid in ipoib_neigh_alloc()
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David J. Wilder <dwilder@us.ibm.com>

commit 0cd4d0fd9b0a4e10c091fc6316d1bf92885dcd9c upstream.

IPoIB can miss a change in destination GID under some conditions.  The
problem is caused when ipoib_neigh->dgid contains a stale address.
The fix is to set ipoib_neigh->dgid to zero in ipoib_neigh_alloc().

This can happen when a system using bonding on its IPoIB interfaces
has switched its active interface from interface A to B and back to A.
The system that fails over will not correctly processes the 2nd
address change, as described below.

When an address has changed neighbor->ha is updated with the new
address.  Each neighbor has an associated ipoib_neigh.
ipoib_neigh->dgid also holds a copy of the remote node's hardware
address.  When an address changes neighbor->ha is updated by the
network layer (arp code) with the new address.  IPoIB detects this
change in ipoib_start_xmit() by comparing neighbor->ha with
ipoib_neigh->dgid.  The bug is that ipoib_neigh->dgid may already
contain the new address (A) thus the change from B to A is missed by
ipoib.  Here is the sequence of events:

    ipoib_neigh->dgid = A  and  neighbor->ha = A

The address is switched to B (the first switch)

    neighbor->ha = B

The change is seen in ipoib_start_xmit() -- neighbor->ha !=
ipoib_neigh->dgid so ipoib_neigh is released, and a new one is
allocated.

The allocator may return the same chunk of memory that was just
released, therefore ipoib_neigh->dgid still contains A at this point.

ipoib_neigh->dgid should be updated in neigh_add_path(), but if the
following conditions are true dgid is not updated:

        1) __path_find() returns a path
        2) path->ah is NULL

The remote system now switches from address B to A, neighbor->ha is
updated to A.

Now we have again : ipoib_neigh->dgid = A  and  neighbor->ha = A

Since the addresses are the same ipoib won't process the change in
address.  Fix this by zeroing out the dgid field when allocating a new
struct ipoib_neigh.

Signed-off-by: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -884,6 +884,7 @@ struct ipoib_neigh *ipoib_neigh_alloc(st
 
 	neigh->neighbour = neighbour;
 	neigh->dev = dev;
+	memset(&neigh->dgid.raw, 0, sizeof (union ib_gid));
 	*to_ipoib_neigh(neighbour) = neigh;
 	skb_queue_head_init(&neigh->queue);
 	ipoib_cm_set(neigh, NULL);


