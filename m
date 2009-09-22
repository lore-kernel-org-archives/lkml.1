Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZIVGf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZIVGf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbZIVGf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:35:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:51161 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbZIVGf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:35:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,429,1249282800"; 
   d="scan'208";a="190195393"
Subject: [BUGFIX 1/2] x86, mce, inject: Use real injectm in raise_local
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 14:35:57 +0800
Message-Id: <1253601357.15717.757.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current raise_local uses struct mce comes from mce_write as parameter
instead of real injectm, so when we set mce.finished = 0 to clear
injected MCE, the real inject stays valid. This will cause the
remaining injectm affects next injection.

To fix this, real injectm is used in raise_local instead of the one on
stack.

This patch is based on the diagnnoses and fixes by Dean Nelson.

Reported-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -98,8 +98,9 @@ static struct notifier_block mce_raise_n
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


