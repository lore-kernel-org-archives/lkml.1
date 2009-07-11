Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbZGKIDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbZGKIDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZGKICh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:02:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:40217 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376AbZGKICf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:02:35 -0400
Date: Sat, 11 Jul 2009 08:01:29 GMT
From: tip-bot for Roland Dreier <roland@digitalvampire.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       roland@digitalvampire.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@digitalvampire.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <874otjitkj.fsf@shaolin.home.digitalvampire.org>
References: <874otjitkj.fsf@shaolin.home.digitalvampire.org>
Subject: [tip:x86/urgent] x86: Remove spurious printk level from segfault message
Message-ID: <tip-a1a08d1cb0ab148fd74216e4c0b4d4db18fe62c6@git.kernel.org>
Git-Commit-ID: a1a08d1cb0ab148fd74216e4c0b4d4db18fe62c6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 11 Jul 2009 08:01:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1a08d1cb0ab148fd74216e4c0b4d4db18fe62c6
Gitweb:     http://git.kernel.org/tip/a1a08d1cb0ab148fd74216e4c0b4d4db18fe62c6
Author:     Roland Dreier <roland@digitalvampire.org>
AuthorDate: Sat, 11 Jul 2009 00:10:04 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Jul 2009 09:56:19 +0200

x86: Remove spurious printk level from segfault message

Since commit 5fd29d6c ("printk: clean up handling of log-levels
and newlines"), the kernel logs segfaults like:

    <6>gnome-power-man[24509]: segfault at 20 ip 00007f9d4950465a sp 00007fffbb50fc70 error 4 in libgobject-2.0.so.0.2103.0[7f9d494f7000+45000]

with the extra "<6>" being KERN_INFO.  This happens because the
printk in show_signal_msg() started with KERN_CONT and then
used "%s" to pass in the real level; and KERN_CONT is no longer
an empty string, and printk only pays attention to the level at
the very beginning of the format string.

Therefore, remove the KERN_CONT from this printk, since it is
now actively causing problems (and never really made any
sense).

Signed-off-by: Roland Dreier <roland@digitalvampire.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <874otjitkj.fsf@shaolin.home.digitalvampire.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/fault.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 85307cc..bfae139 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -697,7 +697,7 @@ show_signal_msg(struct pt_regs *regs, unsigned long error_code,
 	if (!printk_ratelimit())
 		return;
 
-	printk(KERN_CONT "%s%s[%d]: segfault at %lx ip %p sp %p error %lx",
+	printk("%s%s[%d]: segfault at %lx ip %p sp %p error %lx",
 		task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
 		tsk->comm, task_pid_nr(tsk), address,
 		(void *)regs->ip, (void *)regs->sp, error_code);
