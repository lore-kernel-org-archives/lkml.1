Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093Ab0AKHmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0AKHmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 02:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930Ab0AKHmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 02:42:09 -0500
Received: from ozlabs.org ([203.10.76.45]:42914 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab0AKHmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 02:42:08 -0500
Date: Mon, 11 Jan 2010 18:42:05 +1100
From: Stephen Rothwell <Stephen@Rothwell.id.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>
Subject: linux-next: net tree build failure
Message-Id: <20100111184205.8d53fe5b.Stephen@Rothwell.id.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (powerpc_allnoconfig) failed like this:

lib/lib.a(vsprintf.o): In function `pointer':
vsprintf.c:(.text+0x21ba): undefined reference to `byte_rev_table'
vsprintf.c:(.text+0x21c2): undefined reference to `byte_rev_table'

Caused by commit bc7259a2ce764ea16200eb9e53f6e136e918d065
("lib/vsprintf.c: Add %pMF to format FDDI bit reversed MAC addresses")
from the net tree.

I applied the following fixup patch (and can carry it for a while):
(BTW after this patch, CONFIG_BITREVERSE appears to not be used anywhere
except where is is selected in Kconfig files.)

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 11 Jan 2010 18:37:16 +1100
Subject: [PATCH] net: vsprintf now depends on the byte_rev_table

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 lib/Makefile |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index 4b78894..e21f9f9 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -7,7 +7,7 @@ ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
 endif
 
-lib-y := ctype.o string.o vsprintf.o cmdline.o \
+lib-y := ctype.o string.o vsprintf.o cmdline.o bitrev.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
@@ -50,7 +50,6 @@ ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
   lib-y += dec_and_lock.o
 endif
 
-obj-$(CONFIG_BITREVERSE) += bitrev.o
 obj-$(CONFIG_RATIONAL)	+= rational.o
 obj-$(CONFIG_CRC_CCITT)	+= crc-ccitt.o
 obj-$(CONFIG_CRC16)	+= crc16.o
-- 
1.6.5.7


-- 
Cheers,
Stephen Rothwell                    Stephen@Rothwell.id.au
