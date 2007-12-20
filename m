Return-Path: <linux-kernel-owner+w=401wt.eu-S1763979AbXLTWzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763979AbXLTWzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762792AbXLTWzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:55:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56399 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761595AbXLTWzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:55:16 -0500
Date: Thu, 20 Dec 2007 14:54:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-Id: <20071220145415.f737e7f3.akpm@linux-foundation.org>
In-Reply-To: <1198190447.29917.9.camel@heimdal.trondhjem.org>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 17:40:47 -0500
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> I just got the following interesting behaviour. Never mind why the
> original Oops (I was testing some experimental RPC patches), but there
> appears to be a BUG_ON() triggered inside the dump() call.
> 
> Oops occurred with a build based on this afternoon's git tree from Linus
> (v2.6.24-rc5-317-gfaa4877)...
> 
> Cheers
>   Trond
> ---------
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
> printing eip: f8bcc8b3 *pde = 00000000 
> BUG: using smp_processor_id() in preemptible [00000001] code: mount.nfs4/2970
> caller is die+0x59/0x202
> Pid: 2970, comm: mount.nfs4 Not tainted 2.6.24-rc5-ga747a088 #1
>  [<c0405170>] show_trace_log_lvl+0x1a/0x2f
>  [<c0405a76>] show_trace+0x12/0x14
>  [<c0405dc6>] dump_stack+0x6c/0x72
>  [<c04e4cd8>] debug_smp_processor_id+0xa0/0xb4
>  [<c0405462>] die+0x59/0x202
>  [<c05b3e7d>] do_page_fault+0x557/0x63e
>  [<c05b252a>] error_code+0x72/0x78
>  [<f8bd821c>] rpcb_create+0x7c/0x84 [sunrpc]
>  [<f8bd8552>] rpcb_register+0x127/0x18c [sunrpc]
>  [<f8bd31d2>] svc_register+0xcf/0x14c [sunrpc]
>  [<f8bd399f>] __svc_create+0x19a/0x1b3 [sunrpc]
>  [<f8bd3b21>] svc_create+0x13/0x15 [sunrpc]
>  [<f8c74beb>] nfs_callback_up+0x71/0x126 [nfs]
>  [<f8c53cfe>] nfs_get_client+0x14e/0x3a2 [nfs]
>  [<f8c53f88>] nfs4_set_client+0x36/0x14f [nfs]
>  [<f8c54739>] nfs4_create_server+0x8e/0x36c [nfs]
>  [<f8c5c6f1>] nfs4_get_sb+0x2ef/0x3f3 [nfs]
>  [<c0477e40>] vfs_kern_mount+0x7d/0xf1
>  [<c0477f02>] do_kern_mount+0x37/0xbd
>  [<c048a6fb>] do_mount+0x5c3/0x61d
>  [<c048a7c4>] sys_mount+0x6f/0xa9
>  [<c04040b2>] sysenter_past_esp+0x5f/0xa5
>  =======================

Yes - I don't know why the smp_processor_id() test has suddenly started
triggering in there.

I have a sledgehammer fix (below) which Ingo went all complicated about and
I assumed he had it in hand, but I can't see any patches anywhere?

I'd expect the kernel to spit that warning and then proceed with the usual
oops report - that's what it did in Miles Lane's case.  But it seems in
your case that the whole oops report simply vanished?


 arch/x86/kernel/traps_32.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/traps_32.c~i386-use-raw_smp_processor_id-in-die arch/x86/kernel/traps_32.c
--- a/arch/x86/kernel/traps_32.c~i386-use-raw_smp_processor_id-in-die
+++ a/arch/x86/kernel/traps_32.c
@@ -376,7 +376,7 @@ void die(const char * str, struct pt_reg
 		console_verbose();
 		__raw_spin_lock(&die.lock);
 		raw_local_save_flags(flags);
-		die.lock_owner = smp_processor_id();
+		die.lock_owner = raw_smp_processor_id();
 		die.lock_owner_depth = 0;
 		bust_spinlocks(1);
 	}
@@ -636,7 +636,7 @@ static __kprobes void
 mem_parity_error(unsigned char reason, struct pt_regs * regs)
 {
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x on "
-		"CPU %d.\n", reason, smp_processor_id());
+		"CPU %d.\n", reason, raw_smp_processor_id());
 	printk(KERN_EMERG "You have some hardware problem, likely on the PCI bus.\n");
 
 #if defined(CONFIG_EDAC)
@@ -684,7 +684,7 @@ unknown_nmi_error(unsigned char reason, 
 	}
 #endif
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x on "
-		"CPU %d.\n", reason, smp_processor_id());
+		"CPU %d.\n", reason, raw_smp_processor_id());
 	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
 	if (panic_on_unrecovered_nmi)
                 panic("NMI: Not continuing");
@@ -708,7 +708,7 @@ void __kprobes die_nmi(struct pt_regs *r
 	bust_spinlocks(1);
 	printk(KERN_EMERG "%s", msg);
 	printk(" on CPU%d, ip %08lx, registers:\n",
-		smp_processor_id(), regs->ip);
+		raw_smp_processor_id(), regs->ip);
 	show_registers(regs);
 	console_silent();
 	spin_unlock(&nmi_print_lock);
_

