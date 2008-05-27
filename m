Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbYE0VXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbYE0VXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbYE0VXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:23:30 -0400
Received: from gw.goop.org ([64.81.55.164]:37256 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523AbYE0VX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:23:29 -0400
Message-ID: <483C7BB0.6080901@goop.org>
Date: Tue, 27 May 2008 22:22:56 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
References: <200805110030.15510.yhlu.kernel@gmail.com>	 <200805180118.57863.yhlu.kernel@gmail.com>	 <200805211840.18619.yhlu.kernel@gmail.com>	 <200805251000.10205.yhlu.kernel@gmail.com>	 <alpine.LFD.1.10.0805271744080.3295@apollo.tec.linutronix.de>	 <483C70F9.2030901@goop.org> <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>
In-Reply-To: <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Can you send out your boot log?
>   

I've included it below.

> I still can not figure out INIT_PG_TABLE and RAMDISK could overlap? or
> only one byte? or the same page?
>   

Perhaps my explanation in the patch description wasn't clear enough.

When Xen builds the domain, it's responsible for layout of the kernel, 
the initrd and the initial pagetable (the kernel does not create its own 
pagetable like it does when booting directly on x86).

The layout is (from low to high addresses):

     kernel start ->+-------+
                    |.text  |
                    + - - - +
                    |.data  |
                    + - - - +
                    |.bss   |
              _end->+-------+
                    :padding:
                    +-------+<-ramdisk_image
                    :       :
                    |initrd |
                    :       :
                    +-------+<-ramdisk_end
                    :padding:
                    +-------+
                    |pgtable|
init_pg_tables_end->+-------+


Therefore, when you call early_reserve(&end, init_pg_tables_end) to 
reserve the inital pagetable, you also implicitly reserve the whole 
ramdisk area.  Since your code currently reserves the ramdisk first, the 
reservation of the pagetable fails because it overlaps the ramdisk.

My patch does two things:

   1. reserve the initial pagetable first
   2. skip reserving the ramdisk if it is within the pagetable range

This makes sure that all the important memory is reserved from early in 
boot.

There are two alternate fixes:

   1. try to precisely reserve *just* the pagetable, rather than
      assuming it starts at &_end.  I'm not sure there's currently a way
      to do this, but it would be easy enough to add.  Or,
   2. Make early reservation cope with overlapping ranges, and deal with
      them appropriately.

But for now, my patch prevents your code from causing a regression when 
booting under Xen.

    J


(early) Linux version 2.6.26-rc4 (jeremy@victim.goop.org) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #502 SMP PREEMPT Tue May 27 13:37:29 PDT 2008
(early) ACPI in unprivileged domain disabled
(early) BIOS-provided physical RAM map:
(early)  Xen: 0000000000000000 - 000000000009f000 (usable)
(early)  Xen: 0000000000100000 - 0000000010000000 (usable)
(early) console [xenboot0] enabled
(early) debug: ignoring loglevel setting.
(early)  limit_regions start: 0000000000000000 - 000000000009f000 (usable)
(early)  limit_regions start: 0000000000100000 - 0000000010000000 (usable)
(early)  limit_regions endfunc: 0000000000000000 - 000000000009f000 (usable)
(early)  limit_regions endfunc: 0000000000100000 - 0000000010000000 (usable)
(early) user-defined physical RAM map:
(early)  user: 0000000000000000 - 000000000009f000 (usable)
(early)  user: 0000000000100000 - 0000000010000000 (usable)
(early) 0MB HIGHMEM available.
(early) 256MB LOWMEM available.
(early)   low ram: 01036000 - 10000000
(early)   bootmap 01036000 - 01038000
(early)   early res: 0 [0-fff] BIOS data page
(early)   early res: 1 [1000-1fff] EX TRAMPOLINE
(early)   early res: 2 [6000-6fff] TRAMPOLINE
(early)   early res: 3 [100000-970c1b] TEXT DATA BSS
(early)   early res: 4 [970c1c-1035fff] INIT_PG_TABLE
(early)   early res: 5 [1036000-1037fff] BOOTMAP
(early) Scan SMP from c0000000 for 1024 bytes.
(early) Scan SMP from c009fc00 for 1024 bytes.
(early) Scan SMP from c00f0000 for 65536 bytes.
(early) Scan SMP from c00c2c20 for 1024 bytes.
(early) NX (Execute Disable) protection: active
(early) Entering add_active_range(0, 0, 65536) 0 entries of 256 used
(early) Zone PFN ranges:
(early)   DMA             0 ->     4096
(early)   Normal       4096 ->    65536
(early)   HighMem     65536 ->    65536
(early) Movable zone start PFN for each node
(early) early_node_map[1] active PFN ranges
(early)     0:        0 ->    65536
(early) On node 0 totalpages: 65536
(early)   DMA zone: 56 pages used for memmap
(early)   DMA zone: 0 pages reserved
(early)   DMA zone: 4040 pages, LIFO batch:0
(early)   Normal zone: 840 pages used for memmap
(early)   Normal zone: 60600 pages, LIFO batch:15
(early)   HighMem zone: 0 pages used for memmap
(early)   Movable zone: 0 pages used for memmap


