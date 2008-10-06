Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYJFOJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYJFOJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 10:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYJFOJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 10:09:04 -0400
Received: from gecko.sbs.de ([194.138.37.40]:15793 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbYJFOJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 10:09:03 -0400
Message-ID: <48EA1BE9.1030707@siemens.com>
Date: Mon, 06 Oct 2008 16:08:41 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: SIGTRAP vs. sys_exit_group race
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

are there any news on these ideas?

http://marc.info/?l=linux-kernel&m=121540671602971

I've been caught by a race between a ptraced thread running on a
breakpoint, thus generating a SIGTRAP and another thread in this process
issuing sys_exit_group. The discussion above, specifically Oleg's
concerns, made me think that this is a generic issue of current
mainline.

I observed this on a heavily patched 2.6.26.5 kernel which comes, among
other things, with a higher probability for latencies/reschedules
between the queuing of SIGTRAP and the actual delivery. Right into this
window, the sys_exit_group comes. It informs gdb about the termination,
sends out SIGKILL to the other threads and turns the caller into a
zombie. Now the second thread has SIGKILL + SIGTRAP pending, and it
picks SIGTRAP for delivery. At this point gdb gets confused (maybe a bug
of its own?), sends SIGSTOP to the dead thread and waits for it to enter
the traced state (which it will never do) - deadlock of gdb, only
resolvable by killing the latter.

The patch below (rebased against latest git) resolves the issue for me,
but I'm definitely not sure about all its implications and if I'm not
papering over a different issue. Could you comment on my scenario? Is it
possible with mainline as well? Will Roland's approach resolve it?

Thanks,
Jan

---
Index: b/kernel/signal.c
===================================================================
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1528,10 +1528,11 @@ static void ptrace_stop(int exit_code, i
 		spin_unlock_irq(&current->sighand->siglock);
 		arch_ptrace_stop(exit_code, info);
 		spin_lock_irq(&current->sighand->siglock);
-		if (sigkill_pending(current))
-			return;
 	}
 
+	if (sigkill_pending(current))
+		return;
+
 	/*
 	 * If there is a group stop in progress,
 	 * we must participate in the bookkeeping.
-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
