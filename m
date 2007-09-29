Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbXI2IPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbXI2IPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 04:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXI2IPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 04:15:34 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33099 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752190AbXI2IPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 04:15:32 -0400
Message-ID: <391053727.01229@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 29 Sep 2007 16:15:24 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING: at arch/x86_64/kernel/smp.c:397
	smp_call_function_mask()
Message-ID: <20070929081524.GA32760@mail.ustc.edu.cn>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <390947257.08622@ustc.edu.cn> <46FCC0B8.7090403@bull.net> <20070928020950.bdcad2c2.akpm@linux-foundation.org> <46FCC6F5.2030109@bull.net> <20070928023422.77be1e71.akpm@linux-foundation.org> <46FCEE9A.5050806@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FCEE9A.5050806@bull.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 02:07:54PM +0200, Laurent Vivier wrote:
> >> 2- one in global_flush_tlb() which calls smp_call_function() with irqs disabled.
> > 
> > That would be a big bug, and surely we would already have picked it up.
> > 
> > <looks>
> > 
> > argh, mainline's x86_64 smp_call_function() doesn't do the check.  We've
> > had *heaps* of bugs in i386 where people were running smp_call_foo() under
> > local_irq_disable().  I wonder how many there are in x86_64?

Thank god it's a bug in alternative_instructions() instead of global_flush_tlb().

The following patch fixed it.

===
call free_init_pages() with irqs enabled in alternative_instructions()

It fixes the warning message in smp_call_function*(), which should be called
with irqs disabled.

[    0.310000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.310000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.310000] CPU 0/0 -> Node 0
[    0.310000] SMP alternatives: switching to UP code
[    0.310000] Freeing SMP alternatives: 25k freed
[    0.310000] WARNING: at arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
[    0.310000]
[    0.310000] Call Trace:
[    0.310000]  [<ffffffff8100dbde>] dump_trace+0x3ee/0x4a0
[    0.310000]  [<ffffffff8100dcd3>] show_trace+0x43/0x70
[    0.310000]  [<ffffffff8100dd15>] dump_stack+0x15/0x20
[    0.310000]  [<ffffffff8101cd44>] smp_call_function_mask+0x94/0xa0
[    0.310000]  [<ffffffff8101d0b2>] smp_call_function+0x32/0x40
[    0.310000]  [<ffffffff8104277f>] on_each_cpu+0x1f/0x50
[    0.310000]  [<ffffffff81026eac>] global_flush_tlb+0x8c/0x110
[    0.310000]  [<ffffffff81025c85>] free_init_pages+0xe5/0xf0
[    0.310000]  [<ffffffff81549b5e>] alternative_instructions+0x7e/0x150
[    0.310000]  [<ffffffff8154a2ea>] check_bugs+0x1a/0x20
[    0.310000]  [<ffffffff81540c4a>] start_kernel+0x2da/0x380
[    0.310000]  [<ffffffff81540132>] _sinittext+0x132/0x140
[    0.310000]
[    0.320000] ACPI: Core revision 20070126
[    0.560000] Using local APIC timer interrupts.
[    0.590000] Detected 62.496 MHz APIC timer.
[    0.590000] Brought up 1 CPUs

Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Andi Kleen <ak@suse.de> 
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 arch/i386/kernel/alternative.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc8-mm2.orig/arch/i386/kernel/alternative.c
+++ linux-2.6.23-rc8-mm2/arch/i386/kernel/alternative.c
@@ -435,9 +435,6 @@ void __init alternative_instructions(voi
 			alternatives_smp_unlock(__smp_locks, __smp_locks_end,
 						_text, _etext);
 		}
-		free_init_pages("SMP alternatives",
-				(unsigned long)__smp_locks,
-				(unsigned long)__smp_locks_end);
 	} else {
 		alternatives_smp_module_add(NULL, "core kernel",
 					    __smp_locks, __smp_locks_end,
@@ -448,6 +445,11 @@ void __init alternative_instructions(voi
  	apply_paravirt(__parainstructions, __parainstructions_end);
 	local_irq_restore(flags);
 
+	if (smp_alt_once)
+		free_init_pages("SMP alternatives",
+				(unsigned long)__smp_locks,
+				(unsigned long)__smp_locks_end);
+
 	restart_nmi();
 #ifdef CONFIG_X86_MCE
 	restart_mce();

