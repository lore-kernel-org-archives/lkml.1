Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbZDOPsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbZDOPsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZDOPsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:48:24 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45556 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZDOPsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:48:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I6pAfBm0u4H+emhpcnUkcNT65MbeiAp6J+3WwCpjJjql4pxCLFLiO0iLIQw8b3Ma9z
         /ggt7vR7CHFF1wjexftB3xra+bTR0pvwL/zLS58xpbrY18EQEbs+1QdnymWyK0oCrnso
         /RT5z2q80dka7tYsUvLlncDtckIAnyqUTFDp8=
Date: Wed, 15 Apr 2009 17:48:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] vsprintf: introduce %pf
Message-ID: <20090415154817.GC5989@nowhere>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com> <8bd0f97a0904141917g3496f526ifc4fe0bd41c3d1c7@mail.gmail.com> <alpine.DEB.2.00.0904142238060.31421@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904142238060.31421@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 10:38:36PM -0400, Steven Rostedt wrote:
> 
> On Tue, 14 Apr 2009, Mike Frysinger wrote:
> 
> > On Tue, Apr 14, 2009 at 20:00, Frederic Weisbecker wrote:
> > > - * - 'F' For symbolic function descriptor pointers
> > > + * - 'F' For symbolic function descriptor pointers with asm offset
> > > + * - 'f' For simple function symbol
> > 
> > "asm" is weird here as it isnt an assembly offset (not that i have any
> > idea what an "assembly offset" even means).  just say "offset".
> 
> Or perhaps better: function offset, as it ususally means the offset into 
> the function.
> 
> -- Steve
>


Ok, I've tried to keep a balance between all your comments.
Tell me what your think about this v2:

--
>From 302d8752d1734242ab1eb7d9e5df637bcba3f4a9 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 15 Apr 2009 17:41:56 +0200
Subject: [PATCH v2] vsprintf: introduce %pf

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

Changes in v2:

- Add the explanations of the %pf role for vsnprintf() and bstr_printf()
- Change the comments by dropping the "asm offset" notion and only
  define the %pf against the actual function offset notion.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b56f6d0..756ccaf 100644
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
+ * - 'F' For symbolic function descriptor pointers with offset
+ * - 'f' For simple symbolic function names without offset
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
@@ -954,7 +959,8 @@ qualifier:
  *
  * This function follows C99 vsnprintf, but has some extensions:
  * %pS output the name of a text symbol
- * %pF output the name of a function pointer
+ * %pF output the name of a function pointer with its offset
+ * %pf output the name of a function pointer without its offset
  * %pR output the address range in a struct resource
  *
  * The return value is the number of characters which would
@@ -1412,7 +1418,8 @@ EXPORT_SYMBOL_GPL(vbin_printf);
  *
  * The format follows C99 vsnprintf, but has some extensions:
  * %pS output the name of a text symbol
- * %pF output the name of a function pointer
+ * %pF output the name of a function pointer with its offset
+ * %pf output the name of a function pointer without its offset
  * %pR output the address range in a struct resource
  * %n is ignored
  *
-- 
1.6.1



