Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbYLSRTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbYLSRTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYLSRTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:19:47 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:38422 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbYLSRTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:19:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Jmxyyhn4vYM11l5DWz/cYF6TTmD8o5MHFosctiJ3E8BVxfDUj1XhuUthATw1vc28gy
         9uZ8GQQpc/njQF4uZl0sjApzv3HrAe+Cwj40Kd2acALvVlw10gFZirMx2i35eBIqza25
         ho0X5EysqpvWhJN5WGznVGkcHCB0vsAGQnO8U=
Message-ID: <19f34abd0812190919g348b581ex9ebb2e83701899c7@mail.gmail.com>
Date: Fri, 19 Dec 2008 18:19:43 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.28-rc7: error in panic code? (NULL pointer dereference at 0000004c)
In-Reply-To: <19f34abd0812181406n48712c81j41a560aaf6ba6cd8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0812181406n48712c81j41a560aaf6ba6cd8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 11:06 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> With such a patch:
>
> diff --git a/init/main.c b/init/main.c
> index 7e117a2..2f93119 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -465,6 +465,8 @@ static void noinline __init_refok rest_init(void)
>  {
>        int pid;
>
> +       *(char *) NULL = 0;
> +
>        kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
>        numa_default_policy();
>        pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
>
> ...I would expect a page fault and that's that. So panic() is called,
> but it causes a new page fault somewhere. Here is the log:
>
> (this part is correct and expected)
>
> [    0.031003] BUG: unable to handle kernel NULL pointer dereference at 00000000
> [    0.033997] IP: [<c13b448b>] rest_init+0xf/0x57
> [    0.035997] *pde = 00000000
> [    0.037289] Oops: 0002 [#1] SMP
> [    0.037994] last sysfs file:
> [    0.037994] Modules linked in:
> [    0.037994]
> [    0.037994] Pid: 0, comm: swapper Not tainted (2.6.28-rc7 #181) 945P-A
> [    0.037994] EIP: 0060:[<c13b448b>] EFLAGS: 00010246 CPU: 0
> [    0.037994] EIP is at rest_init+0xf/0x57
> [    0.037994] EAX: c16631e3 EBX: 00000040 ECX: 00000a00 EDX: 00000000
> [    0.037994] ESI: 00099800 EDI: c160a000 EBP: c165dfd0 ESP: c165dfd0
> [    0.037994]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.037994] Process swapper (pid: 0, ti=c165c000 task=c156e334
> task.ti=c165c000)
> [    0.037994] Stack:
> [    0.037994]  c165dfe0 c16637af c1691768 00000000 c165dff8 c1663080
> 0175a000 00000000
> [    0.037994]  c14ceaae 00020800 01b7e003 00000000
> [    0.037994] Call Trace:
> [    0.037994]  [<c16637af>] ? start_kernel+0x2a2/0x2a7
> [    0.037994]  [<c1663080>] ? __init_begin+0x80/0x88
> [    0.037994] Code: 00 8b 43 04 8d 56 04 89 50 04 89 46 04 8d 43 04
> 89 46 08 89 53 04 fe 03 5b 5e 5d c3 55 b9 00 0a 00 00 8
> 9 e5 31 d2 b8 e3 31 66 c1 <c6> 05 00 00 00 00 00 e8 00 df c4 ff b9 00
> 06 00 00 31 d2 b8 af
> [    0.037994] EIP: [<c13b448b>] rest_init+0xf/0x57 SS:ESP 0068:c165dfd0
> [    0.038004] ---[ end trace 4eaa2a86a8e2da22 ]---
> [    0.038998] Kernel panic - not syncing: Attempted to kill the idle task!
>
> And now the unexpected part:
>
> [    0.039999] Rebooting in 10 seconds..<1>BUG: unable to handle
> kernel NULL pointer dereference at 0000004c
> [    0.040993] IP: [<c13b41dc>] klist_next+0x10/0x8d
> [    0.040993] *pde = 00000000
> [    0.040993] Oops: 0000 [#2] SMP
> [    0.040993] last sysfs file:
> [    0.040993] Modules linked in:
> [    0.040993]
> [    0.040993] Pid: 0, comm: swapper Tainted: G      D    (2.6.28-rc7
> #181) 945P-A
> [    0.040993] EIP: 0060:[<c13b41dc>] EFLAGS: 00010286 CPU: 0
> [    0.040993] EIP is at klist_next+0x10/0x8d
> [    0.040993] EAX: 0000003c EBX: c165dd60 ECX: 00000000 EDX: c165dd60
> [    0.040993] ESI: c165dd60 EDI: 00000000 EBP: c165dd58 ESP: c165dd48
> [    0.040993]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.040993] Process swapper (pid: 0, ti=c165c000 task=c156e334
> task.ti=c165c000)
> [    0.040993] Stack:
> [    0.040993]  c1026a97 c165dd60 c165dd60 00000000 c165dd74 c11be196
> 0000003c 00000000
> [    0.040993]  c13dbde0 00001078 00000100 c165dd84 c114ed26 c114e458
> c13dbde0 c165dd9c
> [    0.040993]  c1152546 ffffffff c13dbde0 00002710 0000000b c165ddac
> c115259a ffffffff
> [    0.040993] Call Trace:
> [    0.040993]  [<c1026a97>] ? release_console_sem+0x16c/0x199
> [    0.040993]  [<c11be196>] ? bus_find_device+0x4e/0x6e
> [    0.040993]  [<c114ed26>] ? no_pci_devices+0x17/0x2d
> [    0.040993]  [<c114e458>] ? find_anything+0x0/0xa
> [    0.040993]  [<c1152546>] ? pci_get_subsys+0x15/0x5b
> [    0.040993]  [<c115259a>] ? pci_get_device+0xe/0x10
> [    0.040993]  [<c1013342>] ? mach_reboot_fixups+0x27/0x3c
> [    0.040993]  [<c100fdfb>] ? native_machine_emergency_restart+0x3e/0xd7
> [    0.040993]  [<c100fc60>] ? machine_emergency_restart+0x9/0xb
> [    0.040993]  [<c1032b4b>] ? emergency_restart+0x8/0xa
> [    0.040993]  [<c13cf607>] ? panic+0xb9/0xd6
> [    0.040993]  [<c1028ee0>] ? do_exit+0x5b/0x740
> [    0.040993]  [<c13cf633>] ? printk+0xf/0x11
> [    0.040993]  [<c10263df>] ? print_oops_end_marker+0x1e/0x23
> [    0.040993]  [<c13d1c1e>] ? oops_end+0x7f/0x87
> [    0.040993]  [<c1005a08>] ? die+0x5b/0x63
> [    0.040993]  [<c13d3061>] ? do_page_fault+0x581/0x66f
> [    0.040993]  [<c103a537>] ? sched_clock_cpu+0x136/0x142
> [    0.040993]  [<c103a537>] ? sched_clock_cpu+0x136/0x142
> [    0.040993]  [<c1039165>] ? ktime_get+0x13/0x2f
> [    0.040993]  [<c103a562>] ? sched_clock_idle_sleep_event+0xe/0x10
> [    0.040993]  [<c102a86f>] ? __do_softirq+0x119/0x121
> [    0.040993]  [<c116e282>] ? acpi_hw_low_level_read+0x3b/0x68
> [    0.040993]  [<c116e34f>] ? acpi_hw_register_read+0xa0/0x112
> [    0.040993]  [<c116e4f0>] ? acpi_get_register_unlocked+0x2c/0x48
> [    0.040993]  [<c1161aa7>] ? acpi_os_release_lock+0x8/0xa
> [    0.040993]  [<c116e67b>] ? acpi_get_register+0x2d/0x34
> [    0.040993]  [<c13d2ae0>] ? do_page_fault+0x0/0x66f
> [    0.040993]  [<c13d13da>] ? error_code+0x72/0x78
> [    0.040993]  [<c16631e3>] ? kernel_init+0x0/0x148
> [    0.040993]  [<c13b448b>] ? rest_init+0xf/0x57
> [    0.040993]  [<c16637af>] ? start_kernel+0x2a2/0x2a7
> [    0.040993]  [<c1663080>] ? __init_begin+0x80/0x88
> [    0.040993] Code: 89 4a 04 74 08 8d 41 0c e8 fa 04 d9 ff 5d c3 55
> 31 c9 89 e5 e8 e0 ff ff ff 5d c3 55 89 e5 57 56 89 c6 5
> 3 83 ec 04 8b 00 8b 7e 04 <8b> 50 10 89 55 f0 e8 7b cf 01 00 85 ff 74
> 23 8b 47 04 ba ec 42
> [    0.040993] EIP: [<c13b41dc>] klist_next+0x10/0x8d SS:ESP 0068:c165dd48
>
> I know this is not much to fuzz about since it was artificially
> induced with the NULL pointer dereference, but what if such an error
> (a real one) made it into the kernel, it could scroll away the real
> oops. Anyway -- to reproduce, apply the patch and boot with panic=10
> (1 also works). Thanks for the attention,

Reverting:

commit 70308923d317f2ad4973c30d90bb48ae38761317
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Wed Feb 13 22:30:39 2008 -0800

    PCI: make no_pci_devices() use the pci_bus_type list

    no_pci_devices() should use the driver core list of PCI devices, not our
    "separate" one.

    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

fixes it.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
