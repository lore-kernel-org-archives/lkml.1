Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbYAOUxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbYAOUxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbYAOUul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:41 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:56895 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbYAOUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:32 -0500
Message-Id: <20080115205023.958370683@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 14/30 v3] ppc clock accumulate fix
Content-Disposition: inline; filename=ppc-clock-accumulate-update.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a quick and dirty fix for powerpc so it includes
cycle_accumulated in its calculation. It relies on the fact that the
powerpc clocksource is a 64bit counter (don't have to worry about
multiple overflows), so the subtraction should be safe.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/time.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-compile.git/arch/powerpc/kernel/time.c
===================================================================
--- linux-compile.git.orig/arch/powerpc/kernel/time.c	2008-01-14 13:13:43.000000000 -0500
+++ linux-compile.git/arch/powerpc/kernel/time.c	2008-01-14 13:14:13.000000000 -0500
@@ -773,7 +773,8 @@ void update_vsyscall(struct timespec *wa
 	stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
 	do_div(stamp_xsec, 1000000000);
 	stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
-	update_gtod(clock->cycle_last, stamp_xsec, t2x);
+	update_gtod(clock->cycle_last-clock->cycle_accumulated,
+		    stamp_xsec, t2x);
 }
 
 void update_vsyscall_tz(void)

-- 
