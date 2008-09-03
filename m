Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbYICRm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbYICRm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbYICRmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:42:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:57305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbYICRmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:42:44 -0400
Date: Wed, 3 Sep 2008 10:26:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 29/42] net: Unbreak userspace which includes linux/mroute.h
Message-ID: <20080903172624.GD7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0010-net-Unbreak-userspace-which-includes-linux-mroute.h.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 7c19a3d280297d43ef5ff7c6b205dc208a16d3d1 ]

This essentially reverts two commits:

1) 2e8046271f68198dd37451017c1a4a2432e4ec68 ("[IPV4] MROUTE: Move PIM
   definitions to <linux/pim.h>.")

and

2) 80a9492a33dd7d852465625022d56ff76d62174d ("[IPV4] MROUTE: Adjust
   include files for user-space.")

which broke userpsace, in particular the XORP build as reported by
Jose Calhariz, the debain package maintainer for XORP.

Nothing originally in linux/mroute.h was exported to userspace
ever, but some of this stuff started to be when it was moved into
this new linux/pim.h, and that was wrong.  If we didn't provide these
definitions for 10 years we can reasonable expect that applications
defined this stuff locally or used GLIBC headers providing the
protocol definitions.  And as such the only result of this can
be conflict and userland build breakage.

The commit #1 had such a short and terse commit message, that we
cannot even know why such a move and set of new userland exports were
even made.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/Kbuild   |    1 -
 include/linux/mroute.h |   25 +++++++++++++++++++++----
 include/linux/pim.h    |   45 ---------------------------------------------
 3 files changed, 21 insertions(+), 50 deletions(-)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -293,7 +293,6 @@ unifdef-y += parport.h
 unifdef-y += patchkey.h
 unifdef-y += pci.h
 unifdef-y += personality.h
-unifdef-y += pim.h
 unifdef-y += pktcdvd.h
 unifdef-y += pmu.h
 unifdef-y += poll.h
--- a/include/linux/mroute.h
+++ b/include/linux/mroute.h
@@ -2,11 +2,7 @@
 #define __LINUX_MROUTE_H
 
 #include <linux/sockios.h>
-#include <linux/types.h>
-#ifdef __KERNEL__
 #include <linux/in.h>
-#endif
-#include <linux/pim.h>
 
 /*
  *	Based on the MROUTING 3.5 defines primarily to keep
@@ -214,6 +210,27 @@ struct mfc_cache 
 #define IGMPMSG_WHOLEPKT	3		/* For PIM Register processing */
 
 #ifdef __KERNEL__
+
+#define PIM_V1_VERSION		__constant_htonl(0x10000000)
+#define PIM_V1_REGISTER		1
+
+#define PIM_VERSION		2
+#define PIM_REGISTER		1
+
+#define PIM_NULL_REGISTER	__constant_htonl(0x40000000)
+
+/* PIMv2 register message header layout (ietf-draft-idmr-pimvsm-v2-00.ps */
+
+struct pimreghdr
+{
+	__u8	type;
+	__u8	reserved;
+	__be16	csum;
+	__be32	flags;
+};
+
+extern int pim_rcv_v1(struct sk_buff *);
+
 struct rtmsg;
 extern int ipmr_get_route(struct sk_buff *skb, struct rtmsg *rtm, int nowait);
 #endif
--- a/include/linux/pim.h
+++ /dev/null
@@ -1,45 +0,0 @@
-#ifndef __LINUX_PIM_H
-#define __LINUX_PIM_H
-
-#include <asm/byteorder.h>
-
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
-/* Message types - V1 */
-#define PIM_V1_VERSION		__constant_htonl(0x10000000)
-#define PIM_V1_REGISTER		1
-
-/* Message types - V2 */
-#define PIM_VERSION		2
-#define PIM_REGISTER		1
-
-#if defined(__KERNEL__)
-#define PIM_NULL_REGISTER	__constant_htonl(0x40000000)
-
-/* PIMv2 register message header layout (ietf-draft-idmr-pimvsm-v2-00.ps */
-struct pimreghdr
-{
-	__u8	type;
-	__u8	reserved;
-	__be16	csum;
-	__be32	flags;
-};
-
-struct sk_buff;
-extern int pim_rcv_v1(struct sk_buff *);
-#endif
-#endif

-- 
