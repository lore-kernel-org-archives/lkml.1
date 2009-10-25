Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbZJYOiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbZJYOiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 10:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZJYOiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 10:38:21 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45292 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbZJYOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 10:38:20 -0400
Date: Sun, 25 Oct 2009 15:37:58 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Roland McGrath <roland@redhat.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH v2] consider the kind of stack incrementation while
 checking for alternate signal stack
Message-ID: <20091025143758.GA6653@Chamillionaire.breakpoint.cc>
References: <20091018191247.GA21844@Chamillionaire.breakpoint.cc>
 <20091019073358.GE17960@elte.hu>
 <20091019080239.GB25783@Chamillionaire.breakpoint.cc>
 <20091019180810.3CB751E@magilla.sf.frob.com>
 <20091019193058.GA29613@Chamillionaire.breakpoint.cc>
 <20091020211116.2B76F81A3@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091020211116.2B76F81A3@magilla.sf.frob.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PRE_INC and PRE_DEC architectures the stack is first incremented /
decremented and than the value is saved. Therefore sas_ss_sp == sp is
not on the alternative signal stack while sas_ss_sp + sas_ss_size == sp
is on the alternative signal stack.
This was reported as Debian bug #544905 on AMD64 where gcc-4.3 with -O2
created such code.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
v1..v2: - remove support for POST_INC / POST_DEC archs. Every linux
          architecture is either PRE_INC or POST_INC
        - replaced  !(sp - current->sas_ss_sp)) with
          sp > current->sas_ss_sp
          with catches the equal case. Recommended by Roland.

AMD64 test case at [0]

[0] [0] http://download.breakpoint.cc/tc-sig-stack.c

 include/linux/sched.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..6ea5d12 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2086,11 +2086,14 @@ static inline int is_si_special(const struct siginfo *info)
 	return info <= SEND_SIG_FORCED;
 }
 
-/* True if we are on the alternate signal stack.  */
-
+/*
+ * True if we are on the alternate signal stack.
+ * The implementation considers PRE_DEC and PRE_INC architectures.
+ */
 static inline int on_sig_stack(unsigned long sp)
 {
-	return (sp - current->sas_ss_sp < current->sas_ss_size);
+	return sp > current->sas_ss_sp &&
+		sp - current->sas_ss_sp <= current->sas_ss_size;
 }
 
 static inline int sas_ss_flags(unsigned long sp)
-- 
1.6.4.GIT

