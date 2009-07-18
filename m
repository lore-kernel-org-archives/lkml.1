Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZGRPOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZGRPOI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZGRPOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:14:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:3047 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZGRPOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sh9Ixzp3zmVVore66RZX4KLig3zWzDRzGuVCTzeCCbzyYAdzVEOGH86oa1xl32sj6A
         rcg7QttIE0gn2lyDPCNO39hs1pXqocx2hFt9lQOPSFp1HiviTsTkOoCTqXsg4G5Pa0xz
         j3vsB4w3fggS1XVu03ARthVRrppkadW9Kv+GI=
Date: Sun, 19 Jul 2009 00:11:06 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH 3/4] x86: introduce set_desc_base() and set_desc_limit()
Message-ID: <20090718151105.GC11294@localhost.localdomain>
References: <20090718150853.GA11294@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090718150853.GA11294@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename set_base()/set_limit to set_desc_base()/set_desc_limit() and
rewrite them in C. These are naturally introduced by the idea of
get_desc_base()/get_desc_limit().

The conversion actually found the bug in apm_32.c: bad_bios_desc
is written at run-time, but it is defined const variable.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/include/asm/desc.h           |   13 +++++++++++++
 arch/x86/include/asm/stackprotector.h |    4 +---
 arch/x86/include/asm/system.h         |   27 ---------------------------
 arch/x86/kernel/apm_32.c              |   18 +++++++++---------
 drivers/pnp/pnpbios/bioscalls.c       |   21 +++++++++++----------
 5 files changed, 34 insertions(+), 49 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index c993e9e..e8de2f6 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -291,11 +291,24 @@ static inline unsigned long get_desc_base(const struct desc_struct *desc)
 	return desc->base0 | ((desc->base1) << 16) | ((desc->base2) << 24);
 }
 
+static inline void set_desc_base(struct desc_struct *desc, unsigned long base)
+{
+	desc->base0 = base & 0xffff;
+	desc->base1 = (base >> 16) & 0xff;
+	desc->base2 = (base >> 24) & 0xff;
+}
+
 static inline unsigned long get_desc_limit(const struct desc_struct *desc)
 {
 	return desc->limit0 | (desc->limit << 16);
 }
 
+static inline void set_desc_limit(struct desc_struct *desc, unsigned long limit)
+{
+	desc->limit0 = limit & 0xffff;
+	desc->limit = (limit >> 16) & 0xf;
+}
+
 static inline void _set_gate(int gate, unsigned type, void *addr,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index c2d742c..cdc5e0b 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -90,9 +90,7 @@ static inline void setup_stack_canary_segment(int cpu)
 	struct desc_struct desc;
 
 	desc = gdt_table[GDT_ENTRY_STACK_CANARY];
-	desc.base0 = canary & 0xffff;
-	desc.base1 = (canary >> 16) & 0xff;
-	desc.base2 = (canary >> 24) & 0xff;
+	set_desc_base(&desc, canary);
 	write_gdt_entry(gdt_table, GDT_ENTRY_STACK_CANARY, &desc, DESCTYPE_S);
 #endif
 }
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 643c59b..75c49c7 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -150,33 +150,6 @@ do {									\
 #endif
 
 #ifdef __KERNEL__
-#define _set_base(addr, base) do { unsigned long __pr; \
-__asm__ __volatile__ ("movw %%dx,%1\n\t" \
-	"rorl $16,%%edx\n\t" \
-	"movb %%dl,%2\n\t" \
-	"movb %%dh,%3" \
-	:"=&d" (__pr) \
-	:"m" (*((addr)+2)), \
-	 "m" (*((addr)+4)), \
-	 "m" (*((addr)+7)), \
-	 "0" (base) \
-	); } while (0)
-
-#define _set_limit(addr, limit) do { unsigned long __lr; \
-__asm__ __volatile__ ("movw %%dx,%1\n\t" \
-	"rorl $16,%%edx\n\t" \
-	"movb %2,%%dh\n\t" \
-	"andb $0xf0,%%dh\n\t" \
-	"orb %%dh,%%dl\n\t" \
-	"movb %%dl,%2" \
-	:"=&d" (__lr) \
-	:"m" (*(addr)), \
-	 "m" (*((addr)+6)), \
-	 "0" (limit) \
-	); } while (0)
-
-#define set_base(ldt, base) _set_base(((char *)&(ldt)) , (base))
-#define set_limit(ldt, limit) _set_limit(((char *)&(ldt)) , ((limit)-1))
 
 extern void native_load_gs_index(unsigned);
 
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 79302e9..b5e841b 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -403,7 +403,7 @@ static DECLARE_WAIT_QUEUE_HEAD(apm_waitqueue);
 static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
 static struct apm_user *user_list;
 static DEFINE_SPINLOCK(user_list_lock);
-static const struct desc_struct	bad_bios_desc = { { { 0, 0x00409200 } } };
+static struct desc_struct bad_bios_desc = { { { 0, 0x00409200 } } };
 
 static const char driver_version[] = "1.16ac";	/* no spaces */
 
@@ -2337,8 +2337,8 @@ static int __init apm_init(void)
 	 * This is for buggy BIOS's that refer to (real mode) segment 0x40
 	 * even though they are called in protected mode.
 	 */
-	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
-	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
+	set_desc_base(&bad_bios_desc, (unsigned long)__va(0x40UL << 4));
+	set_desc_limit(&bad_bios_desc, 4095 - (0x40 << 4));
 
 	/*
 	 * Set up the long jump entry point to the APM BIOS, which is called
@@ -2358,12 +2358,12 @@ static int __init apm_init(void)
 	 * code to that CPU.
 	 */
 	gdt = get_cpu_gdt_table(0);
-	set_base(gdt[APM_CS >> 3],
-		 __va((unsigned long)apm_info.bios.cseg << 4));
-	set_base(gdt[APM_CS_16 >> 3],
-		 __va((unsigned long)apm_info.bios.cseg_16 << 4));
-	set_base(gdt[APM_DS >> 3],
-		 __va((unsigned long)apm_info.bios.dseg << 4));
+	set_desc_base(&gdt[APM_CS >> 3],
+		 (unsigned long)__va((unsigned long)apm_info.bios.cseg << 4));
+	set_desc_base(&gdt[APM_CS_16 >> 3],
+		 (unsigned long)__va((unsigned long)apm_info.bios.cseg_16 << 4));
+	set_desc_base(&gdt[APM_DS >> 3],
+		 (unsigned long)__va((unsigned long)apm_info.bios.dseg << 4));
 
 	proc_create("apm", 0, NULL, &apm_file_ops);
 
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 7e6b5a3..45ad3e9 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -55,9 +55,9 @@ __asm__(".text			\n"
 
 #define Q2_SET_SEL(cpu, selname, address, size) \
 do { \
-struct desc_struct *gdt = get_cpu_gdt_table((cpu)); \
-set_base(gdt[(selname) >> 3], (u32)(address)); \
-set_limit(gdt[(selname) >> 3], size); \
+	struct desc_struct *gdt = get_cpu_gdt_table((cpu)); \
+	set_desc_base(&gdt[(selname) >> 3], (u32)(address)); \
+	set_desc_limit(&gdt[(selname) >> 3], (size) - 1); \
 } while(0)
 
 static struct desc_struct bad_bios_desc;
@@ -479,16 +479,17 @@ void pnpbios_calls_init(union pnp_bios_install_struct *header)
 	bad_bios_desc.a = 0;
 	bad_bios_desc.b = 0x00409200;
 
-	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
-	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
+	set_desc_base(&bad_bios_desc, (unsigned long)__va(0x40UL << 4));
+	set_desc_limit(&bad_bios_desc, 4095 - (0x40 << 4));
 	for_each_possible_cpu(i) {
 		struct desc_struct *gdt = get_cpu_gdt_table(i);
 		if (!gdt)
 			continue;
-		set_base(gdt[GDT_ENTRY_PNPBIOS_CS32], &pnp_bios_callfunc);
-		set_base(gdt[GDT_ENTRY_PNPBIOS_CS16],
-			 __va(header->fields.pm16cseg));
-		set_base(gdt[GDT_ENTRY_PNPBIOS_DS],
-			 __va(header->fields.pm16dseg));
+		set_desc_base(&gdt[GDT_ENTRY_PNPBIOS_CS32],
+			 (unsigned long)&pnp_bios_callfunc);
+		set_desc_base(&gdt[GDT_ENTRY_PNPBIOS_CS16],
+			 (unsigned long)__va(header->fields.pm16cseg));
+		set_desc_base(&gdt[GDT_ENTRY_PNPBIOS_DS],
+			 (unsigned long)__va(header->fields.pm16dseg));
 	}
 }
-- 
1.6.0.6

