Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYH2U43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYH2U43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYH2U4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:56:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42711
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbYH2U4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:56:20 -0400
Date: Fri, 29 Aug 2008 13:56:14 -0700 (PDT)
Message-Id: <20080829.135614.87412482.davem@davemloft.net>
To: jose.calhariz@tagus.ist.utl.pt
Cc: yoshfuji@linux-ipv6.org, linux-kernel@vger.kernel.org,
       494223@bugs.debian.org
Subject: Re: Definition of PIM_REGISTER in pim.h, with more information
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080829134319.GA8665@copernico.tagus.ist.utl.pt>
References: <20080829134319.GA8665@copernico.tagus.ist.utl.pt>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jose Calhariz <jose.calhariz@tagus.ist.utl.pt>
Date: Fri, 29 Aug 2008 14:43:20 +0100

> I am sending this email again because I have more information.

Thanks for your report.

Yoshifuji-san, nothing in linux/pim.h should be exported to userspace.
The previous location, linux/mroute.h, EXPLICITLY __KERNEL__ protected
these defines and datastructures.

When you created linux/pim.h, everything you moved there was __KERNEL__
protected in linux/mroute.h, and you should not have changed that.

Applications perhaps were having to do their own defines, and looking
at XORP this seems to be what applications have indeed been doing.

Guess what that means?

It means that if we start to export this stuff after having not done
so for nearly 10 years, it's going to break compilation of userspace
and we therefore cannot do this.

In fact, both of the changesets involving linux/pim.h are broken:

	commit 80a9492a33dd7d852465625022d56ff76d62174d
	Author: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
	Date:   Thu Apr 3 09:22:52 2008 +0900

	    [IPV4] MROUTE: Adjust include files for user-space.

It should have been clear to you once you hit this problem and had
to add such horrible hacks that this was simply not going to work.

Now we export this "struct pim" thing exactly because applications
cannot include netinet/in.h and linux/in.h at the same time.

Nothing in the kernel uses "struct pim", it's purely a protocol
definition for userspace, rather than a kernel side API.  We should
never do this, either get it added to some glibc provided header or
define these things inside of the application itself.

I am very unhappy about this.  And I don't even have the patience to
wait for you to fix this up, I'm going to just rip out everything
that is unnecessarily exported here and get things back to how they
were before your changes.

net: Unbreak userspace which includes linux/mroute.h

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
---
 include/linux/Kbuild   |    1 -
 include/linux/mroute.h |   25 +++++++++++++++++++++----
 include/linux/pim.h    |   45 ---------------------------------------------
 3 files changed, 21 insertions(+), 50 deletions(-)
 delete mode 100644 include/linux/pim.h

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
index 07112ee..6befa7d 100644
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
@@ -240,6 +236,27 @@ struct mfc_cache
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
diff --git a/include/linux/pim.h b/include/linux/pim.h
deleted file mode 100644
index 236ffd3..0000000
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
1.5.6.5.GIT

