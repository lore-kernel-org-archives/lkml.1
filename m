Return-Path: <linux-kernel-owner+w=401wt.eu-S1763455AbXLTPDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763455AbXLTPDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXLTPC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:02:58 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:43021 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756134AbXLTPC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:02:57 -0500
Date: Thu, 20 Dec 2007 10:02:56 -0500
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
Message-ID: <20071220150255.GE2308@csclub.uwaterloo.ca>
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com> <20071219202323.GH2310@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 03:56:45PM -0500, linux-os (Dick Johnson) wrote:
> 
> On Wed, 19 Dec 2007, Lennart Sorensen wrote:
> 
> > On Wed, Dec 19, 2007 at 03:10:28PM -0500, linux-os (Dick Johnson) wrote:
> >>
> >>
> >> Here is a so-called BUG when trying to insert the following
> >> module into the kernel (2.6.22.1).
> >>
> >>
> >> BUG: unable to handle kernel paging request at virtual address 6814ec83
> >>   printing eip:
> >> c016d013
> >> *pde = 00000000
> >> Oops: 0000 [#1]
> >> PREEMPT SMP
> >> Modules linked in: MemDev parport_pc lp parport nfsd exportfs lockd sunrpc iptable_filter ip_tables x_tables e1000 e100 mii nls_cp437 msdos fat dm_mod usbhid ff_memless uhci_hcd ehci_hcd video container button battery ac rtc ipv6 ext3 jbd ata_piix libata aic7xxx scsi_transport_spi sd_mod scsi_mod
> >> CPU:    0
> >> EIP:    0060:[<c016d013>]    Not tainted VLI
> >> EFLAGS: 00010046   (2.6.22.1 #2)
> >> EIP is at kmem_cache_alloc+0x23/0x80
> >> eax: 00000000   ebx: 00000246   ecx: f8913300   edx: 6814ec83
> >> esi: 00000000   edi: f8913000   ebp: ef27e000   esp: ef27ff74
> >> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> >> Process insmod (pid: 4593, ti=ef27e000 task=f614f550 task.ti=ef27e000)
> >> Stack: f8913300 00000000 00000000 f8913013 f7fff880 000000d0 00000000 ef27e000
> >>         c012b907 ffffffff 00000000 c0140279 bffedc07 bffedc08 0807a018 00000000
> >>         c0102b82 0807a018 000018c9 0807a008 00000000 00000000 bffeabc8 00000080
> >> Call Trace:
> >>   [<f8913013>] init_module+0x13/0x48 [MemDev]
> >>   [<c012b907>] blocking_notifier_call_chain+0x17/0x20
> >>   [<c0140279>] sys_init_module+0xd9/0x140
> >>   [<c0102b82>] sysenter_past_esp+0x5f/0x85
> >>   =======================
> >> Code: 90 8d b4 26 00 00 00 00 83 ec 0c f6 c2 10 89 74 24 04 89 d6 89 7c 24 08 89 c7 89 1c 24 75 49 9c 5b fa 64 a1 04 20 47 c0 8b 14 87 <8b> 02 85 c0 74 25 c7 42 0c 01 00 00 00 48 89 02 8b 54 82 18 53
> >> EIP: [<c016d013>] kmem_cache_alloc+0x23/0x80 SS:ESP 0068:ef27ff74
> >>
> >>
> >>
> >> Here is the code that causes the crash.
> >>
> >>
> >> #include <linux/autoconf.h>
> >> #include <linux/module.h>
> >> #include <linux/kernel.h>
> >> #include <linux/init.h>
> >> #include <linux/poll.h>
> >> #include <linux/mm.h>
> >> static const char devname[]="Device";
> >> #define NR_PAGES 0x10
> >>
> >> struct DMA {
> >>      void *ptr;
> >>      unsigned long addr;
> >>      size_t len;
> >>      };
> >> //-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> >> //
> >> //  The top-level object that gets allocated once, when the module is
> >> //  installed.
> >> //
> >> struct INFO {
> >>      struct file_operations fa;          // Kernel connection
> >>      struct semaphore dev_sem;
> >>      struct DMA dma[NR_PAGES];           // Can map one megabyte
> >>      uint32_t vm_start;                  // Where mmap() starts
> >>      uint32_t pages;                     // Number of pages mapped
> >>      atomic_t open;                      // Number of opens
> >>      };
> >> //-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> >> static struct INFO *info;
> >> //-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> >> //
> >> //   Initialize the module and return 0 if everything is okay.
> >> //   Return a negative error-code if not.
> >> //
> >> static int32_t startup()
> >> {
> >>      if((info = kmalloc(sizeof(struct INFO), GFP_KERNEL)) == NULL) {
> >>          printk(KERN_ALERT"%s : Can't allocate memory\n", devname);
> >
> > Missing space after KERN_ALERT?
> 
> I certainly hope that it's not the problem! That would
> invalidate both the kernel and the compiler!

It was the only thing that looked a bit odd.  Although white space
generally shouldn't matter in C.

Well maybe the module was just compiled against a different source tree
than the running kernel it was loaded into.

I suppose comment out the printk and see if it's breaking on that line
or somewhere else.  Or just make it a printk with no variables.

--
Len Sorensen
