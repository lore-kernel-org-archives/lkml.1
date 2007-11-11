Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbXKKT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbXKKT2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 14:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbXKKT2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 14:28:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:62468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbXKKT2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 14:28:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,402,1188802800"; 
   d="scan'208";a="316167037"
Date: Sun, 11 Nov 2007 11:27:59 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: [patch] x86: fix taking DNA during 64bit sigreturn
Message-ID: <20071111192758.GA21851@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

restore sigcontext is taking a DNA exception while restoring FP context from
the user stack, during the sigreturn. Appended patch fixes it by doing clts()
if the app doesn't touch FP during the signal handler execution. This will
stop generating a DNA, during the fxrstor in the sigreturn.

This improves 64-bit lat_sig numbers by ~30% on my core2 platform.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/i387_64.c b/arch/x86/kernel/i387_64.c
index 56c1f11..bfaff28 100644
--- a/arch/x86/kernel/i387_64.c
+++ b/arch/x86/kernel/i387_64.c
@@ -92,13 +92,14 @@ int save_i387(struct _fpstate __user *buf)
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
 		err = save_i387_checking((struct i387_fxsave_struct __user *)buf);
 		if (err) return err;
+		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
-		} else {
-		if (__copy_to_user(buf, &tsk->thread.i387.fxsave, 
+	} else {
+		if (__copy_to_user(buf, &tsk->thread.i387.fxsave,
 				   sizeof(struct i387_fxsave_struct)))
 			return -1;
-	} 
-		return 1;
+	}
+	return 1;
 }
 
 /*
diff --git a/include/asm-x86/i387_64.h b/include/asm-x86/i387_64.h
index 0217b74..3a4ffba 100644
--- a/include/asm-x86/i387_64.h
+++ b/include/asm-x86/i387_64.h
@@ -203,6 +203,11 @@ static inline void save_init_fpu(struct task_struct *tsk)
  */
 static inline int restore_i387(struct _fpstate __user *buf)
 {
+	set_used_math();
+	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
+		clts();
+		task_thread_info(current)->status |= TS_USEDFPU;
+	}
 	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
 }
 
