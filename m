Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbYDWOgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbYDWOgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 10:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbYDWOg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 10:36:29 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:42137 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbYDWOgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 10:36:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=xlPXmt7Xg3N8IEcXpYiuqnqmnvJXnPzc5BESgndnDjqegVslSSY51F/ySLqi+z6nnRG+c8oZq6hdVs0J5eU7gU5rVADIaop6HBtytbF3UkqGd49hiuNUkhofpRbUMdglenfBn0fItiHAk50LLLYw6drILcn611DkAeFKM4RM+0o=
Message-ID: <87a5b0800804230736k340e7fe9mffbd72b5b8164015@mail.gmail.com>
Date: Wed, 23 Apr 2008 15:36:23 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Kyle McMartin" <kyle@mcmartin.ca>
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
In-Reply-To: <20080422153849.GH19802@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_11100_313585.1208961383776"
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
	 <20080422081211.e85989ec.randy.dunlap@oracle.com>
	 <87a5b0800804220816y72a7f4f9gec2111df08a1a57f@mail.gmail.com>
	 <20080422152426.GG19802@phobos.i.cabal.ca>
	 <87a5b0800804220834q4d6daec1x4146d211115ab5c@mail.gmail.com>
	 <20080422153849.GH19802@phobos.i.cabal.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_11100_313585.1208961383776
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Apr 22, 2008 at 4:38 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
> On Tue, Apr 22, 2008 at 04:34:03PM +0100, Will Newton wrote:
>  > On Tue, Apr 22, 2008 at 4:24 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
>  > > On Tue, Apr 22, 2008 at 04:16:17PM +0100, Will Newton wrote:
>  > >  > It can be done with Kconfig. Whether it should be or not depends on
>  > >  > your point of view, hence RFC. Currently __ARCH_WANT macros is the way
>  > >  > syscalls are enabled and disabled across architectures. If there's
>  > >  > consensus that it should be done via Kconfig that could certainly be
>  > >  > implmented, but that's a different patch.
>  > >  >
>  > >
>  > >  It's currently done in unistd.h for hysterical raisins. All new
>  > >  conditional syscalls have been done in Kconfig.
>  >
>  > Do you have a syscall in mind that does this in the correct way?
>  >
>
>  epoll is the most immediate example at hand, since it touches
>  fs/compat.c similarly to how you would be touching fs/filesystem.c, and
>  touches kernel/sys_ni.c and init/Kconfig in much the same way.

I implemented the approach you suggested - Kconfig symbol and
cond_syscall definition. I think I actually like the previous approach
better:

1. The arch Kconfig files are quite non-uniform compared to unistd.h
so the definitions wind up at different places in the file which is a
bit messy.
2. Changes to Kconfig may cause churn in defconfigs perhaps?
3. There is more churn in arch Kconfig than unistd.h so getting a
cross arch patch applied is likely to be more difficult.
4. The patch is about 4 times as many lines.

What do you think?

>From 094cbe1ca2fa28ae845ef80da6dad02e90cfbe04 Mon Sep 17 00:00:00 2001
From: Will Newton <will.newton@imgtec.com>
Date: Wed, 23 Apr 2008 15:28:37 +0100
Subject: [PATCH] Introduce ARCH_HAS_SYS_SYSFS Kconfig symbol.

This symbol should be defined by all arches that implement the sysfs(2)
system call. Arches that do not wish to implement this legacy system call
can save a little bit of kernel code size. The only current architecture
to benefit from this is blackfin, but in the future other arches may wish
to do this as well.
---
 arch/alpha/Kconfig     |    4 ++++
 arch/arm/Kconfig       |    4 ++++
 arch/avr32/Kconfig     |    4 ++++
 arch/cris/Kconfig      |    4 ++++
 arch/frv/Kconfig       |    4 ++++
 arch/h8300/Kconfig     |    4 ++++
 arch/ia64/Kconfig      |    4 ++++
 arch/m32r/Kconfig      |    4 ++++
 arch/m68k/Kconfig      |    4 ++++
 arch/m68knommu/Kconfig |    4 ++++
 arch/mips/Kconfig      |    4 ++++
 arch/mn10300/Kconfig   |    4 ++++
 arch/parisc/Kconfig    |    4 ++++
 arch/powerpc/Kconfig   |    4 ++++
 arch/ppc/Kconfig       |    4 ++++
 arch/s390/Kconfig      |    4 ++++
 arch/sh/Kconfig        |    4 ++++
 arch/sparc/Kconfig     |    4 ++++
 arch/sparc64/Kconfig   |    4 ++++
 arch/um/Kconfig        |    4 ++++
 arch/v850/Kconfig      |    4 ++++
 arch/x86/Kconfig       |    4 ++++
 arch/xtensa/Kconfig    |    4 ++++
 fs/filesystems.c       |    4 ++++
 kernel/sys_ni.c        |    1 +
 25 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 729cdbd..9b7b4d2 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -71,6 +71,10 @@ config AUTO_IRQ_AFFINITY
 config ARCH_SUPPORTS_AOUT
 	def_bool y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 source "init/Kconfig"


diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4039a13..c806808 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -137,6 +137,10 @@ config ZONE_DMA
 	bool
 	default y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 config GENERIC_ISA_DMA
 	bool

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 28e0caf..2f9f01d 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -66,6 +66,10 @@ config GENERIC_BUG
 	def_bool y
 	depends on BUG

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 source "init/Kconfig"

 menu "System Type and features"
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 9389d38..7aec04b 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -32,6 +32,10 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index a5aac1b..f08fb9a 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -58,6 +58,10 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 config HZ
 	int
 	default 1000
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 085dc6e..8184c99 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -69,6 +69,10 @@ config TIME_LOW_RES
 config ARCH_SUPPORTS_AOUT
 	def_bool y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 config NO_IOPORT
 	def_bool y

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 8fa3faf..513d960 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -111,6 +111,10 @@ config AUDIT_ARCH
 	bool
 	default y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index de153de..79d6f79 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -39,6 +39,10 @@ config NO_DMA
 config ARCH_SUPPORTS_AOUT
 	def_bool y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 config HZ
 	int
 	default 100
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 65db226..26859b1 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -56,6 +56,10 @@ config NO_DMA
 config ARCH_SUPPORTS_AOUT
 	def_bool y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 config HZ
 	int
 	default 100
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 07eb4c4..d9240a6 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -68,6 +68,10 @@ config NO_IOPORT
 config ARCH_SUPPORTS_AOUT
 	def_bool y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 source "init/Kconfig"

 menu "Processor type and features"
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 8724ed3..0716726 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -752,6 +752,10 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	default n

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 #
 # Select some configuration options automatically based on user selections.
 #
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 6a6409a..3666f5f 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -63,6 +63,10 @@ config GENERIC_HARDIRQS
 config HOTPLUG_CPU
 	def_bool n

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 config HZ
 	int
 	default 1000
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index bc7a19d..c6f5139 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -91,6 +91,10 @@ config ARCH_MAY_HAVE_PC_FDC
 	depends on BROKEN
 	default y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 source "init/Kconfig"


diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 1189d8d..21803f2 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -194,6 +194,10 @@ config PPC_OF_PLATFORM_PCI
 	depends on PPC64 # not supported on 32 bits yet
 	default n

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 source "init/Kconfig"

 source "arch/powerpc/sysdev/Kconfig"
diff --git a/arch/ppc/Kconfig b/arch/ppc/Kconfig
index abc877f..0156eb2 100644
--- a/arch/ppc/Kconfig
+++ b/arch/ppc/Kconfig
@@ -72,6 +72,10 @@ config GENERIC_BUG
 	default y
 	depends on BUG

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 source "init/Kconfig"

 menu "Processor"
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 1831833..c04b232 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -55,6 +55,10 @@ config GENERIC_LOCKBREAK
 	default y
 	depends on SMP && PREEMPT

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 mainmenu "Linux Kernel Configuration"

 config S390
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 8d2cd1d..66b74dc 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -93,6 +93,10 @@ config ARCH_SUPPORTS_AOUT
 config IO_TRAPPED
 	bool

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 source "init/Kconfig"

 menu "System type"
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index c40343c..25c17e3 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -30,6 +30,10 @@ config OF
 config ARCH_SUPPORTS_AOUT
 	def_bool y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 config HZ
 	int
 	default 100
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 463d1be..9f5d1ed 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -90,6 +90,10 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config ARCH_SUPPORTS_AOUT
 	def_bool y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index dba8e05..be0cb93 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -68,6 +68,10 @@ config IRQ_RELEASE_METHOD
 	bool
 	default y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 config HZ
 	int
 	default 100
diff --git a/arch/v850/Kconfig b/arch/v850/Kconfig
index 4379f43..b54d1f4 100644
--- a/arch/v850/Kconfig
+++ b/arch/v850/Kconfig
@@ -56,6 +56,10 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_SUPPORTS_AOUT
 	def_bool y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 # Turn off some random 386 crap that can affect device config
 config ISA
 	bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6c70fed..e0b830b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -155,6 +155,10 @@ config GENERIC_PENDING_IRQ
 	depends on GENERIC_HARDIRQS && SMP
 	default y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 config X86_SMP
 	bool
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 9fc8551..7834ad7 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -50,6 +50,10 @@ config ARCH_HAS_ILOG2_U64
 config NO_IOPORT
 	def_bool y

+config ARCH_HAS_SYS_SYSFS
+	bool
+	default y
+
 config HZ
 	int
 	default 100
diff --git a/fs/filesystems.c b/fs/filesystems.c
index f37f872..f6e1567 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -118,6 +118,8 @@ int unregister_filesystem(struct file_system_type * fs)

 EXPORT_SYMBOL(unregister_filesystem);

+#ifdef CONFIG_ARCH_HAS_SYS_SYSFS
+
 static int fs_index(const char __user * __name)
 {
 	struct file_system_type * tmp;
@@ -197,6 +199,8 @@ asmlinkage long sys_sysfs(int option, unsigned
long arg1, unsigned long arg2)
 	return retval;
 }

+#endif
+
 int get_filesystem_list(char * buf)
 {
 	int len = 0;
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 5b9b467..866ff4b 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -121,6 +121,7 @@ cond_syscall(sys_vm86old);
 cond_syscall(sys_vm86);
 cond_syscall(compat_sys_ipc);
 cond_syscall(compat_sys_sysctl);
+cond_syscall(sys_sysfs);

 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
-- 
1.5.3.5

------=_Part_11100_313585.1208961383776
Content-Type: text/x-patch;
 name=0001-Introduce-ARCH_HAS_SYS_SYSFS-Kconfig-symbol.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffe0c35d0
Content-Disposition: attachment;
 filename=0001-Introduce-ARCH_HAS_SYS_SYSFS-Kconfig-symbol.patch

RnJvbSAwOTRjYmUxY2EyZmEyOGFlODQ1ZWY4MGRhNmRhZDAyZTkwY2ZiZTA0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AaW1ndGVjLmNvbT4K
RGF0ZTogV2VkLCAyMyBBcHIgMjAwOCAxNToyODozNyArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIElu
dHJvZHVjZSBBUkNIX0hBU19TWVNfU1lTRlMgS2NvbmZpZyBzeW1ib2wuCgpUaGlzIHN5bWJvbCBz
aG91bGQgYmUgZGVmaW5lZCBieSBhbGwgYXJjaGVzIHRoYXQgaW1wbGVtZW50IHRoZSBzeXNmcygy
KQpzeXN0ZW0gY2FsbC4gQXJjaGVzIHRoYXQgZG8gbm90IHdpc2ggdG8gaW1wbGVtZW50IHRoaXMg
bGVnYWN5IHN5c3RlbSBjYWxsCmNhbiBzYXZlIGEgbGl0dGxlIGJpdCBvZiBrZXJuZWwgY29kZSBz
aXplLiBUaGUgb25seSBjdXJyZW50IGFyY2hpdGVjdHVyZQp0byBiZW5lZml0IGZyb20gdGhpcyBp
cyBibGFja2ZpbiwgYnV0IGluIHRoZSBmdXR1cmUgb3RoZXIgYXJjaGVzIG1heSB3aXNoCnRvIGRv
IHRoaXMgYXMgd2VsbC4KLS0tCiBhcmNoL2FscGhhL0tjb25maWcgICAgIHwgICAgNCArKysrCiBh
cmNoL2FybS9LY29uZmlnICAgICAgIHwgICAgNCArKysrCiBhcmNoL2F2cjMyL0tjb25maWcgICAg
IHwgICAgNCArKysrCiBhcmNoL2NyaXMvS2NvbmZpZyAgICAgIHwgICAgNCArKysrCiBhcmNoL2Zy
di9LY29uZmlnICAgICAgIHwgICAgNCArKysrCiBhcmNoL2g4MzAwL0tjb25maWcgICAgIHwgICAg
NCArKysrCiBhcmNoL2lhNjQvS2NvbmZpZyAgICAgIHwgICAgNCArKysrCiBhcmNoL20zMnIvS2Nv
bmZpZyAgICAgIHwgICAgNCArKysrCiBhcmNoL202OGsvS2NvbmZpZyAgICAgIHwgICAgNCArKysr
CiBhcmNoL202OGtub21tdS9LY29uZmlnIHwgICAgNCArKysrCiBhcmNoL21pcHMvS2NvbmZpZyAg
ICAgIHwgICAgNCArKysrCiBhcmNoL21uMTAzMDAvS2NvbmZpZyAgIHwgICAgNCArKysrCiBhcmNo
L3BhcmlzYy9LY29uZmlnICAgIHwgICAgNCArKysrCiBhcmNoL3Bvd2VycGMvS2NvbmZpZyAgIHwg
ICAgNCArKysrCiBhcmNoL3BwYy9LY29uZmlnICAgICAgIHwgICAgNCArKysrCiBhcmNoL3MzOTAv
S2NvbmZpZyAgICAgIHwgICAgNCArKysrCiBhcmNoL3NoL0tjb25maWcgICAgICAgIHwgICAgNCAr
KysrCiBhcmNoL3NwYXJjL0tjb25maWcgICAgIHwgICAgNCArKysrCiBhcmNoL3NwYXJjNjQvS2Nv
bmZpZyAgIHwgICAgNCArKysrCiBhcmNoL3VtL0tjb25maWcgICAgICAgIHwgICAgNCArKysrCiBh
cmNoL3Y4NTAvS2NvbmZpZyAgICAgIHwgICAgNCArKysrCiBhcmNoL3g4Ni9LY29uZmlnICAgICAg
IHwgICAgNCArKysrCiBhcmNoL3h0ZW5zYS9LY29uZmlnICAgIHwgICAgNCArKysrCiBmcy9maWxl
c3lzdGVtcy5jICAgICAgIHwgICAgNCArKysrCiBrZXJuZWwvc3lzX25pLmMgICAgICAgIHwgICAg
MSArCiAyNSBmaWxlcyBjaGFuZ2VkLCA5NyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2FyY2gvYWxwaGEvS2NvbmZpZyBiL2FyY2gvYWxwaGEvS2NvbmZpZwppbmRl
eCA3MjljZGJkLi45YjdiNGQyIDEwMDY0NAotLS0gYS9hcmNoL2FscGhhL0tjb25maWcKKysrIGIv
YXJjaC9hbHBoYS9LY29uZmlnCkBAIC03MSw2ICs3MSwxMCBAQCBjb25maWcgQVVUT19JUlFfQUZG
SU5JVFkKIGNvbmZpZyBBUkNIX1NVUFBPUlRTX0FPVVQKIAlkZWZfYm9vbCB5CiAKK2NvbmZpZyBB
UkNIX0hBU19TWVNfU1lTRlMKKwlib29sCisJZGVmYXVsdCB5CisKIHNvdXJjZSAiaW5pdC9LY29u
ZmlnIgogCiAKZGlmZiAtLWdpdCBhL2FyY2gvYXJtL0tjb25maWcgYi9hcmNoL2FybS9LY29uZmln
CmluZGV4IDQwMzlhMTMuLmM4MDY4MDggMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtL0tjb25maWcKKysr
IGIvYXJjaC9hcm0vS2NvbmZpZwpAQCAtMTM3LDYgKzEzNywxMCBAQCBjb25maWcgWk9ORV9ETUEK
IAlib29sCiAJZGVmYXVsdCB5CiAKK2NvbmZpZyBBUkNIX0hBU19TWVNfU1lTRlMKKwlib29sCisJ
ZGVmYXVsdCB5CisKIGNvbmZpZyBHRU5FUklDX0lTQV9ETUEKIAlib29sCiAKZGlmZiAtLWdpdCBh
L2FyY2gvYXZyMzIvS2NvbmZpZyBiL2FyY2gvYXZyMzIvS2NvbmZpZwppbmRleCAyOGUwY2FmLi4y
ZjlmMDFkIDEwMDY0NAotLS0gYS9hcmNoL2F2cjMyL0tjb25maWcKKysrIGIvYXJjaC9hdnIzMi9L
Y29uZmlnCkBAIC02Niw2ICs2NiwxMCBAQCBjb25maWcgR0VORVJJQ19CVUcKIAlkZWZfYm9vbCB5
CiAJZGVwZW5kcyBvbiBCVUcKIAorY29uZmlnIEFSQ0hfSEFTX1NZU19TWVNGUworCWJvb2wKKwlk
ZWZhdWx0IHkKKwogc291cmNlICJpbml0L0tjb25maWciCiAKIG1lbnUgIlN5c3RlbSBUeXBlIGFu
ZCBmZWF0dXJlcyIKZGlmZiAtLWdpdCBhL2FyY2gvY3Jpcy9LY29uZmlnIGIvYXJjaC9jcmlzL0tj
b25maWcKaW5kZXggOTM4OWQzOC4uN2FlYzA0YiAxMDA2NDQKLS0tIGEvYXJjaC9jcmlzL0tjb25m
aWcKKysrIGIvYXJjaC9jcmlzL0tjb25maWcKQEAgLTMyLDYgKzMyLDEwIEBAIGNvbmZpZyBBUkNI
X0hBU19JTE9HMl9VNjQKIAlib29sCiAJZGVmYXVsdCBuCiAKK2NvbmZpZyBBUkNIX0hBU19TWVNf
U1lTRlMKKwlib29sCisJZGVmYXVsdCB5CisKIGNvbmZpZyBHRU5FUklDX0ZJTkRfTkVYVF9CSVQK
IAlib29sCiAJZGVmYXVsdCB5CmRpZmYgLS1naXQgYS9hcmNoL2Zydi9LY29uZmlnIGIvYXJjaC9m
cnYvS2NvbmZpZwppbmRleCBhNWFhYzFiLi5mMDhmYjlhIDEwMDY0NAotLS0gYS9hcmNoL2Zydi9L
Y29uZmlnCisrKyBiL2FyY2gvZnJ2L0tjb25maWcKQEAgLTU4LDYgKzU4LDEwIEBAIGNvbmZpZyBB
UkNIX0hBU19JTE9HMl9VNjQKIAlib29sCiAJZGVmYXVsdCB5CiAKK2NvbmZpZyBBUkNIX0hBU19T
WVNfU1lTRlMKKwlib29sCisJZGVmYXVsdCB5CisKIGNvbmZpZyBIWgogCWludAogCWRlZmF1bHQg
MTAwMApkaWZmIC0tZ2l0IGEvYXJjaC9oODMwMC9LY29uZmlnIGIvYXJjaC9oODMwMC9LY29uZmln
CmluZGV4IDA4NWRjNmUuLjgxODRjOTkgMTAwNjQ0Ci0tLSBhL2FyY2gvaDgzMDAvS2NvbmZpZwor
KysgYi9hcmNoL2g4MzAwL0tjb25maWcKQEAgLTY5LDYgKzY5LDEwIEBAIGNvbmZpZyBUSU1FX0xP
V19SRVMKIGNvbmZpZyBBUkNIX1NVUFBPUlRTX0FPVVQKIAlkZWZfYm9vbCB5CiAKK2NvbmZpZyBB
UkNIX0hBU19TWVNfU1lTRlMKKwlib29sCisJZGVmYXVsdCB5CisKIGNvbmZpZyBOT19JT1BPUlQK
IAlkZWZfYm9vbCB5CiAKZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9LY29uZmlnIGIvYXJjaC9pYTY0
L0tjb25maWcKaW5kZXggOGZhM2ZhZi4uNTEzZDk2MCAxMDA2NDQKLS0tIGEvYXJjaC9pYTY0L0tj
b25maWcKKysrIGIvYXJjaC9pYTY0L0tjb25maWcKQEAgLTExMSw2ICsxMTEsMTAgQEAgY29uZmln
IEFVRElUX0FSQ0gKIAlib29sCiAJZGVmYXVsdCB5CiAKK2NvbmZpZyBBUkNIX0hBU19TWVNfU1lT
RlMKKwlib29sCisJZGVmYXVsdCB5CisKIGNob2ljZQogCXByb21wdCAiU3lzdGVtIHR5cGUiCiAJ
ZGVmYXVsdCBJQTY0X0dFTkVSSUMKZGlmZiAtLWdpdCBhL2FyY2gvbTMyci9LY29uZmlnIGIvYXJj
aC9tMzJyL0tjb25maWcKaW5kZXggZGUxNTNkZS4uNzlkNmY3OSAxMDA2NDQKLS0tIGEvYXJjaC9t
MzJyL0tjb25maWcKKysrIGIvYXJjaC9tMzJyL0tjb25maWcKQEAgLTM5LDYgKzM5LDEwIEBAIGNv
bmZpZyBOT19ETUEKIGNvbmZpZyBBUkNIX1NVUFBPUlRTX0FPVVQKIAlkZWZfYm9vbCB5CiAKK2Nv
bmZpZyBBUkNIX0hBU19TWVNfU1lTRlMKKwlib29sCisJZGVmYXVsdCB5CisKIGNvbmZpZyBIWgog
CWludAogCWRlZmF1bHQgMTAwCmRpZmYgLS1naXQgYS9hcmNoL202OGsvS2NvbmZpZyBiL2FyY2gv
bTY4ay9LY29uZmlnCmluZGV4IDY1ZGIyMjYuLjI2ODU5YjEgMTAwNjQ0Ci0tLSBhL2FyY2gvbTY4
ay9LY29uZmlnCisrKyBiL2FyY2gvbTY4ay9LY29uZmlnCkBAIC01Niw2ICs1NiwxMCBAQCBjb25m
aWcgTk9fRE1BCiBjb25maWcgQVJDSF9TVVBQT1JUU19BT1VUCiAJZGVmX2Jvb2wgeQogCitjb25m
aWcgQVJDSF9IQVNfU1lTX1NZU0ZTCisJYm9vbAorCWRlZmF1bHQgeQorCiBjb25maWcgSFoKIAlp
bnQKIAlkZWZhdWx0IDEwMApkaWZmIC0tZ2l0IGEvYXJjaC9tNjhrbm9tbXUvS2NvbmZpZyBiL2Fy
Y2gvbTY4a25vbW11L0tjb25maWcKaW5kZXggMDdlYjRjNC4uZDkyNDBhNiAxMDA2NDQKLS0tIGEv
YXJjaC9tNjhrbm9tbXUvS2NvbmZpZworKysgYi9hcmNoL202OGtub21tdS9LY29uZmlnCkBAIC02
OCw2ICs2OCwxMCBAQCBjb25maWcgTk9fSU9QT1JUCiBjb25maWcgQVJDSF9TVVBQT1JUU19BT1VU
CiAJZGVmX2Jvb2wgeQogCitjb25maWcgQVJDSF9IQVNfU1lTX1NZU0ZTCisJYm9vbAorCWRlZmF1
bHQgeQorCiBzb3VyY2UgImluaXQvS2NvbmZpZyIKIAogbWVudSAiUHJvY2Vzc29yIHR5cGUgYW5k
IGZlYXR1cmVzIgpkaWZmIC0tZ2l0IGEvYXJjaC9taXBzL0tjb25maWcgYi9hcmNoL21pcHMvS2Nv
bmZpZwppbmRleCA4NzI0ZWQzLi4wNzE2NzI2IDEwMDY0NAotLS0gYS9hcmNoL21pcHMvS2NvbmZp
ZworKysgYi9hcmNoL21pcHMvS2NvbmZpZwpAQCAtNzUyLDYgKzc1MiwxMCBAQCBjb25maWcgR0VO
RVJJQ19IQVJESVJRU19OT19fRE9fSVJRCiAJYm9vbAogCWRlZmF1bHQgbgogCitjb25maWcgQVJD
SF9IQVNfU1lTX1NZU0ZTCisJYm9vbAorCWRlZmF1bHQgeQorCiAjCiAjIFNlbGVjdCBzb21lIGNv
bmZpZ3VyYXRpb24gb3B0aW9ucyBhdXRvbWF0aWNhbGx5IGJhc2VkIG9uIHVzZXIgc2VsZWN0aW9u
cy4KICMKZGlmZiAtLWdpdCBhL2FyY2gvbW4xMDMwMC9LY29uZmlnIGIvYXJjaC9tbjEwMzAwL0tj
b25maWcKaW5kZXggNmE2NDA5YS4uMzY2NmY1ZiAxMDA2NDQKLS0tIGEvYXJjaC9tbjEwMzAwL0tj
b25maWcKKysrIGIvYXJjaC9tbjEwMzAwL0tjb25maWcKQEAgLTYzLDYgKzYzLDEwIEBAIGNvbmZp
ZyBHRU5FUklDX0hBUkRJUlFTCiBjb25maWcgSE9UUExVR19DUFUKIAlkZWZfYm9vbCBuCiAKK2Nv
bmZpZyBBUkNIX0hBU19TWVNfU1lTRlMKKwlib29sCisJZGVmYXVsdCB5CisKIGNvbmZpZyBIWgog
CWludAogCWRlZmF1bHQgMTAwMApkaWZmIC0tZ2l0IGEvYXJjaC9wYXJpc2MvS2NvbmZpZyBiL2Fy
Y2gvcGFyaXNjL0tjb25maWcKaW5kZXggYmM3YTE5ZC4uYzZmNTEzOSAxMDA2NDQKLS0tIGEvYXJj
aC9wYXJpc2MvS2NvbmZpZworKysgYi9hcmNoL3BhcmlzYy9LY29uZmlnCkBAIC05MSw2ICs5MSwx
MCBAQCBjb25maWcgQVJDSF9NQVlfSEFWRV9QQ19GREMKIAlkZXBlbmRzIG9uIEJST0tFTgogCWRl
ZmF1bHQgeQogCitjb25maWcgQVJDSF9IQVNfU1lTX1NZU0ZTCisJYm9vbAorCWRlZmF1bHQgeQor
CiBzb3VyY2UgImluaXQvS2NvbmZpZyIKIAogCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvS2Nv
bmZpZyBiL2FyY2gvcG93ZXJwYy9LY29uZmlnCmluZGV4IDExODlkOGQuLjIxODAzZjIgMTAwNjQ0
Ci0tLSBhL2FyY2gvcG93ZXJwYy9LY29uZmlnCisrKyBiL2FyY2gvcG93ZXJwYy9LY29uZmlnCkBA
IC0xOTQsNiArMTk0LDEwIEBAIGNvbmZpZyBQUENfT0ZfUExBVEZPUk1fUENJCiAJZGVwZW5kcyBv
biBQUEM2NCAjIG5vdCBzdXBwb3J0ZWQgb24gMzIgYml0cyB5ZXQKIAlkZWZhdWx0IG4KIAorY29u
ZmlnIEFSQ0hfSEFTX1NZU19TWVNGUworCWJvb2wKKwlkZWZhdWx0IHkKKwogc291cmNlICJpbml0
L0tjb25maWciCiAKIHNvdXJjZSAiYXJjaC9wb3dlcnBjL3N5c2Rldi9LY29uZmlnIgpkaWZmIC0t
Z2l0IGEvYXJjaC9wcGMvS2NvbmZpZyBiL2FyY2gvcHBjL0tjb25maWcKaW5kZXggYWJjODc3Zi4u
MDE1NmViMiAxMDA2NDQKLS0tIGEvYXJjaC9wcGMvS2NvbmZpZworKysgYi9hcmNoL3BwYy9LY29u
ZmlnCkBAIC03Miw2ICs3MiwxMCBAQCBjb25maWcgR0VORVJJQ19CVUcKIAlkZWZhdWx0IHkKIAlk
ZXBlbmRzIG9uIEJVRwogCitjb25maWcgQVJDSF9IQVNfU1lTX1NZU0ZTCisJYm9vbAorCWRlZmF1
bHQgeQorCiBzb3VyY2UgImluaXQvS2NvbmZpZyIKIAogbWVudSAiUHJvY2Vzc29yIgpkaWZmIC0t
Z2l0IGEvYXJjaC9zMzkwL0tjb25maWcgYi9hcmNoL3MzOTAvS2NvbmZpZwppbmRleCAxODMxODMz
Li5jMDRiMjMyIDEwMDY0NAotLS0gYS9hcmNoL3MzOTAvS2NvbmZpZworKysgYi9hcmNoL3MzOTAv
S2NvbmZpZwpAQCAtNTUsNiArNTUsMTAgQEAgY29uZmlnIEdFTkVSSUNfTE9DS0JSRUFLCiAJZGVm
YXVsdCB5CiAJZGVwZW5kcyBvbiBTTVAgJiYgUFJFRU1QVAogCitjb25maWcgQVJDSF9IQVNfU1lT
X1NZU0ZTCisJYm9vbAorCWRlZmF1bHQgeQorCiBtYWlubWVudSAiTGludXggS2VybmVsIENvbmZp
Z3VyYXRpb24iCiAKIGNvbmZpZyBTMzkwCmRpZmYgLS1naXQgYS9hcmNoL3NoL0tjb25maWcgYi9h
cmNoL3NoL0tjb25maWcKaW5kZXggOGQyY2QxZC4uNjZiNzRkYyAxMDA2NDQKLS0tIGEvYXJjaC9z
aC9LY29uZmlnCisrKyBiL2FyY2gvc2gvS2NvbmZpZwpAQCAtOTMsNiArOTMsMTAgQEAgY29uZmln
IEFSQ0hfU1VQUE9SVFNfQU9VVAogY29uZmlnIElPX1RSQVBQRUQKIAlib29sCiAKK2NvbmZpZyBB
UkNIX0hBU19TWVNfU1lTRlMKKwlib29sCisJZGVmYXVsdCB5CisKIHNvdXJjZSAiaW5pdC9LY29u
ZmlnIgogCiBtZW51ICJTeXN0ZW0gdHlwZSIKZGlmZiAtLWdpdCBhL2FyY2gvc3BhcmMvS2NvbmZp
ZyBiL2FyY2gvc3BhcmMvS2NvbmZpZwppbmRleCBjNDAzNDNjLi4yNWMxN2UzIDEwMDY0NAotLS0g
YS9hcmNoL3NwYXJjL0tjb25maWcKKysrIGIvYXJjaC9zcGFyYy9LY29uZmlnCkBAIC0zMCw2ICsz
MCwxMCBAQCBjb25maWcgT0YKIGNvbmZpZyBBUkNIX1NVUFBPUlRTX0FPVVQKIAlkZWZfYm9vbCB5
CiAKK2NvbmZpZyBBUkNIX0hBU19TWVNfU1lTRlMKKwlib29sCisJZGVmYXVsdCB5CisKIGNvbmZp
ZyBIWgogCWludAogCWRlZmF1bHQgMTAwCmRpZmYgLS1naXQgYS9hcmNoL3NwYXJjNjQvS2NvbmZp
ZyBiL2FyY2gvc3BhcmM2NC9LY29uZmlnCmluZGV4IDQ2M2QxYmUuLjlmNWQxZWQgMTAwNjQ0Ci0t
LSBhL2FyY2gvc3BhcmM2NC9LY29uZmlnCisrKyBiL2FyY2gvc3BhcmM2NC9LY29uZmlnCkBAIC05
MCw2ICs5MCwxMCBAQCBjb25maWcgR0VORVJJQ19IQVJESVJRU19OT19fRE9fSVJRCiBjb25maWcg
QVJDSF9TVVBQT1JUU19BT1VUCiAJZGVmX2Jvb2wgeQogCitjb25maWcgQVJDSF9IQVNfU1lTX1NZ
U0ZTCisJYm9vbAorCWRlZmF1bHQgeQorCiBjaG9pY2UKIAlwcm9tcHQgIktlcm5lbCBwYWdlIHNp
emUiCiAJZGVmYXVsdCBTUEFSQzY0X1BBR0VfU0laRV84S0IKZGlmZiAtLWdpdCBhL2FyY2gvdW0v
S2NvbmZpZyBiL2FyY2gvdW0vS2NvbmZpZwppbmRleCBkYmE4ZTA1Li5iZTBjYjkzIDEwMDY0NAot
LS0gYS9hcmNoL3VtL0tjb25maWcKKysrIGIvYXJjaC91bS9LY29uZmlnCkBAIC02OCw2ICs2OCwx
MCBAQCBjb25maWcgSVJRX1JFTEVBU0VfTUVUSE9ECiAJYm9vbAogCWRlZmF1bHQgeQogCitjb25m
aWcgQVJDSF9IQVNfU1lTX1NZU0ZTCisJYm9vbAorCWRlZmF1bHQgeQorCiBjb25maWcgSFoKIAlp
bnQKIAlkZWZhdWx0IDEwMApkaWZmIC0tZ2l0IGEvYXJjaC92ODUwL0tjb25maWcgYi9hcmNoL3Y4
NTAvS2NvbmZpZwppbmRleCA0Mzc5ZjQzLi5iNTRkMWY0IDEwMDY0NAotLS0gYS9hcmNoL3Y4NTAv
S2NvbmZpZworKysgYi9hcmNoL3Y4NTAvS2NvbmZpZwpAQCAtNTYsNiArNTYsMTAgQEAgY29uZmln
IEFSQ0hfSEFTX0lMT0cyX1U2NAogY29uZmlnIEFSQ0hfU1VQUE9SVFNfQU9VVAogCWRlZl9ib29s
IHkKIAorY29uZmlnIEFSQ0hfSEFTX1NZU19TWVNGUworCWJvb2wKKwlkZWZhdWx0IHkKKwogIyBU
dXJuIG9mZiBzb21lIHJhbmRvbSAzODYgY3JhcCB0aGF0IGNhbiBhZmZlY3QgZGV2aWNlIGNvbmZp
ZwogY29uZmlnIElTQQogCWJvb2wKZGlmZiAtLWdpdCBhL2FyY2gveDg2L0tjb25maWcgYi9hcmNo
L3g4Ni9LY29uZmlnCmluZGV4IDZjNzBmZWQuLmUwYjgzMGIgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2
L0tjb25maWcKKysrIGIvYXJjaC94ODYvS2NvbmZpZwpAQCAtMTU1LDYgKzE1NSwxMCBAQCBjb25m
aWcgR0VORVJJQ19QRU5ESU5HX0lSUQogCWRlcGVuZHMgb24gR0VORVJJQ19IQVJESVJRUyAmJiBT
TVAKIAlkZWZhdWx0IHkKIAorY29uZmlnIEFSQ0hfSEFTX1NZU19TWVNGUworCWJvb2wKKwlkZWZh
dWx0IHkKKwogY29uZmlnIFg4Nl9TTVAKIAlib29sCiAJZGVwZW5kcyBvbiBTTVAgJiYgKChYODZf
MzIgJiYgIVg4Nl9WT1lBR0VSKSB8fCBYODZfNjQpCmRpZmYgLS1naXQgYS9hcmNoL3h0ZW5zYS9L
Y29uZmlnIGIvYXJjaC94dGVuc2EvS2NvbmZpZwppbmRleCA5ZmM4NTUxLi43ODM0YWQ3IDEwMDY0
NAotLS0gYS9hcmNoL3h0ZW5zYS9LY29uZmlnCisrKyBiL2FyY2gveHRlbnNhL0tjb25maWcKQEAg
LTUwLDYgKzUwLDEwIEBAIGNvbmZpZyBBUkNIX0hBU19JTE9HMl9VNjQKIGNvbmZpZyBOT19JT1BP
UlQKIAlkZWZfYm9vbCB5CiAKK2NvbmZpZyBBUkNIX0hBU19TWVNfU1lTRlMKKwlib29sCisJZGVm
YXVsdCB5CisKIGNvbmZpZyBIWgogCWludAogCWRlZmF1bHQgMTAwCmRpZmYgLS1naXQgYS9mcy9m
aWxlc3lzdGVtcy5jIGIvZnMvZmlsZXN5c3RlbXMuYwppbmRleCBmMzdmODcyLi5mNmUxNTY3IDEw
MDY0NAotLS0gYS9mcy9maWxlc3lzdGVtcy5jCisrKyBiL2ZzL2ZpbGVzeXN0ZW1zLmMKQEAgLTEx
OCw2ICsxMTgsOCBAQCBpbnQgdW5yZWdpc3Rlcl9maWxlc3lzdGVtKHN0cnVjdCBmaWxlX3N5c3Rl
bV90eXBlICogZnMpCiAKIEVYUE9SVF9TWU1CT0wodW5yZWdpc3Rlcl9maWxlc3lzdGVtKTsKIAor
I2lmZGVmIENPTkZJR19BUkNIX0hBU19TWVNfU1lTRlMKKwogc3RhdGljIGludCBmc19pbmRleChj
b25zdCBjaGFyIF9fdXNlciAqIF9fbmFtZSkKIHsKIAlzdHJ1Y3QgZmlsZV9zeXN0ZW1fdHlwZSAq
IHRtcDsKQEAgLTE5Nyw2ICsxOTksOCBAQCBhc21saW5rYWdlIGxvbmcgc3lzX3N5c2ZzKGludCBv
cHRpb24sIHVuc2lnbmVkIGxvbmcgYXJnMSwgdW5zaWduZWQgbG9uZyBhcmcyKQogCXJldHVybiBy
ZXR2YWw7CiB9CiAKKyNlbmRpZgorCiBpbnQgZ2V0X2ZpbGVzeXN0ZW1fbGlzdChjaGFyICogYnVm
KQogewogCWludCBsZW4gPSAwOwpkaWZmIC0tZ2l0IGEva2VybmVsL3N5c19uaS5jIGIva2VybmVs
L3N5c19uaS5jCmluZGV4IDViOWI0NjcuLjg2NmZmNGIgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9zeXNf
bmkuYworKysgYi9rZXJuZWwvc3lzX25pLmMKQEAgLTEyMSw2ICsxMjEsNyBAQCBjb25kX3N5c2Nh
bGwoc3lzX3ZtODZvbGQpOwogY29uZF9zeXNjYWxsKHN5c192bTg2KTsKIGNvbmRfc3lzY2FsbChj
b21wYXRfc3lzX2lwYyk7CiBjb25kX3N5c2NhbGwoY29tcGF0X3N5c19zeXNjdGwpOworY29uZF9z
eXNjYWxsKHN5c19zeXNmcyk7CiAKIC8qIGFyY2gtc3BlY2lmaWMgd2VhayBzeXNjYWxsIGVudHJp
ZXMgKi8KIGNvbmRfc3lzY2FsbChzeXNfcGNpY29uZmlnX3JlYWQpOwotLSAKMS41LjMuNQoK
------=_Part_11100_313585.1208961383776--
