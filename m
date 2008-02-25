Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYBYSAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYBYSAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbYBYSAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:00:25 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42385 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbYBYSAY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:00:24 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 25 Feb 2008 12:59:29 -0500
Message-ID: <30804.1203962369@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol 'mcount' has EXPORT_SYMBOL_GPL attached to it.  This is because
"things that use this symbol are too chummy with kernel internals to not be
derivative".  However, the symbol may or may not actually be referenced by a
given module, depending on the setting of CONFIG_FTRACE.  This leads to an
interesting result:  The module may or may not be too chummy depending on a
variable outside its control, and the module source code doesn't have any say
in the matter.  So we have a .c file that *is* a derivative work if the kernel
is built one way, and is *not* if the kernel is built another.  Worse yet,
it *also* depends at runtime on the setting of /proc/sys/kernel/ftrace_enabled

But it's the SAME EXACT SOURCE.  And since the source file isn't called
schrodinger.c, I believe the following patch is in order..

(As an aside, arch/um/kernel/gprof_syms.c already lists mcount as a
SYMBOL, not a SYMBOL_GPL - yet another inconsistency.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
---
--- linux-2.6.25-rc2-mm1/kernel/trace/ftrace.c.dist	2008-02-16 23:34:36.000000000 -0500
+++ linux-2.6.25-rc2-mm1/kernel/trace/ftrace.c	2008-02-25 12:00:57.000000000 -0500
@@ -44,7 +44,7 @@ static struct ftrace_ops *ftrace_list __
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 
 /* mcount is defined per arch in assembly */
-EXPORT_SYMBOL_GPL(mcount);
+EXPORT_SYMBOL(mcount);
 
 notrace void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 {

