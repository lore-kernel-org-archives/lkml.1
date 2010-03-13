Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab0CMMMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:12:43 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:42913 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757068Ab0CMMMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:12:41 -0500
Message-ID: <4B9B812F.3030306@free.fr>
Date: Sat, 13 Mar 2010 13:12:31 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Siarhei Liakh <sliakh.lkml@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:x86/mm] x86, mm: NX protection for kernel data
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > looking for c17ebdb8 in system.map points to a location in pgd_lock:
> > ============================================
> > $grep c17ebd System.map
> > c17ebd68 d bios_check_work
> > c17ebda8 d highmem_pages
> > c17ebdac D pgd_lock
> > c17ebdc8 D pgd_list
> > c17ebdd0 D show_unhandled_signals
> > c17ebdd4 d cpa_lock
> > c17ebdf0 d memtype_lock
> > ============================================
> >
> > I've looked at the lock debugging and could not find any place that
> > would look like an attempt to execute data. This would lead me to
> > think that calling set_memory_nx from kernel_init somehow confuses the
> > lock debugging subsystem, or set_memory_nx does not change page
> > attributes in a safe manner (for example when a lock is stored inside
> > the page whose attributes are being changed).
> 
> I've done some extra debugging and it really does look like the crash
> happens when we are setting NX on a large page which has pgd_lock
> inside it.
> 
> Here is a trace of printk's that I added to troubleshoot this issue:
> =========================
> [    3.072003] try_preserve_large_page - enter
> [    3.073185] try_preserve_large_page - address: 0xc1600000
> [    3.074513] try_preserve_large_page - 2M page
> [    3.075606] try_preserve_large_page - about to call static_protections
> [    3.076000] try_preserve_large_page - back from static_protections
> [    3.076000] try_preserve_large_page - past loop
> [    3.076000] try_preserve_large_page - new_prot != old_prot
> [    3.076000] try_preserve_large_page - the address is aligned and
> the number of pages covers the full range
> [    3.076000] try_preserve_large_page - about to call __set_pmd_pte
> [    3.076000] __set_pmd_pte - enter
> [    3.076000] __set_pmd_pte - address: 0xc1600000
> [    3.076000] __set_pmd_pte - about to call
> set_pte_atomic(*0xc18c0058(low=0x16001e3, high=0x0), (low=0x16001e1,
> high=0x80000000))
> [lock-up here]
> =========================
> 

This may be stupid but :


0xc1600000 2MB page is in 0xc1600000-0xc1800000 range.  pgd_lock (0xc17ebdac) seems to be in that range.

You change attribute from (low=0x16001e3, high=0x0) to (low=0x16001e1, high=0x80000000). IE you set
NX bit (bit 63), but you also clear R/W bit (bit 2). So the page become read only, but you are using a lock
inside this page that need RW access. So you got a page fault.


Now I don't know what should be done.
Is that normal we set the page RO ?

Matthieu
