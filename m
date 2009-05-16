Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbZEPUsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbZEPUsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 16:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZEPUsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 16:48:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbZEPUsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 16:48:15 -0400
Date: Sat, 16 May 2009 13:47:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <ak@linux.intel.com>
cc: Ian Campbell <ian.campbell@citrix.com>, Jakub Jelinek <jakub@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix print out of function which called WARN_ON()
In-Reply-To: <4A0DC797.7040502@linux.intel.com>
Message-ID: <alpine.LFD.2.01.0905161342150.3301@localhost.localdomain>
References: <1242404236-17624-1-git-send-email-ian.campbell@citrix.com> <alpine.LFD.2.01.0905151018370.3343@localhost.localdomain> <4A0DC797.7040502@linux.intel.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 May 2009, Andi Kleen wrote:

> Linus Torvalds wrote:
> > [ Jakub - I added you to the participants list because it really looks
> > like this patch (without 'noinline') triggers a gcc bug.
> 
> This whole thing seems to be much more problematic than I originally thought
> :-/

No, sorry, it was my mistake. The code generated was indeed wrong, but it 
was because the source code was wrong (me calling the _fmt() function 
instead of the _common() function).

What's wrong with me that I can spot subtle errors in assembly language, 
but not the obvious ones in the source code?

Anyway, the proper patch is appended, and Jakub, you can ignore these 
things. gcc is fine.

This patch not only avoids the warnings and gets the right caller 
information, it cleans up the code too:

 - it uses '%pS' instead of of sprint_symbol

 - it avoids stupidly wasting stack space for varargs information in the 
   warn_slowpath_null case.

 - the code actually looks more readable too.

I'll commit it.

		Linus

---
 kernel/panic.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 874ecf1..984b3ec 100644
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
+static void warn_slowpath_common(const char *file, int line, void *caller, struct slowpath_args *args)
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
+	warn_slowpath_common(file, line, __builtin_return_address(0), NULL);
 }
 EXPORT_SYMBOL(warn_slowpath_null);
 #endif
