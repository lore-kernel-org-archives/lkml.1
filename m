Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYKOD0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYKOD0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 22:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYKOD0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 22:26:40 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:63971 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYKOD0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 22:26:40 -0500
Message-ID: <491E416F.5040703@ct.jp.nec.com>
Date: Fri, 14 Nov 2008 19:26:39 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86: ia32_signal: introduce COPY_SEG_STRICT
References: <491E4101.7010405@ct.jp.nec.com>
In-Reply-To: <491E4101.7010405@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Introduce COPY_SEG_STRICT for ia32_restore_sigcontext().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index a28790a..f74178e 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -201,6 +201,12 @@ struct rt_sigframe
 	err |= __get_user(regs->x, &sc->x);	\
 }
 
+#define COPY_SEG_STRICT(seg)	{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		regs->seg = tmp | 3;			\
+}
+
 #define RELOAD_SEG(seg,mask)						\
 	{ unsigned int cur;						\
 	  unsigned short pre;						\
@@ -246,10 +252,8 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 	COPY(dx); COPY(cx); COPY(ip);
 	/* Don't touch extended registers */
 
-	err |= __get_user(regs->cs, &sc->cs);
-	regs->cs |= 3;
-	err |= __get_user(regs->ss, &sc->ss);
-	regs->ss |= 3;
+	COPY_SEG_STRICT(cs);
+	COPY_SEG_STRICT(ss);
 
 	err |= __get_user(tmpflags, &sc->flags);
 	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
-- 
1.5.6

