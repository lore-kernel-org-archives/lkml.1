Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbZCFPhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbZCFPhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbZCFPhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:37:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60668 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbZCFPhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:37:33 -0500
Message-ID: <49B14332.9030109@redhat.com>
Date: Fri, 06 Mar 2009 10:37:22 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH -tip 3/4]Text Edit Lock - Smp alternatives support
References: <49B1428A.9050500@redhat.com>
In-Reply-To: <49B1428A.9050500@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the mutual exclusion provided by the text edit lock in alternatives code.
Since alternative_smp_* will be called from module init code, etc,
we'd better protect it from other subsystems.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: 2.6.29-rc7/arch/x86/kernel/alternative.c
===================================================================
--- 2.6.29-rc7.orig/arch/x86/kernel/alternative.c
+++ 2.6.29-rc7/arch/x86/kernel/alternative.c
@@ -5,6 +5,7 @@
 #include <linux/kprobes.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/memory.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
@@ -226,6 +227,7 @@ static void alternatives_smp_lock(u8 **s
 {
 	u8 **ptr;

+	mutex_lock(&text_mutex);
 	for (ptr = start; ptr < end; ptr++) {
 		if (*ptr < text)
 			continue;
@@ -234,6 +236,7 @@ static void alternatives_smp_lock(u8 **s
 		/* turn DS segment override prefix into lock prefix */
 		text_poke(*ptr, ((unsigned char []){0xf0}), 1);
 	};
+	mutex_unlock(&text_mutex);
 }

 static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end)
@@ -243,6 +246,7 @@ static void alternatives_smp_unlock(u8 *
 	if (noreplace_smp)
 		return;

+	mutex_lock(&text_mutex);
 	for (ptr = start; ptr < end; ptr++) {
 		if (*ptr < text)
 			continue;
@@ -251,6 +255,7 @@ static void alternatives_smp_unlock(u8 *
 		/* turn lock prefix into DS segment override prefix */
 		text_poke(*ptr, ((unsigned char []){0x3E}), 1);
 	};
+	mutex_unlock(&text_mutex);
 }

 struct smp_alt_module {
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

