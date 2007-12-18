Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbXLRNji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbXLRNji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 08:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbXLRNjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 08:39:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47314 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbXLRNj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 08:39:29 -0500
Date: Tue, 18 Dec 2007 14:38:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 21/21] [PATCH] finish processor.h integration
Message-ID: <20071218133818.GA9941@elte.hu>
References: <11979320302030-git-send-email-gcosta@redhat.com> <11979320354186-git-send-email-gcosta@redhat.com> <11979320401316-git-send-email-gcosta@redhat.com> <11979320451308-git-send-email-gcosta@redhat.com> <1197932050948-git-send-email-gcosta@redhat.com> <11979320551036-git-send-email-gcosta@redhat.com> <11979320603229-git-send-email!-gcosta@redhat.com> <11979320653161-git-send-email-gcosta@redhat.com> <11979320693300-git-send-email-gcosta@redhat.com> <20071218131932.GA9457@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218131932.GA9457@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > What's left in processor_32.h and processor_64.h cannot be cleanly 
> > integrated. However, it's just a couple of definitions. They are 
> > moved to processor.h around ifdefs, and the original files are 
> > deleted. Note that there's much less headers included in the final 
> > version.
> 
> and this patch breaks the build on the attached config, with:
> 
>    CC      arch/x86/mm/boot_ioremap_32.o
>  In file included from include/asm/fixmap_32.h:28,
>                   from include/asm/fixmap.h:2,
>                   from include/asm/pgtable_32.h:16,
>                   from include/asm/pgtable.h:2,
>                   from arch/x86/mm/boot_ioremap_32.c:21:
>  include/asm/acpi.h:159: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'acpi_fake_nodes'
>  make[1]: *** [arch/x86/mm/boot_ioremap_32.o] Error 1
>  make: *** [arch/x86/mm/boot_ioremap_32.o] Error 2

really, please do _much_ more careful unification. We unified two full 
architectures in .24-rc1 and there was _not a single regression_ due to 
that unification. Not a single build failure, not a single boot or 
runtime failure.

here the problem is apparently caused by your patch, a careless 
'unification' of include file sections. 32-bit had this:

-#include <asm/vm86.h>
-#include <asm/math_emu.h>
-#include <asm/segment.h>
-#include <asm/page.h>
-#include <asm/types.h>
-#include <asm/sigcontext.h>
-#include <asm/cpufeature.h>
-#include <asm/msr.h>
-#include <asm/system.h>
-#include <linux/threads.h>
-#include <linux/init.h>
-#include <asm/desc_defs.h>

64-bit had this:

-#include <asm/segment.h>
-#include <asm/page.h>
-#include <asm/types.h>
-#include <asm/sigcontext.h>
-#include <asm/cpufeature.h>
-#include <linux/threads.h>
-#include <asm/msr.h>
-#include <asm/current.h>
-#include <asm/system.h>
-#include <linux/personality.h>
-#include <asm/desc_defs.h>

and the 'unified' processor.h has:

+#include <asm/desc_defs.h>
+#include <asm/msr.h>
 #include <asm/page.h>
 #include <asm/percpu.h>
 #include <asm/system.h>
 #include <asm/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/cache.h>
+#include <linux/personality.h>

Those are visible, _crutial_ differences totally unmentioned in the 
patch.

yes, our include file dependencies are a jungle, the differences between 
32-bit and 64-bit are arbitrary in 80% of the cases, but still there's 
no reason why this couldnt be done correctly. The patch below is a quick 
bandaid that adds the missing bits.

	Ingo

------------------>
Subject: x86: fix include file mess
From: Ingo Molnar <mingo@elte.hu>

fix include file mess.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/processor.h |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux-x86.q/include/asm-x86/processor.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/processor.h
+++ linux-x86.q/include/asm-x86/processor.h
@@ -6,15 +6,27 @@
 struct task_struct;
 struct mm_struct;
 
+#ifdef CONFIG_X86_32
+# include <asm/math_emu.h>
+# include <asm/vm86.h>
+#endif
+
+#include <asm/cpufeature.h>
+#include <asm/current.h>
 #include <asm/desc_defs.h>
 #include <asm/msr.h>
 #include <asm/page.h>
 #include <asm/percpu.h>
+#include <asm/segment.h>
+#include <asm/sigcontext.h>
 #include <asm/system.h>
-#include <asm/percpu.h>
-#include <linux/cpumask.h>
+#include <asm/types.h>
+
 #include <linux/cache.h>
+#include <linux/cpumask.h>
+#include <linux/init.h>
 #include <linux/personality.h>
+#include <linux/threads.h>
 
 /*
  * Default implementation of macro that returns current
