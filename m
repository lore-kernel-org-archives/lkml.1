Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbXHTUBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbXHTUBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXHTUBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:01:00 -0400
Received: from web53812.mail.re2.yahoo.com ([206.190.39.55]:25706 "HELO
	web53812.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753674AbXHTUA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:00:59 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2007 16:00:59 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=VWkjSidxDruI+yHazIOC88omoHfTnMgxA6O4Fn3ZHqFIprh3ezeA6SVkG7REz1LlMUEKnY14Aiive/2R6RFerhIrQSLEta1SlluFkVZ8Z8jWVdQ5ML0ATyy4l8W343NO/QV87lI/wcIx+9mNJioI8qXCloIyzLsoLgWjg38AZrc=;
X-YMail-OSG: QhvdOHoVM1lK4TzeATPNao48k4Oia5YL8WjylzbF2hR60ONBMCCgb1PWFKufeKNOM6GcX9Z30mMNayQjm5t7eqItuFhcPjHih.NpmK2cPZAk9n8n.uCI3wjhR31JGmrpqf8JiMtN3x7zTA--
Date: Mon, 20 Aug 2007 12:54:17 -0700 (PDT)
From: K Naru <squat_rack@yahoo.com>
Subject: [Patch 2.6.22.2 ,2nd try] : ./drivers/net/via-rhine.c: Offload checksum handling to VT6105M
To: rl@hellgate.ch
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <517544.547.qm@web53812.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kim Naru (squat_rack@yahoo.com)

Added support to offload TCP/UDP/IP checksum to the
VIA Technologies VT6105M chip.
Firstly, let the stack know this chip is capable of
doing its own checksum(IPV4 only).
Secondly offload checksum to VT6105M, if necessary. 


Verbose Mode:

#1. Define 3 bits(18,19,20) in Transmit Descriptor 1
of chip, which affect checksum processing.
The prefix(TDES1) for the 3 variables is the short
name for Transmit Descriptior 1.
#2. In rhine_init_one(), if pci_rev >=  VT6105M then
set  NETIF_F_IP_CSUM(see skbuff.h for details).
#3. In rhine_start_tx() if NETIF_F_IP_CSUM is set AND
the stack requires a checksum then
set either bit 19(UDP),20(TCP) AND bit 18(IP).

Note : The numbered items above(i.e.#1,#2,#3) denote
pseudo code.

This patch was developed and tested on Imedia
linux-2.6.20 under a PC-Engines Alix System board
(www.pcengines.ch/alix.htm). It was tested(compilation
only) on linux-2.6.22.2. The minor code change between
2.6.20 and 2.6.22 is the use of ip_hdr() in 2.26.22.

In 2.6.20 :
                struct iphdr *ip = skb->nh.iph;
In 2.6.22 :
                const struct iphdr *ip = ip_hdr(skb);

Testing:


ttcp,netperf ftp and top  where used. There appears to
be a small CPU utilization gain. Throughput results 
where more inconclusive.

The data sheet used to get information is 'VT6105M
Data Sheet, Revision 1.63  June21,2006'.

Signed-off-by: Kim Naru (squat_rack@yahoo.com)

---


--- ./drivers/net/via-rhine.c.orig      2007-08-09
14:28:15.000000000 -0700
+++ ./drivers/net/via-rhine.c   2007-08-20
04:29:43.000000000 -0700
@@ -95,6 +95,8 @@ static const int
multicast_filter_limit 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
+#include <linux/in.h>
+#include <linux/ip.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/mii.h>
@@ -343,6 +345,9 @@ struct tx_desc {
 
 /* Initial value for tx_desc.desc_length, Buffer size
goes to bits 0-10 */
 #define TXDESC         0x00e08000
+#define TDES1_TCPCK    0x00100000  /* Bit 20,
Transmit Desc 1  */
+#define TDES1_UDPCK    0x00080000  /* Bit 19,
Transmit Desc 1  */     
+#define TDES1_IPCK     0x00040000  /* Bit 18,
Transmit Desc 1  */     
 
 enum rx_status_bits {
        RxOK=0x8000, RxWholePkt=0x0300, RxErr=0x008F
@@ -788,6 +793,9 @@ static int __devinit
rhine_init_one(stru
        if (rp->quirks & rqRhineI)
                dev->features |=
NETIF_F_SG|NETIF_F_HW_CSUM;
 
+       if (pci_rev >=  VT6105M)    
+               dev->features |= NETIF_F_IP_CSUM;   /*
chip does checksum */
+
        /* dev->name not defined before
register_netdev()! */
        rc = register_netdev(dev);
        if (rc)
@@ -1262,6 +1270,22 @@ static int
rhine_start_tx(struct sk_buff
 
        /* lock eth irq */
        spin_lock_irq(&rp->lock);
+
+       if ((dev->features & NETIF_F_IP_CSUM) && 
+           (skb->ip_summed == CHECKSUM_PARTIAL)) {
+
+               const struct iphdr *ip = ip_hdr(skb);
+
+               /* offload checksum to chip. */
+
+               if (ip->protocol == IPPROTO_TCP)
+                       rp->tx_ring[entry].desc_length
|= TDES1_TCPCK;
+               else if (ip->protocol == IPPROTO_UDP)
+                       rp->tx_ring[entry].desc_length
|=  TDES1_UDPCK;
+               rp->tx_ring[entry].desc_length |= 
TDES1_IPCK;
+
+       }
+
        wmb();
        rp->tx_ring[entry].tx_status =
cpu_to_le32(DescOwn);
        wmb();



       
____________________________________________________________________________________
Looking for a deal? Find great prices on flights and hotels with Yahoo! FareChase.
http://farechase.yahoo.com/
