Return-Path: <linux-kernel-owner+w=401wt.eu-S934494AbXIKUPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494AbXIKUPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965160AbXIKUFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:05:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:11381 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865AbXIKUFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pkEGcSGlHWtGVEtGW3hplLKnUXp0hGagcn8wsFJ7JYCdgV/5QNBOWaikQnoIaY+MV8sSxCl82oZusV7dgeu6Te+IVpqMwOTOlcmUKuMARTG36ambX4Si1ZnTsLz0Q178bGcEMWnB07Lhclvt5bSnZp0ScAqMnrv/vkYNcQgCm+Y=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 0/4] build system: section garbage collection for vmlinux
Date: Tue, 11 Sep 2007 21:05:33 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709112105.34301.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Build system: section garbage collection for vmlinux

Newer gcc and binutils can do dead code and data removal
at link time. It is achieved using combination of
-ffunction-sections -fdata-sections options for gcc and
--gc-sections for ld.

Theory of operation:

Option -ffunction-sections instructs gcc to place each function
(including static ones) in it's own section named .text.function_name
instead of placing all functions in one big .text section.

At link time, ld normally coalesce all such sections into one
output section .text again. It is achieved by having *(.text.*) spec
along with *(.text) spec in built-in linker scripts.

If ld is invoked with --gc-sections, it tracks references, starting
from entry point and marks all input sections which are reachable
from there. Then it discards all input sections which are not marked.

This isn't buying much if you have one big .text section per .o module,
because even one referenced function will pull in entire section.
You need -ffunction-sections in order to split .text into per-function
sections and make --gc-sections much more useful.

-fdata-sections is analogous: it places each global or static variable
into .data.variable_name, .rodata.variable_name or .bss.variable_name.

How to use it in kernel:

First, we need to adapt existing code for new section names.
Basically, we need to stop using section names of the form
.text.xxxx
.data.xxxx
.rodata.xxxx
.bss.xxxx
in the kernel for - otherwise section placement done by kernel's
custom linker scripts produces broken vmlinux and vdso images.

Second, kernel linker scripts need to be adapted by adding KEEP(xxx)
directives around sections which are not directly referenced, but are
nevertheless used (initcalls, altinstructions, etc).

These patches fix section names and add
CONFIG_DISCARD_UNUSED_SECTIONS. It is not enabled
unconditionally because only newest binutils have
ld --gc-sections which is stable enough for kernel use.
IOW: this is an experimental feature for now.

Patches are conservative and mark a lot of things with
KEEP() directive in linker script, inhibiting GC for them.

With CONFIG_MODULES=y, all EXPORT_SYMBOLed functions
are not discarded.

In this case size savings typically look like this:

   text    data     bss     dec     hex filename
5159478 1005139  406784 6571401  644589 linux-2.6.23-rc4.org/vmlinux
5131822  996090  401439 6529351  63a147 linux-2.6.23-rc4.gc/vmlinux

In this particular case, 402 objects were discarded, saving 42 kb.

With CONFIG_MODULE not set, size savings are bigger - around 10%
of vmlinux size.

Linker is unable to discard more because current infrastructure
is a bit flawed in this regard. It prevents some unused code
from being detected. In particular:
KEEP(__ex_table) -> .fixup -> get_user and friends
KEEP(.smp_locks) -> lock prefixes

I am working on improving this, thanks to suggestions from lkml readers.

Patches were run-tested on x86_64, and likely do not work on any other arch
(need to add KEEP() to arch/*/kernel/vmlinux.lds.S for each arch).

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda
