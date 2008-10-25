Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbYJYMoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbYJYMoO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 08:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYJYMn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 08:43:59 -0400
Received: from wmproxy1-g27.free.fr ([212.27.42.91]:10582 "EHLO
	wmproxy1-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbYJYMn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 08:43:58 -0400
Message-ID: <1224938637.4903148d28cfc@imp.free.fr>
Date: Sat, 25 Oct 2008 14:43:57 +0200
From: mathieu.taillefumier@free.fr
To: Yinghai Lu <yinghai@kernel.org>
Cc: mathieu.taillefumier@free.fr, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug] pci allocation resources problems on x86_64
References: <49019FE4.50001@free.fr> <4901A4C2.5020805@free.fr>  <200810241131.55129.jbarnes@virtuousgeek.org>  <1224879041.49022bc1562bb@imp.free.fr> <86802c440810250145qa09a9ay919203055f8e85f0@mail.gmail.com>
In-Reply-To: <86802c440810250145qa09a9ay919203055f8e85f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 84.48.202.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 > and that range it can not use that...
>
> only solution could be
>
> Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
>
> about pci_mem_start from 0xc1000000 instead of 0xc200000
>
> __init void e820_setup_gap(void)
> {
>         unsigned long gapstart, gapsize, round;
>         int found;
>
>         gapstart = 0x10000000;
>         gapsize = 0x400000;
>         found  = e820_search_gap(&gapstart, &gapsize, 0, MAX_GAP_END);
>
> #ifdef CONFIG_X86_64
>         if (!found) {
>                 gapstart = (max_pfn << PAGE_SHIFT) + 1024*1024;
>                 printk(KERN_ERR "PCI: Warning: Cannot find a gap in the 32bit
> "
>                        "address range\n"
>                        KERN_ERR "PCI: Unassigned devices with 32bit resource
> "
>                        "registers may break!\n");
>         }
> #endif
>
>         /*
>          * See how much we want to round up: start off with
>          * rounding to the next 1MB area.
>          */
>         round = 0x100000;
>         while ((gapsize >> 4) > round)
>                 round += round;
>         /* Fun with two's complement */
>         pci_mem_start = (gapstart + round) & -round;
>
>         printk(KERN_INFO
>                "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
>                pci_mem_start, gapstart, gapsize);
> }
>
>
> please check if you can change memhole size in BIOS... if not, we can
> have more patch for it....make pci_mem_start more compact...

It is not possible to modify anything from the bios at least nothing related to
memory. So what do you suggest forcing the pci_mem_start. When I look at the
dmesg file I find some open windows such as 0xc0000001 -> 0xdfffffff and
0xf0000001 -> to 0xfebffffff or something like that.

Mathieu

>
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


