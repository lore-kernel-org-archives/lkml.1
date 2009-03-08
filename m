Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZCHPwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZCHPwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZCHPwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:52:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:34114 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbZCHPwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:52:14 -0400
Date: Sun, 8 Mar 2009 15:51:41 GMT
From: Masami Hiramatsu <mhiramat@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <49B14332.9030109@redhat.com>
References: <49B14332.9030109@redhat.com>
Subject: [tip:tracing/core] tracing, Text Edit Lock - SMP alternatives support
Message-ID: <tip-3945dab45aa8c89014893bfa8eb1e1661a409cef@git.kernel.org>
Git-Commit-ID: 3945dab45aa8c89014893bfa8eb1e1661a409cef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 15:51:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3945dab45aa8c89014893bfa8eb1e1661a409cef
Gitweb:     http://git.kernel.org/tip/3945dab45aa8c89014893bfa8eb1e1661a409cef
Author:     "Masami Hiramatsu" <mhiramat@redhat.com>
AuthorDate: Fri, 6 Mar 2009 10:37:22 -0500
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 16:49:00 +0100

tracing, Text Edit Lock - SMP alternatives support

Use the mutual exclusion provided by the text edit lock in alternatives code.
Since alternative_smp_* will be called from module init code, etc,
we'd better protect it from other subsystems.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <49B14332.9030109@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/alternative.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4c80f15..092a7b8 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -5,6 +5,7 @@
 #include <linux/kprobes.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/memory.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
@@ -226,6 +227,7 @@ static void alternatives_smp_lock(u8 **start, u8 **end, u8 *text, u8 *text_end)
 {
 	u8 **ptr;
 
+	mutex_lock(&text_mutex);
 	for (ptr = start; ptr < end; ptr++) {
 		if (*ptr < text)
 			continue;
@@ -234,6 +236,7 @@ static void alternatives_smp_lock(u8 **start, u8 **end, u8 *text, u8 *text_end)
 		/* turn DS segment override prefix into lock prefix */
 		text_poke(*ptr, ((unsigned char []){0xf0}), 1);
 	};
+	mutex_unlock(&text_mutex);
 }
 
 static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end)
@@ -243,6 +246,7 @@ static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end
 	if (noreplace_smp)
 		return;
 
+	mutex_lock(&text_mutex);
 	for (ptr = start; ptr < end; ptr++) {
 		if (*ptr < text)
 			continue;
@@ -251,6 +255,7 @@ static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end
 		/* turn lock prefix into DS segment override prefix */
 		text_poke(*ptr, ((unsigned char []){0x3E}), 1);
 	};
+	mutex_unlock(&text_mutex);
 }
 
 struct smp_alt_module {
