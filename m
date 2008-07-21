Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYGUPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYGUPcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYGUPcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:32:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33919 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbYGUPcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:32:02 -0400
Date: Mon, 21 Jul 2008 17:31:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] poison pointers change for v2.6.27
Message-ID: <20080721153145.GA11033@elte.hu>
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

Please pull the latest safe-poison-pointers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git safe-poison-pointers-for-linus

this has your suggested change to 0xdead000000000000 included.

Thanks,

	Ingo

------------------>
Avi Kivity (1):
      core, x86: make LIST_POISON less deadly

Ingo Molnar (1):
      x86: change LIST_POISON to 0xdead000000000000


 arch/x86/Kconfig       |    5 +++++
 include/linux/poison.h |   10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e0edaaa..0dbd040 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1019,6 +1019,11 @@ config ARCH_MEMORY_PROBE
 	def_bool X86_64
 	depends on MEMORY_HOTPLUG
 
+config ILLEGAL_POINTER_VALUE
+       hex
+       default 0 if X86_32
+       default 0xdead000000000000 if X86_64
+
 source "mm/Kconfig"
 
 config HIGHPTE
diff --git a/include/linux/poison.h b/include/linux/poison.h
index 9f31683..0d105a5 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -1,14 +1,20 @@
 #ifndef _LINUX_POISON_H
 #define _LINUX_POISON_H
 
+#ifdef CONFIG_ILLEGAL_POINTER_VALUE
+#define POISON_POINTER_DELTA CONFIG_ILLEGAL_POINTER_VALUE
+#else
+#define POISON_POINTER_DELTA 0L
+#endif
+
 /********** include/linux/list.h **********/
 /*
  * These are non-NULL pointers that will result in page faults
  * under normal circumstances, used to verify that nobody uses
  * non-initialized list entries.
  */
-#define LIST_POISON1  ((void *) 0x00100100)
-#define LIST_POISON2  ((void *) 0x00200200)
+#define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
+#define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
 
 /********** include/linux/timer.h **********/
 /*
