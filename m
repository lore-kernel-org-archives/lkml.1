Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZALSEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZALSEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZALSE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:04:28 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:36910 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZALSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:04:26 -0500
Date: Mon, 12 Jan 2009 10:04:23 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, maciej.sosnowski@intel.com,
       leoli@freescale.com, zw@zh-kernel.org
Subject: dmaengine: BUG: Unable to handle kernel paging request
Message-ID: <20090112180423.GA2364@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 12 Jan 2009 10:04:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm working on a driver that uses DMAEngine. With the recent changes,
the driver doesn't work anymore.

I believe I have tracked it down to commit
41d5e59c1299f27983977bcfe3b360600996051c, but it could be one of the
other DMAEngine commits.

The code that crashes is in mm/dmapool.c, line 178:
if (list_empty(&dev->dma_pools))

I distilled the crash down to the following simple driver, which should
just get a reference to dmaengine, in preparation for acquiring a
channel to use.

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/dmaengine.h>

static int __init mytest_init(void)
{
	/* Causes crash in mm/dmapool.c +178 */
	dmaengine_get();
	return 0;
}

static void __exit mytest_exit(void)
{
	dmaengine_put();
}

MODULE_AUTHOR("Ira W. Snyder <iws@ovro.caltech.edu>");
MODULE_DESCRIPTION("DMAEngine Test Driver");
MODULE_LICENSE("GPL");

module_init(mytest_init);
module_exit(mytest_exit);

A log of the crash follows. I'm happy to help test any patches.

Also, please CC me on any replies, I'm not subscribed to LKML.

Thanks,
Ira


Using MPC834x MDS machine description
Linux version 2.6.29-rc1-00002-gde5112d-dirty (iws@desk1) (gcc version 4.2.2) #89 Mon Jan 12 08:40:11 PST 2009
Found legacy serial port 0 for /soc8349@e0000000/serial@4500
  mem=e0004500, taddr=e0004500, irq=0, clk=266666664, speed=0
console [udbg0] enabled                                      
setup_arch: bootmem    
mpc834x_mds_setup_arch()
arch: exit              
Top of RAM: 0x10000000, Total RAM: 0x10000000
Memory hole size: 0MB                        
Zone PFN ranges:     
  DMA      0x00000000 -> 0x00010000
  Normal   0x00010000 -> 0x00010000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges 
    0: 0x00000000 -> 0x00010000    
On node 0 totalpages: 65536    
free_area_init_node: node 0, pgdat c027fa60, node_mem_map c0402000
  DMA zone: 512 pages used for memmap                             
  DMA zone: 0 pages reserved         
  DMA zone: 65024 pages, LIFO batch:15
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
Kernel command line: root=/dev/nfs rw nfsroot=192.168.17.59:/exports/stage3-ppc-2008.0 ip=10.0.0.2:192.168.17.59:10.0.0.1:255.255.255.0:mpc8349emds:eth0:off console=ttyS0,115200 ignore_loglevel
IPIC (128 IRQ sources) at fdffc700                         
PID hash table entries: 1024 (order: 10, 4096 bytes)
time_init: decrementer frequency = 66.666666 MHz    
time_init: processor frequency   = 533.333328 MHz
clocksource: timebase mult[3c00001] shift[22] registered
clockevent: decrementer mult[1111] shift[16] cpu[0]     
Console: colour dummy device 80x25                 
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)  
Memory: 256896k/262144k available (2428k kernel code, 5016k reserved, 136k data, 142k bss, 124k init)
SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop... 133.12 BogoMIPS (lpj=266240)
Mount-cache hash table entries: 512                   
net_namespace: 296 bytes           
NET: Registered protocol family 16
                                  
Registering qe_ic with sysfs...
Registering ipic with sysfs... 
bio: create slab <bio-0> at 0 
Freescale Elo / Elo Plus DMA driver
NET: Registered protocol family 2  
Switched to high resolution mode on CPU 0
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)       
TCP: Hash tables configured (established 8192 bind 8192) 
TCP reno registered                                     
NET: Registered protocol family 1
fsl-elo-dma e00082a8.dma: Probe the Freescale DMA driver for fsl,elo-dma controller at e00082a8...
fsl-elo-dma e00082a8.dma: #0 (fsl,elo-dma-channel), irq 71
fsl-elo-dma e00082a8.dma: #1 (fsl,elo-dma-channel), irq 71
fsl-elo-dma e00082a8.dma: #2 (fsl,elo-dma-channel), irq 71
fsl-elo-dma e00082a8.dma: #3 (fsl,elo-dma-channel), irq 71
msgmni has been set to 502                                
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered (default)
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250.0: ttyS0 at MMIO 0xe0004500 (irq = 16) is a 16550A
                                                             console handover: boot [udbg0] -> real [ttyS0]
loop: module loaded                     
Unable to handle kernel paging request for data at address 0x000000cc
Faulting instruction address: 0xc0069190
Oops: Kernel access of bad area, sig: 11 [#1]
MPC834x MDS
Modules linked in:
NIP: c0069190 LR: c0069190 CTR: 00000000
REGS: cf82be20 TRAP: 0300   Not tainted  (2.6.29-rc1-00002-gde5112d-dirty)
MSR: 00009032 <EE,ME,IR,DR>  CR: 24022022  XER: 20000000
DAR: 000000cc, DSISR: 20000000
TASK = cf828000[1] 'swapper' THREAD: cf82a000
GPR00: 00000000 cf82bed0 cf828000 c026cae0 c021fd44 00000000 cf92986c 6573635f 
GPR08: 706f6f6c c0270000 cf822330 c02a6970 24022088 00001000 0fffd000 00000000 
GPR16: 0fff3568 0fff6d3c 00000000 00000000 00000000 00000000 00000000 00000000 
GPR24: c021faf8 c027be24 c021fd30 00001000 00000008 c026cae0 000000cc cf929840 
NIP [c0069190] dma_pool_create+0x108/0x18c
LR [c0069190] dma_pool_create+0x108/0x18c
Call Trace:
[cf82bed0] [c0069154] dma_pool_create+0xcc/0x18c (unreliable)
[cf82bef0] [c014c7c4] fsl_dma_alloc_chan_resources+0x3c/0x8c
[cf82bf00] [c014aa64] dma_chan_get+0xcc/0x17c
[cf82bf20] [c014b4b8] dmaengine_get+0x7c/0x12c
[cf82bf50] [c0251830] mytest_init+0x2c/0x54
[cf82bf70] [c00038a8] do_one_initcall+0x58/0x19c
[cf82bfe0] [c024015c] kernel_init+0x7c/0xe4
[cf82bff0] [c000fe70] kernel_thread+0x4c/0x68
Instruction dump:
93bf0010 939f000c 93ff0000 93ff0004 4bfc81e1 2f9c0000 419e0070 3d20c027 
3bdc00c4 3ba9cae0 7fa3eb78 4815fec5 <801c00c4> 7f80f000 40be0018 389d000c 
---[ end trace 7a047ae4a4187f96 ]---
Kernel panic - not syncing: Attempted to kill init!
Rebooting in 180 seconds..
