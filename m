Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZLRNFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZLRNFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZLRNEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:04:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:50314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbZLRNEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:04:39 -0500
Date: Fri, 18 Dec 2009 13:03:33 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, randrik_a@yahoo.com,
       peterz@infradead.org, mmarek@suse.cz, randy.dunlap@oracle.com,
       gorcunov@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, randrik_a@yahoo.com, peterz@infradead.org,
       mmarek@suse.cz, gorcunov@gmail.com, randy.dunlap@oracle.com,
       fweisbec@gmail.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <1261010034-7786-1-git-send-regression-fweisbec@gmail.com>
References: <1261010034-7786-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] hw-breakpoints: Fix hardware breakpoints -> perf events dependency
Message-ID: <tip-99e8c5a3b875a34d894a711c9a3669858d6adf45@git.kernel.org>
Git-Commit-ID: 99e8c5a3b875a34d894a711c9a3669858d6adf45
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99e8c5a3b875a34d894a711c9a3669858d6adf45
Gitweb:     http://git.kernel.org/tip/99e8c5a3b875a34d894a711c9a3669858d6adf45
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 17 Dec 2009 01:33:54 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Dec 2009 13:11:51 +0100

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
---
 arch/Kconfig     |    4 +---
 arch/x86/Kconfig |    2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

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
 
