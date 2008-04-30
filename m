Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbYD3PCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbYD3PCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbYD3PCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:02:39 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54222 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757269AbYD3PCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:02:37 -0400
Message-ID: <48188A0C.5030507@sgi.com>
Date: Wed, 30 Apr 2008 08:02:36 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] x86: leave initial __cpu_pda array in place until cpus
 are booted
References: <20080428210906.348866000@polaris-admin.engr.sgi.com> <20080428214541.GA16153@elte.hu> <48175CF8.4010105@sgi.com> <48176EA6.8060506@sgi.com> <20080429214401.GB2302@elte.hu> <20080430060417.GA2408@elte.hu>
In-Reply-To: <20080430060417.GA2408@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
...
> they crashed after about 3 randconfig iterations with:
> 
>   early res: 4 [8000-afff] PGTABLE
>   early res: 5 [b000-b87f] MEMNODEMAP
> PANIC: early exception 0e rip 10:ffffffff8077a150 error 2 cr2 37
> Pid: 0, comm: swapper Not tainted 2.6.25-sched-devel.git-x86-latest.git #14
> 
> Call Trace:
>  [<ffffffff81466196>] early_idt_handler+0x56/0x6a
>  [<ffffffff8077a150>] ? numa_set_node+0x30/0x60
>  [<ffffffff8077a129>] ? numa_set_node+0x9/0x60
>  [<ffffffff8147a543>] numa_init_array+0x93/0xf0
>  [<ffffffff8147b039>] acpi_scan_nodes+0x3b9/0x3f0
>  [<ffffffff8147a496>] numa_initmem_init+0x136/0x150
>  [<ffffffff8146da5f>] setup_arch+0x48f/0x700
>  [<ffffffff802566ea>] ? clockevents_register_notifier+0x3a/0x50
>  [<ffffffff81466a87>] start_kernel+0xd7/0x440
>  [<ffffffff81466422>] x86_64_start_kernel+0x222/0x280
...
Here's the fixup...  This one should follow the previous patches.

Thanks,
Mike
---
Subject: [PATCH 1/1] x86: leave initial __cpu_pda array in place until cpus are booted

  * The __cpu_pda table must be a set of NULL entries (except for the boot cpu)
    to indicate to numa_set_node during early system initialization that the
    cpu pdas are not yet setup.  The pda nodenumber is set later in pda_init().

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git


Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/head64.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- linux-2.6.sched.orig/arch/x86/kernel/head64.c
+++ linux-2.6.sched/arch/x86/kernel/head64.c
@@ -29,17 +29,13 @@
 static struct x8664_pda _boot_cpu_pda __read_mostly;
 
 #ifdef CONFIG_SMP
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
 /*
- * We install an empty cpu_pda pointer table to trap references before
- * the actual cpu_pda pointer table is created in setup_cpu_pda_map().
+ * We install an empty cpu_pda pointer table to indicate to early users
+ * (numa_set_node) that the cpu_pda pointer table for cpus other than
+ * the boot cpu is not yet setup.
  */
 static struct x8664_pda *__cpu_pda[NR_CPUS] __initdata;
 #else
-static struct x8664_pda *__cpu_pda[1] __read_mostly;
-#endif
-
-#else /* !CONFIG_SMP (NR_CPUS will be 1) */
 static struct x8664_pda *__cpu_pda[NR_CPUS] __read_mostly;
 #endif
 
