Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZBUDBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZBUDBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 22:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZBUDA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 22:00:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:60076 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbZBUDA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:00:56 -0500
Message-ID: <499F6E66.7050906@ct.jp.nec.com>
Date: Fri, 20 Feb 2009 19:00:54 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: ia32_signal: introduce {get|set}_user_seg()
References: <499F6DB6.3060500@ct.jp.nec.com>
In-Reply-To: <499F6DB6.3060500@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Introduce {get|set}_user_seg() and loadsegment_xx() macros to make code clean.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |   38 ++++++++++++++++++--------------------
 1 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 8dd0903..588a7aa 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -188,6 +188,14 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 /*
  * Do a signal return; undo the signal stack.
  */
+#define loadsegment_gs(v)	load_gs_index(v)
+#define loadsegment_fs(v)	loadsegment(fs, v)
+#define loadsegment_ds(v)	loadsegment(ds, v)
+#define loadsegment_es(v)	loadsegment(es, v)
+
+#define get_user_seg(seg)	({ unsigned int v; savesegment(seg, v); v; })
+#define set_user_seg(seg, v)	loadsegment_##seg(v)
+
 #define COPY(x)			{		\
 	get_user_ex(regs->x, &sc->x);		\
 }
@@ -203,19 +211,18 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 } while (0)
 
 #define RELOAD_SEG(seg)		{		\
-	unsigned int cur, pre;			\
-	get_user_ex(pre, &sc->seg);		\
-	savesegment(seg, cur);			\
+	unsigned int pre = GET_SEG(seg);	\
+	unsigned int cur = get_user_seg(seg);	\
 	pre |= 3;				\
 	if (pre != cur)				\
-		loadsegment(seg, pre);		\
+		set_user_seg(seg, pre);		\
 }
 
 static int ia32_restore_sigcontext(struct pt_regs *regs,
 				   struct sigcontext_ia32 __user *sc,
 				   unsigned int *pax)
 {
-	unsigned int tmpflags, gs, oldgs, err = 0;
+	unsigned int tmpflags, err = 0;
 	void __user *buf;
 	u32 tmp;
 
@@ -229,12 +236,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 		 * the handler, but does not clobber them at least in the
 		 * normal case.
 		 */
-		get_user_ex(gs, &sc->gs);
-		gs |= 3;
-		savesegment(gs, oldgs);
-		if (gs != oldgs)
-			load_gs_index(gs);
-
+		RELOAD_SEG(gs);
 		RELOAD_SEG(fs);
 		RELOAD_SEG(ds);
 		RELOAD_SEG(es);
@@ -333,17 +335,13 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 				 void __user *fpstate,
 				 struct pt_regs *regs, unsigned int mask)
 {
-	int tmp, err = 0;
+	int err = 0;
 
 	put_user_try {
-		savesegment(gs, tmp);
-		put_user_ex(tmp, (unsigned int __user *)&sc->gs);
-		savesegment(fs, tmp);
-		put_user_ex(tmp, (unsigned int __user *)&sc->fs);
-		savesegment(ds, tmp);
-		put_user_ex(tmp, (unsigned int __user *)&sc->ds);
-		savesegment(es, tmp);
-		put_user_ex(tmp, (unsigned int __user *)&sc->es);
+		put_user_ex(get_user_seg(gs), (unsigned int __user *)&sc->gs);
+		put_user_ex(get_user_seg(fs), (unsigned int __user *)&sc->fs);
+		put_user_ex(get_user_seg(ds), (unsigned int __user *)&sc->ds);
+		put_user_ex(get_user_seg(es), (unsigned int __user *)&sc->es);
 
 		put_user_ex(regs->di, &sc->di);
 		put_user_ex(regs->si, &sc->si);
-- 
1.6.1.2

