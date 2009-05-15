Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZEORxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZEORxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 13:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbZEORxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:53:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbZEORxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:53:24 -0400
Date: Fri, 15 May 2009 10:52:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ian Campbell <ian.campbell@citrix.com>, Jakub Jelinek <jakub@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix print out of function which called WARN_ON()
In-Reply-To: <1242404236-17624-1-git-send-email-ian.campbell@citrix.com>
Message-ID: <alpine.LFD.2.01.0905151018370.3343@localhost.localdomain>
References: <1242404236-17624-1-git-send-email-ian.campbell@citrix.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Jakub - I added you to the participants list because it really looks 
  like this patch (without 'noinline') triggers a gcc bug.

  Or maybe gcc is truly smart enough to turn the "NULL arg pointer" case 
  into a "empty format" call, in which case we actually just solved the 
  original warning case in a _really_ subtle way. Somebody who understands 
  gcc varags should take a look.

  Regardless, even if the optimization happens to _work_, it seems bogus. 
  Even if "vprintk()" has been marked to have a printf-like format, that 
  doesn't mean that you can call it unconditionally by making the format 
  empty - it might have side effects.

  This is with 'gcc -v' reporting:

	gcc version 4.4.0 20090506 (Red Hat 4.4.0-4) (GCC) 

  and is the current fedora-11 compiler (as of a yum update yesterday or 
  the day before) on x86-64 ]

On Fri, 15 May 2009, Ian Campbell wrote:
>
> All WARN_ON()'s currently appear to come from warn_slowpath_null e.g.:
>  WARNING: at kernel/softirq.c:143 warn_slowpath_null+0x1c/0x20()
> 
> This is because since:
> 
>   commit 57adc4d2dbf968fdbe516359688094eef4d46581
>   Author: Andi Kleen <andi@firstfloor.org>
>   Date:   Wed May 6 16:02:53 2009 -0700
> 
>       Eliminate thousands of warnings with gcc 3.2 build
> 
> the caller of warn_slowpath_fmt really is warn_flowpath_null not the
> interesting caller next up the chain. Since __builtin_return_address(X) for X >
> 0 is not reliable, pass the real caller as an argument to warn_slowpath_fmt.

I'd actually much rather re-organize it so that there are the two exported 
functions (with the current interface) that use a common shared static 
function. Rather than passing in '0' in a macro.

IOW, something like this..

Btw, when doing this, it really looked to me like the "noinline" matters. 
I did it first to try to make the assembly clearer to read, but without it 
gcc-4.4 seems to actually generate the wrong code, and does an 
_unconditional_ call to vprintk().

Very odd. I've seen other bugs triggered by gcc-4.4 (alpine miscompiles), 
it all makes me very nervous about the compiler in current fedora-11.

Anybody want to double-check this?

		Linus

---
 kernel/panic.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 874ecf1..3c8048d 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -340,39 +340,44 @@ void oops_exit(void)
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
-void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
-{
+struct slowpath_args {
+	const char *fmt;
 	va_list args;
-	char function[KSYM_SYMBOL_LEN];
-	unsigned long caller = (unsigned long)__builtin_return_address(0);
-	const char *board;
+};
 
-	sprint_symbol(function, caller);
+static void noinline warn_slowpath_common(const char *file, int line, void *caller, struct slowpath_args *args)
+{
+	const char *board;
 
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
-	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
-		line, function);
+	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
 	board = dmi_get_system_info(DMI_PRODUCT_NAME);
 	if (board)
 		printk(KERN_WARNING "Hardware name: %s\n", board);
 
-	if (*fmt) {
-		va_start(args, fmt);
-		vprintk(fmt, args);
-		va_end(args);
-	}
+	if (args)
+		vprintk(args->fmt, args->args);
 
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
 	add_taint(TAINT_WARN);
 }
+
+void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
+{
+	struct slowpath_args args;
+
+	args.fmt = fmt;
+	va_start(args.args, fmt);
+	warn_slowpath_common(file, line, __builtin_return_address(0), &args);
+	va_end(args.args);
+}
 EXPORT_SYMBOL(warn_slowpath_fmt);
 
 void warn_slowpath_null(const char *file, int line)
 {
-	static const char *empty = "";
-	warn_slowpath_fmt(file, line, empty);
+	warn_slowpath_fmt(file, line, __builtin_return_address(0), NULL);
 }
 EXPORT_SYMBOL(warn_slowpath_null);
 #endif
