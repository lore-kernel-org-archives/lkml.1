Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbXG1RFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbXG1RFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 13:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbXG1RFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 13:05:12 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:53219 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbXG1RFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 13:05:10 -0400
Date: Sat, 28 Jul 2007 20:05:08 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: alpha compile failure (srm_printk)
In-Reply-To: <20070605231712.ff1df46f.akpm@linux-foundation.org>
Message-ID: <Pine.SOC.4.64.0707281950340.20474@math.ut.ee>
References: <Pine.SOC.4.64.0706041419470.7370@math>
 <20070605231712.ff1df46f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Retested this compile error with todays 2.6.23-rc1+git, still the same.

> >   LD      arch/alpha/boot/bootloader
> > arch/alpha/boot/bootloader.lds:25: undefined symbol `srm_printk' referenced in expression
> 
> I was unable to repeoduce these errors on 2.6.22-rc4 with your config.

Hmm. Just make works, make bootimage does not. I debugged this further 
today and I can not see how it can work.

The link command in question is
ld   -static -uvsprintf -T   arch/alpha/boot/bootloader.lds arch/alpha/boot/head.o arch/alpha/boot/main.o -o arch/alpha/boot/bootloader
and it still tells
arch/alpha/boot/bootloader.lds:25: undefined symbol `srm_printk' referenced in expression

arch/alpha/boot/bootloader.lds contains a single related line referring 
to srm_printk:
printk = srm_printk;
This only seems to define an alias to srm_printk so not important (and 
unused)?

nm arch/alpha/boot/head.o outputs
0000000000000000 T __start
0000000000000108 T halt
0000000000000110 T move_stack
                 U start_kernel
0000000000000060 T switch_to_osf_pal
0000000000000100 T tbi
0000000000000020 T wrent
0000000000000040 T wrkg

so no mention of srm_printk.

nm arch/alpha/boot/main.o outputs
                 U _end
                 U callback_close
                 U callback_getenv
                 U callback_open
                 U callback_read
0000000000000000 G hwrpb
0000000000000000 T pal_init
0000000000000000 b pcb_va
                 U srm_printk
0000000000000130 T start_kernel
                 U strcpy
                 U switch_to_osf_pal

and the U srm_printk is breaking things. main.c actually uses srm_printk 
inside so it really needs to link one in. I do not see where that 
srm_printk could come from? The only implementation seems to be in 
arch/alpha/lib/srm_printk.c that goes into arch/alpha/lib/lib.a.. maybe 
this is forgotten?

arch/alpha/boot/Makefile contains different link rules for bootloader vs 
bootpheader and bootpzheader - the others also have $(LIBS_Y). However, 
as trial and error showed, adding $(LIBS_Y) to get lib/lib.a does not 
work - I got new unresolved symbols (__kmalloc or some other malloc 
variant).

So, can anyone guide me further - where should srm_printk come from in 
bootloader image?

-- 
Meelis Roos (mroos@linux.ee)
