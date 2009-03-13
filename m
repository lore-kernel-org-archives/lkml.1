Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbZCMKiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbZCMKiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756981AbZCMKhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:37:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:36943 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbZCMKhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:37:24 -0400
Date: Fri, 13 Mar 2009 10:36:44 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B91A7E.76E4.0078.0@novell.com>
References: <49B91A7E.76E4.0078.0@novell.com>
Subject: [tip:core/ipi] panic, smp: provide smp_send_stop() wrapper on UP too
Message-ID: <tip-d1dedb52acd98bd5e13e1ff4c4d045d58bbd16fe@git.kernel.org>
Git-Commit-ID: d1dedb52acd98bd5e13e1ff4c4d045d58bbd16fe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 10:36:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1dedb52acd98bd5e13e1ff4c4d045d58bbd16fe
Gitweb:     http://git.kernel.org/tip/d1dedb52acd98bd5e13e1ff4c4d045d58bbd16fe
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 11:14:06 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 11:24:31 +0100

panic, smp: provide smp_send_stop() wrapper on UP too

Impact: cleanup, no code changed

Remove an ugly #ifdef CONFIG_SMP from panic(), by providing
an smp_send_stop() wrapper on UP too.

LKML-Reference: <49B91A7E.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/smp.h |    4 +++-
 kernel/panic.c      |    2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 2d3bcb6..a69db82 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -38,7 +38,7 @@ int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 /*
  * main cross-CPU interfaces, handles INIT, TLB flush, STOP, etc.
  * (defined in asm header):
- */ 
+ */
 
 /*
  * stops all CPUs but the current one:
@@ -122,6 +122,8 @@ extern unsigned int setup_max_cpus;
 
 #else /* !SMP */
 
+static inline void smp_send_stop(void) { }
+
 /*
  *	These macros fold the SMP functionality into a single CPU system
  */
diff --git a/kernel/panic.c b/kernel/panic.c
index 57fb005..ca75e81 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -85,14 +85,12 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	crash_kexec(NULL);
 
-#ifdef CONFIG_SMP
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
 	 * unfortunately means it may not be hardened to work in a panic
 	 * situation.
 	 */
 	smp_send_stop();
-#endif
 
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
