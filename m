Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYKOD13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYKOD13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 22:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYKOD1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 22:27:22 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64185 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYKOD1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 22:27:21 -0500
Message-ID: <491E4198.8070103@ct.jp.nec.com>
Date: Fri, 14 Nov 2008 19:27:20 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86: ia32_signal: cleanup macro RELOAD_SEG
References: <491E4101.7010405@ct.jp.nec.com>
In-Reply-To: <491E4101.7010405@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Remove mask parameter because it's always 3.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index f74178e..0b7fcf6 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -207,13 +207,14 @@ struct rt_sigframe
 		regs->seg = tmp | 3;			\
 }
 
-#define RELOAD_SEG(seg,mask)						\
-	{ unsigned int cur;						\
-	  unsigned short pre;						\
-	  err |= __get_user(pre, &sc->seg);				\
-	  savesegment(seg, cur);					\
-	  pre |= mask;							\
-	  if (pre != cur) loadsegment(seg, pre); }
+#define RELOAD_SEG(seg)		{		\
+	unsigned int cur, pre;			\
+	err |= __get_user(pre, &sc->seg);	\
+	savesegment(seg, cur);			\
+	pre |= 3;				\
+	if (pre != cur)				\
+		loadsegment(seg, pre);		\
+}
 
 static int ia32_restore_sigcontext(struct pt_regs *regs,
 				   struct sigcontext_ia32 __user *sc,
@@ -244,9 +245,9 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 	if (gs != oldgs)
 		load_gs_index(gs);
 
-	RELOAD_SEG(fs, 3);
-	RELOAD_SEG(ds, 3);
-	RELOAD_SEG(es, 3);
+	RELOAD_SEG(fs);
+	RELOAD_SEG(ds);
+	RELOAD_SEG(es);
 
 	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
 	COPY(dx); COPY(cx); COPY(ip);
-- 
1.5.6

