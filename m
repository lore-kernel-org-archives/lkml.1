Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0CLDMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 22:12:32 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44273 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab0CLDMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 22:12:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e2HP2OFqJWsoJqF1MHYXGKCfrIk76OEn8dosnPpLNSiOV0wmYbdHcJqeOgAbf2uTFV
         wpJpr38p0x9ZEh8tXKNcbd/LEONF/IPKp/KwMlJ3nef2JSe/UhQYV9Zk7Tz/zlamamVP
         ZcILKRRmscmxw36H29+L9NWbQtrDE07ab7OhY=
MIME-Version: 1.0
In-Reply-To: <817ecb6f1003061144r3defbe0eg74e23e0986f8e42d@mail.gmail.com>
References: <817ecb6f1001311527w7914ab20sf15b800dcaa37df7@mail.gmail.com>
	 <tip-01ab31371da90a795b774d87edf2c21bb3a64dda@git.kernel.org>
	 <20100222105457.GA31148@elte.hu> <20100222110106.GA7206@elte.hu>
	 <4B82BCB0.9060903@zytor.com> <20100222172153.GA28638@elte.hu>
	 <817ecb6f1003061144r3defbe0eg74e23e0986f8e42d@mail.gmail.com>
Date: Thu, 11 Mar 2010 22:12:28 -0500
Message-ID: <817ecb6f1003111912p5ff36fcdt6e134d2d08462a9a@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, tglx@linutronix.de,
       jiang@cs.ncsu.edu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 6, 2010 at 2:44 PM, Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
> On Mon, Feb 22, 2010 at 12:21 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>> On 02/22/2010 03:01 AM, Ingo Molnar wrote:
>>> >>
>>> >>> Commit-ID:  01ab31371da90a795b774d87edf2c21bb3a64dda
>>> >>> Gitweb:     http://git.kernel.org/tip/01ab31371da90a795b774d87edf2c21bb3a64dda
[ . . . ]
> I was able to narrow down the issue to spinlock debugging. More
> specifically, DEBUG_SPINLOCK=y seem to be somehow incompatible with
> kernel's RW-data being NX.
[ . . . ]
> Kernel crash dump:
> ============================================
> [    2.844000] EXT3-fs (sda1): warning: maximal mount count reached,
> running e2fsck is recommended
> [    2.848000] EXT3-fs (sda1): using internal journal
> [    2.849556] EXT3-fs (sda1): recovery complete
> [    2.852000] EXT3-fs (sda1): mounted filesystem with ordered data mode
> [    2.854168] VFS: Mounted root (ext3 filesystem) on device 8:1.
> [    2.856000] Freeing unused kernel memory (init): 540k freed
> [    2.857056] NX-protecting the kernel data: 0xc15b3000 - 0xc1834000, 641 pages
> [    2.860328] do_page_fault - entry
> [    2.862554] do_page_fault: 0xc17ebdb8
> [    2.864000] do_page_fault - kernel space
> [    2.864000] do_page_fault - about to call bad_area_nosemaphore()
> [    2.864000] BUG: unable to handle kernel paging request at c17ebdb8
> [    2.864000] IP: [<c12609f7>] do_raw_spin_unlock+0x5e/0x71
> [    2.864000] *pdpt = 00000000018c0001 *pde = 80000000016001e1
> [    2.864000] Oops: 0003 [#1] SMP
> [    2.864000] last sysfs file:
> [    2.864000] Modules linked in:
> [    2.864000]
> [    2.864000] Pid: 1, comm: swapper Not tainted 2.6.33-tip+ #41 /
> [    2.864000] EIP: 0060:[<c12609f7>] EFLAGS: 00010046 CPU: 0
> [    2.864000] EIP is at do_raw_spin_unlock+0x5e/0x71
> [    2.864000] EAX: 00000000 EBX: c17ebdac ECX: 00000001 EDX: 00000c0b
> [    2.864000] ESI: 00000246 EDI: c18c0058 EBP: f780fe14 ESP: f780fe10
> [    2.864000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [    2.864000] Process swapper (pid: 1, ti=f780f000 task=f7826000
> task.ti=f780f000)
> [    2.864000] Stack:
> [    2.864000]  c17ebdac f780fe24 c15ad3f2 00000000 00000000 f780ff18
> c1017a57 00000000
> [    2.864000] <0> 016001e3 00000000 016001e3 f77a8004 00000001
> 00000000 00000163 80000000
> [    2.864000] <0> 00000000 ffffffff ffffffff 80000000 000001e1
> 80000000 00000000 80000000
> [    2.864000] Call Trace:
> [    2.864000]  [<c15ad3f2>] ? _raw_spin_unlock_irqrestore+0x20/0x3c
> [    2.864000]  [<c1017a57>] ? __change_page_attr_set_clr+0x65c/0x945
> [    2.864000]  [<c1092245>] ? vm_unmap_aliases+0x17b/0x186
> [    2.864000]  [<c15b3000>] ? _etext+0x0/0x24
> [    2.864000]  [<c1017eb4>] ? change_page_attr_set_clr+0x174/0x312
> [    2.864000]  [<c15b3000>] ? _etext+0x0/0x24
> [    2.864000]  [<c10182d1>] ? set_memory_nx+0x2d/0x32
> [    2.864000]  [<c10163ab>] ? mark_nxdata_nx+0x37/0x41
> [    2.864000]  [<c15b3000>] ? _etext+0x0/0x24
> [    2.864000]  [<c1834000>] ? i386_start_kernel+0x0/0xaa
> [    2.864000]  [<c101649d>] ? free_initmem+0x1c/0x1e
> [    2.864000]  [<c1001148>] ? init_post+0xd/0x121
> [    2.864000]  [<c1834401>] ? kernel_init+0x1d5/0x1df
> [    2.864000]  [<c183422c>] ? kernel_init+0x0/0x1df
> [    2.864000]  [<c1002e66>] ? kernel_thread_helper+0x6/0x10
> [    2.864000] Code: 54 8b c1 39 43 0c 74 0c ba 74 e1 73 c1 89 d8 e8
> 31 ff ff ff 64 a1 d8 6b 8b c1 39 43 08 74 0c ba 80 e1 73 c1 89 d8 e8
> 1a ff ff ff <c7> 43 0c ff ff ff ff c7 43 08 ff ff ff ff fe 03 5b 5d c3
> 55 89
> [    2.864000] EIP: [<c12609f7>] do_raw_spin_unlock+0x5e/0x71 SS:ESP
> 0068:f780fe10
> [    2.864000] CR2: 00000000c17ebdb8
> [    2.864000] ---[ end trace 0d94f53e9dfe82f9 ]---
> [    2.948071] swapper used greatest stack depth: 1804 bytes left
> [    2.952000] Kernel panic - not syncing: Attempted to kill init!
> ============================================
>
> looking for c17ebdb8 in system.map points to a location in pgd_lock:
> ============================================
> $grep c17ebd System.map
> c17ebd68 d bios_check_work
> c17ebda8 d highmem_pages
> c17ebdac D pgd_lock
> c17ebdc8 D pgd_list
> c17ebdd0 D show_unhandled_signals
> c17ebdd4 d cpa_lock
> c17ebdf0 d memtype_lock
> ============================================
>
> I've looked at the lock debugging and could not find any place that
> would look like an attempt to execute data. This would lead me to
> think that calling set_memory_nx from kernel_init somehow confuses the
> lock debugging subsystem, or set_memory_nx does not change page
> attributes in a safe manner (for example when a lock is stored inside
> the page whose attributes are being changed).

I've done some extra debugging and it really does look like the crash
happens when we are setting NX on a large page which has pgd_lock
inside it.

Here is a trace of printk's that I added to troubleshoot this issue:
=========================
[    3.072003] try_preserve_large_page - enter
[    3.073185] try_preserve_large_page - address: 0xc1600000
[    3.074513] try_preserve_large_page - 2M page
[    3.075606] try_preserve_large_page - about to call static_protections
[    3.076000] try_preserve_large_page - back from static_protections
[    3.076000] try_preserve_large_page - past loop
[    3.076000] try_preserve_large_page - new_prot != old_prot
[    3.076000] try_preserve_large_page - the address is aligned and
the number of pages covers the full range
[    3.076000] try_preserve_large_page - about to call __set_pmd_pte
[    3.076000] __set_pmd_pte - enter
[    3.076000] __set_pmd_pte - address: 0xc1600000
[    3.076000] __set_pmd_pte - about to call
set_pte_atomic(*0xc18c0058(low=0x16001e3, high=0x0), (low=0x16001e1,
high=0x80000000))
[lock-up here]
=========================
