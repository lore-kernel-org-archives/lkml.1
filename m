Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYH1Scc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYH1Scc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYH1ScY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:32:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:14868 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYH1ScX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=rGJUixnz6/rTrtMadpz8+ilp2iNHhoPCmEKPi6zofob+oh6oNwiiwPbFTeIhys+yXF
         QO9K9qBeuEOlM34XcBCWe+f92UTVxDbClJAGSYNQkvyEfRncYXO7BHYhh/Rn4sQCUobm
         /ucqF4LygNiM3jFNSTzQ3gUiK40Z7Vt6VB4YA=
Date: Thu, 28 Aug 2008 20:32:23 +0200
To: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] bitfields API
Message-ID: <20080828183223.GA30781@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

kmemcheck is the kernel patch that detects use of uninitialized memory.

kmemcheck reports eagerly, that is, any load of uninitialized memory
will be reported, even though the bits in question will be thrown away
later (before they are used in making a decision).

One problem that we have encountered (which generates a false positive
report) is that of bitfield accesses. In particular, whenever a bit of
a bitfield is set (or cleared), the whole byte may be loaded before the
specific bit is toggled. If the bitfield has not been accessed prior to
this, it will of course load the uninitialized byte and report this to
the user.

One solution to the problem is to tell the compiler that the memory
location in question is in fact uninitialized. This means that the
compiler can optimize out the initial load (since it will be unused in
either case), and no warning will be given by kmemcheck.

One way to tell this to the compiler is to set all the members of the
bitfield at once. We could do this unconditionally, although it adds
some overhead on certain architectures, or we can do it for certain
architectures only. My proposal is the attached patch -- a bitfields
"API". Please see the patch description for a thorough explanation.

(Please note that the patches do nothing unless the architecture is
explicit about wanting the functionality. On i386, the second patch in
the series would actually save 7 bytes, while on sparc it would take
about 48 bytes _more_.)

(The alternative to the patch is to explicitly initialize all the
fields [including any leftover "padding" fields that must also be
present] to zero at the same time, before copying in the new values.
This seems a little excessive to me, and I believe that a single
bitfield_begin_init() is neater and harder to break than an explicit
[and seemingly meaningless] list of bitfield member initializations).

So:

How do you feel about this patch? It's all about making kmemcheck more
useful... and not much else. Does it have any chance of entering the
kernel along with kmemcheck (when/if that happens)?

Thanks in advance.


Vegard

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-bitfields-add-bitfields-API.patch"

>From ef0d12868cacb41ed13705fcf28d35fd96d284a8 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Wed, 27 Aug 2008 18:37:16 +0200
Subject: [PATCH] bitfields: add bitfields API

It turns out that there is an inherent conflict between the way GCC
encodes bitfield operations and the way kmemcheck detects uses of
uninitialized memory; since bitfields span one or more bytes,
accessing only a single bit may generate a load of the whole byte.
This happens regardless of whether we actually want to preserve the
contents of the rest of the bitfield or not.

The solution to the problem is to initialize all the fields at once,
which means that GCC can now optimize out the initial load. This can
actually even save a few bytes on certain architectures, although
this is not the main purpose of the patch. On other architectures,
the generated assembly code will be slightly longer; therefore, the
patch should do nothing in those cases.

This new header defines one macro for defining bitfields,
DEFINE_BITFIELD, and one macro for annotating the places where the
bitfield is being initialized, bitfield_begin_init. See the next
patch in the series for an example of how to use these macros.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/bitfield.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/bitfield.h

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
new file mode 100644
index 0000000..2d02ba3
--- /dev/null
+++ b/include/linux/bitfield.h
@@ -0,0 +1,26 @@
+#ifndef LINUX_BITFIELD_H
+#define LINUX_BITFIELD_H
+
+#define DEFINE_BITFIELD(type, name, fields...)	\
+	union {					\
+		struct {			\
+			type _fields;		\
+		} name;				\
+		struct {			\
+			type fields;		\
+		};				\
+	};
+
+/*
+ * NOTE: This macro should NOT be used to initialize the bitfield! Its
+ * purpose is to inform the compiler that the bitfield is currently
+ * uninitialized and that the other bits do not have to be preserved on
+ * subsequent changes to the bitfield.
+ */
+#ifdef CONFIG_ARCH_WANT_BITFIELD_INITIALIZERS
+#define bitfield_begin_init(name) ((name)._fields = 0)
+#else
+#define bitfield_begin_init(name)
+#endif
+
+#endif
-- 
1.5.5.1


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-net-use-bitfields-API-in-skbuff.patch"

>From 39caa17f8bce166a69d9e49643ecb79db95b02f4 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Wed, 27 Aug 2008 18:44:29 +0200
Subject: [PATCH] net: use bitfields API in skbuff

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/skbuff.h |    6 ++++--
 net/core/skbuff.c      |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9099237..35fe08d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -14,6 +14,7 @@
 #ifndef _LINUX_SKBUFF_H
 #define _LINUX_SKBUFF_H
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/time.h>
@@ -285,11 +286,12 @@ struct sk_buff {
 		};
 	};
 	__u32			priority;
-	__u8			local_df:1,
+	DEFINE_BITFIELD(__u8,	flags1,
+				local_df:1,
 				cloned:1,
 				ip_summed:2,
 				nohdr:1,
-				nfctinfo:3;
+				nfctinfo:3);
 	__u8			pkt_type:3,
 				fclone:2,
 				ipvs_property:1,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ca1ccdf..1a2505b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -36,6 +36,7 @@
  *	The functions in this file will not compile correctly with gcc 2.4.x
  */
 
+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -438,6 +439,7 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	memcpy(new->cb, old->cb, sizeof(old->cb));
 	new->csum_start		= old->csum_start;
 	new->csum_offset	= old->csum_offset;
+	bitfield_begin_init(new->flags1);
 	new->local_df		= old->local_df;
 	new->pkt_type		= old->pkt_type;
 	new->ip_summed		= old->ip_summed;
-- 
1.5.5.1


--ibTvN161/egqYuK8--
