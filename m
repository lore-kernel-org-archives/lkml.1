Return-Path: <linux-kernel-owner+w=401wt.eu-S1762499AbZEFWDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762499AbZEFWDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761435AbZEFVyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:40 -0400
Received: from kroah.org ([198.145.64.141]:57089 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761436AbZEFVyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:58 2009
Message-Id: <20090506214758.213596036@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [patch 21/58] x86-64: fix FPU corruption with signals and preemption
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=x86-64-fix-fpu-corruption-with-signals-and-preemption.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 06c38d5e36b12d040839ff224e805146c0368556 upstream.

In 64bit signal delivery path, clear_used_math() was happening before saving
the current active FPU state on to the user stack for signal handling. Between
clear_used_math() and the state store on to the user stack, potentially we
can get a page fault for the user address and can block. Infact, while testing
we were hitting the might_fault() in __clear_user() which can do a schedule().

At a later point in time, we will schedule back into this process and
resume the save state (using "xsave/fxsave" instruction) which can lead
to DNA fault. And as used_math was cleared before, we will reinit the FP state
in the DNA fault and continue. This reinit will result in loosing the
FPU state of the process.

Move clear_used_math() to a point after the FPU state has been stored
onto the user stack.

This issue is present from a long time (even before the xsave changes
and the x86 merge). But it can easily be exposed in 2.6.28.x and 2.6.29.x
series because of the __clear_user() in this path, which has an explicit
__cond_resched() leading to a context switch with CONFIG_PREEMPT_VOLUNTARY.

[ Impact: fix FPU state corruption ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/xsave.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -89,7 +89,7 @@ int save_i387_xstate(void __user *buf)
 
 	if (!used_math())
 		return 0;
-	clear_used_math(); /* trigger finit */
+
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
 		/*
 	 	 * Start with clearing the user buffer. This will present a
@@ -114,6 +114,8 @@ int save_i387_xstate(void __user *buf)
 			return -1;
 	}
 
+	clear_used_math(); /* trigger finit */
+
 	if (task_thread_info(tsk)->status & TS_XSAVE) {
 		struct _fpstate __user *fx = buf;
 		struct _xstate __user *x = buf;


