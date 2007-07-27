Return-Path: <linux-kernel-owner+w=401wt.eu-S937244AbXG0PBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937244AbXG0PBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761302AbXG0PBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:01:07 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:53706 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759540AbXG0PBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:01:06 -0400
Date: Fri, 27 Jul 2007 18:01:04 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Paul Mackerras <paulus@samba.org>
cc: linuxppc-dev@ozlabs.org, Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix ppc kernels after build-id addition
In-Reply-To: <18088.10923.67233.336636@cargo.ozlabs.ibm.com>
Message-ID: <Pine.SOC.4.64.0707271742450.27338@math.ut.ee>
References: <Pine.SOC.4.64.0707251301200.21641@math.ut.ee>
 <18088.10923.67233.336636@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch fixes arch/ppc kernels, at least for prep subarch, after 
> > build-id addition. Without the patch, kernels were 3 times the size and 
> > bootloader refused to load them. Now they are back to normal again.
> 
> I just built an ARCH=ppc kernel for the prep subarch and the vmlinux
> size was normal.  Can you identify exactly why the kernels got so much
> bigger, i.e. what is taking up all the space?

Now I got the previous patches tested and got to this one. Retested with 
fresh git (build-id patch already applied) and latest Debian unstable 
(binutils package 2.17cvs20070718-1, GNU ld (GNU Binutils for Debian) 
2.17.50.20070718).

size -A vmlinux yields the same results (module notes section) and is 
roughly the same size:

vmlinux  :
section                      size         addr
.note.gnu.build-id             36          180
.text                     2399820   3221225472
.rodata                    378440   3223625728
.pci_fixup                   1448   3224004168
__ksymtab                   18376   3224005616
__ksymtab_gpl                4600   3224023992
__ksymtab_strings           53334   3224028592
__param                      1600   3224081928
__ex_table                  11096   3224084480
__bug_table                 18276   3224095576
.data                      126504   3224117248
.data.page_aligned          12288   3224244224
.data.read_mostly            5468   3224256512
.data.cacheline_aligned       256   3224264704
.data.init_task              8192   3224272896
.init.text                 103668   3224281088
.exit.text                   2964   3224384768
.init.data                  21516   3224387732
.init.setup                   684   3224409248
.initcall.init                556   3224409932
.con_initcall.init              8   3224410488
__ftr_fixup                   544   3224410496
.bss                       198296   3224412160
.stab                        1236            0
.stabstr                     1783            0
.comment                    34278            0
Total                     3405267

The differneces come in under arc/ppc/boot/images.
Without the patch:

-rwxr-xr-x 1 mroos mroos    4654112 2007-07-27 17:20 zImage.bugboot
-rwxr-xr-x 1 mroos mroos    4719626 2007-07-27 17:20 zImage.elf
-rwxr-xr-x 1 mroos mroos    4655114 2007-07-27 17:20 zImage.prep
-rw-r--r-- 1 mroos mroos 3224410860 2007-07-27 17:00 vmlinux.bin
-rw-r--r-- 1 mroos mroos    4604269 2007-07-27 17:14 vmlinux.gz

With the patch:

-rwxr-xr-x 1 mroos mroos 1528864 2007-07-27 02:01 zImage.bugboot
-rwxr-xr-x 1 mroos mroos 1594378 2007-07-27 02:01 zImage.elf
-rwxr-xr-x 1 mroos mroos 1529866 2007-07-27 02:01 zImage.prep
-rwxr-xr-x 1 mroos mroos 3189664 2007-07-27 01:31 vmlinux.bin
-rw-r--r-- 1 mroos mroos 1476643 2007-07-27 01:31 vmlinux.gz

Without the patch, vmlinux.bin is ... huge. However, only zImage.elf is 
easily measurable with size.

size -A arch/ppc/boot/images/zImage.elf (without patch):
section      size       addr
.text     24964    8388608
.data   4620288    8417280
.bss      35660   13037568
Total   4680912

size -A arch/ppc/boot/images/zImage.elf (with patch): 
section      size      addr
.text     24964   8388608
.data   1495040   8417280
.bss      35660   9912320
Total   1555664

It seems the differences come in in .data section.

objdump -t -j .data arch/ppc/boot/images/zImage.elf (without patch):

arch/ppc/boot/images/zImage.elf:     file format elf32-powerpc

SYMBOL TABLE:
00807000 l    d  .data	00000000 .data
00808f38 l     O .data	00000130 rs_table
008090dc l     O .data	00000026 order.2247
00809182 l     O .data	00000800 lenfix.2194
00809102 l     O .data	00000080 distfix.2195
008099c2 l     O .data	00000040 dbase.2118
00809982 l     O .data	00000040 dext.2119
00809a40 l     O .data	0000003e lbase.2116
00809a02 l     O .data	0000003e lext.2117
008089d0 l     O .data	00000004 key_pending
00809ab0 l     O .data	00000ff0 font
00807634 g     O .data	00000200 ctrl_map
00807434 g     O .data	00000200 altgr_map
00c6efb5 g       .data	00000000 __image_end
00808db0 g     O .data	00000015 AC
00808dc8 g     O .data	000000c0 PCI_slots
00808e88 g     O .data	00000004 cmd_line
00807a34 g     O .data	00000200 alt_map
0080ae48 g       .data	00000000 __image_begin
00808ea0 g     O .data	00000004 orig_y
00c6f000 g       .data	00000000 __ramdisk_begin
00808e9c g     O .data	00000004 cols
00808234 g     O .data	00000099 func_buf
00808e90 g     O .data	00000004 hold_residual
00807c34 g     O .data	00000200 ctrl_alt_map
00808eac g     O .data	00000004 funcbufsize
00808eb0 g     O .data	00000004 accent_table_size
00808e8c g     O .data	00000004 keyb_present
00808ea8 g     O .data	00000004 funcbufptr
00807e34 g     O .data	00000400 key_maps
00808e94 g     O .data	00000004 vidmem
00808ea4 g     O .data	00000004 keymap_count
008089d4 g     O .data	000000dc GenVgaTextRegs
00807834 g     O .data	00000200 shift_ctrl_map
00807034 g     O .data	00000200 plain_map
0080702f g       .data	00000000 timebase_period_ns
00c6f000 g       .data	00000000 __ramdisk_end
008082d0 g     O .data	00000400 func_table
00807234 g     O .data	00000200 shift_map
008086d0 g     O .data	00000300 accent_table
00808ab0 g     O .data	00000300 TextCLUT
00807000 g     O .data	0000002f cmd_preset
00808e98 g     O .data	00000004 lines

objdump -t -j .data arch/ppc/boot/images/zImage.elf (with patch):

/home/mroos/kraam/linux-2.6/arch/ppc/boot/images/zImage.elf:     file format elf32-powerpc

SYMBOL TABLE:
00807000 l    d  .data	00000000 .data
00808f38 l     O .data	00000130 rs_table
008090dc l     O .data	00000026 order.2247
00809182 l     O .data	00000800 lenfix.2194
00809102 l     O .data	00000080 distfix.2195
008099c2 l     O .data	00000040 dbase.2118
00809982 l     O .data	00000040 dext.2119
00809a40 l     O .data	0000003e lbase.2116
00809a02 l     O .data	0000003e lext.2117
008089d0 l     O .data	00000004 key_pending
00809ab0 l     O .data	00000ff0 font
00807634 g     O .data	00000200 ctrl_map
00807434 g     O .data	00000200 altgr_map
0097366b g       .data	00000000 __image_end
00808db0 g     O .data	00000015 AC
00808dc8 g     O .data	000000c0 PCI_slots
00808e88 g     O .data	00000004 cmd_line
00807a34 g     O .data	00000200 alt_map
0080ae48 g       .data	00000000 __image_begin
00808ea0 g     O .data	00000004 orig_y
00974000 g       .data	00000000 __ramdisk_begin
00808e9c g     O .data	00000004 cols
00808234 g     O .data	00000099 func_buf
00808e90 g     O .data	00000004 hold_residual
00807c34 g     O .data	00000200 ctrl_alt_map
00808eac g     O .data	00000004 funcbufsize
00808eb0 g     O .data	00000004 accent_table_size
00808e8c g     O .data	00000004 keyb_present
00808ea8 g     O .data	00000004 funcbufptr
00807e34 g     O .data	00000400 key_maps
00808e94 g     O .data	00000004 vidmem
00808ea4 g     O .data	00000004 keymap_count
008089d4 g     O .data	000000dc GenVgaTextRegs
00807834 g     O .data	00000200 shift_ctrl_map
00807034 g     O .data	00000200 plain_map
0080702f g       .data	00000000 timebase_period_ns
00974000 g       .data	00000000 __ramdisk_end
008082d0 g     O .data	00000400 func_table
00807234 g     O .data	00000200 shift_map
008086d0 g     O .data	00000300 accent_table
00808ab0 g     O .data	00000300 TextCLUT
00807000 g     O .data	0000002f cmd_preset
00808e98 g     O .data	00000004 lines

The only differences are __image_end, __ramdisk_begin and __ramdisk_end.

What more to look at?

-- 
Meelis Roos (mroos@linux.ee)
