Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZGRPPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZGRPPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZGRPPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:15:21 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:60933 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbZGRPPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lqIxHjIiMsXl/vtFqrIP6Is1cMzscuIP5CW8Pciij8xwtEAn6G7EsBOISq3Y2VFnXb
         C1xc18cfWCYw0oxMwUl6Yw+MTuGQ4IH4lkVAaFWIa9Kr4Bu3Ly3Fd6hrVM/9S+na8tw7
         XQkmOUFbys4bcmOgTF3BRed7Zh6m4o2bMmV84=
Date: Sun, 19 Jul 2009 00:12:20 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH 4/4] x86: introduce GDT_ENTRY_INIT()
Message-ID: <20090718151219.GD11294@localhost.localdomain>
References: <20090718150853.GA11294@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090718150853.GA11294@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GDT_ENTRY_INIT is static initializer of desc_struct.

We already have similar macro GDT_ENTRY() but it's static
initializer for u64 and it cannot be used for desc_struct.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/include/asm/desc_defs.h      |    6 +++++
 arch/x86/include/asm/lguest.h         |    5 ++-
 arch/x86/include/asm/stackprotector.h |    2 +-
 arch/x86/kernel/apm_32.c              |    2 +-
 arch/x86/kernel/cpu/common.c          |   40 ++++++++++++++++----------------
 drivers/pnp/pnpbios/bioscalls.c       |    5 +---
 6 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/desc_defs.h b/arch/x86/include/asm/desc_defs.h
index a6adefa..9d66848 100644
--- a/arch/x86/include/asm/desc_defs.h
+++ b/arch/x86/include/asm/desc_defs.h
@@ -34,6 +34,12 @@ struct desc_struct {
 	};
 } __attribute__((packed));
 
+#define GDT_ENTRY_INIT(flags, base, limit) { { { \
+		.a = ((limit) & 0xffff) | (((base) & 0xffff) << 16), \
+		.b = (((base) & 0xff0000) >> 16) | (((flags) & 0xf0ff) << 8) | \
+			((limit) & 0xf0000) | ((base) & 0xff000000), \
+	} } }
+
 enum {
 	GATE_INTERRUPT = 0xE,
 	GATE_TRAP = 0xF,
diff --git a/arch/x86/include/asm/lguest.h b/arch/x86/include/asm/lguest.h
index 313389c..94cd698 100644
--- a/arch/x86/include/asm/lguest.h
+++ b/arch/x86/include/asm/lguest.h
@@ -91,8 +91,9 @@ static inline void lguest_set_ts(void)
 }
 
 /* Full 4G segment descriptors, suitable for CS and DS. */
-#define FULL_EXEC_SEGMENT ((struct desc_struct){ { {0x0000ffff, 0x00cf9b00} } })
-#define FULL_SEGMENT ((struct desc_struct){ { {0x0000ffff, 0x00cf9300} } })
+#define FULL_EXEC_SEGMENT \
+	((struct desc_struct)GDT_ENTRY_INIT(0xc09b, 0, 0xfffff))
+#define FULL_SEGMENT ((struct desc_struct)GDT_ENTRY_INIT(0xc093, 0, 0xfffff))
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index cdc5e0b..44efdff 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -48,7 +48,7 @@
  * head_32 for boot CPU and setup_per_cpu_areas() for others.
  */
 #define GDT_STACK_CANARY_INIT						\
-	[GDT_ENTRY_STACK_CANARY] = { { { 0x00000018, 0x00409000 } } },
+	[GDT_ENTRY_STACK_CANARY] = GDT_ENTRY_INIT(0x4090, 0, 0x18),
 
 /*
  * Initialize the stackprotector canary value.
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index b5e841b..febb2da 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -403,7 +403,7 @@ static DECLARE_WAIT_QUEUE_HEAD(apm_waitqueue);
 static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
 static struct apm_user *user_list;
 static DEFINE_SPINLOCK(user_list_lock);
-static struct desc_struct bad_bios_desc = { { { 0, 0x00409200 } } };
+static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092, 0, 0);
 
 static const char driver_version[] = "1.16ac";	/* no spaces */
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f1961c0..8c9bc28 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -71,45 +71,45 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	 * TLS descriptors are currently at a different place compared to i386.
 	 * Hopefully nobody expects them at a fixed place (Wine?)
 	 */
-	[GDT_ENTRY_KERNEL32_CS]		= { { { 0x0000ffff, 0x00cf9b00 } } },
-	[GDT_ENTRY_KERNEL_CS]		= { { { 0x0000ffff, 0x00af9b00 } } },
-	[GDT_ENTRY_KERNEL_DS]		= { { { 0x0000ffff, 0x00cf9300 } } },
-	[GDT_ENTRY_DEFAULT_USER32_CS]	= { { { 0x0000ffff, 0x00cffb00 } } },
-	[GDT_ENTRY_DEFAULT_USER_DS]	= { { { 0x0000ffff, 0x00cff300 } } },
-	[GDT_ENTRY_DEFAULT_USER_CS]	= { { { 0x0000ffff, 0x00affb00 } } },
+	[GDT_ENTRY_KERNEL32_CS]		= GDT_ENTRY_INIT(0xc09b, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_CS]		= GDT_ENTRY_INIT(0xa09b, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc093, 0, 0xfffff),
+	[GDT_ENTRY_DEFAULT_USER32_CS]	= GDT_ENTRY_INIT(0xc0fb, 0, 0xfffff),
+	[GDT_ENTRY_DEFAULT_USER_DS]	= GDT_ENTRY_INIT(0xc0f3, 0, 0xfffff),
+	[GDT_ENTRY_DEFAULT_USER_CS]	= GDT_ENTRY_INIT(0xa0fb, 0, 0xfffff),
 #else
-	[GDT_ENTRY_KERNEL_CS]		= { { { 0x0000ffff, 0x00cf9a00 } } },
-	[GDT_ENTRY_KERNEL_DS]		= { { { 0x0000ffff, 0x00cf9200 } } },
-	[GDT_ENTRY_DEFAULT_USER_CS]	= { { { 0x0000ffff, 0x00cffa00 } } },
-	[GDT_ENTRY_DEFAULT_USER_DS]	= { { { 0x0000ffff, 0x00cff200 } } },
+	[GDT_ENTRY_KERNEL_CS]		= GDT_ENTRY_INIT(0xc09a, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
+	[GDT_ENTRY_DEFAULT_USER_CS]	= GDT_ENTRY_INIT(0xc0fa, 0, 0xfffff),
+	[GDT_ENTRY_DEFAULT_USER_DS]	= GDT_ENTRY_INIT(0xc0f2, 0, 0xfffff),
 	/*
 	 * Segments used for calling PnP BIOS have byte granularity.
 	 * They code segments and data segments have fixed 64k limits,
 	 * the transfer segment sizes are set at run time.
 	 */
 	/* 32-bit code */
-	[GDT_ENTRY_PNPBIOS_CS32]	= { { { 0x0000ffff, 0x00409a00 } } },
+	[GDT_ENTRY_PNPBIOS_CS32]	= GDT_ENTRY_INIT(0x409a, 0, 0xffff),
 	/* 16-bit code */
-	[GDT_ENTRY_PNPBIOS_CS16]	= { { { 0x0000ffff, 0x00009a00 } } },
+	[GDT_ENTRY_PNPBIOS_CS16]	= GDT_ENTRY_INIT(0x009a, 0, 0xffff),
 	/* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_DS]		= { { { 0x0000ffff, 0x00009200 } } },
+	[GDT_ENTRY_PNPBIOS_DS]		= GDT_ENTRY_INIT(0x0092, 0, 0xffff),
 	/* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_TS1]		= { { { 0x00000000, 0x00009200 } } },
+	[GDT_ENTRY_PNPBIOS_TS1]		= GDT_ENTRY_INIT(0x0092, 0, 0),
 	/* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_TS2]		= { { { 0x00000000, 0x00009200 } } },
+	[GDT_ENTRY_PNPBIOS_TS2]		= GDT_ENTRY_INIT(0x0092, 0, 0),
 	/*
 	 * The APM segments have byte granularity and their bases
 	 * are set at run time.  All have 64k limits.
 	 */
 	/* 32-bit code */
-	[GDT_ENTRY_APMBIOS_BASE]	= { { { 0x0000ffff, 0x00409a00 } } },
+	[GDT_ENTRY_APMBIOS_BASE]	= GDT_ENTRY_INIT(0x409a, 0, 0xffff),
 	/* 16-bit code */
-	[GDT_ENTRY_APMBIOS_BASE+1]	= { { { 0x0000ffff, 0x00009a00 } } },
+	[GDT_ENTRY_APMBIOS_BASE+1]	= GDT_ENTRY_INIT(0x009a, 0, 0xffff),
 	/* data */
-	[GDT_ENTRY_APMBIOS_BASE+2]	= { { { 0x0000ffff, 0x00409200 } } },
+	[GDT_ENTRY_APMBIOS_BASE+2]	= GDT_ENTRY_INIT(0x409a, 0, 0xffff),
 
-	[GDT_ENTRY_ESPFIX_SS]		= { { { 0x0000ffff, 0x00cf9200 } } },
-	[GDT_ENTRY_PERCPU]		= { { { 0x0000ffff, 0x00cf9200 } } },
+	[GDT_ENTRY_ESPFIX_SS]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
+	[GDT_ENTRY_PERCPU]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
 	GDT_STACK_CANARY_INIT
 #endif
 } };
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 45ad3e9..bd035e3 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -60,7 +60,7 @@ do { \
 	set_desc_limit(&gdt[(selname) >> 3], (size) - 1); \
 } while(0)
 
-static struct desc_struct bad_bios_desc;
+static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092, 0, 0);
 
 /*
  * At some point we want to use this stack frame pointer to unwind
@@ -476,9 +476,6 @@ void pnpbios_calls_init(union pnp_bios_install_struct *header)
 	pnp_bios_callpoint.offset = header->fields.pm16offset;
 	pnp_bios_callpoint.segment = PNP_CS16;
 
-	bad_bios_desc.a = 0;
-	bad_bios_desc.b = 0x00409200;
-
 	set_desc_base(&bad_bios_desc, (unsigned long)__va(0x40UL << 4));
 	set_desc_limit(&bad_bios_desc, 4095 - (0x40 << 4));
 	for_each_possible_cpu(i) {
-- 
1.6.0.6

