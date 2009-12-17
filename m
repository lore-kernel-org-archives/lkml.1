Return-Path: <linux-kernel-owner+w=401wt.eu-S935963AbZLQBam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935963AbZLQBam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935930AbZLQB3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:29:13 -0500
Received: from kroah.org ([198.145.64.141]:48102 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763679AbZLQBUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:49 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:06 2009
Message-Id: <20091217011606.605472719@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [66/90] sparc64: Fix overly strict range type matching for PCI devices.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 4230fa3b89ea1c413766bd411a8315a3d05aa6c7 ]

When we are trying to see if a range property entry applies
to a given address, we are overly strict about the type.

We should only allow I/O ranges for I/O addresses, and only allow
CONFIG space ranges for CONFIG space address.

However for MEM ranges, they come in 32-bit and 64-bit flavors.
And a lack of an exact match is OK if the range is 32-bit and
the address is 64-bit.  We can assign a 64-bit address properly
into a 32-bit parent range just fine.

So allow it.

Reported-by: Patrick Finnegan <pat@computer-refuge.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/of_device_64.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -104,9 +104,19 @@ static int of_bus_pci_map(u32 *addr, con
 	int i;
 
 	/* Check address type match */
-	if ((addr[0] ^ range[0]) & 0x03000000)
-		return -EINVAL;
+	if (!((addr[0] ^ range[0]) & 0x03000000))
+		goto type_match;
+
+	/* Special exception, we can map a 64-bit address into
+	 * a 32-bit range.
+	 */
+	if ((addr[0] & 0x03000000) == 0x03000000 &&
+	    (range[0] & 0x03000000) == 0x02000000)
+		goto type_match;
+
+	return -EINVAL;
 
+type_match:
 	if (of_out_of_range(addr + 1, range + 1, range + na + pna,
 			    na - 1, ns))
 		return -EINVAL;


