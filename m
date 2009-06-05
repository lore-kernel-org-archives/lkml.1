Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZFEIJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZFEIJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbZFEIFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37483 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068AbZFEIFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 10/62] Blackfin: fix warnings with I/O port macros
Date: Fri,  5 Jun 2009 04:04:19 -0400
Message-Id: <1244189111-19639-11-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I/O port functions take ints, so we need to cast them up before
passing to our read/write funcs to avoid ugly messes of warnings.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/include/asm/io.h |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/blackfin/include/asm/io.h b/arch/blackfin/include/asm/io.h
index 63b2d8c..3022b5c 100644
--- a/arch/blackfin/include/asm/io.h
+++ b/arch/blackfin/include/asm/io.h
@@ -80,19 +80,22 @@ static inline unsigned int readl(const volatile void __iomem *addr)
 #define memcpy_fromio(a,b,c)	memcpy((a),(void *)(b),(c))
 #define memcpy_toio(a,b,c)	memcpy((void *)(a),(b),(c))
 
-#define inb(addr)    readb(addr)
-#define inw(addr)    readw(addr)
-#define inl(addr)    readl(addr)
-#define outb(x,addr) ((void) writeb(x,addr))
-#define outw(x,addr) ((void) writew(x,addr))
-#define outl(x,addr) ((void) writel(x,addr))
-
-#define inb_p(addr)    inb(addr)
-#define inw_p(addr)    inw(addr)
-#define inl_p(addr)    inl(addr)
-#define outb_p(x,addr) outb(x,addr)
-#define outw_p(x,addr) outw(x,addr)
-#define outl_p(x,addr) outl(x,addr)
+/* Convert "I/O port addresses" to actual addresses.  i.e. ugly casts. */
+#define __io(port) ((void *)(unsigned long)(port))
+
+#define inb(port)    readb(__io(port))
+#define inw(port)    readw(__io(port))
+#define inl(port)    readl(__io(port))
+#define outb(x,port) writeb(x,__io(port))
+#define outw(x,port) writew(x,__io(port))
+#define outl(x,port) writel(x,__io(port))
+
+#define inb_p(port)    inb(__io(port))
+#define inw_p(port)    inw(__io(port))
+#define inl_p(port)    inl(__io(port))
+#define outb_p(x,port) outb(x,__io(port))
+#define outw_p(x,port) outw(x,__io(port))
+#define outl_p(x,port) outl(x,__io(port))
 
 #define ioread8_rep(a,d,c)	readsb(a,d,c)
 #define ioread16_rep(a,d,c)	readsw(a,d,c)
-- 
1.6.3.1

