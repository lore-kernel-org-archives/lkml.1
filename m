Return-Path: <linux-kernel-owner+w=401wt.eu-S938582AbYCSVrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938582AbYCSVrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765930AbYCSUSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:18:06 -0400
Received: from ozlabs.org ([203.10.76.45]:33333 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658AbYCSUSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:18:04 -0400
From: Michael Neuling <mikey@neuling.org>
To: skumar@linux.vnet.ibm.com
cc: linux-kernel@vger.kernel.org, Poornima Nayak <Poornima.Nayak@in.ibm.com>,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       benh@kernel.crashing.org
Subject: Re: [BUG]2.6.25-rc6:Unable to handle kernel paging request 
In-reply-to: <20080318052921.GA32259@in.ibm.com> 
References: <20080318052921.GA32259@in.ibm.com>
Comments: In-reply-to Sudhir Kumar <skumar@linux.vnet.ibm.com>
   message dated "Tue, 18 Mar 2008 10:59:21 +0530."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 22.1.1
Date: Tue, 18 Mar 2008 17:04:28 +0100
Message-ID: <22152.1205856268@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080318052921.GA32259@in.ibm.com> you wrote:
> Hi,
> I found the following bug at kernel boot up on my power machine
> with 2.6.25-rc6 kernel.
> 
> USB Mass Storage support registered.
> mice: PS/2 mouse device common for all mice
> Unable to handle kernel paging request for data at address
> 0xd00008000000002e
> Faulting instruction address: 0xc00000000074ded8
> cpu 0x0: Vector: 300 (Data Access) at [c00000003e073aa0]
>     pc: c00000000074ded8: .f71805f_find+0x44/0x32c
>     lr: c00000000074e1f8: .f71805f_init+0x38/0x194
>     sp: c00000003e073d20
>    msr: 8000000000009032
>    dar: d00008000000002e
>  dsisr: 42000000
>   current = 0xc0000000220851c0
>   paca    = 0xc0000000007c2700
>     pid   = 1, comm = swapper
> enter ? for help
> [c00000003e073dc0] c00000000074e1f8 .f71805f_init+0x38/0x194
> [c00000003e073ea0] c000000000724bdc .kernel_init+0x204/0x3c8
> [c00000003e073f90] c000000000025df4 .kernel_thread+0x4c/0x68

Is this an all yes or random config?  CONFIG_SENSORS_F71805F doesn't
appear in any of the powerpc def configs.

Anyway, I'm guessing the driver hasn't checked the device tree and is
probing somewhere it shouldn't.  

Mikey

> 
> For further reference some of the debug info is:
> 0:mon> r
> R00 = d00008000000002e   R16 = 4000000001c00000
> R01 = c00000003e073d20   R17 = c00000000066ecc8
> R02 = c0000000008f4458   R18 = 0000000000000000
> R03 = 000000000000002e   R19 = 00000000003a1000
> R04 = c00000003e073e30   R20 = 000000000235a3d0
> R05 = c00000003e073e34   R21 = c00000000075a3d0
> R06 = 0000000024000044   R22 = 000000000235a640
> R07 = c000000000010bcc   R23 = c00000000075a640
> R08 = c00000003e073570   R24 = c00000000066fe90
> R09 = d000080000000000   R25 = 0000000000000000
> R10 = cf000000009c2d60   R26 = c00000003e070000
> R11 = ffffffffffffff87   R27 = c00000003e073e30
> R12 = 0000000000000000   R28 = c00000003e073e34
> R13 = c0000000007c2700   R29 = 000000000000002e
> R14 = 0000000000000000   R30 = c000000000880278
> R15 = c000000000670448   R31 = c00000000078e050
> pc  = c00000000074ded8 .f71805f_find+0x44/0x32c
> lr  = c00000000074e1f8 .f71805f_init+0x38/0x194
> msr = 8000000000009032   cr  = 24000042
> ctr = c00000000074e1c0   xer = 0000000000000005   trap =  300
> dar = d00008000000002e   dsisr = 42000000
> 
> 0:mon> e
> cpu 0x0: Vector: 300 (Data Access) at [c00000003e073aa0]
>     pc: c00000000074ded8: .f71805f_find+0x44/0x32c
>     lr: c00000000074e1f8: .f71805f_init+0x38/0x194
>     sp: c00000003e073d20
>    msr: 8000000000009032
>    dar: d00008000000002e
>  dsisr: 42000000
>   current = 0xc0000000220851c0
>   paca    = 0xc0000000007c2700
>     pid   = 1, comm = swapper
> 
> 0:mon> di %pc
> c00000000074ded8  7d6919ae      stbx    r11,r9,r3
> c00000000074dedc  39000001      li      r8,1
> c00000000074dee0  990d01dc      stb     r8,476(r13)
> c00000000074dee4  e93f0000      ld      r9,0(r31)
> c00000000074dee8  7c034a14      add     r0,r3,r9
> c00000000074deec  7c0004ac      sync
> c00000000074def0  7d6919ae      stbx    r11,r9,r3
> c00000000074def4  990d01dc      stb     r8,476(r13)
> c00000000074def8  38800023      li      r4,35
> c00000000074defc  4bcc95e1      bl      c0000000004174dc        #
> .superio_inw+0x0/0x134
> c00000000074df00  3940ffed      li      r10,-19
> c00000000074df04  5463043e      clrlwi  r3,r3,16
> c00000000074df08  2f831934      cmpwi   cr7,r3,6452
> c00000000074df0c  409e0260      bne     cr7,c00000000074e16c    #
> .f71805f_find+0x2d8/0x32c
> c00000000074df10  e93e8038      ld      r9,-32712(r30)
> c00000000074df14  a0690000      lhz     r3,0(r9)
> 0:mon> 
> 
> Thanks
> Sudhir Kumar
> ISTL, IBM
> Bangalore
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 
