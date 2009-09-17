Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbZIQT5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbZIQT5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZIQT5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:57:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57401 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZIQT5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:57:43 -0400
Message-Id: <20090917195745.400832939@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Sep 2009 15:55:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zhao Lei <zhaolei@cn.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/5] [PATCH 1/5] vsprintf: add %ps that is the same as %pS but is like %pf
References: <20090917195508.189551309@goodmis.org>
Content-Disposition: inline; filename=0001-vsprintf-add-ps-that-is-the-same-as-pS-but-is-like-p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

On PowerPC64 function pointers do not point directly at the functions,
but instead point to pointers to the functions. The output of %pF expects
to point to a pointer to the function, whereas %pS will show the function
itself.

mcount returns the direct pointer to the function and not the pointer to
the pointer. Thus %pS must be used to show this. The function tracer
requires printing of the functions without offsets and uses the %pf
instead.

 %pF produces run_local_timers+0x4/0x1f
 %pf produces just run_local_timers

For PowerPC64, we need to use the direct pointer, and we only have
%pS which will produce .run_local_timers+0x4/0x1f

This patch creates a %ps that matches the %pf as %pS matches %pF.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 lib/vsprintf.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index cb8a112..c8f3ed6 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -581,7 +581,7 @@ static char *symbol_string(char *buf, char *end, void *ptr,
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	if (ext != 'f')
+	if (ext != 'f' && ext != 's')
 		sprint_symbol(sym, value);
 	else
 		kallsyms_lookup(value, NULL, NULL, NULL, sym);
@@ -822,6 +822,7 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'F':
 	case 'f':
 		ptr = dereference_function_descriptor(ptr);
+	case 's':
 		/* Fallthrough */
 	case 'S':
 		return symbol_string(buf, end, ptr, spec, *fmt);
@@ -1063,7 +1064,8 @@ qualifier:
  * @args: Arguments for the format string
  *
  * This function follows C99 vsnprintf, but has some extensions:
- * %pS output the name of a text symbol
+ * %pS output the name of a text symbol with offset
+ * %ps output the name of a text symbol without offset
  * %pF output the name of a function pointer with its offset
  * %pf output the name of a function pointer without its offset
  * %pR output the address range in a struct resource
-- 
1.6.3.3


