Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZIQVhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZIQVhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZIQVhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:37:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:57988 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbZIQVht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:37:49 -0400
Date: Thu, 17 Sep 2009 21:37:09 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jin.dongming@np.css.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
       ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jin.dongming@np.css.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
       ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A94E244.3020301@jp.fujitsu.com>
References: <4A94E244.3020301@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] x86, mce: CE in last bank prevents panic by unknown MCE
Message-ID: <tip-680b6cfd3cee30a7d997d49430fb73af84523853@git.kernel.org>
Git-Commit-ID: 680b6cfd3cee30a7d997d49430fb73af84523853
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 21:37:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  680b6cfd3cee30a7d997d49430fb73af84523853
Gitweb:     http://git.kernel.org/tip/680b6cfd3cee30a7d997d49430fb73af84523853
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 26 Aug 2009 16:20:36 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Aug 2009 20:21:11 +0200

x86, mce: CE in last bank prevents panic by unknown MCE

If MCE handler is called but none of mces_seen have machine
check event which might signal the MCE (i.e. event higher than
MCE_KEEP_SEVERITY), panic with "Machine check from unknown
source" will be taken since the MCE is assumed to be signaled
from external agent or so.

Usually mces_seen never point MCE_KEEP_SEVERITY event such as
CE. But it can happen because initial value of mces_seen is
accidentally modified by mce_no_way_out() - in case if
mce_no_way_out() run through all banks and the last bank has
the CE, mces_seen points the CE and the "panic by unknown" will
not be taken.

This patch fixes this undesired behavior, and clarifies the logic.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jin Dongming <jin.dongming@np.css.fujitsu.com>
LKML-Reference: <4A94E244.3020301@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>


---
 arch/x86/kernel/cpu/mcheck/mce.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 54bd1b2..325559d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -612,7 +612,7 @@ out:
  * This way we prevent any potential data corruption in a unrecoverable case
  * and also makes sure always all CPU's errors are examined.
  *
- * Also this detects the case of an machine check event coming from outer
+ * Also this detects the case of a machine check event coming from outer
  * space (not detected by any CPUs) In this case some external agent wants
  * us to shut down, so panic too.
  *
@@ -665,7 +665,7 @@ static void mce_reign(void)
 	 * No machine check event found. Must be some external
 	 * source or one CPU is hung. Panic.
 	 */
-	if (!m && tolerant < 3)
+	if (global_worst <= MCE_KEEP_SEVERITY && tolerant < 3)
 		mce_panic("Machine check from unknown source", NULL, NULL);
 
 	/*
@@ -889,11 +889,11 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	mce_setup(&m);
 
 	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
-	no_way_out = mce_no_way_out(&m, &msg);
-
 	final = &__get_cpu_var(mces_seen);
 	*final = m;
 
+	no_way_out = mce_no_way_out(&m, &msg);
+
 	barrier();
 
 	/*
