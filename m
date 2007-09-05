Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbXIENnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbXIENnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 09:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbXIENnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 09:43:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:30121 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbXIENnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 09:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=j3jPFGSjY1KJG2C+McZG/OSS8IN7Z5WpzWBMqzSTY83bIdyR6lZ5fjeETUJKl0TUStD5VQ59Yc9EKd4zN21XSf1yf1sKKojtoSYaT52b1X/yvRlQG54TBuu8jBVZnV5fRFZWnqJ6ml4aZT85DFsIoRFVpVKtRUNJHNK13dRuVgM=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: sam@ravnborg.org, kai@germaschewski.name
Subject: [PATCH 0/3] build system: section garbage collection for vmlinux
Date: Wed, 5 Sep 2007 14:43:21 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709051443.21522.vda.linux@googlemail.com>
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
Size savings are modest:

   text    data     bss     dec     hex filename
5159478 1005139  406784 6571401  644589 linux-2.6.23-rc4.org/vmlinux
5131822  996090  401439 6529351  63a147 linux-2.6.23-rc4.gc/vmlinux

In this particular case, 402 objects were discarded, saving 42 kb.

Linker is unable to discard more because current infrastructure
is a bit flawed in this regard. It prevents some unused code
from being detected. In particular:
KEEP(__ex_table) -> .fixup -> get_user and friends
KEEP(.smp_locks) -> lock prefixes

This is an experimental build where KEEPs for them were removed:

   text    data     bss     dec     hex filename
5131822  996090  401439 6529351  63a147 vmlinux
5065681  996090  401439 6463210  629eea vmlinux.sans_KEEP

52k of difference are due to __ex_table and .smp_locks being removed,
the remaining ~13k is genuinely unused .text.* sections.

Patches were run-tested on x86_64, and likely do not work on any other arch
(need to add KEEP() to arch/*/kernel/vmlinux.lds.S for each arch).
--
vda
