Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbYIIUhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbYIIUhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYIIUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:37:05 -0400
Received: from gw.goop.org ([64.81.55.164]:45785 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYIIUhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:37:03 -0400
Message-ID: <48C6DE6E.1070804@goop.org>
Date: Tue, 09 Sep 2008 13:37:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Xen: Fix pte unpin BUG when !CONFIG_SMP
References: <> <1220959508-13806-1-git-send-email-alex.nixon@citrix.com> <48C6BB00.9040607@goop.org> <48C6CCD7.8030800@citrix.com>
In-Reply-To: <48C6CCD7.8030800@citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
> Jeremy Fitzhardinge wrote:
>> Alex Nixon wrote:
>>  
>>> We still need to pin PTEs, even if there are no PTE locks. 
>>> Otherwise we'll BUG whenever there aren't PTE locks (i.e. whenever
>>> NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS), as we try to unpin PTEs which
>>> were never pinned in the first place.
>>>       
>>
>> Where does the unpin happen?  xen_unpin_page() also checks to see if it
>> took the lock before trying to unpin, symmetric with xen_pin_page().
>>
>>     J
>>   
> Here's the backtrace of the BUG() the patch addresses.  Now you've
> pointed it out - I see the asymmetry - and also suspect some ptes are
> being left pinned.
>
> I'm having trouble finding a cleaner solution which solves this but
> doesn't incite more BUGs.
> Perhaps you have an idea?

Right, I see.  We shouldn't be pinning ptes on attachment in
xen_alloc_ptpage() if we're not using split pte locks.

    J

>
> - Alex
>
>
> ------------[ cut here ]------------
> kernel BUG at
> /local/scratch/hotplug.linux.trees.git/arch/x86/xen/enlighten.c:847!
> invalid opcode: 0000 [#1]
> Modules linked in:
>
> Pid: 1, comm: init Tainted: G        W (2.6.27-rc5-tip #352)
> EIP: 0061:[<c10038fe>] EFLAGS: 00010282 CPU: 0
> EIP is at pin_pagetable_pfn+0x3f/0x4b
> EAX: ffffffea EBX: df82bd7c ECX: 00000001 EDX: 00000000
> ESI: 00007ff0 EDI: c1a579e0 EBP: df82bd94 ESP: df82bd7c
> DS: 007b ES: 007b FS: 0000 GS: 0000 SS: e021
> Process init (pid: 1, ti=df82a000 task=df82c000 task.ti=df82a000)
> Stack: 00000004 0014a0a1 00000000 0001fb4f c1a579e0 c1a579e0 df82bda4
> c1003dd3
>       003f69e0 c157e024 df82bdac c1003e0e df82bdc8 c101b577 00000000
> 00000000
>       003f69e0 c1661000 dfb4e000 df82be28 c1062d35 1fb4f067 00000000
> dfb4e000
> Call Trace:
> [<c1003dd3>] ? xen_release_ptpage+0x61/0x80
> [<c1003e0e>] ? xen_release_pte+0xd/0xf
> [<c101b577>] ? __pte_free_tlb+0x46/0x5f
> [<c1062d35>] ? free_pgd_range+0x1dc/0x391
> [<c10794e5>] ? setup_arg_pages+0x1b8/0x22b
> [<c109b3cb>] ? load_elf_binary+0x3f1/0x10c6
> [<c1062206>] ? get_user_pages+0x316/0x394
> [<c1078bef>] ? get_arg_page+0x2c/0x7e
> [<c1078bc1>] ? put_arg_page+0x8/0xa
> [<c1078d97>] ? copy_strings+0x156/0x160
> [<c1078e51>] ? search_binary_handler+0x7b/0x1c0
> [<c1079e20>] ? do_execve+0x13a/0x1c4
> [<c1007164>] ? sys_execve+0x29/0x4b
> [<c1008a2e>] ? syscall_call+0x7/0xb
> [<c100b11f>] ? kernel_execve+0x17/0x1c
> [<c1003140>] ? run_init_process+0x17/0x19
> [<c10031e8>] ? init_post+0xa6/0xf6
> [<c100965f>] ? kernel_thread_helper+0x7/0x10
> =======================
>

