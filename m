Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbYJ1U11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbYJ1U11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYJ1U0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:26:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:10590 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbYJ1U0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:26:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,501,1220252400"; 
   d="scan'208";a="456435727"
Date: Tue, 28 Oct 2008 13:26:49 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Roland McGrath <roland@redhat.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: cpu2000(both float and int) 13% regression with 2.6.28-rc1
Message-ID: <20081028202649.GJ30573@linux-os.sc.intel.com>
References: <1225175522.1685.57.camel@ymzhang> <20081028080327.GB15734@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081028080327.GB15734@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 01:03:27AM -0700, Ingo Molnar wrote:
> 
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > Comparing with 2.6.27, cpu2000 (both float and int) has about 13% regression
> > with 2.6.28-rc1 ﻿on my new-model x86-64 machine.
> > 
> > I bisected down to below patch.
> > 
> > commit 0afe2db21394820d32646a695eccf3fbfe6ab5c7
> > Merge: d847059... 43603c8...
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Sat Oct 11 20:23:20 2008 +0200
> > 
> >     Merge branch 'x86/unify-cpu-detect' into x86-v28-for-linus-phase4-D
> >     
> >     Conflicts:
> >         arch/x86/kernel/cpu/common.c
> >         arch/x86/kernel/signal_64.c
> >         include/asm-x86/cpufeature.h
> > 
> > 
> > When I tried to revert it against 2.6.28-rc2, there are many conflictions.

Ingo, I will work with Yanmin and report our findings. It is interesting to see
double digit regression on cpu2000 benchmark. My understanding is that
these benchmarks are not sensitive to signal handling. Also lmbench
signal handling(lat_sig) has less than 3-4% regression, because of
added overhead duing signal setup and restore. Context switch didn't have
any noticeable difference, when I measure before.

Anyhow, while we look at this, probably this is the best point to add "noxsave"
boot option patch, which I missed before. Ingo, Peter: Please consider this for
2.6.28.

thanks,
suresh 
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: Introduce noxsave boot parameter

Introduce "noxsave" boot parameter which will disable the cpu's xsave/xrstor
capabilities.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 343e0f0..c60be3d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1451,6 +1451,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			register save and restore. The kernel will only save
 			legacy floating-point registers on task switch.
 
+	noxsave		[BUGS=X86] Disables x86 extended register state save
+			and restore using xsave. The kernel will fallback to
+			enabling legacy floating-point and sse state.
+
 	noclflush	[BUGS=X86] Don't use the CLFLUSH instruction
 
 	nohlt		[BUGS=ARM,SH]
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 25581dc..bb9d547 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -93,6 +93,13 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 #endif
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
+static int __init x86_xsave_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
+	return 1;
+}
+__setup("noxsave", x86_xsave_setup);
+
 #ifdef CONFIG_X86_32
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;
