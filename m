Return-Path: <linux-kernel-owner+w=401wt.eu-S1763053AbXGZF55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763053AbXGZF55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbXGZF5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:57:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688AbXGZF5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:57:46 -0400
Date: Wed, 25 Jul 2007 22:56:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, Yinghai Lu <yinghai.lu@sun.com>
Subject: Re: 2.6.23-rc1-mm1 -- mostly fails to build
Message-Id: <20070725225658.00e18aaa.akpm@linux-foundation.org>
In-Reply-To: <20070725224143.GA668@shadowen.org>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<46A77C28.1050807@shadowen.org>
	<20070725224143.GA668@shadowen.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 23:41:46 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> On Wed, Jul 25, 2007 at 05:36:56PM +0100, Andy Whitcroft wrote:
> 
> > Will investigate the NUMA-Q explosion and report on that separatly.
> 
> Ok, I've been looking at the NUMA-Q boot panic below:
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
>  printing eip:
> c111689f
> *pdpt = 0000000001387001
> *pde = 0000000000000000
> Oops: 0000 [#1]
> SMP
> Modules linked in:
> CPU:    0
> EIP:    0060:[<c111689f>]    Not tainted VLI
> EFLAGS: 00010286   (2.6.23-rc1-mm1-gc8131905-dirty #251)
> EIP is at pci_create_bus+0x11b/0x277
> eax: 00000000   ebx: c9352e00   ecx: c9073e94   edx: c9325400
> esi: c9325400   edi: c932559c   ebp: 00000002   esp: c9073e90
> ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Process swapper (pid: 1, ti=c9072000 task=c9070030 task.ti=c9072000)
> Stack: c12adc4f c9325400 00000000 00000002 00000000 00000000 00000000 c934c800
>        000000d6 00000000 c1116a09 00000000 c9073ed5 c11b178a 00000000 c934c940
>        00000000 02fffff4 c12bd8ac c934c800 c12bd8b4 c9325000 c1119825 c934c800
> Call Trace:
>  [<c1116a09>] pci_scan_bus_parented+0xe/0x21
>  [<c11b178a>] pci_fixup_i450nx+0xa7/0x101
>  [<c1119825>] pci_do_fixups+0x2d/0x38
>  [<c111665c>] pci_device_add+0x48/0x77
>  [<c11166a5>] pci_scan_single_device+0x1a/0x1f
>  [<c11166bf>] pci_scan_slot+0x15/0x47
>  [<c111670a>] pci_scan_child_bus+0x19/0x7c
>  [<c1116a14>] pci_scan_bus_parented+0x19/0x21
>  [<c11b259d>] pcibios_scan_root+0x75/0x7e
>  [<c1369ee3>] pci_numa_init+0x2c/0xe4
>  [<c1354b87>] kernel_init+0x0/0xa1
>  [<c1354a15>] do_initcalls+0x73/0x1a3
>  [<c109032c>] proc_register+0xa0/0xa7
>  [<c10905cd>] create_proc_entry+0x73/0x86
>  [<c103a5c9>] register_irq_proc+0x75/0x92
>  [<c1354b87>] kernel_init+0x0/0xa1
>  [<c1354be6>] kernel_init+0x5f/0xa1
>  [<c10031c3>] kernel_thread_helper+0x7/0x10
>  =======================
> Code: ff 8b 83 84 00 00 00 c7 04 24 4f dc 2a c1 89 44 24 04 e8 f8 42 f0 ff 83 7c 24 14 00 75 15 8b 93 84 00 00 00 85 d2 74 0b 8b 43 44 <8b> 00 89 82 50 01 00 00 c7 44 24 04 9a 04 00 00 8d bb 88 00 00
> EIP: [<c111689f>] pci_create_bus+0x11b/0x277 SS:ESP 0068:c9073e90
> Kernel panic - not syncing: Attempted to kill init!
> 
> This seems to have been caused by the introduction of the following
> code fragment into pci_create_bus:
> 
>         if (!parent)
>                 set_dev_node(b->bridge, pcibus_to_node(b));
> 
> This has come as part of the -mm patch below:
> 
>     try-parent-numa_node-at-first-before-using-default-v2.patch
> 
> This patch does not seem to be wrong in and of itself.  It does
> expose the fact that we are building busses with NULL sysdata.
> This has come up at least three times now.  Below is the patch
> proposed the last couple of times.  It is needed to allow any machine
> with i450nx quirk, plus for NUMA-Q systems.

All this could have happened due to my hamfisted repairing of yet another
reject storm, too.

> Andrew please could you add this to -mm again.
> 

ok..
