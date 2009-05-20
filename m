Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZETOxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZETOxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZETOx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:53:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39867 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZETOx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:53:26 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: linux-next: net tree build failure
References: <20090521001928.4bf71911.sfr@canb.auug.org.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 20 May 2009 07:53:21 -0700
In-Reply-To: <20090521001928.4bf71911.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Thu\, 21 May 2009 00\:19\:28 +1000")
Message-ID: <m1d4a3keqm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: sfr@canb.auug.org.au, hskinnemoen@atmel.com, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, davem@davemloft.net
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Dave,
>
> Today's linux-next build of at least some av32 and arm configs failed like this:
>
> arch/avr32/kernel/signal.c:216: error: conflicting types for 'restart_syscall'
> include/linux/sched.h:2184: error: previous definition of 'restart_syscall' was here
>
> Caused by commit 690cc3ffe33ac4a2857583c22d4c6244ae11684d ("syscall:
> Implement a convinience function restart_syscall") from the net tree.
>
> grep is your friend ...

Grrr. Some days it feels like all of the good names are already taken.

How does this look for a solution to the name clash?


---

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 80b8b5c..88a8f0b 100644
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
