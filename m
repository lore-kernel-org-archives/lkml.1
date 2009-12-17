Return-Path: <linux-kernel-owner+w=401wt.eu-S1763444AbZLQAeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763444AbZLQAeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762854AbZLQAeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:34:00 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34568 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762844AbZLQAd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:33:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q320u14Hpu75Qc6fD9ANbyo/2Ow4jHmGltR9zr1+8icNA804cDp9JKtcfhgwnxwWsS
         ZkOGvhmrHynl91i70QbO75iqSGcrVap4xO+A7B48EOMda0zrIMJDzkKEJ4mAlgm5sHAU
         GqOT/UuEDMOa4o8KgjpSZeo4HtLZ9Ar7hlqK8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Michal Marek <mmarek@suse.cz>,
       Andrew Randrianasulu <randrik_a@yahoo.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [PATCH v2] hw-breakpoint: Fix hardware breakpoints -> perf events dependency
Date: Thu, 17 Dec 2009 01:33:54 +0100
Message-Id: <1261010034-7786-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1261009575-7496-1-git-send-regression-fweisbec@gmail.com>
References: <1261009575-7496-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
events. The user can still disable the latter, but it is necessary
for the breakpoints.

What we need is:

- x86 selects HAVE_HW_BREAKPOINTS and PERF_EVENTS
- HAVE_HW_BREAKPOINTS depends on PERF_EVENTS

so that we ensure PERF_EVENTS is enabled and frozen for x86.

This fixes the following kind of build errors:

In file included from arch/x86/kernel/hw_breakpoint.c:31:
include/linux/hw_breakpoint.h: In function 'hw_breakpoint_addr':
include/linux/hw_breakpoint.h:39: error: 'struct perf_event' has no member named 'attr'
include/linux/hw_breakpoint.h: In function 'hw_breakpoint_type':
include/linux/hw_breakpoint.h:44: error: 'struct perf_event' has no member named 'attr'
include/linux/hw_breakpoint.h: In function 'hw_breakpoint_len':
include/linux/hw_breakpoint.h:49: error: 'struct perf_event' has no member named 'attr'
include/linux/hw_breakpoint.h: In function 'counter_arch_bp':
include/linux/hw_breakpoint.h:85: error: 'struct perf_event' has no member named 'hw'

v2: Select also ANON_INODES from x86, required for perf

Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reported-by: Michal Marek <mmarek@suse.cz>
Reported-by: Andrew Randrianasulu <randrik_a@yahoo.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
---
 arch/Kconfig     |    4 +---
 arch/x86/Kconfig |    2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 28146cd..32e8b68 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -138,9 +138,7 @@ config HAVE_USER_RETURN_NOTIFIER
 
 config HAVE_HW_BREAKPOINT
 	bool
-	depends on HAVE_PERF_EVENTS
-	select ANON_INODES
-	select PERF_EVENTS
+	depends on PERF_EVENTS
 
 
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 098f0d3..cbc1b98 100644
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
 
-- 
1.6.2.3

