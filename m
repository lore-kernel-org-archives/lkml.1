Return-Path: <linux-kernel-owner+w=401wt.eu-S2992835AbXEBG3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992835AbXEBG3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992823AbXEBG3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:29:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992847AbXEBG32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:29:28 -0400
Date: Tue, 1 May 2007 23:29:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matt_Domsch@dell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edd: Switch to refcounting PCI APIs
Message-Id: <20070501232917.60d9d0d1.akpm@linux-foundation.org>
In-Reply-To: <20070423145255.3ff4369e@the-village.bc.nu>
References: <20070423145255.3ff4369e@the-village.bc.nu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 14:52:55 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/firmware/edd.c linux-2.6.21-rc6-mm1/drivers/firmware/edd.c
> --- linux.vanilla-2.6.21-rc6-mm1/drivers/firmware/edd.c	2007-04-12 14:14:43.000000000 +0100
> +++ linux-2.6.21-rc6-mm1/drivers/firmware/edd.c	2007-04-23 11:50:57.185158272 +0100
> @@ -669,7 +669,7 @@
>  	struct edd_info *info = edd_dev_get_info(edev);
>  
>  	if (edd_dev_is_type(edev, "PCI")) {
> -		return pci_find_slot(info->params.interface_path.pci.bus,
> +		return pci_get_slot(info->params.interface_path.pci.bus,
>  				     PCI_DEVFN(info->params.interface_path.pci.slot,
>  					       info->params.interface_path.pci.
>  					       function));
> @@ -682,9 +682,12 @@
>  {
>  
>  	struct pci_dev *pci_dev = edd_get_pci_dev(edev);
> +	int ret;
>  	if (!pci_dev)
>  		return 1;
> -	return sysfs_create_link(&edev->kobj,&pci_dev->dev.kobj,"pci_dev");
> +	ret = sysfs_create_link(&edev->kobj,&pci_dev->dev.kobj,"pci_dev");
> +	pci_dev_put(pci_dev);
> +	return ret;
>  }
> 

This escaped notice:

 
drivers/firmware/edd.c: In function 'edd_get_pci_dev':
drivers/firmware/edd.c:673: warning: passing argument 1 of 'pci_get_slot' makes pointer from integer without a cast



But this didn't:

Calling initcall 0xc0534e00: edd_init+0x0/0x2c0()
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000014
 printing eip:
c029ed16
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in:
CPU:    1
EIP:    0060:[<c029ed16>]    Not tainted VLI
EFLAGS: 00010286   (2.6.21-mm1 #2)
EIP is at pci_get_slot+0x26/0x90
eax: c04e9280   ebx: 00000000   ecx: 00000204   edx: 00000001
esi: 00000020   edi: c0499789   ebp: c242ff30   esp: c242ff18
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 1, ti=c242e000 task=c242d550 task.ti=c242e000)
Stack: c04ff358 0000000d c242ff30 c01b8b6f c326ec0c c0568ac1 c242ff70 c053505e 
       c326ec18 c04a2d9a 00000081 00000006 00000000 00000000 00000001 00000000 
       c326ec18 c0568a92 c0568a92 00000000 00000000 00000000 c242ffe0 c05185c2 
Call Trace:
 [<c0103e2a>] show_trace_log_lvl+0x1a/0x30
 [<c0103ee9>] show_stack_log_lvl+0xa9/0xd0
 [<c01040f9>] show_registers+0x1e9/0x2f0
 [<c010430f>] die+0x10f/0x240
 [<c0116369>] do_page_fault+0x2d9/0x610
 [<c03e38ea>] error_code+0x72/0x78
 [<c053505e>] edd_init+0x25e/0x2c0
 [<c05185c2>] kernel_init+0x122/0x2f0
 [<c0103a53>] kernel_thread_helper+0x7/0x14
 =======================
Code: 5d c3 8d 76 00 55 89 e5 56 89 d6 53 89 c3 83 ec 10 89 e0 25 00 e0 ff ff f7 40 14 00 ff ff 0f 75 46 b8 80 92 4e c0 e8 2a 7b e9 ff <8b> 43 14 8d 4b 14 eb 04 89 f6 89 d0 8b 10 0f 18 02 90 39 c8 74 
EIP: [<c029ed16>] pci_get_slot+0x26/0x90 SS:ESP 0068:c242ff18

