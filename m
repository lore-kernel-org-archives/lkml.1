Return-Path: <linux-kernel-owner+w=401wt.eu-S1751832AbZIVTKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbZIVTKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZIVTKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:10:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:33812 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZIVTKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:10:44 -0400
Date: Tue, 22 Sep 2009 19:09:43 GMT
From: tip-bot for Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, dnelson@redhat.com, ying.huang@intel.com,
       ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: ying.huang@intel.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, dnelson@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1253601357.15717.757.camel@yhuang-dev.sh.intel.com>
References: <1253601357.15717.757.camel@yhuang-dev.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: mce, inject: Use real inject-msg in raise_local
Message-ID: <tip-14c0abf14a5e67e793131116bd97f57da37ccce3@git.kernel.org>
Git-Commit-ID: 14c0abf14a5e67e793131116bd97f57da37ccce3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 19:09:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14c0abf14a5e67e793131116bd97f57da37ccce3
Gitweb:     http://git.kernel.org/tip/14c0abf14a5e67e793131116bd97f57da37ccce3
Author:     Huang Ying <ying.huang@intel.com>
AuthorDate: Tue, 22 Sep 2009 14:35:57 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 21:06:37 +0200

x86: mce, inject: Use real inject-msg in raise_local

Current raise_local() uses a struct mce that comes from mce_write()
as a parameter instead of the real inject-msg, so when we set
mce.finished = 0 to clear injected MCE, the real inject stays
valid.

This will cause the remaining inject-msg affect the next injection,
which is not desired.

To fix this, real inject-msg is used in raise_local instead of the
one on the stack.

This patch is based on the diagnosis and the fixes by Dean Nelson.

Reported-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1253601357.15717.757.camel@yhuang-dev.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 7029f0e..472763d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -98,8 +98,9 @@ static struct notifier_block mce_raise_nb = {
 };
 
 /* Inject mce on current CPU */
-static int raise_local(struct mce *m)
+static int raise_local(void)
 {
+	struct mce *m = &__get_cpu_var(injectm);
 	int context = MCJ_CTX(m->inject_flags);
 	int ret = 0;
 	int cpu = m->extcpu;
@@ -167,12 +168,12 @@ static void raise_mce(struct mce *m)
 			}
 			cpu_relax();
 		}
-		raise_local(m);
+		raise_local();
 		put_cpu();
 		put_online_cpus();
 	} else
 #endif
-		raise_local(m);
+		raise_local();
 }
 
 /* Error injection interface */
