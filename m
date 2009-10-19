Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbZJSSIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbZJSSIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 14:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZJSSIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 14:08:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbZJSSIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 14:08:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] consider stack access while checking for alternate
 signal stack
In-Reply-To: Sebastian Andrzej Siewior's message of  Monday, 19 October 2009 10:02:39 +0200 <20091019080239.GB25783@Chamillionaire.breakpoint.cc>
References: <20091018191247.GA21844@Chamillionaire.breakpoint.cc>
	<20091019073358.GE17960@elte.hu>
	<20091019080239.GB25783@Chamillionaire.breakpoint.cc>
Emacs: featuring the world's first municipal garbage collector!
Message-Id: <20091019180810.3CB751E@magilla.sf.frob.com>
Date: Mon, 19 Oct 2009 11:08:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AFAICT all you want is the following, and I'm not sure it requires all that
much explanation.  I've probably missed some subtlety.


Thanks,
Roland

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2090,7 +2090,13 @@ static inline int is_si_special(const struct siginfo *info)
 
 static inline int on_sig_stack(unsigned long sp)
 {
-	return (sp - current->sas_ss_sp < current->sas_ss_size);
+#ifdef CONFIG_STACK_GROWSUP
+	return sp >= current->sas_ss_sp &&
+		sp - current->sas_ss_sp < current->sas_ss_size;
+#else
+	return sp > current->sas_ss_sp &&
+		sp - current->sas_ss_sp <= current->sas_ss_size;
+#endif
 }
 
