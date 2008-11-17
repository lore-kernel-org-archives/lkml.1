Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbYKQXm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYKQXm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYKQXms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:42:48 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:39904 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYKQXmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:42:47 -0500
Message-ID: <49220144.2010005@cosmosbay.com>
Date: Tue, 18 Nov 2008 00:41:56 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: eth_type_trans(): Re: [Bug #11308] tbench regression on each
 kernel release from 2.6.22 -&gt; 2.6.28
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117212657.GH12020@elte.hu> <4921E4B0.7010507@cosmosbay.com>
In-Reply-To: <4921E4B0.7010507@cosmosbay.com>
Content-Type: multipart/mixed;
 boundary="------------010901030205040709000206"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 18 Nov 2008 00:42:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010901030205040709000206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Eric Dumazet a =E9crit :
>=20
> But seeing your disassembly, I can see compare_ether_addr() is not inli=
ned.
>=20
> This sucks.
>=20
> /**
> * compare_ether_addr - Compare two Ethernet addresses
> * @addr1: Pointer to a six-byte array containing the Ethernet address
> * @addr2: Pointer other six-byte array containing the Ethernet address
> *
> * Compare two ethernet addresses, returns 0 if equal
> */
> static inline unsigned compare_ether_addr(const u8 *addr1, const u8 *ad=
dr2)
> {
>        const u16 *a =3D (const u16 *) addr1;
>        const u16 *b =3D (const u16 *) addr2;
>=20
>        BUILD_BUG_ON(ETH_ALEN !=3D 6);
>        return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2])) !=3D 0;
> }
>=20
> On my machine/compiler, it is inlined, that makes a big difference.

old gcc compiler... OK understood...

>=20
> c0420750 <eth_type_trans>: /* eth_type_trans total:  14417  0.4101 */
>=20
>=20

Could you try this patch Ingo ?

Thanks

[PATCH] net: eth_type_trans() should be a leaf function

In old days, eth_type_trans() was a leaf function. It is not anymore the =
case.

eth_type_trans() is a critical network function, called for each incoming=
 packet.

We should make sure it is not calling functions, especially trivial ones.=


1) Adds an __always_inline to compare_ether_addr() : This one was created=
 to be faster
   than memcmp(). It really should be faster (and inlined)

2) Hand code skb_put() call in eth_type_trans()

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/etherdevice.h |    2 +-
 net/ethernet/eth.c          |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--------------010901030205040709000206
Content-Type: text/plain;
 name="eth_type_trans_speedup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="eth_type_trans_speedup.patch"

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 25d62e6..94af6a7 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -128,7 +128,7 @@ static inline void random_ether_addr(u8 *addr)
  *
  * Compare two ethernet addresses, returns 0 if equal
  */
-static inline unsigned compare_ether_addr(const u8 *addr1, const u8 *addr2)
+static __always_inline unsigned compare_ether_addr(const u8 *addr1, const u8 *addr2)
 {
 	const u16 *a = (const u16 *) addr1;
 	const u16 *b = (const u16 *) addr2;
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index b9d85af..30b60b2 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -162,7 +162,12 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
 
 	skb->dev = dev;
 	skb_reset_mac_header(skb);
-	skb_pull(skb, ETH_HLEN);
+	/*
+	 * Hand coded skb_pull(skb, ETH_HLEN) to avoid a function call
+	 */
+	if (likely(skb->len >= ETH_HLEN))
+		__skb_pull(skb, ETH_HLEN);
+
 	eth = eth_hdr(skb);
 
 	if (is_multicast_ether_addr(eth->h_dest)) {

--------------010901030205040709000206--
