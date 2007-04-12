Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbXDLUaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbXDLUaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXDLUaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:30:06 -0400
Received: from knorkaan.xs4all.nl ([82.93.149.176]:43982 "EHLO
	knorkaan.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbXDLUaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:30:04 -0400
X-Greylist: delayed 2399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 16:30:03 EDT
Date: Thu, 12 Apr 2007 21:50:00 +0200 (CEST)
From: Jerome Borsboom <j.borsboom@erasmusmc.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] allow VLAN interface on top of bridge interface
Message-ID: <Pine.LNX.4.64.0704122136330.3170@knorkaan.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a VLAN interface is created on top of a bridge interface and 
netfilter is enabled to see the bridged packets, the packets can be 
corrupted when passing through the netfilter code. This is caused by the 
VLAN driver not setting the 'protocol' and 'nh' members of the sk_buff 
structure. In general, this is no problem as the VLAN interface is mostly 
connected to a physical ethernet interface which does not use the 
'protocol' and 'nh' members. For a bridge interface, however, these 
members do matter.

Signed-off-by: Jerome Borsboom <j.borsboom@erasmusmc.nl>


--- linux-2.6.20/net/8021q/vlan_dev.c 2007-02-04 19:44:54.000000000 +0100 
+++ linux-2.6.20/net/8021q/vlan_dev.c 2007-04-12 21:12:17.000000000 +0200 
@@ -380,6 +380,9 @@
  		} else {
  			vhdr->h_vlan_encapsulated_proto = htons(len);
  		}
+
+		skb->protocol = htons(ETH_P_8021Q);
+		skb->nh.raw = skb->data;
  	}

  	/* Before delegating work to the lower layer, enter our MAC-address */
