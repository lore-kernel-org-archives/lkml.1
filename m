Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZCJC5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZCJC5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 22:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZCJC5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 22:57:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:23741 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbZCJC5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 22:57:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,333,1233561600"; 
   d="asc'?scan'208";a="393069179"
Subject: [PATCH -v2 3/3] kexec x86_64: Add kexec jump support for x86_64
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HXPnC5cVat1RmYWvBMZP"
Date: Tue, 10 Mar 2009 10:57:16 +0800
Message-Id: <1236653836.24215.133.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HXPnC5cVat1RmYWvBMZP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patch add kexec jump support for x86_64. More information about
kexec jump can be found in corresponding x86_32 support patch.

v2:

- rebased on x86 git
- fix code style

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/Kconfig                     |    2=20
 arch/x86/include/asm/kexec.h         |   13 +-
 arch/x86/kernel/machine_kexec_64.c   |   42 +++++++-
 arch/x86/kernel/relocate_kernel_64.S |  177 ++++++++++++++++++++++++++++--=
-----
 arch/x86/kernel/vmlinux_64.lds.S     |    7 +
 5 files changed, 197 insertions(+), 44 deletions(-)

--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -13,6 +13,7 @@
 #include <linux/numa.h>
 #include <linux/ftrace.h>
 #include <linux/io.h>
+#include <linux/suspend.h>
=20
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -270,19 +271,43 @@ void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
+	int save_ftrace_enabled;
=20
-	tracer_disable();
+#ifdef CONFIG_KEXEC_JUMP
+	if (kexec_image->preserve_context)
+		save_processor_state();
+#endif
+
+	save_ftrace_enabled =3D __ftrace_enabled_save();
=20
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
=20
+	if (image->preserve_context) {
+#ifdef CONFIG_X86_IO_APIC
+		/*
+		 * We need to put APICs in legacy mode so that we can
+		 * get timer interrupts in second kernel. kexec/kdump
+		 * paths already have calls to disable_IO_APIC() in
+		 * one form or other. kexec jump path also need
+		 * one.
+		 */
+		disable_IO_APIC();
+#endif
+	}
+
 	control_page =3D page_address(image->control_code_page) + PAGE_SIZE;
-	memcpy(control_page, relocate_kernel, PAGE_SIZE);
+	memcpy(control_page, relocate_kernel, KEXEC_CONTROL_CODE_MAX_SIZE);
=20
 	page_list[PA_CONTROL_PAGE] =3D virt_to_phys(control_page);
+	page_list[VA_CONTROL_PAGE] =3D (unsigned long)control_page;
 	page_list[PA_TABLE_PAGE] =3D
 	  (unsigned long)__pa(page_address(image->control_code_page));
=20
+	if (image->type =3D=3D KEXEC_TYPE_DEFAULT)
+		page_list[PA_SWAP_PAGE] =3D (page_to_pfn(image->swap_page)
+						<< PAGE_SHIFT);
+
 	/*
 	 * The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
@@ -302,8 +327,17 @@ void machine_kexec(struct kimage *image)
 	set_idt(phys_to_virt(0), 0);
=20
 	/* now call it */
-	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
-			image->start);
+	image->start =3D relocate_kernel((unsigned long)image->head,
+				       (unsigned long)page_list,
+				       image->start,
+				       image->preserve_context);
+
+#ifdef CONFIG_KEXEC_JUMP
+	if (kexec_image->preserve_context)
+		restore_processor_state();
+#endif
+
+	__ftrace_enabled_restore(save_ftrace_enabled);
 }
=20
 void arch_crash_save_vmcoreinfo(void)
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -9,13 +9,13 @@
 # define PAGES_NR		4
 #else
 # define PA_CONTROL_PAGE	0
-# define PA_TABLE_PAGE		1
-# define PAGES_NR		2
+# define VA_CONTROL_PAGE	1
+# define PA_TABLE_PAGE		2
+# define PA_SWAP_PAGE		3
+# define PAGES_NR		4
 #endif
=20
-#ifdef CONFIG_X86_32
 # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
-#endif
=20
 #ifndef __ASSEMBLY__
=20
@@ -136,10 +136,11 @@ relocate_kernel(unsigned long indirectio
 		unsigned int has_pae,
 		unsigned int preserve_context);
 #else
-NORET_TYPE void
+unsigned long
 relocate_kernel(unsigned long indirection_page,
 		unsigned long page_list,
-		unsigned long start_address) ATTRIB_NORET;
+		unsigned long start_address,
+		unsigned int preserve_context);
 #endif
=20
 #define ARCH_HAS_KIMAGE_ARCH
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -19,6 +19,24 @@
 #define PTR(x) (x << 3)
 #define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY=
)
=20
+/*
+ * control_page + KEXEC_CONTROL_CODE_MAX_SIZE
+ * ~ control_page + PAGE_SIZE are used as data storage and stack for
+ * jumping back
+ */
+#define DATA(offset)		(KEXEC_CONTROL_CODE_MAX_SIZE+(offset))
+
+/* Minimal CPU state */
+#define RSP			DATA(0x0)
+#define CR0			DATA(0x8)
+#define CR3			DATA(0x10)
+#define CR4			DATA(0x18)
+
+/* other data */
+#define CP_PA_TABLE_PAGE	DATA(0x20)
+#define CP_PA_SWAP_PAGE		DATA(0x28)
+#define CP_PA_BACKUP_PAGES_MAP	DATA(0x30)
+
 	.text
 	.align PAGE_SIZE
 	.code64
@@ -28,8 +46,27 @@ relocate_kernel:
 	 * %rdi indirection_page
 	 * %rsi page_list
 	 * %rdx start address
+	 * %rcx preserve_context
 	 */
=20
+	/* Save the CPU context, used for jumping back */
+	pushq %rbx
+	pushq %rbp
+	pushq %r12
+	pushq %r13
+	pushq %r14
+	pushq %r15
+	pushf
+
+	movq	PTR(VA_CONTROL_PAGE)(%rsi), %r11
+	movq	%rsp, RSP(%r11)
+	movq	%cr0, %rax
+	movq	%rax, CR0(%r11)
+	movq	%cr3, %rax
+	movq	%rax, CR3(%r11)
+	movq	%cr4, %rax
+	movq	%rax, CR4(%r11)
+
 	/* zero out flags, and disable interrupts */
 	pushq $0
 	popfq
@@ -41,10 +78,18 @@ relocate_kernel:
 	movq	PTR(PA_CONTROL_PAGE)(%rsi), %r8
=20
 	/* get physical address of page table now too */
-	movq	PTR(PA_TABLE_PAGE)(%rsi), %rcx
+	movq	PTR(PA_TABLE_PAGE)(%rsi), %r9
+
+	/* get physical address of swap page now */
+	movq	PTR(PA_SWAP_PAGE)(%rsi), %r10
+
+	/* save some information for jumping back */
+	movq	%r9, CP_PA_TABLE_PAGE(%r11)
+	movq	%r10, CP_PA_SWAP_PAGE(%r11)
+	movq	%rdi, CP_PA_BACKUP_PAGES_MAP(%r11)
=20
 	/* Switch to the identity mapped page tables */
-	movq	%rcx, %cr3
+	movq	%r9, %cr3
=20
 	/* setup a new stack at the end of the physical control page */
 	lea	PAGE_SIZE(%r8), %rsp
@@ -83,9 +128,87 @@ identity_mapped:
 1:
=20
 	/* Flush the TLB (needed?) */
-	movq	%rcx, %cr3
+	movq	%r9, %cr3
+
+	movq	%rcx, %r11
+	call	swap_pages
+
+	/*
+	 * To be certain of avoiding problems with self-modifying code
+	 * I need to execute a serializing instruction here.
+	 * So I flush the TLB by reloading %cr3 here, it's handy,
+	 * and not processor dependent.
+	 */
+	movq	%cr3, %rax
+	movq	%rax, %cr3
+
+	/*
+	 * set all of the registers to known values
+	 * leave %rsp alone
+	 */
+
+	testq	%r11, %r11
+	jnz 1f
+	xorq	%rax, %rax
+	xorq	%rbx, %rbx
+	xorq    %rcx, %rcx
+	xorq    %rdx, %rdx
+	xorq    %rsi, %rsi
+	xorq    %rdi, %rdi
+	xorq    %rbp, %rbp
+	xorq	%r8,  %r8
+	xorq	%r9,  %r9
+	xorq	%r10, %r9
+	xorq	%r11, %r11
+	xorq	%r12, %r12
+	xorq	%r13, %r13
+	xorq	%r14, %r14
+	xorq	%r15, %r15
+
+	ret
+
+1:
+	popq	%rdx
+	leaq	PAGE_SIZE(%r10), %rsp
+	call	*%rdx
+
+	/* get the re-entry point of the peer system */
+	movq	0(%rsp), %rbp
+	call	1f
+1:
+	popq	%r8
+	subq	$(1b - relocate_kernel), %r8
+	movq	CP_PA_SWAP_PAGE(%r8), %r10
+	movq	CP_PA_BACKUP_PAGES_MAP(%r8), %rdi
+	movq	CP_PA_TABLE_PAGE(%r8), %rax
+	movq	%rax, %cr3
+	lea	PAGE_SIZE(%r8), %rsp
+	call	swap_pages
+	movq	$virtual_mapped, %rax
+	pushq	%rax
+	ret
+
+virtual_mapped:
+	movq	RSP(%r8), %rsp
+	movq	CR4(%r8), %rax
+	movq	%rax, %cr4
+	movq	CR3(%r8), %rax
+	movq	CR0(%r8), %r8
+	movq	%rax, %cr3
+	movq	%r8, %cr0
+	movq	%rbp, %rax
+
+	popf
+	popq	%r15
+	popq	%r14
+	popq	%r13
+	popq	%r12
+	popq	%rbp
+	popq	%rbx
+	ret
=20
 	/* Do the copies */
+swap_pages:
 	movq	%rdi, %rcx 	/* Put the page_list in %rcx */
 	xorq	%rdi, %rdi
 	xorq	%rsi, %rsi
@@ -117,39 +240,27 @@ identity_mapped:
 	movq	%rcx,   %rsi  /* For ever source page do a copy */
 	andq	$0xfffffffffffff000, %rsi
=20
+	movq	%rdi, %rdx
+	movq	%rsi, %rax
+
+	movq	%r10, %rdi
 	movq	$512,   %rcx
 	rep ; movsq
-	jmp	0b
-3:
-
-	/*
-	 * To be certain of avoiding problems with self-modifying code
-	 * I need to execute a serializing instruction here.
-	 * So I flush the TLB by reloading %cr3 here, it's handy,
-	 * and not processor dependent.
-	 */
-	movq	%cr3, %rax
-	movq	%rax, %cr3
=20
-	/*
-	 * set all of the registers to known values
-	 * leave %rsp alone
-	 */
+	movq	%rax, %rdi
+	movq	%rdx, %rsi
+	movq	$512,   %rcx
+	rep ; movsq
=20
-	xorq	%rax, %rax
-	xorq	%rbx, %rbx
-	xorq    %rcx, %rcx
-	xorq    %rdx, %rdx
-	xorq    %rsi, %rsi
-	xorq    %rdi, %rdi
-	xorq    %rbp, %rbp
-	xorq	%r8,  %r8
-	xorq	%r9,  %r9
-	xorq	%r10, %r9
-	xorq	%r11, %r11
-	xorq	%r12, %r12
-	xorq	%r13, %r13
-	xorq	%r14, %r14
-	xorq	%r15, %r15
+	movq	%rdx, %rdi
+	movq	%r10, %rsi
+	movq	$512,   %rcx
+	rep ; movsq
=20
+	lea	PAGE_SIZE(%rax), %rsi
+	jmp	0b
+3:
 	ret
+
+	.globl kexec_control_code_size
+.set kexec_control_code_size, . - relocate_kernel
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -275,3 +275,10 @@ ASSERT((_end - _text <=3D KERNEL_IMAGE_SIZ
 ASSERT((per_cpu__irq_stack_union =3D=3D 0),
         "irq_stack_union is not at start of per-cpu area");
 #endif
+
+#ifdef CONFIG_KEXEC
+#include <asm/kexec.h>
+
+ASSERT(kexec_control_code_size <=3D KEXEC_CONTROL_CODE_MAX_SIZE,
+       "kexec control code size is too big")
+#endif
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1439,7 +1439,7 @@ config CRASH_DUMP
 config KEXEC_JUMP
 	bool "kexec jump (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	depends on KEXEC && HIBERNATION && X86_32
+	depends on KEXEC && HIBERNATION
 	---help---
 	  Jump between original kernel and kexeced kernel and invoke
 	  code in physical address mode via KEXEC


--=-HXPnC5cVat1RmYWvBMZP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm11wIACgkQKhFGF+eHlpghmwCfRiNNx+Ahp1qneKy5vsucKyxU
jL4AoKNhwIKcfKKJUZ+nj7mprDQ7ueVT
=FW+s
-----END PGP SIGNATURE-----

--=-HXPnC5cVat1RmYWvBMZP--

