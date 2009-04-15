Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbZDOABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbZDOABU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZDOABF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:01:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44946 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbZDOABD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:01:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HWLM7w/fsOdK4xuCir4RJXpXUTPSNmoAyTPAbKn/mQvRJ/FcoZiH8tDuQtuZ+x2BOU
         KK8tOk+rFJa+v/9c0Fw+EF+EZ5aQInihj9ahO75hxbdGqHhrCOoJMs3jP20u78O3RZl8
         FW/Yzuk2kafNcMjsrkscZR5SN5Z/JVaqVD4Xs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] vsprintf: introduce %pf
Date: Wed, 15 Apr 2009 02:00:59 +0200
Message-Id: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I remember well, a format which could let us to print a pure
function name has been suggested by Andrew Morton some monthes ago.

The current %pF is very convenient to print a function symbol, but
often we only want to print the name of the function, without
its asm offset.

That's what does %pf in this patch.
The lowecase f has been chosen for its intuitive sense of a weak kind
of %pF

The support for this new format would be welcome for the tracing tree
where the need to print pure function names is often needed and also
on other parts:

$ git-grep -E "kallsyms_lookup\(.+?\)"
arch/blackfin/kernel/traps.c:   symname = kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
arch/powerpc/xmon/xmon.c:               name = kallsyms_lookup(pc, &size, &offset, NULL, tmpstr);
arch/sh/kernel/cpu/sh5/unwind.c:        sym = kallsyms_lookup(pc, NULL, &offset, NULL, namebuf);
arch/x86/kernel/ftrace.c:       kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
kernel/kprobes.c:               sym = kallsyms_lookup((unsigned long)p->addr, NULL,
kernel/lockdep.c:       return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
kernel/trace/ftrace.c:  kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
kernel/trace/trace_functions.c: kallsyms_lookup(ip, NULL, NULL, NULL, str);
kernel/trace/trace_output.c:    kallsyms_lookup(address, NULL, NULL, NULL, str);

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/vsprintf.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b56f6d0..15c9094 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -575,12 +575,15 @@ static char *string(char *buf, char *end, char *s, struct printf_spec spec)
 }
 
 static char *symbol_string(char *buf, char *end, void *ptr,
-				struct printf_spec spec)
+				struct printf_spec spec, char ext)
 {
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	sprint_symbol(sym, value);
+	if (ext != 'f')
+		sprint_symbol(sym, value);
+	else
+		kallsyms_lookup(value, NULL, NULL, NULL, sym);
 	return string(buf, end, sym, spec);
 #else
 	spec.field_width = 2*sizeof(void *);
@@ -692,7 +695,8 @@ static char *ip4_addr_string(char *buf, char *end, u8 *addr,
  *
  * Right now we handle:
  *
- * - 'F' For symbolic function descriptor pointers
+ * - 'F' For symbolic function descriptor pointers with asm offset
+ * - 'f' For simple function symbol
  * - 'S' For symbolic direct pointers
  * - 'R' For a struct resource pointer, it prints the range of
  *       addresses (not the name nor the flags)
@@ -715,10 +719,11 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 
 	switch (*fmt) {
 	case 'F':
+	case 'f':
 		ptr = dereference_function_descriptor(ptr);
 		/* Fallthrough */
 	case 'S':
-		return symbol_string(buf, end, ptr, spec);
+		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 		return resource_string(buf, end, ptr, spec);
 	case 'm':
-- 
1.6.1

