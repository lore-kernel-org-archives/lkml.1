Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbYGAPXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbYGAPXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbYGAPWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:22:20 -0400
Received: from mail.suse.de ([195.135.220.2]:43305 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760022AbYGAPWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:22:19 -0400
Date: Tue, 1 Jul 2008 08:19:10 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jeff Dike <jdike@addtoit.com>, Joris van Rantwijk <jorispubl@xs4all.nl>,
       Thorsten Knabe <linux@thorsten-knabe.de>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 5/9] x86_64 ptrace: fix sys32_ptrace task_struct leak
Message-ID: <20080701151910.GF3536@suse.de>
References: <20080701151057.930340322@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86_64-ptrace-fix-sys32_ptrace-task_struct-leak.patch"
In-Reply-To: <20080701151835.GA3536@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Roland McGrath <roland@redhat.com>

Commit 5a4646a4efed8c835f76c3b88f3155f6ab5b8d9b introduced a leak of
task_struct refs into sys32_ptrace.  This bug has already gone away in
for 2.6.26 in commit 562b80bafffaf42a6d916b0a2ee3d684220a1c10.

Signed-off-by: Roland McGrath <roland@redhat.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/ptrace.c |   45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1309,42 +1309,49 @@ asmlinkage long sys32_ptrace(long reques
 		break;
 
 	case PTRACE_GETREGS:	/* Get all gp regs from the child. */
-		return copy_regset_to_user(child, &user_x86_32_view,
-					   REGSET_GENERAL,
-					   0, sizeof(struct user_regs_struct32),
-					   datap);
+		ret = copy_regset_to_user(child, &user_x86_32_view,
+					  REGSET_GENERAL,
+					  0, sizeof(struct user_regs_struct32),
+					  datap);
+		break;
 
 	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
-		return copy_regset_from_user(child, &user_x86_32_view,
-					     REGSET_GENERAL, 0,
-					     sizeof(struct user_regs_struct32),
-					     datap);
+		ret = copy_regset_from_user(child, &user_x86_32_view,
+					    REGSET_GENERAL, 0,
+					    sizeof(struct user_regs_struct32),
+					    datap);
+		break;
 
 	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
-		return copy_regset_to_user(child, &user_x86_32_view,
-					   REGSET_FP, 0,
-					   sizeof(struct user_i387_ia32_struct),
-					   datap);
+		ret = copy_regset_to_user(child, &user_x86_32_view,
+					  REGSET_FP, 0,
+					  sizeof(struct user_i387_ia32_struct),
+					  datap);
+		break;
 
 	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
-		return copy_regset_from_user(
+		ret = copy_regset_from_user(
 			child, &user_x86_32_view, REGSET_FP,
 			0, sizeof(struct user_i387_ia32_struct), datap);
+		break;
 
 	case PTRACE_GETFPXREGS:	/* Get the child extended FPU state. */
-		return copy_regset_to_user(child, &user_x86_32_view,
-					   REGSET_XFP, 0,
-					   sizeof(struct user32_fxsr_struct),
-					   datap);
+		ret = copy_regset_to_user(child, &user_x86_32_view,
+					  REGSET_XFP, 0,
+					  sizeof(struct user32_fxsr_struct),
+					  datap);
+		break;
 
 	case PTRACE_SETFPXREGS:	/* Set the child extended FPU state. */
-		return copy_regset_from_user(child, &user_x86_32_view,
+		ret = copy_regset_from_user(child, &user_x86_32_view,
 					     REGSET_XFP, 0,
 					     sizeof(struct user32_fxsr_struct),
 					     datap);
+		break;
 
 	default:
-		return compat_ptrace_request(child, request, addr, data);
+		ret = compat_ptrace_request(child, request, addr, data);
+		break;
 	}
 
  out:

-- 
