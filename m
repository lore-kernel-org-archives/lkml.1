Return-Path: <linux-kernel-owner+w=401wt.eu-S933093AbYEGTKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbYEGTKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765614AbYEGTJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:09:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:2595 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764722AbYEGTJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:09:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,450,1204531200"; 
   d="scan'208";a="325557468"
Date: Wed, 7 May 2008 12:09:52 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Frederik Deweerdt <deweerdt@free.fr>, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Oops with strace_test
Message-ID: <20080507190952.GA11931@linux-os.sc.intel.com>
References: <20080430121202.GD18314@alice> <20080505100008.GA2354@alice> <20080505180053.GB5576@slug> <20080506121005.GJ32591@elte.hu> <20080507103615.GC2340@alice> <alpine.LFD.1.10.0805071534580.3318@apollo.tec.linutronix.de> <20080507172032.GB3348@alice> <alpine.LFD.1.10.0805071924550.3318@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071924550.3318@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 07:26:20PM +0200, Thomas Gleixner wrote:
> 
> Ok, we decoded the problem in meantime. Suresh will send a patch soon.

Appended patch should fix it. Eric, can you please check if it fixes the issue?
I have to fix the math-emu aswell. But I will send a different patch for it.

thanks,
suresh
---

[patch] fix fpu restore during sig return

If the task never used fpu, initialize the fpu before restoring the FP state
from the signal handler context. This will allocate the fpu state,
if the task never needed it before.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index db6839b..45e19ee 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -450,7 +450,6 @@ static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
 
-	clear_fpu(tsk);
 	return __copy_from_user(&tsk->thread.xstate->fsave, buf,
 				sizeof(struct i387_fsave_struct));
 }
@@ -461,7 +460,6 @@ static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
 	struct user_i387_ia32_struct env;
 	int err;
 
-	clear_fpu(tsk);
 	err = __copy_from_user(&tsk->thread.xstate->fxsave, &buf->_fxsr_env[0],
 			       sizeof(struct i387_fxsave_struct));
 	/* mxcsr reserved bits must be masked to zero for security reasons */
@@ -478,6 +476,16 @@ int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
 	int err;
 
 	if (HAVE_HWFP) {
+		struct task_struct *tsk = current;
+		
+		clear_fpu(tsk);
+
+		if (!used_math()) {
+			err = init_fpu(tsk);
+			if (err)
+				return err;
+		}
+		
 		if (cpu_has_fxsr)
 			err = restore_i387_fxsave(buf);
 		else
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index da2adb4..6b722d3 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -175,7 +175,15 @@ static inline int save_i387(struct _fpstate __user *buf)
  */
 static inline int restore_i387(struct _fpstate __user *buf)
 {
-	set_used_math();
+	struct task_struct *tsk = current;
+	int err;
+
+	if (!used_math()) {
+		err = init_fpu(tsk);
+		if (err)
+			return err;
+	}
+
 	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
 		clts();
 		task_thread_info(current)->status |= TS_USEDFPU;
