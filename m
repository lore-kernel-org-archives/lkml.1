Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZB0S3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZB0S3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZB0S3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:29:13 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64765 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZB0S3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:29:11 -0500
Message-ID: <49A830F5.7090906@ct.jp.nec.com>
Date: Fri, 27 Feb 2009 10:29:09 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86: signal: use 16 bytes boundary for rt_sigframe
References: <49A83078.3020207@ct.jp.nec.com>
In-Reply-To: <49A83078.3020207@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Supporting xsave/xrestore introduces 64 bytes boundary for save_i387_xstate().
16 bytes boundary is OK for rt_sigframe.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 5ed4533..951aa60 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -409,15 +409,13 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	if (used_math()) {
 		sp -= sig_xstate_size;
 		*fpstate = (void __user *)round_down(sp, 64);
+
 		if (save_i387_xstate(*fpstate) < 0)
 			return (void __user *) -1L;
-
-		sp -= frame_size;
-		return (void __user *)round_down(sp, 16) - 8;
 	}
 
 	sp -= frame_size;
-	return (void __user *)round_down(sp, 64) - 8;
+	return (void __user *)round_down(sp, 16) - 8;
 }
 
 static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-- 
1.6.1.2

