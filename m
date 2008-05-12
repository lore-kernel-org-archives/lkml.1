Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYELP53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYELP53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYELP5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:57:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:50908 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbYELP5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:57:19 -0400
Date: Mon, 12 May 2008 10:51:35 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Sam Ravnborg <sam@ravnborg.org>
cc: lkml List <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>
Subject: Re: How to link a .o with all modules
In-Reply-To: <9D9C21A5-8796-4FC1-B792-E00112000900@kernel.crashing.org>
Message-ID: <Pine.LNX.4.64.0805121048590.9802@blarg.am.freescale.net>
References: <6C8AB345-2DA0-460D-B7C8-262463247DDE@kernel.crashing.org>
 <20080504192434.GA23752@uranus.ravnborg.org> <D346E2E4-26C3-482E-ABBF-AF1EE97E91CD@kernel.crashing.org>
 <20080505204449.GA9446@uranus.ravnborg.org> <5DD68A6B-45FD-4163-BDF5-356C70A00676@kernel.crashing.org>
 <20080508202200.GA12578@uranus.ravnborg.org> <9D9C21A5-8796-4FC1-B792-E00112000900@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Kumar Gala wrote:

>
> On May 8, 2008, at 3:22 PM, Sam Ravnborg wrote:
>
> > On Thu, May 08, 2008 at 09:16:10AM -0500, Kumar Gala wrote:
> > >
> > > On May 5, 2008, at 3:44 PM, Sam Ravnborg wrote:
> > >
> > > > > >
> > > > > >
> > > > > > Let me know if this does address your question.
> > > > >
> > > > > The problem is MODPOST complains about undefined symbols:
> > > > >
> > > > > MODPOST 24 modules
> > > > > ERROR: "_restgpr_20_x" [net/key/af_key.ko] undefined!
> > > > > ERROR: "_restgpr_25_x" [net/key/af_key.ko] undefined!
> > > > > ERROR: "_restgpr_30_x" [net/key/af_key.ko] undefined!
> > > >
> > > > I need a bit more context to try to analyse this.
> > > > Where did you expect _restgpr_20_x to be defined.
> > > > If in vmlinux then were they present in the
> > > > Module.symvers file?
> > >
> > > No they aren't there since we I'm not EXPORT_SYMBOL() them.  Should I
> > > also be doing EXPORT_SYMBOL?
> >
> > So modpost claim it cannot find the symbols.
> >
> > >
> > > > If in the linked in .o file - could you
> > > > see the symbols using objdump.
> > >
> > > Yes.
> > >
> > > readelf -a:
> > >
> > > ...
> > > Symbol table '.symtab' contains 113 entries:
> > >   Num:    Value  Size Type    Bind   Vis      Ndx Name
> > > ...
> > >     5: 00000000     0 FUNC    GLOBAL DEFAULT    1 _savegpr_14
> > >     6: 00000000     0 FUNC    GLOBAL DEFAULT    1 _save32gpr_14
> > > ...
> >
> > Strange.
> >
> > I did not look closer.
> > But it looks like the linker failed to resolve these symbols
> > in the final link somehow - despite the symbols are present in
> > the linked in .o file.
> >
> > Can you try to drop me the output of the relocation records for the
> > finally linked .o file (the one with your .o file linked in).
> >
> > objdump -r IIRC
>
> I'm assuming you mean objdump -r arch/powerpc/lib/built-in.o
>

Any update on this?

Here's my current patch that causes me issue:

- k

---

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 7822d25..77645a3 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -51,7 +51,7 @@ $(addprefix $(obj)/,$(zlib) gunzip_util.o main.o): \
 	$(addprefix $(obj)/,$(zliblinuxheader)) $(addprefix $(obj)/,$(zlibheader))

 src-libfdt := fdt.c fdt_ro.c fdt_wip.c fdt_sw.c fdt_rw.c fdt_strerror.c
-src-wlib := string.S crt0.S stdio.c main.c \
+src-wlib := string.S crt0.S crtsavres.S stdio.c main.c \
 		$(addprefix libfdt/,$(src-libfdt)) libfdt-wrapper.c \
 		ns16550.c serial.c simple_alloc.c div64.S util.S \
 		gunzip_util.c elf_util.c $(zlib) devtree.c oflib.c ofconsole.c \
diff --git a/arch/powerpc/boot/crtsavres.S b/arch/powerpc/boot/crtsavres.S
new file mode 100644
index 0000000..6bac266
--- /dev/null
+++ b/arch/powerpc/boot/crtsavres.S
@@ -0,0 +1,233 @@
+/*
+ * Special support for eabi and SVR4
+ *
+ *   Copyright (C) 1995, 1996, 1998, 2000, 2001 Free Software Foundation, Inc.
+ *   Written By Michael Meissner
+ *   64-bit support written by David Edelsohn
+ *
+ * This file is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * In addition to the permissions in the GNU General Public License, the
+ * Free Software Foundation gives you unlimited permission to link the
+ * compiled version of this file with other programs, and to distribute
+ * those programs without any restriction coming from the use of this
+ * file.  (The General Public License restrictions do apply in other
+ * respects; for example, they cover modification of the file, and
+ * distribution when not linked into another program.)
+ *
+ * This file is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 51 Franklin Street, Fifth Floor,
+ * Boston, MA 02110-1301, USA.
+ *
+ *    As a special exception, if you link this library with files
+ *    compiled with GCC to produce an executable, this does not cause
+ *    the resulting executable to be covered by the GNU General Public License.
+ *    This exception does not however invalidate any other reasons why
+ *    the executable file might be covered by the GNU General Public License.
+ */
+
+/* Do any initializations needed for the eabi environment */
+
+	.file	"crtsavres.S"
+	.section ".text"
+
+/* On PowerPC64 Linux, these functions are provided by the linker.  */
+#ifndef __powerpc64__
+
+#define FUNC_START(name) \
+	.type name,@function; \
+	.globl name; \
+name:
+
+/* Routines for saving integer registers, called by the compiler.  */
+/* Called with r11 pointing to the stack header word of the caller of the */
+/* function, just beyond the end of the integer save area.  */
+
+FUNC_START(_savegpr_14)
+FUNC_START(_save32gpr_14)
+	stw	14,-72(11)	/* save gp registers */
+FUNC_START(_savegpr_15)
+FUNC_START(_save32gpr_15)
+	stw	15,-68(11)
+FUNC_START(_savegpr_16)
+FUNC_START(_save32gpr_16)
+	stw	16,-64(11)
+FUNC_START(_savegpr_17)
+FUNC_START(_save32gpr_17)
+	stw	17,-60(11)
+FUNC_START(_savegpr_18)
+FUNC_START(_save32gpr_18)
+	stw	18,-56(11)
+FUNC_START(_savegpr_19)
+FUNC_START(_save32gpr_19)
+	stw	19,-52(11)
+FUNC_START(_savegpr_20)
+FUNC_START(_save32gpr_20)
+	stw	20,-48(11)
+FUNC_START(_savegpr_21)
+FUNC_START(_save32gpr_21)
+	stw	21,-44(11)
+FUNC_START(_savegpr_22)
+FUNC_START(_save32gpr_22)
+	stw	22,-40(11)
+FUNC_START(_savegpr_23)
+FUNC_START(_save32gpr_23)
+	stw	23,-36(11)
+FUNC_START(_savegpr_24)
+FUNC_START(_save32gpr_24)
+	stw	24,-32(11)
+FUNC_START(_savegpr_25)
+FUNC_START(_save32gpr_25)
+	stw	25,-28(11)
+FUNC_START(_savegpr_26)
+FUNC_START(_save32gpr_26)
+	stw	26,-24(11)
+FUNC_START(_savegpr_27)
+FUNC_START(_save32gpr_27)
+	stw	27,-20(11)
+FUNC_START(_savegpr_28)
+FUNC_START(_save32gpr_28)
+	stw	28,-16(11)
+FUNC_START(_savegpr_29)
+FUNC_START(_save32gpr_29)
+	stw	29,-12(11)
+FUNC_START(_savegpr_30)
+FUNC_START(_save32gpr_30)
+	stw	30,-8(11)
+FUNC_START(_savegpr_31)
+FUNC_START(_save32gpr_31)
+	stw	31,-4(11)
+	blr
+
+/* Routines for restoring integer registers, called by the compiler.  */
+/* Called with r11 pointing to the stack header word of the caller of the */
+/* function, just beyond the end of the integer restore area.  */
+
+FUNC_START(_restgpr_14)
+FUNC_START(_rest32gpr_14)
+	lwz	14,-72(11)	/* restore gp registers */
+FUNC_START(_restgpr_15)
+FUNC_START(_rest32gpr_15)
+	lwz	15,-68(11)
+FUNC_START(_restgpr_16)
+FUNC_START(_rest32gpr_16)
+	lwz	16,-64(11)
+FUNC_START(_restgpr_17)
+FUNC_START(_rest32gpr_17)
+	lwz	17,-60(11)
+FUNC_START(_restgpr_18)
+FUNC_START(_rest32gpr_18)
+	lwz	18,-56(11)
+FUNC_START(_restgpr_19)
+FUNC_START(_rest32gpr_19)
+	lwz	19,-52(11)
+FUNC_START(_restgpr_20)
+FUNC_START(_rest32gpr_20)
+	lwz	20,-48(11)
+FUNC_START(_restgpr_21)
+FUNC_START(_rest32gpr_21)
+	lwz	21,-44(11)
+FUNC_START(_restgpr_22)
+FUNC_START(_rest32gpr_22)
+	lwz	22,-40(11)
+FUNC_START(_restgpr_23)
+FUNC_START(_rest32gpr_23)
+	lwz	23,-36(11)
+FUNC_START(_restgpr_24)
+FUNC_START(_rest32gpr_24)
+	lwz	24,-32(11)
+FUNC_START(_restgpr_25)
+FUNC_START(_rest32gpr_25)
+	lwz	25,-28(11)
+FUNC_START(_restgpr_26)
+FUNC_START(_rest32gpr_26)
+	lwz	26,-24(11)
+FUNC_START(_restgpr_27)
+FUNC_START(_rest32gpr_27)
+	lwz	27,-20(11)
+FUNC_START(_restgpr_28)
+FUNC_START(_rest32gpr_28)
+	lwz	28,-16(11)
+FUNC_START(_restgpr_29)
+FUNC_START(_rest32gpr_29)
+	lwz	29,-12(11)
+FUNC_START(_restgpr_30)
+FUNC_START(_rest32gpr_30)
+	lwz	30,-8(11)
+FUNC_START(_restgpr_31)
+FUNC_START(_rest32gpr_31)
+	lwz	31,-4(11)
+	blr
+
+/* Routines for restoring integer registers, called by the compiler.  */
+/* Called with r11 pointing to the stack header word of the caller of the */
+/* function, just beyond the end of the integer restore area.  */
+
+FUNC_START(_restgpr_14_x)
+FUNC_START(_rest32gpr_14_x)
+	lwz	14,-72(11)	/* restore gp registers */
+FUNC_START(_restgpr_15_x)
+FUNC_START(_rest32gpr_15_x)
+	lwz	15,-68(11)
+FUNC_START(_restgpr_16_x)
+FUNC_START(_rest32gpr_16_x)
+	lwz	16,-64(11)
+FUNC_START(_restgpr_17_x)
+FUNC_START(_rest32gpr_17_x)
+	lwz	17,-60(11)
+FUNC_START(_restgpr_18_x)
+FUNC_START(_rest32gpr_18_x)
+	lwz	18,-56(11)
+FUNC_START(_restgpr_19_x)
+FUNC_START(_rest32gpr_19_x)
+	lwz	19,-52(11)
+FUNC_START(_restgpr_20_x)
+FUNC_START(_rest32gpr_20_x)
+	lwz	20,-48(11)
+FUNC_START(_restgpr_21_x)
+FUNC_START(_rest32gpr_21_x)
+	lwz	21,-44(11)
+FUNC_START(_restgpr_22_x)
+FUNC_START(_rest32gpr_22_x)
+	lwz	22,-40(11)
+FUNC_START(_restgpr_23_x)
+FUNC_START(_rest32gpr_23_x)
+	lwz	23,-36(11)
+FUNC_START(_restgpr_24_x)
+FUNC_START(_rest32gpr_24_x)
+	lwz	24,-32(11)
+FUNC_START(_restgpr_25_x)
+FUNC_START(_rest32gpr_25_x)
+	lwz	25,-28(11)
+FUNC_START(_restgpr_26_x)
+FUNC_START(_rest32gpr_26_x)
+	lwz	26,-24(11)
+FUNC_START(_restgpr_27_x)
+FUNC_START(_rest32gpr_27_x)
+	lwz	27,-20(11)
+FUNC_START(_restgpr_28_x)
+FUNC_START(_rest32gpr_28_x)
+	lwz	28,-16(11)
+FUNC_START(_restgpr_29_x)
+FUNC_START(_rest32gpr_29_x)
+	lwz	29,-12(11)
+FUNC_START(_restgpr_30_x)
+FUNC_START(_rest32gpr_30_x)
+	lwz	30,-8(11)
+FUNC_START(_restgpr_31_x)
+FUNC_START(_rest32gpr_31_x)
+	lwz	0,4(11)
+	lwz	31,-4(11)
+	mtlr	0
+	mr	1,11
+	blr
+#endif
-- 
1.5.4.1

