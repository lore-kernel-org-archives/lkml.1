Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbYAOX6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbYAOX6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbYAOXtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:49:45 -0500
Received: from s9.math.TU-Berlin.DE ([130.149.11.90]:55331 "EHLO
	mail-pool.math.tu-berlin.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758095AbYAOXtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:49:43 -0500
X-Greylist: delayed 2633 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 18:49:43 EST
Date: Wed, 16 Jan 2008 00:05:44 +0100
From: Jan Christoph Nordholz <hesso@pool.math.tu-berlin.de>
To: shemminger@linux-foundation.org, kaber@trash.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] net_device refcnt bug when NFQUEUEing bridged packets
Message-ID: <20080115230544.GA21214@pool.math.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I came across the following bug a few weeks ago (which still applies to
2.6.24-rc7):

Packets that are to be sent out over a bridge device are skb_clone()d in
br_loop() before traversing the appropriate (FORWARD/OUTPUT) NF chain. 
The copies made by skb_clone() share their nf_bridge metadata with the
original, which is no problem usually.
If however one or more packets of a br_loop() run end up in a NFQUEUE,
their shared nf_bridge metadata causes trouble when they are about to be
reinjected: nf_reinject() decrements the net_device refcounts that were
previously upped when queueing the packet in __nf_queue(), but as
skb->nf_bridge->physoutdev points to the same device for all these
packets, most (if not all) of them will affect the wrong refcnt.

(I originally encountered the bug on a Xen host because the hypervisor
refused to shutdown a virtual device with non-zero refcount... but it is
perfectly reproducible with a standard kernel, too, although it was a
bit more tedious to create a test scenario, involving a couple of UMLs.)

I'd suggest to make a real copy of the nf_bridge member in br_loop() if
CONFIG_BRIDGE_NETFILTER is defined - I've attached a patch that illus-
trates how to fix the bug (and the machine I've found the bug on is
running a kernel with this patch since weeks and has not had any
refcount anomalies since), but I admit it is ugly, returning the reference
acquired by __nf_copy() and then copying manually...

Please tell me where that logic should really go (skbuff.h? br_netfilter.c?)
so I can wrap up a final and CodingStyle-conformant version, or feel free
to simply apply a modified version.


Regards,

Jan


Signed-off-by: Jan Christoph Nordholz <hesso@pool.math.tu-berlin.de>
---
diff -Naur linux-2.6.24-rc7/ linux/
--- linux-2.6.24-rc7/net/bridge/br_forward.c
+++ linux/net/bridge/br_forward.c
@@ -120,6 +120,20 @@
					return;
				}
 
+#ifdef CONFIG_BRIDGE_NETFILTER
+				if (skb->nf_bridge) {
+					nf_bridge_put(skb2->nf_bridge);
+					if ((skb2->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC)) == NULL) {
+						br->statistics.tx_dropped++;
+						kfree_skb(skb2);
+						kfree_skb(skb);
+						return;
+					}
+					memcpy(skb2->nf_bridge, skb->nf_bridge, sizeof(struct nf_bridge_info));
+					atomic_set(&(skb2->nf_bridge->use), 1);
+				}
+#endif
+
				__packet_hook(prev, skb2);
			}
