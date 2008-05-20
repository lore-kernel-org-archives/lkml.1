Return-Path: <linux-kernel-owner+w=401wt.eu-S933684AbYETUsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbYETUsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760497AbYETUsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:48:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49028 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759715AbYETUsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:48:05 -0400
Date: Tue, 20 May 2008 22:47:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       macro@ds2.pg.gda.pl
Subject: Re: Unify common parts of i8259.c
Message-ID: <20080520204750.GA31409@elte.hu>
References: <20080520151528.GA1596@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520151528.GA1596@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> Merge common parts of i8259_{32,64} into i8259.c.

hm, did you intend this to be a 'mechanic' (i.e. no functionality 
changes expected) unification?

i stuck it into -tip for testing and it caused a boot failure after a 
couple of bootups, with this config:

  http://redhat.com/~mingo/misc/config-Tue_May_20_22_15_40_CEST_2008.bad

the hang is during early bootup, after SLUB init:

  SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
  [ hard hang ]

full bootlog below. Reverting your patch fixes the bootup. The next line 
would be:

  Calibrating delay using timer specific routine.. 4023.05 BogoMIPS (lpj=8046112)

so somewhere between that and the SLUB init is it hanging.

If this change is intentionally not mechanic then please split this into 
the mechanic and non-mechanic portions, to make it all bisectable. If 
it's supposed to be mechanic then there's a bug in it - in that case a 
more gradual conversion is useful too.

We'd prefer to have 10 or 20 small commits instead one large commit - 
because in -tip we can bisect any problems to the exact change that 
caused it - while now we are left to guess about a rather large change:

   6 files changed, 347 insertions(+), 609 deletions(-)

in fact such a big change might warrant 30 or 50 small changes as well - 
the smaller the changes, the better. Such a 1000-lines change we cannot 
reasonably bisect.

	Ingo

-------------->
Linux version 2.6.26-rc3-sched-devel.git (mingo@dione) (gcc version 4.2.2) #483 Tue May 20 22:16:05 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
debug: ignoring loglevel setting.
127MB HIGHMEM available.
896MB LOWMEM available.
  early res: 0 [0-fff] BIOS data page
  early res: 1 [100000-487a8b] TEXT DATA BSS
  early res: 2 [487a8c-48afff] INIT_PG_TABLE
  early res: 3 [9f800-fffff] BIOS reserved
Entering add_active_range(0, 0, 262128) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262128
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   262128
On node 0 totalpages: 262128
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 255 pages used for memmap
  HighMem zone: 32497 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260081
Kernel command line: root=/dev/sda1 console=ttyS0,115200 console=tty debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0
debug: sysrq always enabled.
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2010.291 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1035232k/1048512k available (1788k kernel code, 12628k reserved, 562k data, 140k init, 131008k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffee000 - 0xfffff000   (  68 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc034e000 - 0xc0371000   ( 140 kB)
      .data : 0xc02bf20c - 0xc034bcf0   ( 562 kB)
      .text : 0xc0100000 - 0xc02bf20c   (1788 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[ hard hang ]

