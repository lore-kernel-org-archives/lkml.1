Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbYKRIfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbYKRIfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYKRIfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:35:42 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:40755 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYKRIfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:35:41 -0500
Message-ID: <49227E37.6070100@cosmosbay.com>
Date: Tue, 18 Nov 2008 09:35:03 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: eth_type_trans(): Re: [Bug #11308] tbench regression on each
 kernel release from 2.6.22 -&gt; 2.6.28
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117212657.GH12020@elte.hu> <4921E4B0.7010507@cosmosbay.com> <49220144.2010005@cosmosbay.com> <alpine.LFD.2.00.0811171557310.18283@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811171557310.18283@nehalem.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------040503030806040700050101"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 18 Nov 2008 09:35:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040503030806040700050101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Linus Torvalds a =E9crit :
>=20
> On Tue, 18 Nov 2008, Eric Dumazet wrote:
>>> *
>>> * Compare two ethernet addresses, returns 0 if equal
>>> */
>>> static inline unsigned compare_ether_addr(const u8 *addr1, const u8 *=
addr2)
>>> {
>>>        const u16 *a =3D (const u16 *) addr1;
>>>        const u16 *b =3D (const u16 *) addr2;
>>>
>>>        BUILD_BUG_ON(ETH_ALEN !=3D 6);
>>>        return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2])) !=3D 0;=

>=20
> Btw, at least on some Intel CPU's, it would be faster to do this as a=20
> 32-bit xor and a 16-bit xor. And if we can know that there is always 2 =

> bytes at the end (because of how the thing was allocated), it's faster =

> still to do it as a 64-bit xor and a mask.
>=20
> And that's true even if the addresses are only 2-byte aligned.
>=20

Yes, this is allowed, we always have at least 8 bytes for both arrays,
when called from eth_type_trans() at least.

I tried this idea and got nice assembly on 32 bits:

 158:   33 82 38 01 00 00       xor    0x138(%edx),%eax
 15e:   33 8a 34 01 00 00       xor    0x134(%edx),%ecx
 164:   c1 e0 10                shl    $0x10,%eax
 167:   09 c1                   or     %eax,%ecx
 169:   74 0b                   je     176 <eth_type_trans+0x87>

And very nice assembly on 64 bits of course (one xor, one shl)

About alignments, we have aligned addr2, but not addr1

Nice oprofile improvement in eth_type_trans(), 0.17 % instead of 0.41 %

opreport -l vmlinux | grep eth_type_trans
38797     0.1710  eth_type_trans



[PATCH] eth: Declare an optimized compare_ether_addr_64bits() function

Linus mentioned we could try to perform long word operations, even
on potentially unaligned addresses, on x86 at least.

This patch implements a compare_ether_addr_64bits() function,
that handles the case of x86 cpus, but might be used on other arches as w=
ell.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---

--------------040503030806040700050101
Content-Type: text/plain;
 name="compare_ether_addr_64bits.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="compare_ether_addr_64bits.patch"

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 25d62e6..ee0df09 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -136,6 +136,47 @@ static inline unsigned compare_ether_addr(const u8 *addr1, const u8 *addr2)
 	BUILD_BUG_ON(ETH_ALEN != 6);
 	return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2])) != 0;
 }
+
+static inline unsigned long zap_last_2bytes(unsigned long value)
+{
+#ifdef __BIG_ENDIAN
+	return value >> 16;
+#else
+	return value << 16;
+#endif
+}
+
+/**
+ * compare_ether_addr_64bits - Compare two Ethernet addresses
+ * @addr1: Pointer to an array of 8 bytes
+ * @addr2: Pointer to an other array of 8 bytes
+ *
+ * Compare two ethernet addresses, returns 0 if equal.
+ * Same result than "memcmp(addr1, addr2, ETH_ALEN)" but without conditional
+ * branches, and possibly long word memory accesses on CPU allowing cheap
+ * unaligned memory reads.
+ * arrays = { byte1, byte2, byte3, byte4, byte6, byte7, pad1, pad2}
+ * 
+ * Please note that alignment of addr1 & addr2 is only guaranted to be 16 bits.
+ */
+
+static inline unsigned compare_ether_addr_64bits(const u8 addr1[6+2],
+						 const u8 addr2[6+2])
+{
+#if defined(CONFIG_X86)
+	unsigned long fold = *(const unsigned long *)addr1 ^
+			     *(const unsigned long *)addr2;
+
+	if (sizeof(fold) == 8)
+		return zap_last_2bytes(fold) != 0;
+
+	fold |= zap_last_2bytes(*(const unsigned long *)(addr1 + 4) ^
+				*(const unsigned long *)(addr2 + 4));
+	return fold != 0;
+#else
+	return compare_ether_addr(addr1, addr2);
+#endif
+}
 #endif	/* __KERNEL__ */
 
 #endif	/* _LINUX_ETHERDEVICE_H */
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index b9d85af..dcfeb9b 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -166,7 +166,7 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
 	eth = eth_hdr(skb);
 
 	if (is_multicast_ether_addr(eth->h_dest)) {
-		if (!compare_ether_addr(eth->h_dest, dev->broadcast))
+		if (!compare_ether_addr_64bits(eth->h_dest, dev->broadcast))
 			skb->pkt_type = PACKET_BROADCAST;
 		else
 			skb->pkt_type = PACKET_MULTICAST;
@@ -181,7 +181,7 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
 	 */
 
 	else if (1 /*dev->flags&IFF_PROMISC */ ) {
-		if (unlikely(compare_ether_addr(eth->h_dest, dev->dev_addr)))
+		if (unlikely(compare_ether_addr_64bits(eth->h_dest, dev->dev_addr)))
 			skb->pkt_type = PACKET_OTHERHOST;
 	}
 

--------------040503030806040700050101--
