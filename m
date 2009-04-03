Return-Path: <linux-kernel-owner+w=401wt.eu-S1763071AbZDCKey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763071AbZDCKey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759576AbZDCKea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:34:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:38654 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbZDCKe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:34:28 -0400
Date: Fri, 3 Apr 2009 10:33:45 GMT
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       srostedt@redhat.com, tglx@linutronix.de, sfr@canb.auug.org.au,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, srostedt@redhat.com, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20090327230834.93d0221d.sfr@canb.auug.org.au>
References: <20090327230834.93d0221d.sfr@canb.auug.org.au>
Subject: [tip:tracing/kmemtrace-v2] tracing, powerpc: fix powerpc tree and tracing tree interaction
Message-ID: <tip-a095bdbb136f7bed96b7adf5aa1dd27bb2f839bf@git.kernel.org>
Git-Commit-ID: a095bdbb136f7bed96b7adf5aa1dd27bb2f839bf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 10:33:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a095bdbb136f7bed96b7adf5aa1dd27bb2f839bf
Gitweb:     http://git.kernel.org/tip/a095bdbb136f7bed96b7adf5aa1dd27bb2f839bf
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Fri, 27 Mar 2009 23:08:34 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Apr 2009 00:50:24 +0200

tracing, powerpc: fix powerpc tree and tracing tree interaction

Today's linux-next build (powerpc allyesconfig) failed like this:

arch/powerpc/kernel/ftrace.c: In function 'prepare_ftrace_return':
arch/powerpc/kernel/ftrace.c:612: warning: passing argument 3 of 'ftrace_push_return_trace' makes pointer from integer without a cast
arch/powerpc/kernel/ftrace.c:612: error: too many arguments to function 'ftrace_push_return_trace'

Caused by commit 5d1a03dc541dc6672e60e57249ed22f40654ca47
("function-graph: moved the timestamp from arch to generic code") from
the tracing tree which (removed an argument from
ftrace_push_return_trace()) interacting with commit
6794c78243bfda020ab184d6d578944f8e90d26c ("powerpc64: port of the
function graph tracer") from the powerpc tree.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: <linuxppc-dev@ozlabs.org>
LKML-Reference: <20090327230834.93d0221d.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/ftrace.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 5b5d16b..5455943 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -557,7 +557,6 @@ extern void mod_return_to_handler(void);
 void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 {
 	unsigned long old;
-	unsigned long long calltime;
 	int faulted;
 	struct ftrace_graph_ent trace;
 	unsigned long return_hooker = (unsigned long)&return_to_handler;
@@ -606,10 +605,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		return;
 	}
 
-	calltime = cpu_clock(raw_smp_processor_id());
-
-	if (ftrace_push_return_trace(old, calltime,
-				self_addr, &trace.depth) == -EBUSY) {
+	if (ftrace_push_return_trace(old, self_addr, &trace.depth) == -EBUSY) {
 		*parent = old;
 		return;
 	}
