Return-Path: <linux-kernel-owner+w=401wt.eu-S1761587AbXKNEsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587AbXKNEsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXKNEsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:48:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:43406 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbXKNEsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:48:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:x-mimeole;
        b=gGLtE77jRbdck0KKvDXop6D4IOIpuxFm8y9d9g4H59q2viQRzW796YLhAFO6EdeYp/kG3Q5DoKLDYn9ZWSNoIOt+HZ9BxJu0sizahgXiUkzZvSVAxwak2mDUj+lyJ9MkWAZkM7zXSKDZCouLUIEKqGP0Kgb76OiJc02ptcYc4xE=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "'Kok, Auke'" <auke-jan.h.kok@intel.com>,
       "'Patrick McHardy'" <kaber@trash.net>
Cc: "'Herbert Xu'" <herbert@gondor.apana.org.au>,
       "'David Miller'" <davem@davemloft.net>, <w@1wt.eu>,
       <cfriesen@nortel.com>, <netdev@vger.kernel.org>,
       <djohnson+linux-kernel@sw.starentnetworks.com>,
       <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sourceforge.net>
Subject: RE: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous mode
Date: Wed, 14 Nov 2007 13:47:30 +0900
Message-ID: <000001c82679$796d1770$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcgmdK4eZYsnHK6ZRTSqPgaYyECxJA==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/14, Kok, Auke <auke-jan.h.kok@intel.com>:
> Patrick McHardy wrote:
> > Kok, Auke wrote:
> >> Patrick McHardy wrote:
> >>
> >>> I already posted a patch for this, not sure what happened to it.
> >>> Auke, any news on merging the secondary unicast address support?
> >>
> >> I dropped the ball on that one. Care to resend it and send me one for
> >> e1000e as well?
> >
> > Patch for e1000 attached.
> >
> > Does e1000e also work with PCI cards if I add the proper IDs?
> > Otherwise I could only send an untested patch.
> 
> 
> Johnwoo,
> 
> your patch unfortunately does not apply after patrick's unicast patch,
> 
> also, ich8lan support is removed from e1000 in the e1000 version in
> jgarzik/netdev-2.6 #upstream as planned (moved over to e1000e!).
> 
> Can you resend your patch so that it applies to jgarzik/netdev-2.6 #upstream with
> Patrick's patch applied? That would help a lot. And possibly do the e1000e patch
> as well :)
> 

This is a patch for the jgarzik/netdev-2.6 #upstream with Patrick's one was applied.
But the ich8lan stuff was not removed at this patch.
I'll work e1000e too :-)

Thanks.
Joonwoo

[E1000]: Disable vlan hw accel when promiscuous mode

Even though netdevice is in the promiscuous mode, we should receive all of ingress packets.
This disable the vlan filtering feature when a vlan hw accel configured e1000 device goes into promiscuous mode.
This make packets visible to sniffers though it's not vlan id of itself.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

---
 drivers/net/e1000/e1000_main.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 5fd5f51..edf2ced 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -2425,7 +2425,7 @@ e1000_set_rx_mode(struct net_device *netdev)
 	struct e1000_hw *hw = &adapter->hw;
 	struct dev_addr_list *uc_ptr;
 	struct dev_addr_list *mc_ptr;
-	uint32_t rctl;
+	uint32_t rctl, ctrl;
 	uint32_t hash_value;
 	int i, rar_entries = E1000_RAR_ENTRIES;
 	int mta_reg_count = (hw->mac_type == e1000_ich8lan) ?
@@ -2442,13 +2442,23 @@ e1000_set_rx_mode(struct net_device *netdev)
 	/* Check for Promiscuous and All Multicast modes */
 
 	rctl = E1000_READ_REG(hw, RCTL);
+	ctrl = E1000_READ_REG(hw, CTRL);
 
 	if (netdev->flags & IFF_PROMISC) {
 		rctl |= (E1000_RCTL_UPE | E1000_RCTL_MPE);
-	} else if (netdev->flags & IFF_ALLMULTI) {
-		rctl |= E1000_RCTL_MPE;
+		if (adapter->hw.mac_type != e1000_ich8lan) {
+			if (ctrl & E1000_CTRL_VME)
+				rctl &= ~E1000_RCTL_VFE;
+		}
 	} else {
-		rctl &= ~E1000_RCTL_MPE;
+		if (adapter->hw.mac_type != e1000_ich8lan) {
+			if (ctrl & E1000_CTRL_VME)
+				rctl |= E1000_RCTL_VFE;
+		} else if (netdev->flags & IFF_ALLMULTI) {
+			rctl |= E1000_RCTL_MPE;
+		} else {
+			rctl &= ~E1000_RCTL_MPE;
+		}
 	}
 
 	uc_ptr = NULL;
@@ -4967,7 +4977,10 @@ e1000_vlan_rx_register(struct net_device *netdev, struct vlan_group *grp)
 		if (adapter->hw.mac_type != e1000_ich8lan) {
 			/* enable VLAN receive filtering */
 			rctl = E1000_READ_REG(&adapter->hw, RCTL);
-			rctl |= E1000_RCTL_VFE;
+			if (netdev->flags & IFF_PROMISC)
+				rctl &= ~E1000_RCTL_VFE;
+			else
+				rctl |= E1000_RCTL_VFE;
 			rctl &= ~E1000_RCTL_CFIEN;
 			E1000_WRITE_REG(&adapter->hw, RCTL, rctl);
 			e1000_update_mng_vlan(adapter);
---

