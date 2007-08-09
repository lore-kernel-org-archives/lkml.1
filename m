Return-Path: <linux-kernel-owner+w=401wt.eu-S938586AbXHIN40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938586AbXHIN40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763605AbXHIN4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:56:12 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:58582 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762057AbXHIN4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:56:09 -0400
Subject: Re: SLUB doesn't work with kdump kernel on Cell
From: Lucio Correia <ljhc@br.ibm.com>
Reply-To: ljhc@br.ibm.com
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>, Arnd Bergmann <arndb@arndb.de>
In-Reply-To: <200708082310.59997.arnd@arndb.de>
References: <1186604151.3608.46.camel@localhost.localdomain>
	 <200708082310.59997.arnd@arndb.de>
Content-Type: text/plain
Organization: IBM
Date: Thu, 09 Aug 2007 10:57:08 -0300
Message-Id: <1186667828.3038.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 23:10 +0200, Arnd Bergmann wrote:
> On Wednesday 08 August 2007, Lucio Correia wrote:
> >   DMA             0 ->    12288
> >   Normal      12288 ->    12288
> > early_node_map[2] active PFN ranges
> >     0:        0 ->     2560
> >     1:    12287 ->    12288
> 
> As Christoph found, this memory map is really strange. Other machines
> have something like
> 
> Zone PFN ranges:
>   DMA             0 ->    16384
>   Normal      16384 ->    16384
> early_node_map[2] active PFN ranges
>     0:        0 ->     8192
>     1:     8192 ->    16384
> 
> Lucio,
> What code builds the memory map that gets passed to the kdump kernel?

The function default_machine_kexec_prepare in
arch/powerpc/kernel/machine_kexec_64.c.


> Does the original kernel see the same map on your machine?

For the original kernel the map is ok:

Zone PFN ranges:
  DMA             0 ->    16384
  Normal      16384 ->    16384
early_node_map[2] active PFN ranges
    0:        0 ->     8192
    1:     8192 ->    16384


> 	Arnd <><

I also tried to pass maxcpus=1 for the command line of second kernel,
and it didn't work. How can I alternatively disable the node?

Loaded the kernel and crashed it with the commands:


[root@localhost ~]# kexec -p /boot/vmlinux-2.6.22-5.20070711bsckdump
--initrd=/boot/initrd-2.6.22-5.20070711bsckdump.img --append="maxcpus=1"
get memory ranges:1
Modified cmdline:maxcpus=1 elfcorehdr=41984K savemaxmem=1024M
root=LABEL=/1 
segment[0].mem:0x2000000 memsz:9371648
segment[1].mem:0x28f0000 memsz:65536
segment[2].mem:0x2900000 memsz:65536
segment[3].mem:0x2910000 memsz:65536
segment[4].mem:0x2920000 memsz:3735552
segment[5].mem:0x9ff0000 memsz:65536

[root@localhost ~]# echo c > /proc/sysrq-trigger


The boot output for the second kernel is:


SysRq : Trigger a crashdump
Sending IPI to other cpus...
Starting Linux PPC64 #1 SMP Tue Jul 17 09:30:52 CEST 2007
-----------------------------------------------------
ppc64_pft_size                = 0x0
physicalMemorySize            = 0xa010000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0xc000000009800000
htab_hash_mask                = 0x7fff
physical_start                = 0x2000000
-----------------------------------------------------
Linux version 2.6.22-5.20070711bsckdump
(cellbld@cellbuild.boeblingen.de.ibm.com) (gcc version 4.1.2 20070502
(Red Hat 4.1.27
*** 0000 : CF000012

*** 0000 : Setup Arch
[boot]0012 Setup Arch
no ISA IO ranges or unexpected isa range,mapping 64k
mmio NVRAM, 1024k at 0x2401fb00000 mapped to d000080080060000
Zone PFN ranges:
  DMA             0 ->    12288
  Normal      12288 ->    12288
early_node_map[2] active PFN ranges
    0:        0 ->     2560
    1:    12287 ->    12288
*** 0000 : CF000015

*** 0000 : Setup Done
[boot]0015 Setup Done
Built 2 zonelists.  Total pages: 2559
Kernel command line: maxcpus=1 elfcorehdr=41984K savemaxmem=1024M
root=LABEL=/1 
IIC for CPU 0 target id 0xe : /interrupt-controller@20000508400
IIC for CPU 1 target id 0xf : /interrupt-controller@20000508400
IIC for CPU 2 target id 0x1e : /interrupt-controller@30000508400
IIC for CPU 3 target id 0x1f : /interrupt-controller@30000508400
spider_pic: node 0, addr:
0x24000008000 /interrupt-controller@24000008000
spider_pic: node 1, addr:
0x34000008000 /interrupt-controller@34000008000
PID hash table entries: 1024 (order: 10, 8192 bytes)
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [tty0]
Using Cell machine description
Found initrd at 0xc000000002920000:0xc000000002cb0000
Starting Linux PPC64 #1 SMP Tue Jul 17 09:30:52 CEST 2007
-----------------------------------------------------
ppc64_pft_size                = 0x0
physicalMemorySize            = 0xa010000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0xc000000009800000
htab_hash_mask                = 0x7fff
physical_start                = 0x2000000
-----------------------------------------------------
Linux version 2.6.22-5.20070711bsckdump
(cellbld@cellbuild.boeblingen.de.ibm.com) (gcc version 4.1.2 20070502
(Red Hat 4.1.27
*** 0000 : CF000012

*** 0000 : Setup Arch
[boot]0012 Setup Arch
no ISA IO ranges or unexpected isa range,mapping 64k
mmio NVRAM, 1024k at 0x2401fb00000 mapped to d000080080060000
Zone PFN ranges:
  DMA             0 ->    12288
  Normal      12288 ->    12288
early_node_map[2] active PFN ranges
    0:        0 ->     2560
    1:    12287 ->    12288
*** 0000 : CF000015

*** 0000 : Setup Done
[boot]0015 Setup Done
Built 2 zonelists.  Total pages: 2559
Kernel command line: maxcpus=1 elfcorehdr=41984K savemaxmem=1024M
root=LABEL=/1 
IIC for CPU 0 target id 0xe : /interrupt-controller@20000508400
IIC for CPU 1 target id 0xf : /interrupt-controller@20000508400
IIC for CPU 2 target id 0x1e : /interrupt-controller@30000508400
IIC for CPU 3 target id 0x1f : /interrupt-controller@30000508400
spider_pic: node 0, addr:
0x24000008000 /interrupt-controller@24000008000
spider_pic: node 1, addr:
0x34000008000 /interrupt-controller@34000008000
PID hash table entries: 1024 (order: 10, 8192 bytes)
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [tty0]
Dentry cache hash table entries: 32768 (order: 2, 262144 bytes)
Inode-cache hash table entries: 16384 (order: 1, 131072 bytes)
freeing bootmem node 0
freeing bootmem node 1
Memory: 112576k/163904k available (6400k kernel code, 51328k reserved,
1344k data, 870k bss, 448k init)
------------[ cut here ]------------
kernel BUG at mm/slub.c:1802!
cpu 0x0: Vector: 700 (Program Check) at [c000000002793a60]
    pc: c000000002106f94: .kmem_cache_open+0x1e8/0x338
    lr: c000000002106f88: .kmem_cache_open+0x1dc/0x338
    sp: c000000002793ce0
   msr: 9000000000029032
  current = 0xc0000000026643f0
  paca    = 0xc000000002664d00
    pid   = 0, comm = swapper
kernel BUG at mm/slub.c:1802!
enter ? for help
[c000000002793da0] c00000000210788c .create_kmalloc_cache+0x70/0xe8
[c000000002793e50] c0000000025f65cc .kmem_cache_init+0x40/0x16c
[c000000002793ee0] c0000000025d09a8 .start_kernel+0x2f8/0x404
[c000000002793f90] c000000002008534 .start_here_common+0x60/0xac
0:mon> 


-- 
Lucio Correia
Software Engineer
IBM LTC Brazil

