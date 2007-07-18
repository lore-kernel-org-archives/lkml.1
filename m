Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbXGRNCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbXGRNCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbXGRNCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:02:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbXGRNCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:02:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Work around a possible compiler bug
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 18 Jul 2007 14:02:33 +0100
Message-ID: <20070718130233.12173.76080.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Work around a possible bug in the FRV compiler.

What appears to be happening is that gcc resolves the __builtin_constant_p()
in kmalloc() to true, but then fails to reduce the therefore constant
conditions in the if-statements it guards to constant results.

When compiling with -O2 or -Os, one single spurious error crops up in
cpuup_callback() in mm/slab.c.  This can be avoided by making the memsize
variable const.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/Makefile |    2 +-
 mm/slab.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/frv/Makefile b/arch/frv/Makefile
index 038e3a8..9bf7345 100644
--- a/arch/frv/Makefile
+++ b/arch/frv/Makefile
@@ -88,7 +88,7 @@ ASFLAGS		+= -mno-fdpic
 # make sure the .S files get compiled with debug info
 # and disable optimisations that are unhelpful whilst debugging
 ifdef CONFIG_DEBUG_INFO
-CFLAGS		+= -O1
+#CFLAGS		+= -O1
 AFLAGS		+= -Wa,--gdwarf2
 ASFLAGS		+= -Wa,--gdwarf2
 endif
diff --git a/mm/slab.c b/mm/slab.c
index 96d30ee..88bc633 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1163,7 +1163,7 @@ static int __cpuinit cpuup_callback(struct notifier_block *nfb,
 	struct kmem_cache *cachep;
 	struct kmem_list3 *l3 = NULL;
 	int node = cpu_to_node(cpu);
-	int memsize = sizeof(struct kmem_list3);
+	const int memsize = sizeof(struct kmem_list3);
 
 	switch (action) {
 	case CPU_LOCK_ACQUIRE:

