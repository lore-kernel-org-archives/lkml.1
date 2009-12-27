Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbZL0KLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbZL0KLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 05:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZL0KLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 05:11:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39476 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZL0KLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 05:11:52 -0500
Subject: Re: tbench regression with 2.6.33-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Lin Ming <ming.m.lin@intel.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1261906883.5451.1.camel@marge.simson.net>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1261902760.6201.33.camel@marge.simson.net>
	 <1261904349.15854.2.camel@laptop>
	 <1261906883.5451.1.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Dec 2009 11:11:02 +0100
Message-ID: <1261908662.15854.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-27 at 10:41 +0100, Mike Galbraith wrote:
> On Sun, 2009-12-27 at 09:59 +0100, Peter Zijlstra wrote:
> > On Sun, 2009-12-27 at 09:32 +0100, Mike Galbraith wrote:
> > > Perf also isn't free, and in 33, we lost the ability to config it out,
> > 
> > Uhm, that's a plain bug, we should be able to build a kernel without
> > perf support, does the hw breakpoint support have an unfortunate select
> > some place or something?
> 
> Yeah, it's selected in arch/x86/Kconfig.  The kernel won't build without
> it either.

Came from this :/

Any way we can fix this? Frederic/Ingo?

---
commit 99e8c5a3b875a34d894a711c9a3669858d6adf45
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Thu Dec 17 01:33:54 2009 +0100

    hw-breakpoints: Fix hardware breakpoints -> perf events dependency
    
    The kbuild's select command doesn't propagate through the config
    dependencies.
    
    Hence the current rules of hardware breakpoint's config can't
    ensure perf can never be disabled under us.
    
    We have:
    
    config X86
    	selects HAVE_HW_BREAKPOINTS
    
    config HAVE_HW_BREAKPOINTS
    	select PERF_EVENTS
    
    config PERF_EVENTS
    	[...]
    
    x86 will select the breakpoints but that won't propagate to perf
    events. The user can still disable the latter, but it is
    necessary for the breakpoints.
    
    What we need is:
    
     - x86 selects HAVE_HW_BREAKPOINTS and PERF_EVENTS
     - HAVE_HW_BREAKPOINTS depends on PERF_EVENTS
    
    so that we ensure PERF_EVENTS is enabled and frozen for x86.
    
    This fixes the following kind of build errors:
    
     In file included from arch/x86/kernel/hw_breakpoint.c:31:
     include/linux/hw_breakpoint.h: In function 'hw_breakpoint_addr':
     include/linux/hw_breakpoint.h:39: error: 'struct perf_event' has no member named 'attr'
    
    v2: Select also ANON_INODES from x86, required for perf
    
    Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
    Reported-by: Michal Marek <mmarek@suse.cz>
    Reported-by: Andrew Randrianasulu <randrik_a@yahoo.com>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Randy Dunlap <randy.dunlap@oracle.com>
    Cc: K.Prasad <prasad@linux.vnet.ibm.com>
    LKML-Reference: <1261010034-7786-1-git-send-regression-fweisbec@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/Kconfig b/arch/Kconfig
index d828758..9d055b4 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -135,9 +135,7 @@ config HAVE_DEFAULT_NO_SPIN_MUTEXES
 
 config HAVE_HW_BREAKPOINT
 	bool
-	depends on HAVE_PERF_EVENTS
-	select ANON_INODES
-	select PERF_EVENTS
+	depends on PERF_EVENTS
 
 config HAVE_USER_RETURN_NOTIFIER
 	bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3b2a5ac..55298e8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -50,6 +50,8 @@ config X86
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_HW_BREAKPOINT
+	select PERF_EVENTS
+	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
 


