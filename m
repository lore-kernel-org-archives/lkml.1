Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbZEOOeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbZEOOeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZEOOd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:33:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57564 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZEOOdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:33:55 -0400
Date: Fri, 15 May 2009 10:33:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] powerpc/ftrace: fix constraint to be early clobber
Message-ID: <alpine.DEB.2.00.0905141236420.30591@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After upgrading my distcc boxes from gcc 4.2.2 to 4.4.0, the function 
graph tracer broke. This was discovered on my x86 boxes.

The issue is that gcc used the same register for an output as it did for 
an input in an asm statement. I first thought this was a bug in gcc and 
reported it. I was notified that gcc was correct and that the output had 
to be flagged as an "early clobber".

I noticed that powerpc had the same issue and this patch fixes it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 70e2a73..68fd74e 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -594,7 +594,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 			PPC_LONG "2b,4b\n"
 		".previous"
 
-		: [old] "=r" (old), [faulted] "=r" (faulted)
+		: [old] "=&r" (old), [faulted] "=r" (faulted)
 		: [parent] "r" (parent), [return_hooker] "r" (return_hooker)
 		: "memory"
 	);

