Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZBUXRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZBUXRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 18:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZBUXRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 18:17:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:20603 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbZBUXRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 18:17:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,247,1233561600"; 
   d="scan'208";a="388727368"
Date: Sat, 21 Feb 2009 15:17:41 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Philippe Grenard <philippe.grenard@laposte.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       John Stoffel <john@stoffel.org>
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel (amd64)
Message-ID: <20090221231741.GA6733@linux-os.sc.intel.com>
References: <200902131944.56634.philippe.grenard@laposte.net> <200902202108.55332.philippe.grenard@laposte.net> <20090220215830.GB30665@elte.hu> <200902211121.46292.philippe.grenard@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902211121.46292.philippe.grenard@laposte.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 02:21:46AM -0800, Philippe Grenard wrote:
> Hello Ingo, thanks for your reply,
> 
> I've tried to boot 2.6.29-rc5 with both "Max CPUID Value" Enabled and
> Disabled, and tried for both case the "nofxsr" option without better result...

Philippe, Can you apply the appended patch and pass "noxsave" boot param
and see if it helps fix your freeze issue. This should atleast take away
the xsave equation from the picture.

I haven't followed this thread closely, but do you have nmi watchdog and other
debug options like CONFIG_DETECT_SOFTLOCKUP enabled? That might give more clues
about the freeze.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: Introduce noxsave boot parameter

Introduce "noxsave" boot parameter which will disable the cpu's xsave/xrstor
capabilities.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/Documentation/kernel-parameters.txt
===================================================================
--- tip/Documentation/kernel-parameters.txt.orig
+++ tip/Documentation/kernel-parameters.txt
@@ -1493,6 +1493,10 @@ and is between 256 and 4096 characters. 
 			register save and restore. The kernel will only save
 			legacy floating-point registers on task switch.
 
+	noxsave		[BUGS=X86] Disables x86 extended register state save
+			and restore using xsave. The kernel will fallback to
+			enabling legacy floating-point and sse state.
+
 	noclflush	[BUGS=X86] Don't use the CLFLUSH instruction
 
 	nohlt		[BUGS=ARM,SH]
Index: tip/arch/x86/kernel/cpu/common.c
===================================================================
--- tip/arch/x86/kernel/cpu/common.c.orig
+++ tip/arch/x86/kernel/cpu/common.c
@@ -127,6 +127,13 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_p
 } };
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
