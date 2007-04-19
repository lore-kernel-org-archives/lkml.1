Return-Path: <linux-kernel-owner+w=401wt.eu-S1766818AbXDSPTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766818AbXDSPTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766819AbXDSPTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:19:49 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:50646 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766818AbXDSPTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:19:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tQ2YHUIHYqgVXwPJy/xESKcuL6tf9ZzFp1/o1hi17eEpMQwVfOMj1Cpm2QRHqs560ZaK9VHYQXasiH8xYJOZ27Aw19Vz0hoWYcceS/71mohKglbf71odfZKfiy/pCgSlkb2PC6IBkHTnj8x/iXu2dGxhLTGNxizQtrvDYO9F09c=
Message-ID: <a6cc5d600704190819q619dc0d8jf00240fac4141005@mail.gmail.com>
Date: Thu, 19 Apr 2007 20:49:45 +0530
From: "Ashish Gupta" <ashishg2dec@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel OOPS:Badness in map_area_pte at mm/vmalloc.c:126 - Why should it misbehave? Linux 2.6.11
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On configuring an ARM based gateway with a large number of iptables
rules, in the kernel, memory allocation (vmalloc) in the kernel half
of IPTABLES issues the following warning

Badness in map_area_pte at mm/vmalloc.c:126
Badness in map_area_pte at mm/vmalloc.c:126
Badness in map_area_pte at mm/vmalloc.c:126
Badness in map_area_pte at mm/vmalloc.c:126

Seemingly since 4 pages are requested for allocation. I retraced this
back in the kernel to iptables in the function do_replace in
ip_tables.c. This causes corruption of the filter table data structure
which cause a subsequent Kernel OOPS on trying to handle packets via
the tables.

The question is, under what conditions will a page table entry be
present in the first level page directory table, if the pages it
refers to its has just been freshly allocated in vmalloc?

Suprisingly, if, after bootup I wait for some time, say about 30
seconds and start creating the rules, this warning does not occur, and
neither does the crash !!. The start and end for VMALLOC are at
0xc2800000 and 0xd0000000 where as the memory address allocated by
vmalloc is 0xc3811000, which is well within the range. Considering is
a 4K hole is left between subsequent vmalloc areas, an overlap seems
quite unlikely.

The crash was traced, back to the translation fault generated on
accessing memory on the same data structure for which the errors
appeared above. The  kernel in question is 2.6.11.

Although not required for the question - The crash dump is given
below. The code has been isolated to ipt_do_table in ip_tables.c. The
code crashes on trying to access the hook_entry for the iptables
filter table for Local out hook.

The target on which I am testing does not have any debug facility (due
to memory constraints in the system). But I have isolated the reason
for the crash.
Misc. Details on the Ooops is:-
1) Isolation of code causing the crash - As below
2) Hardware : ARM based running linux 2.6.11 with 32 MB of RAM
4) Crash Dump : - As below.

Isolation of code causing the crash:-
_______________________________
The target on which it is running does not have any other debug
mechanism. Hence I am also sending the dump of the faulty instruction
in question.
c01355a4 <ipt_do_table>:
c01355a4:       e1a0c00d        mov     ip, sp
c01355a8:       e92ddff0        stmdb   sp!, {r4, r5, r6, r7, r8, r9,
sl, fp, ip,
lr, pc}
c01355ac:       e24cb004        sub     fp, ip, #4      ; 0x4
c01355b0:       e24dd02c        sub     sp, sp, #44     ; 0x2c
c01355b4:       e3a06000        mov     r6, #0  ; 0x0
c01355b8:       e1a08000        mov     r8, r0
c01355bc:       e50b1044        str     r1, [fp, #-68]
c01355c0:       e50b2048        str     r2, [fp, #-72]
c01355c4:       e50b304c        str     r3, [fp, #-76]
c01355c8:       e50b602c        str     r6, [fp, #-44]
c01355cc:       e59b5004        ldr     r5, [fp, #4]
c01355d0:       e5903000        ldr     r3, [r0]
c01355d4:       e1a02001        mov     r2, r1
c01355d8:       e59f03b4        ldr     r0, [pc, #948]  ; c0135994
<.text+0x10c994>
c01355dc:       e5931018        ldr     r1, [r3, #24]
c01355e0:       ebfbfbb7        bl      c00344c4 <printk>
c01355e4:       e5980000        ldr     r0, [r8]
c01355e8:       ebfffe21        bl      c0134e74 <dump_tcpudp_packet>
c01355ec:       e51b004c        ldr     r0, [fp, #-76]
c01355f0:       e59f33a0        ldr     r3, [pc, #928]  ; c0135998
<.text+0x10c998>
c01355f4:       e1500006        cmp     r0, r6
c01355f8:       01a00003        moveq   r0, r3
c01355fc:       e5982000        ldr     r2, [r8]
c0135600:       e50b0030        str     r0, [fp, #-48]
c0135604:       e51b0048        ldr     r0, [fp, #-72]
c0135608:       e1500006        cmp     r0, r6
c013560c:       01a00003        moveq   r0, r3
c0135610:       e50b0034        str     r0, [fp, #-52]
c0135614:       e5922028        ldr     r2, [r2, #40]
c0135618:       e50b203c        str     r2, [fp, #-60]
c013561c:       e59f0378        ldr     r0, [pc, #888]  ; c013599c
<.text+0x10c99c>
c0135620:       ebfbfba7        bl      c00344c4 <printk>
c0135624:       e59f0374        ldr     r0, [pc, #884]  ; c01359a0
<.text+0x10c9a0>
c0135628:       e51b1044        ldr     r1, [fp, #-68]
c013562c:       ebfbfba4        bl      c00344c4 <printk>
c0135630:       e59f036c        ldr     r0, [pc, #876]  ; c01359a4
<.text+0x10c9a4>
c0135634:       e1a01005        mov     r1, r5
c0135638:       ebfbfba1        bl      c00344c4 <printk>
c013563c:       e59f0364        ldr     r0, [pc, #868]  ; c01359a8
<.text+0x10c9a8>
c0135640:       e595102c        ldr     r1, [r5, #44]
c0135644:       ebfbfb9e        bl      c00344c4 <printk>
c0135648:       e595102c        ldr     r1, [r5, #44]
c013564c:       e59f0358        ldr     r0, [pc, #856]  ; c01359ac
<.text+0x10c9ac>
c0135650:       e2811040        add     r1, r1, #64     ; 0x40
c0135654:       ebfbfb9a        bl      c00344c4 <printk>
c0135658:       e51b2044        ldr     r2, [fp, #-68]
c013565c:       e595302c        ldr     r3, [r5, #44]
c0135660:       e1a04102        mov     r4, r2, lsl #2
c0135664:       e0843003        add     r3, r4, r3
********************************
c0135668:       e593100c        ldr     r1, [r3, #12]
********************************
c013566c:       e59f033c        ldr     r0, [pc, #828]  ; c01359b0
<.text+0x10c9b0>


This translates to the following in the ip_tables code

file ip_tables.c
function ipt_do_table :-
*****************************
e = get_entry(table_base, table->private->hook_entry[hook]);
******************************



Unable to handle kernel paging request at virtual address c3811018
pgd = c0904000
[c3811018] *pgd=00a1a011, *pte=00000000, *ppte=00000000
Internal error: Oops: 7 [#1]
Modules linked in: cnxt_drv fiq_rel hsl_mod_gpl
CPU: 0
pc : [<c0135708>]    lr : [<00000001>]    Tainted: P
sp : c09978bc  ip : 60000093  fp : c0997910
r10: c01b2634  r9 : c3811040  r8 : c0997970
r7 : 00000003  r6 : 00000000  r5 : 00000000  r4 : c01a1fdc
r3 : 00000003  r2 : c381100c  r1 : 0000bfd0  r0 : 00000021
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  Segment user
Control: 5397F  Table: 00904000  DAC: 00000015
Process odyssey (pid: 178, stack limit = 0xc0996194)
Stack: (0xc09978bc to 0xc0998000)
78a0:
624115d3
78c0: ad12309e c1a3a000 00000000 00000003 00000000 c093a810 c47cc046
c01b4e40
78e0: c1a3a000 00000000 00000003 c0997974 00000000 00000003 c0997970
ffffffcf
7900: c01b2634 c099792c c0997914 c0141a0c c0135608 c01a1fdc 00000000
c01a1fc0
7920: c099795c c0997930 c00eae70 c014199c c015db58 00000003 00000000
c015db58
7940: c01b2634 00000002 ffffffcf c1a3a000 c09979a0 c0997960 c00eb994
c00eae28
7960: c1a3a000 c0997974 c015db58 ffffffcf c0886480 c01a1fc0 c0886480
00000000
7980: 00000002 c0997a10 c0997a10 80000000 c01b2774 c09979cc c09979a4
c015eac0
79a0: c00eb940 c1a3a000 c015db58 ffffffcf c01a3000 c0997a14 00000000
00000003
79c0: c09979fc c09979d0 c00eae70 c015e890 c0159f90 00000003 00000000
c0159f90
79e0: c01b2774 00000007 80000000 c08d9000 c0997a40 c0997a00 c00eb994
c00eae28
7a00: c08d9000 c0997a14 c0159f90 80000000 c0886480 c01a3000 c0886480
c08d9000
7a20: c1a3a240 c0ac7280 c015a07c c1a3a000 c1a3a000 c0997a64 c0997a44
c015a0e4
7a40: c00eb940 c08d9000 c0159f90 80000000 c1a3a238 c0886480 c0997a88
c0997a68
7a60: c015a360 c015a088 c0886480 c1a3a240 c093a802 c1a73e60 00000008
c0997aa4
7a80: c0997a8c c0159150 c015a260 c1a3a000 c0886480 c1b44820 c0997ac0
c0997aa8
7aa0: c00e5524 c01590bc 0000000e c0886480 c1b44820 c0997af4 c0997ac4
c00e7a78
7ac0: c00e53d0 00000000 00000169 c0886480 c1a3a000 c1a73e60 00000000
00000000
7ae0: 80000000 c01b263c c0997b14 c0997af8 c00feae8 c00e7868 c0886480
c1a3a000
7b00: c00fe91c 00000004 c0997b38 c0997b18 c015dd9c c00fe928 c01a30e0
c0997b80
7b20: 00000000 00000004 c0997b7c c0997b68 c0997b3c c00eae70 c015dc64
c00fe91c
7b40: 00000004 00000000 c00fe91c c01b263c 00000002 80000000 c1a3a000
c0997bac
7b60: c0997b6c c00eb994 c00eae28 c1a3a000 c0997b80 c00fe91c 80000000
c0886480
7b80: c01a30e0 c0886480 c1a3a000 c1a73e60 00000003 00000000 80000000
c01b2634
7ba0: c0997bd8 c0997bb0 c0101200 c00eb940 c1a3a000 c00fe91c 80000000
c0886480
7bc0: c1a3a000 c00fe510 00000003 c0997bec c0997bdc c00fe530 c0100f90
c0886480
7be0: c0997c10 c0997bf0 c015dd9c c00fe51c c01a30a8 c0997c58 00000000
00000003
7c00: c0997c54 c0997c40 c0997c14 c00eae70 c015dc64 c00fe510 00000003
00000000
7c20: c00fe510 c01b2634 00000002 80000000 c1a3a000 c0997c84 c0997c44
c00eb994
7c40: c00eae28 c1a3a000 c0997c58 c00fe510 80000000 c0886480 c01a30a8
c093a810
7c60: c0886480 c1a73e60 c09b7240 00000040 c09b7240 00000001 c0997cb8
c0997c88
7c80: c0100528 c00eb940 c1a3a000 c00fe510 80000000 c0886480 c093a824
c09b73c8
7ca0: c09b7294 000001da c09b7240 c0997ce4 c0997cbc c011c06c c0100180
c1a73e60
7cc0: c09b7240 00000000 c0997f20 faffffef 00000000 00000000 c0997d94
c0997ce8
7ce0: c011cb18 c011be6c 00000000 c0997d5c c1a73e60 00000040 0000014d
00000155
7d00: 00000000 faffffef 00000000 00006c07 00000000 00000003 00000000
faffffef
7d20: 0101a8c0 00000000 00000000 00000000 00000000 00000000 00000000
00000000
7d40: 00000011 6c070108 00000000 00000000 00000000 00000000 00000000
faffffef
7d60: 00000003 00000000 c1a73e60 c09b7240 0000014d c0997f20 c0997db8
00000000
7d80: 00000000 c0997ea0 c0997db4 c0997d98 c0123bd4 c011c5f4 c0997db8
c0997e18
7da0: c0997f20 0000014d c0997e9c c0997db8 c00daa88 c0123b84 c0997dc4
c003057c
7dc0: 00000000 00000001 ffffffff 00000000 c00245e4 00000000 c0997e10
00000000
7de0: c003145c c0030c98 c0982540 00000000 00000000 c00434a0 c0043378
00000000
7e00: c01aaab4 0000000a c0997e24 00000000 c0982540 c00467d0 c0997e18
c0997e18
7e20: c003864c c00433e4 00000001 c0997e30 c0997e3c c00387f8 c00385e0
0000014d
7e40: c1a94d20 c0997e7c 00000000 c0997f20 c002a93c c00387a8 c0997e64
c0997e80
7e60: ffffffff ff000000 c0197ce4 c0997ea0 00000010 c0997ea0 c1a94d20
00000040
7e80: bc1ffb44 00259958 0000014d 00000010 c0997f70 c0997ea0 c00db8f4
c00da9dc
7ea0: 6c070002 faffffef 00000000 00000000 bc1ffb88 c0997ecc c0029924
c0997f70
7ec0: c0997ecc c00dba38 c0060598 01080002 00000000 00000000 00000000
c0997f78
7ee0: 00000000 00000000 c0997f1c c0997ef8 c002c9f4 c003016c c0997f7c
00000002
7f00: c01aac20 00000074 bc1ffafc 400285e0 c0997f38 c0997f38 c0997f24
c004d738
7f20: c0997ea0 00000010 c0997f3c 00000001 00000000 00000000 00000040
00259958
7f40: 0000014d 00000000 0000000b 0000014d 00000000 00000066 c0029924
c0996000
7f60: 400285e0 c0997fa4 c0997f74 c00dc0cc c00db850 bc1ffb44 00000010
00000096
7f80: 00259958 0000014d 00000000 bc1ffb44 00000010 00259958 00000000
c0997fa8
7fa0: c00297a0 c00dbf6c 00259958 c002e56c 0000000b bc1ffb00 0000014d
00000010
7fc0: 00259958 0000014d 00000000 00000096 bc1ffe20 befffdd0 400285e0
00000000
7fe0: 4012f0f4 bc1ffaf8 400fcfd0 4011d73c 20000010 0000000b e3f99d51
01fcc237
Backtrace:
Function entered at [<c01355fc>] from [<c0141a0c>]
Function entered at [<c0141990>] from [<c00eae70>]
 r4 = C01A1FC0
Function entered at [<c00eae1c>] from [<c00eb994>]
Function entered at [<c00eb934>] from [<c015eac0>]
Function entered at [<c015e884>] from [<c00eae70>]
 r7 = 00000003  r6 = 00000000  r5 = C0997A14  r4 = C01A3000
Function entered at [<c00eae1c>] from [<c00eb994>]
Function entered at [<c00eb934>] from [<c015a0e4>]
Function entered at [<c015a07c>] from [<c015a360>]
 r5 = C0886480  r4 = C1A3A238
Function entered at [<c015a254>] from [<c0159150>]
 r8 = 00000008  r7 = C1A73E60  r6 = C093A802  r5 = C1A3A240
 r4 = C0886480
Function entered at [<c01590b0>] from [<c00e5524>]
 r6 = C1B44820  r5 = C0886480  r4 = C1A3A000
Function entered at [<c00e53c4>] from [<c00e7a78>]
 r6 = C1B44820  r5 = C0886480  r4 = 0000000E
Function entered at [<c00e785c>] from [<c00feae8>]
Function entered at [<c00fe91c>] from [<c015dd9c>]
 r7 = 00000004  r6 = C00FE91C  r5 = C1A3A000  r4 = C0886480
Function entered at [<c015dc58>] from [<c00eae70>]
 r8 = C0997B7C  r7 = 00000004  r6 = 00000000  r5 = C0997B80
 r4 = C01A30E0
Function entered at [<c00eae1c>] from [<c00eb994>]
Function entered at [<c00eb934>] from [<c0101200>]
Function entered at [<c0100f84>] from [<c00fe530>]
 r7 = 00000003  r6 = C00FE510  r5 = C1A3A000  r4 = C0886480
Function entered at [<c00fe510>] from [<c015dd9c>]
 r4 = C0886480
Function entered at [<c015dc58>] from [<c00eae70>]
 r8 = C0997C54  r7 = 00000003  r6 = 00000000  r5 = C0997C58
 r4 = C01A30A8
Function entered at [<c00eae1c>] from [<c00eb994>]
Function entered at [<c00eb934>] from [<c0100528>]
Function entered at [<c0100174>] from [<c011c06c>]
Function entered at [<c011be60>] from [<c011cb18>]
Function entered at [<c011c5e8>] from [<c0123bd4>]
Function entered at [<c0123b78>] from [<c00daa88>]
