Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZGTMCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZGTMCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZGTMC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:02:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:45425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbZGTMC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:02:27 -0400
Date: Mon, 20 Jul 2009 12:01:54 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <20090718151219.GD11294@localhost.localdomain>
References: <20090718151219.GD11294@localhost.localdomain>
Subject: [tip:x86/asm] x86: Introduce GDT_ENTRY_INIT()
Message-ID: <tip-d520da1173abd1f918b7e690220e14ba0fc56cfc@git.kernel.org>
Git-Commit-ID: d520da1173abd1f918b7e690220e14ba0fc56cfc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 20 Jul 2009 12:01:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d520da1173abd1f918b7e690220e14ba0fc56cfc
Gitweb:     http://git.kernel.org/tip/d520da1173abd1f918b7e690220e14ba0fc56cfc
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Sun, 19 Jul 2009 00:12:20 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 19 Jul 2009 18:27:53 +0200

x86: Introduce GDT_ENTRY_INIT()

GDT_ENTRY_INIT is static initializer of desc_struct.

We already have similar macro GDT_ENTRY() but it's static
initializer for u64 and it cannot be used for desc_struct.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <20090718151219.GD11294@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
