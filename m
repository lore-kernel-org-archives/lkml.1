Return-Path: <linux-kernel-owner+w=401wt.eu-S934990AbZDBGDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934990AbZDBGDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbZDBGC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:02:59 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47564 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbZDBGC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:02:57 -0400
Date: Thu, 2 Apr 2009 11:32:49 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing/wakeup: move access to wakeup_cpu
	into spinlock
Message-ID: <20090402060249.GH4620@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <20090326122806.GA4188@in.ibm.com> <20090326132739.GB5960@nowhere> <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com> <alpine.DEB.2.00.0903261032070.17665@gandalf.stny.rr.com> <20090327084144.GA23318@in.ibm.com> <20090327124532.GA9963@in.ibm.com> <alpine.DEB.2.00.0904011939170.30963@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904011939170.30963@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 07:42:58PM -0400, Steven Rostedt wrote:

....

> 
> 
> 
> Hi Maneesh,
> 
> Could you try this patch and see if it keeps your system from crashing?
> 
> Thanks,
> 
> -- Steve
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index a331ec3..dbf3f8f 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -917,10 +917,15 @@ retint_careful:
>  	TRACE_IRQS_ON
>  	ENABLE_INTERRUPTS(CLBR_NONE)
>  	pushq %rdi
> -	CFI_ADJUST_CFA_OFFSET	8
> +	pushq %rbp
> +	call  1f
> +1:	mov  %rsp, %rbp
> +	CFI_ADJUST_CFA_OFFSET	24
>  	call  schedule
> +	addq $8, %rsp /* skip call */
> +	popq %rbp
>  	popq %rdi
> -	CFI_ADJUST_CFA_OFFSET	-8
> +	CFI_ADJUST_CFA_OFFSET	-24
>  	GET_THREAD_INFO(%rcx)
>  	DISABLE_INTERRUPTS(CLBR_NONE)
>  	TRACE_IRQS_OFF



Hi Steve

I tried the above patch but similar oops again

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff80292349>] probe_wakeup_sched_switch+0x11f/0x1e8
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:01/0000:01:01.1/irq
CPU 3 
Modules linked in: autofs4 hidp rfcomm l2cap bluetooth iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod sbs sbshc battery ac parport_pc lp parport sg sr_mod ide_cd_mod cdrom serio_raw acpi_memhotplug button tg3 libphy i2c_piix4 i2c_core pcspkr usb_storage uhci_hcd ohci_hcd ehci_hcd aacraid sd_mod scsi_mod ext3 jbd
Pid: 16589, comm: sshd Not tainted 2.6.29-tip-test #3 eserver xSeries 366-[88632RA]-
RIP: 0010:[<ffffffff80292349>]  [<ffffffff80292349>] probe_wakeup_sched_switch+0x11f/0x1e8
RSP: 0018:ffff8801da1b5e90  EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000046
RDX: 0000000000000000 RSI: ffffffff8020bf85 RDI: ffffffff80d6f460
RBP: ffff8801da1b5ed0 R08: 0000000000000000 R09: 0000000100000003
R10: ffff8801da1b5ed0 R11: ffff88022d152078 R12: 0000000000000046
R13: ffff88022f352040 R14: 0000000000000000 R15: 0000000000000003
FS:  00007f748364d710(0000) GS:ffff880028155000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 00000001cfd8e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: ffffffff80d91980 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Process sshd (pid: 16589, threadinfo ffff8801da1b4000, task ffff88022d152040)
Stack:
 ffff88022d152040 ffff88022d152040 ffff880028162960 ffff880224d79810
 ffff880028167d00 00007fff8b6c7190 0000000000000005 00007fff8b6c7190
 ffff8801da1b5f70 ffffffff805210b7 ffff8802295b8558 0000000000000001
Call Trace:
 [<ffffffff805210b7>] schedule+0x82f/0xb39
 [<ffffffff802d95a4>] ? sys_write+0x72/0x8d
 [<ffffffff8020bf85>] sysret_careful+0xd/0x10
Code: d2 48 c7 c7 38 ef 73 80 89 f3 e8 83 20 00 00 85 db 75 6f 48 8b 4d 00 48 8b 3d 54 ed af 00 45 89 f0 48 8b 01 48 8b 71 08 4c 89 e1 <48> 8b 50 08 e8 5f a1 ff ff 48 8b 3d 37 ed af 00 48 8b 75 c8 45 
RIP  [<ffffffff80292349>] probe_wakeup_sched_switch+0x11f/0x1e8
 RSP <ffff8801da1b5e90>
CR2: 0000000000000008


<probe_wakeup_sched_switch>:
:
:
ffffffff8029195f:       75 6f                   jne    ffffffff802919d0 <probe_wakeup_sched_switch+0x176>
ffffffff80291961:       48 8b 4d 00             mov    0x0(%rbp),%rcx
ffffffff80291965:       48 8b 3d 24 f7 af 00    mov    11532068(%rip),%rdi        # ffffffff80d91090 <wakeup_trace>
ffffffff8029196c:       45 89 f0                mov    %r14d,%r8d
ffffffff8029196f:       48 8b 01                mov    (%rcx),%rax
ffffffff80291972:       48 8b 71 08             mov    0x8(%rcx),%rsi
ffffffff80291976:       4c 89 e1                mov    %r12,%rcx
ffffffff80291979:       48 8b 50 08             mov    0x8(%rax),%rdx
ffffffff8029197d:       e8 af a7 ff ff          callq  ffffffff8028c131 <trace_function>
ffffffff80291982:       48 8b 3d 07 f7 af 00    mov    11532039(%rip),%rdi        # ffffffff80d91090 <wakeup_trace>
ffffffff80291989:       48 8b 75 c8             mov    0xffffffffffffffc8(%rbp),%rsi
ffffffff8029198d:       45 89 f0                mov    %r14d,%r8d
:
:

ffffffff8020c93c <retint_careful>:
ffffffff8020c93c:       0f ba e2 03             bt     $0x3,%edx
ffffffff8020c940:       73 29                   jae    ffffffff8020c96b <retint_signal>
ffffffff8020c942:       fb                      sti
ffffffff8020c943:       57                      push   %rdi
ffffffff8020c944:       55                      push   %rbp
ffffffff8020c945:       e8 00 00 00 00          callq  ffffffff8020c94a <retint_careful+0xe>
ffffffff8020c94a:       48 89 e5                mov    %rsp,%rbp
ffffffff8020c94d:       e8 d6 34 31 00          callq  ffffffff8051fe28 <schedule>
ffffffff8020c952:       48 83 c4 08             add    $0x8,%rsp
ffffffff8020c956:       5d                      pop    %rbp
ffffffff8020c957:       5f                      pop    %rdi
ffffffff8020c958:       65 48 8b 0c 25 e8 b4    mov    %gs:0xb4e8,%rcx
ffffffff8020c95f:       00 00
ffffffff8020c961:       48 81 e9 d8 1f 00 00    sub    $0x1fd8,%rcx
ffffffff8020c968:       fa                      cli
ffffffff8020c969:       eb 91                   jmp    ffffffff8020c8fc <retint_check>


-- 
Maneesh Soni
Linux Technology Center
IBM India Systems and Technology Lab,
Bangalore, India.
