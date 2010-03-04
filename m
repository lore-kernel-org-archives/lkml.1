Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab0CDFXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 00:23:49 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:44008 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0CDFXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 00:23:46 -0500
Message-ID: <4B8F43DD.10002@in.ibm.com>
Date: Thu, 04 Mar 2010 10:53:41 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: -next March 3: Boot failure on x86 (Oops)
References: <20100303174603.5be197ba.sfr@canb.auug.org.au> <4B8E83D4.6090507@in.ibm.com> <4B8F0CD0.1040507@kernel.org>
In-Reply-To: <4B8F0CD0.1040507@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On 03/04/2010 12:44 AM, Sachin Sant wrote:
>   
>> Today's next failed to boot on x86 box with following trace
>>
>> Unpacking initramfs...
>> Freeing initrd memory: 10584k freed
>> BUG: unable to handle kernel NULL pointer dereference at (null)
>> IP: [<c01a6b12>] pcpu_alloc+0x1cb/0x75e
>> *pdpt = 00000000005dd001 *pde = 0000000000000000
>> Oops: 0000 [#1] SMP
>> last sysfs file:
>> Modules linked in:
>>
>> Pid: 1, comm: swapper Not tainted 2.6.33-autotest-next-20100303 #1
>> /eserver xSeries 235 -[86717AX]-
>> EIP: 0060:[<c01a6b12>] EFLAGS: 00010002 CPU: 1
>> EIP is at pcpu_alloc+0x1cb/0x75e
>> EAX: 00000000 EBX: c05c4100 ECX: cccccccc EDX: 00000000
>> ESI: 000000b0 EDI: 00000005 EBP: f5c69fa8 ESP: f5c69f2c
>> DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> Process swapper (pid: 1, ti=f5c68000 task=f5c66ce0 task.ti=f5c68000)
>> Stack:
>> 00000000 00000005 61746164 0a383d29 5f656400 61746164 00000004 000000b0
>> <0> 000a3036 00000286 61637061 29656863 0a36313d c0579100 c058da30 f5c69f94
>> <0> c01310be c05c41cc 00000028 c058da30 f5c69fa4 c0116a73 c0492091 c0492089
>> Call Trace:
>> [<c058da30>] ? crash_save_vmcoreinfo_init+0x0/0x31a
>> [<c01310be>] ? log_buf_kexec_setup+0x3f/0x67
>> [<c058da30>] ? crash_save_vmcoreinfo_init+0x0/0x31a
>> [<c0116a73>] ? arch_crash_save_vmcoreinfo+0x37/0x3c
>> [<c058d9ff>] ? crash_notes_memory_init+0x0/0x31
>> [<c01a70be>] ? __alloc_percpu+0xa/0xc
>> [<c058da11>] ? crash_notes_memory_init+0x12/0x31
>> [<c0101139>] ? do_one_initcall+0x4c/0x131
>> [<c057b352>] ? kernel_init+0x127/0x178
>> [<c057b22b>] ? kernel_init+0x0/0x178
>> [<c0102df6>] ? kernel_thread_helper+0x6/0x10
>> Code: 45 a8 e9 65 ff ff ff 8b 4d 9c 8b 55 a0 8b 45 84 e8 31 fa ff ff 85
>> c0 89 45 a4 0f 89 fd 00 00 00 8b 45 84 8b 00 89 45 84 8b 55 84 <8b> 02
>> 0f 18 00 90 8b 45 cc 03 05 a0 9b 57 c0 39 c2 0f 85 67 ff
>> EIP: [<c01a6b12>] pcpu_alloc+0x1cb/0x75e SS:ESP 0068:f5c69f2c
>> CR2: 0000000000000000
>> ---[ end trace a7919e7f17c0a725 ]---
>>
>> x86_64 boots fine. Have attached dmesg log.
>>     
>
> Can you please feed the address to gdb and get the line number?  Also,
> is it reproducible on mainline?
>   
I can recreate this with latest git as well (2.6.33-git9 [eaa5eec7..])

Disassembly from 2.6.33-git9 code base follows :

/usr/local/autobench/var/tmp/build/linux/mm/percpu.c:1137
                        if (off >= 0)
     e91:       0f 89 fd 00 00 00       jns    f94 <pcpu_alloc+0x2bd>
/usr/local/autobench/var/tmp/build/linux/mm/percpu.c:1116
        }

restart:
        /* search through normal chunks */
        for (slot = pcpu_size_to_slot(size); slot < pcpu_nr_slots; slot++) {
                list_for_each_entry(chunk, &pcpu_slot[slot], list) {
     e97:       8b 45 84                mov    -0x7c(%ebp),%eax
     e9a:       8b 00                   mov    (%eax),%eax
     e9c:       89 45 84                mov    %eax,-0x7c(%ebp)
prefetch():
/usr/local/autobench/var/tmp/build/linux/arch/x86/include/asm/processor.h:886
     e9f:       8b 55 84                mov    -0x7c(%ebp),%edx
     ea2:       8b 02                   mov    (%edx),%eax

^^^^^^^^^^^^^^^^^^^ EIP corresponds to this line

     ea4:       8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi
pcpu_alloc():
/usr/local/autobench/var/tmp/build/linux/mm/percpu.c:1116
     ea8:       8b 45 cc                mov    -0x34(%ebp),%eax
     eab:       03 05 30 00 00 00       add    0x30,%eax
     eb1:       39 c2                   cmp    %eax,%edx

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

