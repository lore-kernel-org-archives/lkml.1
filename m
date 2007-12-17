Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbXLQRPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbXLQRPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbXLQRPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:15:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:64590 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbXLQRPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:15:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=XV01DNhol1Us3Rb/XUo0cu3GUUWr6brUg66MrrZANZ0kSvTtUYsFNqV0InID1VXM9XUA15rr4sZtpFvJYPzNjOBT5HeBajWvcLlhmQv2IzT9kYS75p+Wwqa3PuURcDcZ8L3pWPJjAy1xKK+IvhbrXJL1H7hUk63C7U/pz4Iu2lE=
Date: Mon, 17 Dec 2007 20:15:07 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: cleanup i387_32.c according to checkpatch
Message-ID: <20071217171507.GD7882@cvg.cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does cleanup checkpatch warnings/errors on i387_32.c

Signed-off-by: Cyrill Gorcunov <gorunov@gmail.com>
---

Ingo this patch is over x86 tree so it could be applied without
hand-works I hope ;)
The old and new i387_32.s (asm listings) were checked with diff to be
identical so it's safe to apply this patch.

 arch/x86/kernel/i387_32.c |  291 +++++++++++++++++++++++----------------------
 1 files changed, 149 insertions(+), 142 deletions(-)

diff --git a/arch/x86/kernel/i387_32.c b/arch/x86/kernel/i387_32.c
index 7d2e12f..bebe034 100644
--- a/arch/x86/kernel/i387_32.c
+++ b/arch/x86/kernel/i387_32.c
@@ -29,11 +29,13 @@ void mxcsr_feature_mask_init(void)
 	unsigned long mask = 0;
 	clts();
 	if (cpu_has_fxsr) {
-		memset(&current->thread.i387.fxsave, 0, sizeof(struct i387_fxsave_struct));
-		asm volatile("fxsave %0" : : "m" (current->thread.i387.fxsave)); 
+		memset(&current->thread.i387.fxsave, 0,
+		       sizeof(struct i387_fxsave_struct));
+		asm volatile("fxsave %0" : : "m" (current->thread.i387.fxsave));
 		mask = current->thread.i387.fxsave.mxcsr_mask;
-		if (mask == 0) mask = 0x0000ffbf;
-	} 
+		if (mask == 0)
+			mask = 0x0000ffbf;
+	}
 	mxcsr_feature_mask &= mask;
 	stts();
 }
@@ -47,18 +49,21 @@ void mxcsr_feature_mask_init(void)
 void init_fpu(struct task_struct *tsk)
 {
 	if (cpu_has_fxsr) {
-		memset(&tsk->thread.i387.fxsave, 0, sizeof(struct i387_fxsave_struct));
+		memset(&tsk->thread.i387.fxsave, 0,
+		       sizeof(struct i387_fxsave_struct));
 		tsk->thread.i387.fxsave.cwd = 0x37f;
 		if (cpu_has_xmm)
 			tsk->thread.i387.fxsave.mxcsr = 0x1f80;
 	} else {
-		memset(&tsk->thread.i387.fsave, 0, sizeof(struct i387_fsave_struct));
+		memset(&tsk->thread.i387.fsave, 0,
+		       sizeof(struct i387_fsave_struct));
 		tsk->thread.i387.fsave.cwd = 0xffff037fu;
 		tsk->thread.i387.fsave.swd = 0xffff0000u;
 		tsk->thread.i387.fsave.twd = 0xffffffffu;
 		tsk->thread.i387.fsave.fos = 0xffff0000u;
 	}
-	/* only the device not available exception or ptrace can call init_fpu */
+	/* only the device not available exception
+	 * or ptrace can call init_fpu */
 	set_stopped_child_used_math(tsk);
 }
 
@@ -83,21 +88,22 @@ EXPORT_SYMBOL_GPL(kernel_fpu_begin);
  * FPU tag word conversions.
  */
 
-static inline unsigned short twd_i387_to_fxsr( unsigned short twd )
+static inline unsigned short twd_i387_to_fxsr(unsigned short twd)
 {
 	unsigned int tmp; /* to avoid 16 bit prefixes in the code */
- 
+
 	/* Transform each pair of bits into 01 (valid) or 00 (empty) */
-        tmp = ~twd;
-        tmp = (tmp | (tmp>>1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
-        /* and move the valid bits to the lower byte. */
-        tmp = (tmp | (tmp >> 1)) & 0x3333; /* 00VV00VV00VV00VV */
-        tmp = (tmp | (tmp >> 2)) & 0x0f0f; /* 0000VVVV0000VVVV */
-        tmp = (tmp | (tmp >> 4)) & 0x00ff; /* 00000000VVVVVVVV */
-        return tmp;
+	tmp = ~twd;
+	tmp = (tmp | (tmp >> 1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
+	/* and move the valid bits to the lower byte. */
+	tmp = (tmp | (tmp >> 1)) & 0x3333; /* 00VV00VV00VV00VV */
+	tmp = (tmp | (tmp >> 2)) & 0x0f0f; /* 0000VVVV0000VVVV */
+	tmp = (tmp | (tmp >> 4)) & 0x00ff; /* 00000000VVVVVVVV */
+
+	return tmp;
 }
 
-static inline unsigned long twd_fxsr_to_i387( struct i387_fxsave_struct *fxsave )
+static inline unsigned long twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
 {
 	struct _fpxreg *st = NULL;
 	unsigned long tos = (fxsave->swd >> 11) & 7;
@@ -108,26 +114,26 @@ static inline unsigned long twd_fxsr_to_i387( struct i387_fxsave_struct *fxsave
 
 #define FPREG_ADDR(f, n)	((void *)&(f)->st_space + (n) * 16);
 
-	for ( i = 0 ; i < 8 ; i++ ) {
-		if ( twd & 0x1 ) {
-			st = FPREG_ADDR( fxsave, (i - tos) & 7 );
+	for (i = 0; i < 8; i++) {
+		if (twd & 0x1) {
+			st = FPREG_ADDR(fxsave, (i - tos) & 7);
 
-			switch ( st->exponent & 0x7fff ) {
+			switch (st->exponent & 0x7fff) {
 			case 0x7fff:
 				tag = 2;		/* Special */
 				break;
 			case 0x0000:
-				if ( !st->significand[0] &&
-				     !st->significand[1] &&
-				     !st->significand[2] &&
-				     !st->significand[3] ) {
+				if (!st->significand[0] &&
+				    !st->significand[1] &&
+				    !st->significand[2] &&
+				    !st->significand[3]) {
 					tag = 1;	/* Zero */
 				} else {
 					tag = 2;	/* Special */
 				}
 				break;
 			default:
-				if ( st->significand[3] & 0x8000 ) {
+				if (st->significand[3] & 0x8000) {
 					tag = 0;	/* Valid */
 				} else {
 					tag = 2;	/* Special */
@@ -147,18 +153,18 @@ static inline unsigned long twd_fxsr_to_i387( struct i387_fxsave_struct *fxsave
  * FPU state interaction.
  */
 
-unsigned short get_fpu_cwd( struct task_struct *tsk )
+unsigned short get_fpu_cwd(struct task_struct *tsk)
 {
-	if ( cpu_has_fxsr ) {
+	if (cpu_has_fxsr) {
 		return tsk->thread.i387.fxsave.cwd;
 	} else {
 		return (unsigned short)tsk->thread.i387.fsave.cwd;
 	}
 }
 
-unsigned short get_fpu_swd( struct task_struct *tsk )
+unsigned short get_fpu_swd(struct task_struct *tsk)
 {
-	if ( cpu_has_fxsr ) {
+	if (cpu_has_fxsr) {
 		return tsk->thread.i387.fxsave.swd;
 	} else {
 		return (unsigned short)tsk->thread.i387.fsave.swd;
@@ -166,9 +172,9 @@ unsigned short get_fpu_swd( struct task_struct *tsk )
 }
 
 #if 0
-unsigned short get_fpu_twd( struct task_struct *tsk )
+unsigned short get_fpu_twd(struct task_struct *tsk)
 {
-	if ( cpu_has_fxsr ) {
+	if (cpu_has_fxsr) {
 		return tsk->thread.i387.fxsave.twd;
 	} else {
 		return (unsigned short)tsk->thread.i387.fsave.twd;
@@ -176,9 +182,9 @@ unsigned short get_fpu_twd( struct task_struct *tsk )
 }
 #endif  /*  0  */
 
-unsigned short get_fpu_mxcsr( struct task_struct *tsk )
+unsigned short get_fpu_mxcsr(struct task_struct *tsk)
 {
-	if ( cpu_has_xmm ) {
+	if (cpu_has_xmm) {
 		return tsk->thread.i387.fxsave.mxcsr;
 	} else {
 		return 0x1f80;
@@ -187,27 +193,27 @@ unsigned short get_fpu_mxcsr( struct task_struct *tsk )
 
 #if 0
 
-void set_fpu_cwd( struct task_struct *tsk, unsigned short cwd )
+void set_fpu_cwd(struct task_struct *tsk, unsigned short cwd)
 {
-	if ( cpu_has_fxsr ) {
+	if (cpu_has_fxsr) {
 		tsk->thread.i387.fxsave.cwd = cwd;
 	} else {
 		tsk->thread.i387.fsave.cwd = ((long)cwd | 0xffff0000u);
 	}
 }
 
-void set_fpu_swd( struct task_struct *tsk, unsigned short swd )
+void set_fpu_swd(struct task_struct *tsk, unsigned short swd)
 {
-	if ( cpu_has_fxsr ) {
+	if (cpu_has_fxsr) {
 		tsk->thread.i387.fxsave.swd = swd;
 	} else {
 		tsk->thread.i387.fsave.swd = ((long)swd | 0xffff0000u);
 	}
 }
 
-void set_fpu_twd( struct task_struct *tsk, unsigned short twd )
+void set_fpu_twd(struct task_struct *tsk, unsigned short twd)
 {
-	if ( cpu_has_fxsr ) {
+	if (cpu_has_fxsr) {
 		tsk->thread.i387.fxsave.twd = twd_i387_to_fxsr(twd);
 	} else {
 		tsk->thread.i387.fsave.twd = ((long)twd | 0xffff0000u);
@@ -220,8 +226,8 @@ void set_fpu_twd( struct task_struct *tsk, unsigned short twd )
  * FXSR floating point environment conversions.
  */
 
-static int convert_fxsr_to_user( struct _fpstate __user *buf,
-					struct i387_fxsave_struct *fxsave )
+static int convert_fxsr_to_user(struct _fpstate __user *buf,
+				struct i387_fxsave_struct *fxsave)
 {
 	unsigned long env[7];
 	struct _fpreg __user *to;
@@ -236,32 +242,32 @@ static int convert_fxsr_to_user( struct _fpstate __user *buf,
 	env[5] = fxsave->foo;
 	env[6] = fxsave->fos;
 
-	if ( __copy_to_user( buf, env, 7 * sizeof(unsigned long) ) )
+	if (__copy_to_user(buf, env, 7 * sizeof(unsigned long)))
 		return 1;
 
 	to = &buf->_st[0];
 	from = (struct _fpxreg *) &fxsave->st_space[0];
-	for ( i = 0 ; i < 8 ; i++, to++, from++ ) {
+	for (i = 0; i < 8; i++, to++, from++) {
 		unsigned long __user *t = (unsigned long __user *)to;
 		unsigned long *f = (unsigned long *)from;
 
 		if (__put_user(*f, t) ||
-				__put_user(*(f + 1), t + 1) ||
-				__put_user(from->exponent, &to->exponent))
+		    __put_user(*(f + 1), t + 1) ||
+		    __put_user(from->exponent, &to->exponent))
 			return 1;
 	}
 	return 0;
 }
 
-static int convert_fxsr_from_user( struct i387_fxsave_struct *fxsave,
-					  struct _fpstate __user *buf )
+static int convert_fxsr_from_user(struct i387_fxsave_struct *fxsave,
+				  struct _fpstate __user *buf)
 {
 	unsigned long env[7];
 	struct _fpxreg *to;
 	struct _fpreg __user *from;
 	int i;
 
-	if ( __copy_from_user( env, buf, 7 * sizeof(long) ) )
+	if (__copy_from_user(env, buf, 7 * sizeof(long)))
 		return 1;
 
 	fxsave->cwd = (unsigned short)(env[0] & 0xffff);
@@ -275,13 +281,13 @@ static int convert_fxsr_from_user( struct i387_fxsave_struct *fxsave,
 
 	to = (struct _fpxreg *) &fxsave->st_space[0];
 	from = &buf->_st[0];
-	for ( i = 0 ; i < 8 ; i++, to++, from++ ) {
+	for (i = 0; i < 8; i++, to++, from++) {
 		unsigned long *t = (unsigned long *)to;
 		unsigned long __user *f = (unsigned long __user *)from;
 
 		if (__get_user(*t, f) ||
-				__get_user(*(t + 1), f + 1) ||
-				__get_user(to->exponent, &from->exponent))
+		    __get_user(*(t + 1), f + 1) ||
+		    __get_user(to->exponent, &from->exponent))
 			return 1;
 	}
 	return 0;
@@ -291,42 +297,42 @@ static int convert_fxsr_from_user( struct i387_fxsave_struct *fxsave,
  * Signal frame handlers.
  */
 
-static inline int save_i387_fsave( struct _fpstate __user *buf )
+static inline int save_i387_fsave(struct _fpstate __user *buf)
 {
 	struct task_struct *tsk = current;
 
-	unlazy_fpu( tsk );
+	unlazy_fpu(tsk);
 	tsk->thread.i387.fsave.status = tsk->thread.i387.fsave.swd;
-	if ( __copy_to_user( buf, &tsk->thread.i387.fsave,
-			     sizeof(struct i387_fsave_struct) ) )
+	if (__copy_to_user(buf, &tsk->thread.i387.fsave,
+			   sizeof(struct i387_fsave_struct)))
 		return -1;
 	return 1;
 }
 
-static int save_i387_fxsave( struct _fpstate __user *buf )
+static int save_i387_fxsave(struct _fpstate __user *buf)
 {
 	struct task_struct *tsk = current;
 	int err = 0;
 
-	unlazy_fpu( tsk );
+	unlazy_fpu(tsk);
 
-	if ( convert_fxsr_to_user( buf, &tsk->thread.i387.fxsave ) )
+	if (convert_fxsr_to_user(buf, &tsk->thread.i387.fxsave))
 		return -1;
 
-	err |= __put_user( tsk->thread.i387.fxsave.swd, &buf->status );
-	err |= __put_user( X86_FXSR_MAGIC, &buf->magic );
-	if ( err )
+	err |= __put_user(tsk->thread.i387.fxsave.swd, &buf->status);
+	err |= __put_user(X86_FXSR_MAGIC, &buf->magic);
+	if (err)
 		return -1;
 
-	if ( __copy_to_user( &buf->_fxsr_env[0], &tsk->thread.i387.fxsave,
-			     sizeof(struct i387_fxsave_struct) ) )
+	if (__copy_to_user(&buf->_fxsr_env[0], &tsk->thread.i387.fxsave,
+			   sizeof(struct i387_fxsave_struct)))
 		return -1;
 	return 1;
 }
 
-int save_i387( struct _fpstate __user *buf )
+int save_i387(struct _fpstate __user *buf)
 {
-	if ( !used_math() )
+	if (!used_math())
 		return 0;
 
 	/* This will cause a "finit" to be triggered by the next
@@ -334,49 +340,49 @@ int save_i387( struct _fpstate __user *buf )
 	 */
 	clear_used_math();
 
-	if ( HAVE_HWFP ) {
-		if ( cpu_has_fxsr ) {
-			return save_i387_fxsave( buf );
+	if (HAVE_HWFP) {
+		if (cpu_has_fxsr) {
+			return save_i387_fxsave(buf);
 		} else {
-			return save_i387_fsave( buf );
+			return save_i387_fsave(buf);
 		}
 	} else {
-		return save_i387_soft( &current->thread.i387.soft, buf );
+		return save_i387_soft(&current->thread.i387.soft, buf);
 	}
 }
 
-static inline int restore_i387_fsave( struct _fpstate __user *buf )
+static inline int restore_i387_fsave(struct _fpstate __user *buf)
 {
 	struct task_struct *tsk = current;
-	clear_fpu( tsk );
-	return __copy_from_user( &tsk->thread.i387.fsave, buf,
-				 sizeof(struct i387_fsave_struct) );
+	clear_fpu(tsk);
+	return __copy_from_user(&tsk->thread.i387.fsave, buf,
+				sizeof(struct i387_fsave_struct));
 }
 
-static int restore_i387_fxsave( struct _fpstate __user *buf )
+static int restore_i387_fxsave(struct _fpstate __user *buf)
 {
 	int err;
 	struct task_struct *tsk = current;
-	clear_fpu( tsk );
-	err = __copy_from_user( &tsk->thread.i387.fxsave, &buf->_fxsr_env[0],
-				sizeof(struct i387_fxsave_struct) );
+	clear_fpu(tsk);
+	err = __copy_from_user(&tsk->thread.i387.fxsave, &buf->_fxsr_env[0],
+			       sizeof(struct i387_fxsave_struct));
 	/* mxcsr reserved bits must be masked to zero for security reasons */
 	tsk->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
-	return err ? 1 : convert_fxsr_from_user( &tsk->thread.i387.fxsave, buf );
+	return err ? 1 : convert_fxsr_from_user(&tsk->thread.i387.fxsave, buf);
 }
 
-int restore_i387( struct _fpstate __user *buf )
+int restore_i387(struct _fpstate __user *buf)
 {
 	int err;
 
-	if ( HAVE_HWFP ) {
-		if ( cpu_has_fxsr ) {
-			err = restore_i387_fxsave( buf );
+	if (HAVE_HWFP) {
+		if (cpu_has_fxsr) {
+			err = restore_i387_fxsave(buf);
 		} else {
-			err = restore_i387_fsave( buf );
+			err = restore_i387_fsave(buf);
 		}
 	} else {
-		err = restore_i387_soft( &current->thread.i387.soft, buf );
+		err = restore_i387_soft(&current->thread.i387.soft, buf);
 	}
 	set_used_math();
 	return err;
@@ -386,67 +392,67 @@ int restore_i387( struct _fpstate __user *buf )
  * ptrace request handlers.
  */
 
-static inline int get_fpregs_fsave( struct user_i387_struct __user *buf,
-				    struct task_struct *tsk )
+static inline int get_fpregs_fsave(struct user_i387_struct __user *buf,
+				   struct task_struct *tsk)
 {
-	return __copy_to_user( buf, &tsk->thread.i387.fsave,
-			       sizeof(struct user_i387_struct) );
+	return __copy_to_user(buf, &tsk->thread.i387.fsave,
+			      sizeof(struct user_i387_struct));
 }
 
-static inline int get_fpregs_fxsave( struct user_i387_struct __user *buf,
-				     struct task_struct *tsk )
+static inline int get_fpregs_fxsave(struct user_i387_struct __user *buf,
+				    struct task_struct *tsk)
 {
-	return convert_fxsr_to_user( (struct _fpstate __user *)buf,
-				     &tsk->thread.i387.fxsave );
+	return convert_fxsr_to_user((struct _fpstate __user *)buf,
+				    &tsk->thread.i387.fxsave);
 }
 
-int get_fpregs( struct user_i387_struct __user *buf, struct task_struct *tsk )
+int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *tsk)
 {
-	if ( HAVE_HWFP ) {
-		if ( cpu_has_fxsr ) {
-			return get_fpregs_fxsave( buf, tsk );
+	if (HAVE_HWFP) {
+		if (cpu_has_fxsr) {
+			return get_fpregs_fxsave(buf, tsk);
 		} else {
-			return get_fpregs_fsave( buf, tsk );
+			return get_fpregs_fsave(buf, tsk);
 		}
 	} else {
-		return save_i387_soft( &tsk->thread.i387.soft,
-				       (struct _fpstate __user *)buf );
+		return save_i387_soft(&tsk->thread.i387.soft,
+				      (struct _fpstate __user *)buf);
 	}
 }
 
-static inline int set_fpregs_fsave( struct task_struct *tsk,
-				    struct user_i387_struct __user *buf )
+static inline int set_fpregs_fsave(struct task_struct *tsk,
+				   struct user_i387_struct __user *buf)
 {
-	return __copy_from_user( &tsk->thread.i387.fsave, buf,
-				 sizeof(struct user_i387_struct) );
+	return __copy_from_user(&tsk->thread.i387.fsave, buf,
+				sizeof(struct user_i387_struct));
 }
 
-static inline int set_fpregs_fxsave( struct task_struct *tsk,
-				     struct user_i387_struct __user *buf )
+static inline int set_fpregs_fxsave(struct task_struct *tsk,
+				    struct user_i387_struct __user *buf)
 {
-	return convert_fxsr_from_user( &tsk->thread.i387.fxsave,
-				       (struct _fpstate __user *)buf );
+	return convert_fxsr_from_user(&tsk->thread.i387.fxsave,
+				      (struct _fpstate __user *)buf);
 }
 
-int set_fpregs( struct task_struct *tsk, struct user_i387_struct __user *buf )
+int set_fpregs(struct task_struct *tsk, struct user_i387_struct __user *buf)
 {
-	if ( HAVE_HWFP ) {
-		if ( cpu_has_fxsr ) {
-			return set_fpregs_fxsave( tsk, buf );
+	if (HAVE_HWFP) {
+		if (cpu_has_fxsr) {
+			return set_fpregs_fxsave(tsk, buf);
 		} else {
-			return set_fpregs_fsave( tsk, buf );
+			return set_fpregs_fsave(tsk, buf);
 		}
 	} else {
-		return restore_i387_soft( &tsk->thread.i387.soft,
-					  (struct _fpstate __user *)buf );
+		return restore_i387_soft(&tsk->thread.i387.soft,
+					 (struct _fpstate __user *)buf);
 	}
 }
 
-int get_fpxregs( struct user_fxsr_struct __user *buf, struct task_struct *tsk )
+int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *tsk)
 {
-	if ( cpu_has_fxsr ) {
-		if (__copy_to_user( buf, &tsk->thread.i387.fxsave,
-				    sizeof(struct user_fxsr_struct) ))
+	if (cpu_has_fxsr) {
+		if (__copy_to_user(buf, &tsk->thread.i387.fxsave,
+				   sizeof(struct user_fxsr_struct)))
 			return -EFAULT;
 		return 0;
 	} else {
@@ -454,15 +460,16 @@ int get_fpxregs( struct user_fxsr_struct __user *buf, struct task_struct *tsk )
 	}
 }
 
-int set_fpxregs( struct task_struct *tsk, struct user_fxsr_struct __user *buf )
+int set_fpxregs(struct task_struct *tsk, struct user_fxsr_struct __user *buf)
 {
 	int ret = 0;
 
-	if ( cpu_has_fxsr ) {
-		if (__copy_from_user( &tsk->thread.i387.fxsave, buf,
-				  sizeof(struct user_fxsr_struct) ))
+	if (cpu_has_fxsr) {
+		if (__copy_from_user(&tsk->thread.i387.fxsave, buf,
+				     sizeof(struct user_fxsr_struct)))
 			ret = -EFAULT;
-		/* mxcsr reserved bits must be masked to zero for security reasons */
+		/* mxcsr reserved bits must be masked to zero
+		 * for security reasons */
 		tsk->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
 	} else {
 		ret = -EIO;
@@ -474,41 +481,40 @@ int set_fpxregs( struct task_struct *tsk, struct user_fxsr_struct __user *buf )
  * FPU state for core dumps.
  */
 
-static inline void copy_fpu_fsave( struct task_struct *tsk,
-				   struct user_i387_struct *fpu )
+static inline void copy_fpu_fsave(struct task_struct *tsk,
+				  struct user_i387_struct *fpu)
 {
-	memcpy( fpu, &tsk->thread.i387.fsave,
-		sizeof(struct user_i387_struct) );
+	memcpy(fpu, &tsk->thread.i387.fsave,
+	       sizeof(struct user_i387_struct));
 }
 
-static inline void copy_fpu_fxsave( struct task_struct *tsk,
-				   struct user_i387_struct *fpu )
+static inline void copy_fpu_fxsave(struct task_struct *tsk,
+				   struct user_i387_struct *fpu)
 {
 	unsigned short *to;
 	unsigned short *from;
 	int i;
 
-	memcpy( fpu, &tsk->thread.i387.fxsave, 7 * sizeof(long) );
+	memcpy(fpu, &tsk->thread.i387.fxsave, 7 * sizeof(long));
 
 	to = (unsigned short *)&fpu->st_space[0];
 	from = (unsigned short *)&tsk->thread.i387.fxsave.st_space[0];
-	for ( i = 0 ; i < 8 ; i++, to += 5, from += 8 ) {
-		memcpy( to, from, 5 * sizeof(unsigned short) );
-	}
+	for (i = 0; i < 8; i++, to += 5, from += 8)
+		memcpy(to, from, 5 * sizeof(unsigned short));
 }
 
-int dump_fpu( struct pt_regs *regs, struct user_i387_struct *fpu )
+int dump_fpu(struct pt_regs *regs, struct user_i387_struct *fpu)
 {
 	int fpvalid;
 	struct task_struct *tsk = current;
 
 	fpvalid = !!used_math();
-	if ( fpvalid ) {
-		unlazy_fpu( tsk );
-		if ( cpu_has_fxsr ) {
-			copy_fpu_fxsave( tsk, fpu );
+	if (fpvalid) {
+		unlazy_fpu(tsk);
+		if (cpu_has_fxsr) {
+			copy_fpu_fxsave(tsk, fpu);
 		} else {
-			copy_fpu_fsave( tsk, fpu );
+			copy_fpu_fsave(tsk, fpu);
 		}
 	}
 
@@ -531,7 +537,8 @@ int dump_task_fpu(struct task_struct *tsk, struct user_i387_struct *fpu)
 	return fpvalid;
 }
 
-int dump_task_extended_fpu(struct task_struct *tsk, struct user_fxsr_struct *fpu)
+int dump_task_extended_fpu(struct task_struct *tsk,
+			   struct user_fxsr_struct *fpu)
 {
 	int fpvalid = tsk_used_math(tsk) && cpu_has_fxsr;
 

