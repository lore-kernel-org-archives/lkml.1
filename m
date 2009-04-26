Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZDZR3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZDZR3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 13:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZDZR3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 13:29:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059AbZDZR3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:29:38 -0400
Date: Sun, 26 Apr 2009 10:12:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tim Abbott <tabbott@MIT.EDU>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 14/15] x86: convert to use __HEAD and HEAD_TEXT macros.
In-Reply-To: <alpine.LFD.2.00.0904260934570.3101@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu> <1240711870-30505-4-git-send-email-tabbott@mit.edu>
 <1240711870-30505-5-git-send-email-tabbott@mit.edu> <1240711870-30505-6-git-send-email-tabbott@mit.edu> <1240711870-30505-7-git-send-email-tabbott@mit.edu> <1240711870-30505-8-git-send-email-tabbott@mit.edu> <1240711870-30505-9-git-send-email-tabbott@mit.edu>
 <1240711870-30505-10-git-send-email-tabbott@mit.edu> <1240711870-30505-11-git-send-email-tabbott@mit.edu> <1240711870-30505-12-git-send-email-tabbott@mit.edu> <1240711870-30505-13-git-send-email-tabbott@mit.edu> <1240711870-30505-14-git-send-email-tabbott@mit.edu>
 <alpine.LFD.2.00.0904260934570.3101@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 26 Apr 2009, Linus Torvalds wrote:
> 
> Btw, this one really needs to unify the two lds files first. Look at 
> 
> 	diff -u arch/x86/boot/compressed/vmlinux_*.lds
> 
> output and realize that they're basially exctly the same except for 
> trivial naming differences, and the fact that the64-bit version hs a 
> "pgtable" thing.
> 
> So this really needs to be done by first unifying the thing so that there 
> is _one_ arch/x86/boot/compressed/vmlinux.lds.S file with a preprocessor 
> that takes care of the trivial differences [..]

Something like this?

Looks obvious enough, and I think we could/should do the main 
"vmlinux_32/64" files somewhat similarly to this too. But they have a lot 
of other differences (the whole vsyscall setup etc), so that part isn't 
nearly as trivial.

I compile-tested on both x86-64 and i386, but just one config each. 

There's some trivial cleanup there (make the output format a Kconfig thign 
rather than doing #ifdef's for it, and unify both 32-bit and 64-bit BSS 
end to "_ebss", where 32-bit used to use the traditional "_end"), but 
other than that it's really very mindless and straigt conversion. 

For example, I think we should aim to remove "startup_32" vs "startup_64", 
and just call it "startup", and get rid of one more difference. I didn't 
do that.

Also, notice the comment in the unified vmlinux.lds.S talks about 
"head_64" and "startup_32" which is an odd and incorrect mix, but that was 
actually what the old 64-bit only lds file had, so the confusion isn't 
new, and now that mixing is arguably more accurate thanks to the 
vmlinux.lds.S file being shared between the two cases ;)

		Linus

---
 arch/x86/Kconfig                                   |    5 ++
 arch/x86/boot/compressed/Makefile                  |    2 +-
 arch/x86/boot/compressed/head_32.S                 |    8 ++--
 .../compressed/{vmlinux_64.lds => vmlinux.lds.S}   |   11 +++++-
 arch/x86/boot/compressed/vmlinux_32.lds            |   43 --------------------
 5 files changed, 20 insertions(+), 49 deletions(-)
 rename arch/x86/boot/compressed/{vmlinux_64.lds => vmlinux.lds.S} (78%)
 delete mode 100644 arch/x86/boot/compressed/vmlinux_32.lds

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c9086e6..30f41d7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -47,6 +47,11 @@ config X86
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 
+config OUTPUT_FORMAT
+	string
+	default "elf32-i386" if X86_32
+	default "elf64-x86-64" if X86_64
+
 config ARCH_DEFCONFIG
 	string
 	default "arch/x86/configs/i386_defconfig" if X86_32
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 65551c9..0f4b5e2 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -19,7 +19,7 @@ KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
 
-$(obj)/vmlinux: $(src)/vmlinux_$(BITS).lds $(obj)/head_$(BITS).o $(obj)/misc.o $(obj)/piggy.o FORCE
+$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o $(obj)/piggy.o FORCE
 	$(call if_changed,ld)
 	@:
 
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 3a8a866..85bd328 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -88,9 +88,9 @@ ENTRY(startup_32)
  * where decompression in place becomes safe.
  */
 	pushl %esi
-	leal _end(%ebp), %esi
-	leal _end(%ebx), %edi
-	movl $(_end - startup_32), %ecx
+	leal _ebss(%ebp), %esi
+	leal _ebss(%ebx), %edi
+	movl $(_ebss - startup_32), %ecx
 	std
 	rep
 	movsb
@@ -121,7 +121,7 @@ relocated:
  */
 	xorl %eax,%eax
 	leal _edata(%ebx),%edi
-	leal _end(%ebx), %ecx
+	leal _ebss(%ebx), %ecx
 	subl %edi,%ecx
 	cld
 	rep
diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux.lds.S
similarity index 78%
rename from arch/x86/boot/compressed/vmlinux_64.lds
rename to arch/x86/boot/compressed/vmlinux.lds.S
index bef1ac8..ffcb191 100644
--- a/arch/x86/boot/compressed/vmlinux_64.lds
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -1,6 +1,13 @@
-OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
+OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
+
+#ifdef CONFIG_X86_64
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(startup_64)
+#else
+OUTPUT_ARCH(i386)
+ENTRY(startup_32)
+#endif
+
 SECTIONS
 {
 	/* Be careful parts of head_64.S assume startup_32 is at
@@ -38,11 +45,13 @@ SECTIONS
 		*(.bss)
 		*(.bss.*)
 		*(COMMON)
+#ifdef CONFIG_X86_64
 		. = ALIGN(8);
 		_end_before_pgt = . ;
 		. = ALIGN(4096);
 		pgtable = . ;
 		. = . + 4096 * 6;
+#endif
 		_ebss = .;
 	}
 }
diff --git a/arch/x86/boot/compressed/vmlinux_32.lds b/arch/x86/boot/compressed/vmlinux_32.lds
deleted file mode 100644
index bb3c483..0000000
--- a/arch/x86/boot/compressed/vmlinux_32.lds
+++ /dev/null
@@ -1,43 +0,0 @@
-OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
-OUTPUT_ARCH(i386)
-ENTRY(startup_32)
-SECTIONS
-{
-	/* Be careful parts of head_32.S assume startup_32 is at
-	 * address 0.
-	 */
-	. = 0;
-	.text.head : {
-		_head = . ;
-		*(.text.head)
-		_ehead = . ;
-	}
-	.rodata.compressed : {
-		*(.rodata.compressed)
-	}
-	.text :	{
-		_text = .; 	/* Text */
-		*(.text)
-		*(.text.*)
-		_etext = . ;
-	}
-	.rodata : {
-		_rodata = . ;
-		*(.rodata)	 /* read-only data */
-		*(.rodata.*)
-		_erodata = . ;
-	}
-	.data :	{
-		_data = . ;
-		*(.data)
-		*(.data.*)
-		_edata = . ;
-	}
-	.bss : {
-		_bss = . ;
-		*(.bss)
-		*(.bss.*)
-		*(COMMON)
-		_end = . ;
-	}
-}
