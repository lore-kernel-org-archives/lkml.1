Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0BTBaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:30:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:56172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab0BTBaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:30:16 -0500
Date: Sat, 20 Feb 2010 01:28:54 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80D02@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D02@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86: Initialize stack canary in secondary start
Message-ID: <tip-35f720c5930f689647d51ad77e2a8d6f0abf66c8@git.kernel.org>
Git-Commit-ID: 35f720c5930f689647d51ad77e2a8d6f0abf66c8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 20 Feb 2010 01:28:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35f720c5930f689647d51ad77e2a8d6f0abf66c8
Gitweb:     http://git.kernel.org/tip/35f720c5930f689647d51ad77e2a8d6f0abf66c8
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Thu, 17 Sep 2009 07:36:43 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 19 Feb 2010 16:25:17 -0800

x86: Initialize stack canary in secondary start

Some secondary clockevent setup code needs to call request_irq, which
will cause fake stack check failure in schedule() if voluntary
preemption model is chosen.  It is safe to have stack canary
initialized here early, since start_secondary() does not return.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D02@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/smpboot.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b4e870c..3e6150d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -48,6 +48,7 @@
 #include <linux/err.h>
 #include <linux/nmi.h>
 #include <linux/tboot.h>
+#include <linux/stackprotector.h>
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -324,6 +325,9 @@ notrace static void __cpuinit start_secondary(void *unused)
 	/* enable local interrupts */
 	local_irq_enable();
 
+	/* to prevent fake stack check failure in clock setup */
+	boot_init_stack_canary();
+
 	x86_cpuinit.setup_percpu_clockev();
 
 	wmb();
