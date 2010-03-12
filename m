Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab0CLFuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 00:50:50 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63323 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab0CLFur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 00:50:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rjMDTjgaVnVvTmWuvTzcZ96Jevol2BK7xLAduSSjzwbAFRTrjqEhKaE2KDafhri3Qs
         bAGiDQAvXJYXmfyJrdYs/c+Pg8QbrJlpM8ghhicJtS6nl2iz426sVSs5If6rtWCcmAg/
         Rt4lFDwHsmgPy8mJs330o4QdIcCNa2QMaAOVY=
Date: Fri, 12 Mar 2010 06:50:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Also export the weak version of
	perf_arch_fetch_caller_regs
Message-ID: <20100312055043.GB5014@nowhere>
References: <20100312150003.afd9b59a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312150003.afd9b59a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 03:00:03PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: ".perf_arch_fetch_caller_regs" [fs/xfs/xfs.ko] undefined!
> ERROR: ".perf_arch_fetch_caller_regs" [arch/powerpc/platforms/cell/spufs/spufs.ko] undefined!
> 
> Caused by commit 5331d7b84613b8325362dde53dc2bff2fb87d351 ("perf:
> Introduce new perf_fetch_caller_regs() for hot regs snapshot") from the
> tip tree.  Presumably commit 639fe4b12f92b54c9c3b38c82cdafaa38cfd3e63
> ("perf: export perf_trace_regs and perf_arch_fetch_caller_regs") should
> have exported the weak version as well as the x86 one.
> 
> I have used the version of the tip tree from next-20100311 for today.


Does that fixes the issue? Sorry I can not test for now...

Thanks!

---
>From 0b21e01edb23b4725d20a9e5fddb6df7fedd16e1 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 12 Mar 2010 06:23:22 +0100
Subject: [PATCH] perf: Also export the weak version of perf_arch_fetch_caller_regs

perf_arch_fetch_caller_regs() is exported in x86 but not for
other archs that use the weak version.

Export it only once from the generic code, it will apply to
either weak/overriden version.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c |    1 -
 kernel/perf_event.c              |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a6d92c3..a3aff76 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1691,4 +1691,3 @@ void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int ski
 	regs->cs = __KERNEL_CS;
 	local_save_flags(regs->flags);
 }
-EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8bf6127..7aea58d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2794,6 +2794,7 @@ __weak
 void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
 {
 }
+EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
 
 /*
  * Output
-- 
1.6.2.3



