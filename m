Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbZCaNkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbZCaNkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbZCaNkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:40:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37865 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbZCaNkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:40:06 -0400
Date: Tue, 31 Mar 2009 15:39:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] stacktrace updates for v2.6.30
Message-ID: <20090331133950.GA24778@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest stacktrace-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git stacktrace-for-linus

One patch to improve saved lockdep stack-traces.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      symbols, stacktrace: look up init symbols after module symbols


 kernel/extable.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index e136ed8..c46da6a 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -41,6 +41,14 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 	return e;
 }
 
+static inline int init_kernel_text(unsigned long addr)
+{
+	if (addr >= (unsigned long)_sinittext &&
+	    addr <= (unsigned long)_einittext)
+		return 1;
+	return 0;
+}
+
 __notrace_funcgraph int core_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_stext &&
@@ -48,8 +56,7 @@ __notrace_funcgraph int core_kernel_text(unsigned long addr)
 		return 1;
 
 	if (system_state == SYSTEM_BOOTING &&
-	    addr >= (unsigned long)_sinittext &&
-	    addr <= (unsigned long)_einittext)
+	    init_kernel_text(addr))
 		return 1;
 	return 0;
 }
@@ -58,7 +65,19 @@ __notrace_funcgraph int __kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
 		return 1;
-	return __module_text_address(addr) != NULL;
+	if (__module_text_address(addr))
+		return 1;
+	/*
+	 * There might be init symbols in saved stacktraces.
+	 * Give those symbols a chance to be printed in
+	 * backtraces (such as lockdep traces).
+	 *
+	 * Since we are after the module-symbols check, there's
+	 * no danger of address overlap:
+	 */
+	if (init_kernel_text(addr))
+		return 1;
+	return 0;
 }
 
 int kernel_text_address(unsigned long addr)
