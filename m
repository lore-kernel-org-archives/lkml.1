Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbZBCALS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbZBCALS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZBCALF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:11:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:48196 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbZBCALE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:11:04 -0500
Message-ID: <49878B88.8050602@kernel.org>
Date: Mon, 02 Feb 2009 16:10:48 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: percpu patchset broke kexec with vmlinux for x86_64
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

following patch broke kexec vmlinux

commit 3e5d8f978435bb9ba4dfe3f4514e65e7885db1a9
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Jan 13 20:41:35 2009 +0900

    x86: make percpu symbols zerobased on SMP
    
    [ Based on original patch from Christoph Lameter and Mike Travis. ]
    
    This patch makes percpu symbols zerobased on x86_64 SMP by adding
    PERCPU_VADDR() to vmlinux.lds.h which helps setting explicit vaddr on
    the percpu output section and using it in vmlinux_64.lds.S.  A new
    PHDR is added as existing ones cannot contain sections near address
    zero.  PERCPU_VADDR() also adds a new symbol __per_cpu_load which
    always points to the vaddr of the loaded percpu data.init region.
    
    The following adjustments have been made to accomodate the address
    change.
    
    * code to locate percpu gdt_page in head_64.S is updated to add the
      load address to the gdt_page offset.
    
    * __per_cpu_load is used in places where access to the init data area
      is necessary.
    
    * pda->data_offset is initialized soon after C code is entered as zero
      value doesn't work anymore.
    
    This patch is mostly taken from Mike Travis' "x86_64: Base percpu
    variables at zero" patch.


.data.percpu is overlapped with .data.init

YH


yhlu@linux-mstp:~/xx/xx/kernel/tip/linux-2.6> readelf -l vmlinux

Elf file type is EXEC (Executable file)
Entry point 0x200000
There are 6 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000200000 0xffffffff80200000 0x0000000000200000
                 0x0000000000ca6000 0x0000000000ca6000  R E    200000
  LOAD           0x0000000000ea6000 0xffffffff80ea6000 0x0000000000ea6000
                 0x000000000014dfe0 0x000000000014dfe0  RWE    200000
  LOAD           0x0000000001000000 0xffffffffff600000 0x0000000000ff4000
                 0x0000000000000888 0x0000000000000888  RWE    200000
  LOAD           0x00000000011f6000 0xffffffff80ff6000 0x0000000000ff6000
                 0x0000000000073086 0x0000000000a2d938  RWE    200000
  LOAD           0x0000000001400000 0x0000000000000000 0x000000000106a000
                 0x00000000001d2ce0 0x00000000001d2ce0  RWE    200000
  NOTE           0x00000000009e2c1c 0xffffffff809e2c1c 0x00000000009e2c1c
                 0x0000000000000024 0x0000000000000024         4

 Section to Segment mapping:
  Segment Sections...
   00     .text .notes __ex_table .rodata __bug_table .pci_fixup .builtin_fw __ksymtab __ksymtab_gpl __ksymtab_strings __init_rodata __param 
   01     .data .init.rodata .data.cacheline_aligned .data.read_mostly 
   02     .vsyscall_0 .vsyscall_fn .vsyscall_gtod_data .vsyscall_1 .vsyscall_2 .vgetcpu_mode .jiffies 
   03     .data.init_task .smp_locks .init.text .init.data .init.setup .initcall.init .con_initcall.init .x86_cpu_dev.init .altinstructions .altinstr_replacement .exit.text .init.ramfs .bss 
   04     .data.percpu 
   05     .notes 
