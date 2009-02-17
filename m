Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZBQSSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZBQSSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZBQSSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:18:11 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:62103 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbZBQSSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:18:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEAOyKmklMQWt2/2dsb2JhbACBbtFVhBMG
Date: Tue, 17 Feb 2009 13:18:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King <rmk@arm.linux.org.uk>
Cc: "Rosendahl Viktor (Nokia-D/Helsinki)" <Viktor.Rosendahl@nokia.com>,
       ext Tony Lindgren <tony@atomide.com>,
       "Moiseichuk Leonid (Nokia-D/Helsinki)" <leonid.moiseichuk@nokia.com>,
       "Kallioinen Juha (Nokia-D/Helsinki)" <juha.kallioinen@nokia.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       Eero Tamminen <eero.tamminen@nokia.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: [PATCH] ARM fix syscall trace return value
Message-ID: <20090217181805.GA15788@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:06:55 up 47 days, 18:05,  4 users,  load average: 0.31, 0.31,
	0.29
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

I am currently finding core bugs in the Linux kernel implementation of
the ARM architecture. :-( e.g. return value not being sent to the
syscall_trace function upon exit (upon which LTTng depends). (patch
below)

This is _very_ silly because there is no dependency on the syscall being
executed, and the syscall_entry/syscall_exit events are recorded at the
_exact_ same time. Yes, I mean the _exact_ same time : using a clock
which consists of atomic_add_return monotonic increments, it seems like
ARM is able to return the _same_ value of an atomic increment return
*twice* !! I think the atomic.h primitives are broken and that they
allow concurrent modification of a given atomic variable by the pipeline.
It sounds weird, and I hope I am not crazy (just getting into the ARM
world..). ;) Any thoughts ? I'll try adding some barriers to see if it
helps.

BTW, the patch below applies to 2.6.29-rc4.

Mathieu


ARM fix syscall trace return value

I noticed that the arm syscall_trace, when called upon syscall return,
passes the system call number rather than the return value to
syscall_trace. This caused very very weird behavior with LTTng probably
due to pipeline effects, because there was no dependency on the
syscall return value. Therefore, we were seeing the syscall entry,
syscall exit events (with the _same_ timestamp ! Is it possible that
the ARM atomic increment return is not really atomic wrt such pipeline
effects ?), then followed by fs.open (which should clearly have
happened in between.

This patch modifies entry-common.S to pass the correct register
to syscall_trace upon system call exit.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: rmk@arm.linux.org.uk
CC: Eero Tamminen <eero.tamminen@nokia.com>
---
 arch/arm/kernel/entry-common.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-omap-2.6/arch/arm/kernel/entry-common.S
===================================================================
--- linux-omap-2.6.orig/arch/arm/kernel/entry-common.S	2009-02-17 16:58:14.000000000 +0000
+++ linux-omap-2.6/arch/arm/kernel/entry-common.S	2009-02-17 17:24:33.000000000 +0000
@@ -89,6 +89,7 @@
 	mov	why, #1
 	tst	r1, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
 	beq	ret_slow_syscall
+	mov	r2, #0				@ fork returns 0 to the child
 	mov	r1, sp
 	mov	r0, #1				@ trace exit [IP = 1]
 	bl	syscall_trace
@@ -292,7 +293,7 @@
 
 __sys_trace_return:
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
-	mov	r2, scno
+	mov	r2, r0
 	mov	r1, sp
 	mov	r0, #1				@ trace exit [IP = 1]
 	bl	syscall_trace

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
