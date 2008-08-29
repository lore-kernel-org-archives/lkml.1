Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbYH2Vim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbYH2Vim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYH2Vif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:38:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49456
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbYH2Vie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:38:34 -0400
Date: Fri, 29 Aug 2008 14:38:29 -0700 (PDT)
Message-Id: <20080829.143829.39803986.davem@davemloft.net>
To: jose.calhariz@tagus.ist.utl.pt
Cc: yoshfuji@linux-ipv6.org, linux-kernel@vger.kernel.org,
       494223@bugs.debian.org
Subject: Re: Definition of PIM_REGISTER in pim.h, with more information
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080829.135614.87412482.davem@davemloft.net>
References: <20080829134319.GA8665@copernico.tagus.ist.utl.pt>
	<20080829.135614.87412482.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 29 Aug 2008 13:56:14 -0700 (PDT)

> net: Unbreak userspace which includes linux/mroute.h

Actually, now that I can see how this linux/pim.h thing
is used by both linux/mroute.h and linux/mroute6.h I have
decided to fix the problem in a different way.

net: Unbreak userspace usage of linux/mroute.h

Nothing in linux/pim.h should be exported to userspace.

This should fix the XORP build failure reported by
Jose Calhariz, the debain package maintainer.

Nothing originally in linux/mroute.h was exported to userspace
ever, but some of this stuff started to be when it was moved into
this new linux/pim.h, and that was wrong.  If we didn't provide these
definitions for 10 years we can reasonably expect that applications
defined this stuff locally or used GLIBC headers providing the
protocol definitions.  And as such the only result of this can
be conflict and userland build breakage.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/linux/Kbuild    |    1 -
 include/linux/mroute.h  |    2 +-
 include/linux/mroute6.h |    1 +
 include/linux/pim.h     |   18 ------------------
 4 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 7d97067..5939125 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -297,7 +297,6 @@ unifdef-y += parport.h
 unifdef-y += patchkey.h
 unifdef-y += pci.h
 unifdef-y += personality.h
-unifdef-y += pim.h
 unifdef-y += pktcdvd.h
 unifdef-y += pmu.h
 unifdef-y += poll.h
diff --git a/include/linux/mroute.h b/include/linux/mroute.h
index 07112ee..8a45569 100644
--- a/include/linux/mroute.h
+++ b/include/linux/mroute.h
@@ -6,7 +6,6 @@
 #ifdef __KERNEL__
 #include <linux/in.h>
 #endif
-#include <linux/pim.h>
 
 /*
  *	Based on the MROUTING 3.5 defines primarily to keep
@@ -130,6 +129,7 @@ struct igmpmsg
  */
 
 #ifdef __KERNEL__
+#include <linux/pim.h>
 #include <net/sock.h>
 
 #ifdef CONFIG_IP_MROUTE
diff --git a/include/linux/mroute6.h b/include/linux/mroute6.h
index 5cf5047..6f4c180 100644
--- a/include/linux/mroute6.h
+++ b/include/linux/mroute6.h
@@ -115,6 +115,7 @@ struct sioc_mif_req6
 
 #ifdef __KERNEL__
 
+#include <linux/pim.h>
 #include <linux/skbuff.h>	/* for struct sk_buff_head */
 
 #ifdef CONFIG_IPV6_MROUTE
diff --git a/include/linux/pim.h b/include/linux/pim.h
index 236ffd3..1ba0661 100644
--- a/include/linux/pim.h
+++ b/include/linux/pim.h
@@ -3,22 +3,6 @@
 
 #include <asm/byteorder.h>
 
-#ifndef __KERNEL__
-struct pim {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	__u8	pim_type:4,		/* PIM message type */
-		pim_ver:4;		/* PIM version */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	__u8	pim_ver:4;		/* PIM version */
-		pim_type:4;		/* PIM message type */
-#endif
-	__u8	pim_rsv;		/* Reserved */
-	__be16	pim_cksum;		/* Checksum */
-};
-
-#define PIM_MINLEN		8
-#endif
-
 /* Message types - V1 */
 #define PIM_V1_VERSION		__constant_htonl(0x10000000)
 #define PIM_V1_REGISTER		1
@@ -27,7 +11,6 @@ struct pim {
 #define PIM_VERSION		2
 #define PIM_REGISTER		1
 
-#if defined(__KERNEL__)
 #define PIM_NULL_REGISTER	__constant_htonl(0x40000000)
 
 /* PIMv2 register message header layout (ietf-draft-idmr-pimvsm-v2-00.ps */
@@ -42,4 +25,3 @@ struct pimreghdr
 struct sk_buff;
 extern int pim_rcv_v1(struct sk_buff *);
 #endif
-#endif
-- 
1.5.6.5.GIT

