Return-Path: <linux-kernel-owner+w=401wt.eu-S1764241AbXLMHMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764241AbXLMHMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762253AbXLMG5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:57:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55519 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762611AbXLMG5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:57:45 -0500
Date: Wed, 12 Dec 2007 22:53:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, bunk@kernel.org,
       davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 40/60] IPV4: Remove bogus ifdef mess in arp_process
Message-ID: <20071213065301.GP6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv4-remove-bogus-ifdef-mess-in-arp_process.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Adrian Bunk <bunk@kernel.org>

[IPV4]: Remove bogus ifdef mess in arp_process

[ Upstream commit: 3660019e5f96fd9a8b7d4214a96523c0bf7b676d ]

The #ifdef's in arp_process() were not only a mess, they were also wrong
in the CONFIG_NET_ETHERNET=n and (CONFIG_NETDEV_1000=y or
CONFIG_NETDEV_10000=y) cases.

Since they are not required this patch removes them.

Also removed are some #ifdef's around #include's that caused compile
errors after this change.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/arp.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -110,12 +110,8 @@
 #include <net/tcp.h>
 #include <net/sock.h>
 #include <net/arp.h>
-#if defined(CONFIG_AX25) || defined(CONFIG_AX25_MODULE)
 #include <net/ax25.h>
-#if defined(CONFIG_NETROM) || defined(CONFIG_NETROM_MODULE)
 #include <net/netrom.h>
-#endif
-#endif
 #if defined(CONFIG_ATM_CLIP) || defined(CONFIG_ATM_CLIP_MODULE)
 #include <net/atmclip.h>
 struct neigh_table *clip_tbl_hook;
@@ -729,20 +725,10 @@ static int arp_process(struct sk_buff *s
 		    htons(dev_type) != arp->ar_hrd)
 			goto out;
 		break;
-#ifdef CONFIG_NET_ETHERNET
 	case ARPHRD_ETHER:
-#endif
-#ifdef CONFIG_TR
 	case ARPHRD_IEEE802_TR:
-#endif
-#ifdef CONFIG_FDDI
 	case ARPHRD_FDDI:
-#endif
-#ifdef CONFIG_NET_FC
 	case ARPHRD_IEEE802:
-#endif
-#if defined(CONFIG_NET_ETHERNET) || defined(CONFIG_TR) || \
-    defined(CONFIG_FDDI)	 || defined(CONFIG_NET_FC)
 		/*
 		 * ETHERNET, Token Ring and Fibre Channel (which are IEEE 802
 		 * devices, according to RFC 2625) devices will accept ARP
@@ -757,21 +743,16 @@ static int arp_process(struct sk_buff *s
 		    arp->ar_pro != htons(ETH_P_IP))
 			goto out;
 		break;
-#endif
-#if defined(CONFIG_AX25) || defined(CONFIG_AX25_MODULE)
 	case ARPHRD_AX25:
 		if (arp->ar_pro != htons(AX25_P_IP) ||
 		    arp->ar_hrd != htons(ARPHRD_AX25))
 			goto out;
 		break;
-#if defined(CONFIG_NETROM) || defined(CONFIG_NETROM_MODULE)
 	case ARPHRD_NETROM:
 		if (arp->ar_pro != htons(AX25_P_IP) ||
 		    arp->ar_hrd != htons(ARPHRD_NETROM))
 			goto out;
 		break;
-#endif
-#endif
 	}
 
 	/* Understand only these message types */

-- 
