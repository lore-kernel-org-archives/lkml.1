Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0CHUsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:48:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60569 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab0CHUsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:48:08 -0500
Message-ID: <4B956283.10706@canonical.com>
Date: Mon, 08 Mar 2010 21:48:03 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/20] KVM: x86 emulator: fix memory access during x86
 emulation
References: <1266414330-27444-1-git-send-email-avi@redhat.com> <1266414330-27444-14-git-send-email-avi@redhat.com> <4B925E66.5@canonical.com> <4B937AF5.5020004@redhat.com> <4B950542.2030306@canonical.com> <4B9505E6.1040501@redhat.com>
In-Reply-To: <4B9505E6.1040501@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 03/08/2010 04:10 PM, Stefan Bader wrote:
>> Avi Kivity wrote:
>>   
>>> On 03/06/2010 03:53 PM, Stefan Bader wrote:
>>>     
>>>> i Avi,
>>>>
>>>> we currently try to integrate this patch for an update into a 2.6.32
>>>> based
>>>> system (amongst other kvm updates). But as soon as this patch gets
>>>> added kvm
>>>> will die on startup in kvm_leave_lazy_mmu. This has been documented
>>>> here:
>>>>
>>>> https://bugs.edge.launchpad.net/ubuntu/+source/linux/+bug/531823
>>>>
>>>> I have placed the backports of your patches, which are currently in
>>>> linux-next
>>>> and marked for stable here:
>>>>
>>>> git://kernel.ubuntu.com/smb/linux-2.6.32.y kvm
>>>>
>>>> I have tested the failure with a version that got only the following
>>>> patches in:
>>>> KVM: x86 emulator: Add Virtual-8086 mode of emulation
>>>> KVM: x86 emulator: fix memory access during x86 emulation
>>>> KVM: x86 emulator: Check IOPL level during io instruction emulation
>>>> KVM: x86 emulator: Fix popf emulation
>>>> KVM: x86 emulator: Check CPL level during privilege instruction
>>>> emulation
>>>>
>>>> and also with a version that takes all stable patches up to the bad
>>>> one:
>>>> KVM: VMX: Trap and invalid MWAIT/MONITOR instruction
>>>> KVM: x86 emulator: Add group8 instruction decoding
>>>> KVM: x86 emulator: Add group9 instruction decoding
>>>> KVM: x86 emulator: Add Virtual-8086 mode of emulation
>>>> KVM: x86 emulator: fix memory access during x86 emulation
>>>>
>>>> But as soon as the fix for memory access gets added, the bug will
>>>> occur. Would
>>>> you have an idea what might be causing this?
>>>>
>>>>        
>>> Does the same guest, using the same qemu-kvm, work on kvm.git or
>>> upstream?
>>>
>>>      
>> The test was done with a kvm user-space package based on 0.12.3 (which
>> seems to
>> be the current upstream version). I try to do a test on the git version.
>>    
> 
> I meant keep the same userspace without change, and try it on a Linus
> kernel or kvm.git master
> (http://git.kernel.org/?p=virt/kvm/kvm.git;a=summary).
> 
HEAD of kvm.git tree works (with same client and userspace)
Stable 2.6.32.y tree plus all patches marked cc: stable fails.

(32bit host/guest)
Host dmesg:
kvm: emulating exchange as write

Guest dmesg:
...
[    3.053503] Freeing initrd memory: 8843k freed
[    3.059863] Freeing unused kernel memory: 660k freed
[    3.076657] Write protecting the kernel text: 4780k
[    3.082863] Write protecting the kernel read-only data: 1912k
[    3.086666] BUG: unable to handle kernel paging request at c01292e3
[    3.088025] IP: [<c01292e3>] kvm_leave_lazy_mmu+0x43/0x70
[    3.088025] *pde = 00910067 *pte = 00129161
[    3.088025] Oops: 0003 [#1] SMP
[    3.088025] last sysfs file:
[    3.088025] Modules linked in:
[    3.088025]
[    3.088025] Pid: 1, comm: init Not tainted (2.6.32-15-generic #22-Ubuntu) Bochs
[    3.088025] EIP: 0060:[<c01292e3>] EFLAGS: 00010246 CPU: 0
[    3.088025] EIP is at kvm_leave_lazy_mmu+0x43/0x70
[    3.088025] EAX: 00000002 EBX: 00000018 ECX: 01802c20 EDX: 00000000
[    3.088025] ESI: c1802c20 EDI: c1802c20 EBP: df071cb4 ESP: df071ca8
[    3.088025]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    3.088025] Process init (pid: 1, ti=df070000 task=df068000 task.ti=df070000)
[    3.088025] Stack:
[    3.088025]  c0000000 dce2b000 dce2a844 df071cf0 c01e8b6d 00000000 00000001
bffff000
[    3.088025] <0> 00000000 db7ed000 c139d54c c139d54c df133000 db7ed000
1ffef067 bffff000
[    3.088025] <0> bfe10000 db44bbfc df071d2c c01e8ce0 c0000000 df133000
db44bbfc bfe10000
[    3.088025] Call Trace:
[    3.088025]  [<c01e8b6d>] ? move_ptes+0x1ad/0x270
[    3.088025]  [<c01e8ce0>] ? move_page_tables+0xb0/0x130
[    3.088025]  [<c020b614>] ? shift_arg_pages+0x94/0x180
[    3.088025]  [<c020b885>] ? setup_arg_pages+0x185/0x1b0
[    3.088025]  [<c0241243>] ? load_elf_binary+0x3c3/0xac0
[    3.088025]  [<c02f1654>] ? security_file_permission+0x14/0x20
[    3.088025]  [<c02052f4>] ? rw_verify_area+0x64/0xe0
[    3.088025]  [<c0240e80>] ? load_elf_binary+0x0/0xac0
[    3.088025]  [<c020bd9f>] ? search_binary_handler+0xef/0x2f0
[    3.088025]  [<c020b465>] ? kernel_read+0x35/0x50
[    3.088025]  [<c023f7b2>] ? load_script+0x1e2/0x270
[    3.088025]  [<c01e4160>] ? get_user_pages+0x50/0x60
[    3.088025]  [<c020a662>] ? get_arg_page+0x52/0xb0
[    3.088025]  [<c023f5d0>] ? load_script+0x0/0x270
[    3.088025]  [<c020bd9f>] ? search_binary_handler+0xef/0x2f0
[    3.088025]  [<c020a834>] ? copy_strings+0x174/0x190
[    3.088025]  [<c020c2c7>] ? do_execve+0x1f7/0x2c0
[    3.088025]  [<c034ed6a>] ? strncpy_from_user+0x3a/0x70
[    3.088025]  [<c0101a1d>] ? sys_execve+0x2d/0x60
[    3.088025]  [<c01033ec>] ? syscall_call+0x7/0xb
[    3.088025]  [<c01070a4>] ? kernel_execve+0x24/0x30
[    3.088025]  [<c01012ac>] ? run_init_process+0x1c/0x20
[    3.088025]  [<c0101396>] ? init_post+0xe6/0x100
[    3.088025]  [<c07d83d0>] ? kernel_init+0xb8/0xbf
[    3.088025]  [<c07d8318>] ? kernel_init+0x0/0xbf
[    3.088025]  [<c0104087>] ? kernel_thread_helper+0x7/0x10
[    3.088025] Code: 6c 87 c0 64 a1 40 6a 87 c0 03 3c 85 80 4a 7d c0 8b 9f 00 04
00 00 85 db 74 24 89 fe 31 d2 66 90 8d 8e 00 00 00 40 b8 02 00 00 00 <0f> 01 c1
01 c6 29 c3 75 ec c7 87 00 04 00 00 00 00 00 00 e8 e5
[    3.088025] EIP: [<c01292e3>] kvm_leave_lazy_mmu+0x43/0x70 SS:ESP 0068:df071ca8
[    3.088025] CR2: 00000000c01292e3
[    3.088025] ---[ end trace 85e247d11bf9c7e0 ]---
[    3.088025] note: init[1] exited with preempt_count 2
[    3.141968] BUG: scheduling while atomic: init/1/0x00000002
[    3.143101] Modules linked in:
[    3.143723] Pid: 1, comm: init Tainted: G      D    2.6.32-15-generic #22-Ubuntu
[    3.145183] Call Trace:
[    3.145674]  [<c013d562>] __schedule_bug+0x62/0x70
[    3.146646]  [<c05a37d4>] schedule+0x614/0x840
[    3.147497]  [<c05a9bcc>] ? smp_apic_timer_interrupt+0x5c/0x8b
[    3.148636]  [<c0103df1>] ? apic_timer_interrupt+0x31/0x40
[    3.149690]  [<c05a53b5>] rwsem_down_failed_common+0x75/0x1a0
[    3.150977]  [<c05a552d>] rwsem_down_read_failed+0x1d/0x30
[    3.152040]  [<c05a5587>] call_rwsem_down_read_failed+0x7/0x10
[    3.153149]  [<c05a4aec>] ? down_read+0x1c/0x20
[    3.154017]  [<c01878ef>] acct_collect+0x3f/0x170
[    3.154976]  [<c014ec12>] do_exit+0x262/0x310
[    3.155808]  [<c05a6595>] oops_end+0x95/0xd0
[    3.156642]  [<c01292e3>] ? kvm_leave_lazy_mmu+0x43/0x70
[    3.157660]  [<c012b2cc>] no_context+0xbc/0xe0
[    3.158545]  [<c01292e3>] ? kvm_leave_lazy_mmu+0x43/0x70
[    3.159553]  [<c01292e3>] ? kvm_leave_lazy_mmu+0x43/0x70
[    3.160627]  [<c012b32c>] __bad_area_nosemaphore+0x3c/0x160
[    3.161838]  [<c01c89ba>] ? T.903+0x3da/0x480
[    3.162741]  [<c01292e3>] ? kvm_leave_lazy_mmu+0x43/0x70
[    3.163772]  [<c012b467>] bad_area_nosemaphore+0x17/0x20
[    3.164809]  [<c05a7d56>] do_page_fault+0x2f6/0x380
[    3.165744]  [<c05a7a60>] ? do_page_fault+0x0/0x380
[    3.166737]  [<c05a5a63>] error_code+0x73/0x80
[    3.167595]  [<c01292e3>] ? kvm_leave_lazy_mmu+0x43/0x70
[    3.168629]  [<c01e8b6d>] move_ptes+0x1ad/0x270
[    3.169495]  [<c01e8ce0>] move_page_tables+0xb0/0x130
[    3.170525]  [<c020b614>] shift_arg_pages+0x94/0x180
[    3.171476]  [<c020b885>] setup_arg_pages+0x185/0x1b0
[    3.172461]  [<c0241243>] load_elf_binary+0x3c3/0xac0
[    3.173429]  [<c02f1654>] ? security_file_permission+0x14/0x20
[    3.174609]  [<c02052f4>] ? rw_verify_area+0x64/0xe0
[    3.175555]  [<c0240e80>] ? load_elf_binary+0x0/0xac0
[    3.176533]  [<c020bd9f>] search_binary_handler+0xef/0x2f0
[    3.177588]  [<c020b465>] ? kernel_read+0x35/0x50
[    3.178551]  [<c023f7b2>] load_script+0x1e2/0x270
[    3.179465]  [<c01e4160>] ? get_user_pages+0x50/0x60
[    3.180430]  [<c020a662>] ? get_arg_page+0x52/0xb0
[    3.181346]  [<c023f5d0>] ? load_script+0x0/0x270
[    3.182244]  [<c020bd9f>] search_binary_handler+0xef/0x2f0
[    3.183371]  [<c020a834>] ? copy_strings+0x174/0x190
[    3.184341]  [<c020c2c7>] do_execve+0x1f7/0x2c0
[    3.185210]  [<c034ed6a>] ? strncpy_from_user+0x3a/0x70
[    3.186203]  [<c0101a1d>] sys_execve+0x2d/0x60
[    3.187101]  [<c01033ec>] syscall_call+0x7/0xb
[    3.187945]  [<c01070a4>] ? kernel_execve+0x24/0x30
[    3.188890]  [<c01012ac>] ? run_init_process+0x1c/0x20
[    3.189874]  [<c0101396>] ? init_post+0xe6/0x100
[    3.190828]  [<c07d83d0>] ? kernel_init+0xb8/0xbf
[    3.191873]  [<c07d8318>] ? kernel_init+0x0/0xbf
[    3.192777]  [<c0104087>] ? kernel_thread_helper+0x7/0x10
[    3.524180] Clocksource tsc unstable (delta = -140394173 ns)
