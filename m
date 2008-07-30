Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbYGaAJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbYGaAJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761222AbYGaAIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:08:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:38203 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761655AbYGaAIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:08:53 -0400
Date: Wed, 30 Jul 2008 16:58:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 15/62] Patch Upstream: x86 ptrace: fix PTRACE_GETFPXREGS
	error
Message-ID: <20080730235819.GO12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="patch-upstream-x86-ptrace-fix-ptrace_getfpxregs-error.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Roland McGrath <roland@redhat.com>

commit 45fdc3a7624a4a48185a04ae0abab5f9793d8952 upstream

ptrace has always returned only -EIO for all failures to access
registers.  The user_regset calls are allowed to return a more
meaningful variety of errors.  The REGSET_XFP calls use -ENODEV
for !cpu_has_fxsr hardware.  Make ptrace return the traditional
-EIO instead of the error code from the user_regset call.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/i387.c   |    4 ++--
 arch/x86/kernel/ptrace.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -162,7 +162,7 @@ int xfpregs_get(struct task_struct *targ
 	int ret;
 
 	if (!cpu_has_fxsr)
-		return -EIO;
+		return -ENODEV;
 
 	ret = init_fpu(target);
 	if (ret)
@@ -179,7 +179,7 @@ int xfpregs_set(struct task_struct *targ
 	int ret;
 
 	if (!cpu_has_fxsr)
-		return -EIO;
+		return -ENODEV;
 
 	ret = init_fpu(target);
 	if (ret)
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -943,13 +943,13 @@ long arch_ptrace(struct task_struct *chi
 		return copy_regset_to_user(child, &user_x86_32_view,
 					   REGSET_XFP,
 					   0, sizeof(struct user_fxsr_struct),
-					   datap);
+					   datap) ? -EIO : 0;
 
 	case PTRACE_SETFPXREGS:	/* Set the child extended FPU state. */
 		return copy_regset_from_user(child, &user_x86_32_view,
 					     REGSET_XFP,
 					     0, sizeof(struct user_fxsr_struct),
-					     datap);
+					     datap) ? -EIO : 0;
 #endif
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION

-- 
