Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbYCEQup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbYCEQup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759627AbYCEQuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:50:35 -0500
Received: from gw.goop.org ([64.81.55.164]:56285 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234AbYCEQud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:50:33 -0500
Message-ID: <47CECE14.8090808@goop.org>
Date: Wed, 05 Mar 2008 08:45:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
References: <47CDBB87.8090906@goop.org> <20080304212821.GB8944@elte.hu> <47CDBEDC.1050302@goop.org> <20080305064814.GB28398@elte.hu>
In-Reply-To: <20080305064814.GB28398@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>
>>>   
>>>       
>>>> I think set_pmd_pfn, which is only called by __set_fixmap, might have a 
>>>> preempt bug in it.
>>>>     
>>>>         
>>> yes, and we had similar preemption bugs in the past. I guess most places 
>>> are either infrequent or have some natural atomicity anyway. Wanna send a 
>>> patch?
>>>       
>> Sure.  Should it just disable preemption, or take a lock?  It calls 
>> set_pte_at without holding any pte locks; that seems to be relatively 
>> common.  Is it OK when you're operating on init_mm?
>>     
>
> no, it's not OK to modify the kernel pagetable without locking - taking 
> the pgd_lock should do the trick. Could you send the stacktrace that 
> shows the place that is preemptible?
So far I've noticed two places:

1. __set_fixmap to set up the vdso compat mapping (set_pte_at and tlb 
flush):

BUG: using smp_processor_id() in preemptible [00000000] code: init/1
caller is paravirt_get_lazy_mode+0xe/0x1b
Pid: 1, comm: init Not tainted 2.6.25-rc3-x86-latest.git #196
 [<c022be65>] debug_smp_processor_id+0x99/0xb0
 [<c011aa88>] paravirt_get_lazy_mode+0xe/0x1b
 [<c0105092>] xen_set_pte_at+0x2e/0xc0
 [<c011d322>] __set_fixmap+0x14a/0x176
 [<c011e4bb>] arch_setup_additional_pages+0x83/0x11d
 [<c01934a3>] load_elf_binary+0xad8/0x113a
 [<c016d410>] ? vfs_read+0xef/0x106
 [<c01700dd>] search_binary_handler+0xb8/0x19f
 [<c01929cb>] ? load_elf_binary+0x0/0x113a
 [<c01703ab>] ? prepare_binprm+0xc3/0xcb
 [<c0192375>] load_script+0x179/0x18c
 [<c0159caf>] ? get_user_pages+0x31d/0x397
 [<c016fe47>] ? get_arg_page+0x2d/0x80
 [<c01700dd>] search_binary_handler+0xb8/0x19f
 [<c01921fc>] ? load_script+0x0/0x18c
 [<c0171302>] do_execve+0x121/0x16a
 [<c01067d9>] sys_execve+0x29/0x52
 [<c0108286>] syscall_call+0x7/0xb
 [<c017007b>] ? search_binary_handler+0x56/0x19f
 [<c010af2f>] ? kernel_execve+0x17/0x1c
 [<c010217f>] ? _stext+0x17/0x19
 [<c01021d6>] ? init_post+0x55/0xbb
 [<c01035e7>] ? xen_irq_disable+0x21/0x23
 [<c010828f>] ? syscall_exit+0x5/0x1d
 [<c0108ee7>] ? kernel_thread_helper+0x7/0x10
 =======================
BUG: using smp_processor_id() in preemptible [00000000] code: init/1
caller is xen_flush_tlb_single+0x11/0x89
Pid: 1, comm: init Not tainted 2.6.25-rc3-x86-latest.git #196
 [<c022be65>] debug_smp_processor_id+0x99/0xb0
 [<c0103c0b>] xen_flush_tlb_single+0x11/0x89
 [<c011d33f>] __set_fixmap+0x167/0x176
 [<c011e4bb>] arch_setup_additional_pages+0x83/0x11d
 [<c01934a3>] load_elf_binary+0xad8/0x113a
 [<c016d410>] ? vfs_read+0xef/0x106
 [<c01700dd>] search_binary_handler+0xb8/0x19f
 [<c01929cb>] ? load_elf_binary+0x0/0x113a
 [<c01703ab>] ? prepare_binprm+0xc3/0xcb
 [<c0192375>] load_script+0x179/0x18c
 [<c0159caf>] ? get_user_pages+0x31d/0x397
 [<c016fe47>] ? get_arg_page+0x2d/0x80
 [<c01700dd>] search_binary_handler+0xb8/0x19f
 [<c01921fc>] ? load_script+0x0/0x18c
 [<c0171302>] do_execve+0x121/0x16a
 [<c01067d9>] sys_execve+0x29/0x52
 [<c0108286>] syscall_call+0x7/0xb
 [<c017007b>] ? search_binary_handler+0x56/0x19f
 [<c010af2f>] ? kernel_execve+0x17/0x1c
 [<c010217f>] ? _stext+0x17/0x19
 [<c01021d6>] ? init_post+0x55/0xbb
 [<c01035e7>] ? xen_irq_disable+0x21/0x23
 [<c010828f>] ? syscall_exit+0x5/0x1d
 [<c0108ee7>] ? kernel_thread_helper+0x7/0x10
 =======================


2. and vmalloc:

BUG: using smp_processor_id() in preemptible [00000000] code: multipath.stati/1981
caller is paravirt_get_lazy_mode+0xe/0x1b
Pid: 1981, comm: multipath.stati Not tainted 2.6.25-rc3-x86-latest.git #196
 [<c022be65>] debug_smp_processor_id+0x99/0xb0
 [<c011aa88>] paravirt_get_lazy_mode+0xe/0x1b
 [<c0105092>] xen_set_pte_at+0x2e/0xc0
 [<c015f736>] map_vm_area+0x1fa/0x255
 [<c015fc83>] __vmalloc_area_node+0xdb/0xfa
 [<c015fceb>] __vmalloc_node+0x49/0x58
 [<c015fd26>] __vmalloc+0x10/0x12
 [<c015fdca>] vmalloc+0x19/0x1b
 [<c038d3b4>] dm_ctl_ioctl+0x155/0x248
 [<c038c56b>] ? list_versions+0x0/0x79
 [<c0103c00>] ? xen_flush_tlb_single+0x6/0x89
 [<c038d25f>] ? dm_ctl_ioctl+0x0/0x248
 [<c01767be>] vfs_ioctl+0x22/0x67
 [<c0176a54>] do_vfs_ioctl+0x251/0x268
 [<c015b45f>] ? remove_vma+0x34/0x3a
 [<c015bdc8>] ? do_munmap+0x17d/0x197
 [<c0176a97>] sys_ioctl+0x2c/0x45
 [<c0108286>] syscall_call+0x7/0xb
 =======================

    J
