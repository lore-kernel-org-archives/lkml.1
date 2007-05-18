Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbXERLuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbXERLuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXERLuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:50:05 -0400
Received: from aun.it.uu.se ([130.238.12.36]:59614 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbXERLuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:50:04 -0400
Date: Fri, 18 May 2007 13:49:59 +0200 (MEST)
Message-Id: <200705181149.l4IBnxaT018994@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.22-rc1] net/core/skbuff.c gcc-3.2.3 compilation error
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend. First message reached netdev but not linux-kernel due to Cc: typo]

Compiling 2.6.22-rc1 with gcc-3.2.3 for i486 fails with:

  gcc -m32 -Wp,-MD,net/core/.skbuff.o.d  -nostdinc -isystem /home/mikpe/pkgs/linux-x86/gnu/lib/gcc-lib/i486-pc-linux-gnu/3.2.3/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -O2 -pipe -msoft-float -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=4  -march=i486 -ffreestanding -maccumulate-outgoing-args -DCONFIG_AS_CFI=1  -Iinclude/asm-i386/mach-default -fomit-frame-pointer       -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(skbuff)"  -D"KBUILD_MODNAME=KBUILD_STR(skbuff)" -c -o net/core/skbuff.o net/core/skbuff.c
net/core/skbuff.c:648:1: directives may not be used inside a macro argument
net/core/skbuff.c:647:39: unterminated argument list invoking macro "memcpy"
net/core/skbuff.c: In function `pskb_expand_head':
net/core/skbuff.c:651: `memcpy' undeclared (first use in this function)
net/core/skbuff.c:651: (Each undeclared identifier is reported only once
net/core/skbuff.c:651: for each function it appears in.)
net/core/skbuff.c:651: syntax error before "skb"
make[2]: *** [net/core/skbuff.o] Error 1
make[1]: *** [net/core] Error 2
make: *** [net] Error 2

The patch below implements a simple workaround which is to
clone the offending memcpy() call and specialise it for the
two different scenarios.

Other workarounds are of course possible: e.g. bind the varying
parameter in a local variable, or use a macro or inline function
to perform the varying computation.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

--- linux-2.6.22-rc1/net/core/skbuff.c.~1~	2007-05-17 21:34:18.000000000 +0200
+++ linux-2.6.22-rc1/net/core/skbuff.c	2007-05-18 01:28:16.000000000 +0200
@@ -644,11 +644,10 @@
 
 	/* Copy only real data... and, alas, header. This should be
 	 * optimized for the cases when header is void. */
-	memcpy(data + nhead, skb->head,
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
-		skb->tail);
+	memcpy(data + nhead, skb->head, skb->tail);
 #else
-		skb->tail - skb->head);
+	memcpy(data + nhead, skb->head, skb->tail - skb->head);
 #endif
 	memcpy(data + size, skb_end_pointer(skb),
 	       sizeof(struct skb_shared_info));
