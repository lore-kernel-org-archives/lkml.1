Return-Path: <linux-kernel-owner+w=401wt.eu-S1161629AbXBOWwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161629AbXBOWwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161630AbXBOWwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:52:04 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52007 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161629AbXBOWwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:52:02 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Len Brown <lenb@kernel.org>
Cc: john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, auke-jan.h.kok@intel.com,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: e1000_intr in request_irq faults in 2.6.20-git
References: <200702151728.07726.lenb@kernel.org>
Date: Thu, 15 Feb 2007 15:50:32 -0700
In-Reply-To: <200702151728.07726.lenb@kernel.org> (Len Brown's message of
	"Thu, 15 Feb 2007 17:28:06 -0500")
Message-ID: <m1y7mzhw7b.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

> e1000 faults in 2.6.20-git, while 2.6.20 worked fine.
>
> System is a D875PBZ with LOM.
>
> clues?

I'm guessing this is an old bug found by the following bit of
debug coded added into since v2.6.20

+#ifdef CONFIG_DEBUG_SHIRQ
+       if (irqflags & IRQF_SHARED) {
+               /*
+                * It's a shared IRQ -- the driver ought to be prepared for it
+                * to happen immediately, so let's make sure....
+                * We do this before actually registering it, to make sure that
+                * a 'real' IRQ doesn't run in parallel with our fake
+                */
+               if (irqflags & IRQF_DISABLED) {
+                       unsigned long flags;
+
+                       local_irq_save(flags);
+                       handler(irq, dev_id);
+                       local_irq_restore(flags);
+               } else
+                       handler(irq, dev_id);
+       }
+#endif

I don't have a clue why the e1000 wasn't ready though.

Eric


>
> Bringing up loopback interface:  [  OK  ]
> Bringing up interface eth0: BUG: unable to handle kernel NULL pointer
> dereference at virtual address 00000000
>  printing eip:
> *pde = 3747c001
> Oops: 0000 [#1]
> SMP
> Modules linked in: dm_mod video thermal sbs i2c_ec fan button dock battery
> asus_acpi ac lp intel_agp agpgart ehci_hcd parport_serial parpt
> CPU:    0
> EIP:    0060:[<00000000>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.20-g724339d7 #32)
> EIP is at _stext+0x3fefed10/0x14
> eax: c21cd3a0   ebx: f8840000   ecx: 00000000   edx: c22d2e44
> esi: c21cd3a0   edi: 00000000   ebp: c21cd564   esp: f755de6c
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process ip (pid: 2975, ti=f755d000 task=f75590b0 task.ti=f755d000)
> Stack: c02a2077 fffffff4 f7987404 00000000 c02a1fc3 c0140cb5 00000010 012321b4
>        c21cd3a0 c21cd000 c21cd000 00000000 c02a1a71 c21cd000 c21cd000 c21cd3a0
>        00000000 c21cd3a0 00000000 c02a4916 c21cd000 00001003 00001002 c03b3751
> Call Trace:
>  [<c02a2077>] e1000_intr+0xb4/0x107
>  [<c02a1fc3>] e1000_intr+0x0/0x107
>  [<c0140cb5>] request_irq+0xa5/0xcc
>  [<c02a1a71>] e1000_request_irq+0xad/0xe6
>  [<c02a4916>] e1000_open+0x43/0xbd
>  [<c03b3751>] dev_open+0x2b/0x62
>  [<c03b224d>] dev_change_flags+0x47/0xe4
>  [<c03eb20e>] devinet_ioctl+0x250/0x56d
>  [<c03b3348>] dev_ifsioc+0x113/0x38d
>  [<c021f4ee>] copy_to_user+0x2d/0x43
>  [<c03a9a28>] sock_ioctl+0x19f/0x1be
>  [<c03a9889>] sock_ioctl+0x0/0x1be
>  [<c0168767>] do_ioctl+0x1f/0x62
>  [<c01689ee>] vfs_ioctl+0x244/0x256
>  [<c0168a33>] sys_ioctl+0x33/0x4c
>  [<c0103d88>] sysenter_past_esp+0x5d/0x81
>  =======================
> Code:  Bad EIP value.
> EIP: [<00000000>] _stext+0x3fefed10/0x14 SS:ESP 0068:f755de6c
> /etc/sysconfig/network-scripts/ifup-eth: line 272: 2975 Segmentation fault ip
> link set dev ${REALDEVICE} up
> Failed to bring up eth0.
> [FAILED]
