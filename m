Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZETWse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZETWse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZETWs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:48:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55265 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZETWsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:48:25 -0400
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk,
       hskinnemoen@atmel.com
Subject: Subject: [PATCH] Sort out syscall_restart name clash.
References: <20090521001928.4bf71911.sfr@canb.auug.org.au>
	<m1d4a3keqm.fsf@fess.ebiederm.org>
	<20090520.124403.159818618.davem@davemloft.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 20 May 2009 15:48:20 -0700
In-Reply-To: <20090520.124403.159818618.davem@davemloft.net> (David Miller's message of "Wed\, 20 May 2009 12\:44\:03 -0700 \(PDT\)")
Message-ID: <m1k54bie6j.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: davem@davemloft.net, hskinnemoen@atmel.com, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Today's linux-next build of at least some av32 and arm configs failed like this:
>
> arch/avr32/kernel/signal.c:216: error: conflicting types for 'restart_syscall'
> include/linux/sched.h:2184: error: previous definition of 'restart_syscall' was here
>
> Caused by commit 690cc3ffe33ac4a2857583c22d4c6244ae11684d ("syscall:
> Implement a convinience function restart_syscall") from the net tree.

Grrr. Some days it feels like all of the good names are already taken.

Let's just rename the two static users in arm and avr32 to get this
sorted out.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 arch/arm/kernel/signal.c   |    6 +++---
 arch/avr32/kernel/signal.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 80b8b5c..614c9f6 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -532,7 +532,7 @@ setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
 	return err;
 }
 
-static inline void restart_syscall(struct pt_regs *regs)
+static inline void setup_syscall_restart(struct pt_regs *regs)
 {
 	regs->ARM_r0 = regs->ARM_ORIG_r0;
 	regs->ARM_pc -= thumb_mode(regs) ? 2 : 4;
@@ -567,7 +567,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka,
 			}
 			/* fallthrough */
 		case -ERESTARTNOINTR:
-			restart_syscall(regs);
+			setup_syscall_restart(regs);
 		}
 	}
 
@@ -691,7 +691,7 @@ static int do_signal(sigset_t *oldset, struct pt_regs *regs, int syscall)
 		if (regs->ARM_r0 == -ERESTARTNOHAND ||
 		    regs->ARM_r0 == -ERESTARTSYS ||
 		    regs->ARM_r0 == -ERESTARTNOINTR) {
-			restart_syscall(regs);
+			setup_syscall_restart(regs);
 		}
 	}
 	single_step_set(current);
diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index 803d7be..2722756 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -212,7 +212,7 @@ out:
 	return err;
 }
 
-static inline void restart_syscall(struct pt_regs *regs)
+static inline void setup_syscall_restart(struct pt_regs *regs)
 {
 	if (regs->r12 == -ERESTART_RESTARTBLOCK)
 		regs->r8 = __NR_restart_syscall;
@@ -296,7 +296,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset, int syscall)
 			}
 			/* fall through */
 		case -ERESTARTNOINTR:
-			restart_syscall(regs);
+			setup_syscall_restart(regs);
 		}
 	}
 
-- 
1.6.1.2.350.g88cc

