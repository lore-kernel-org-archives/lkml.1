Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZGKHQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZGKHQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZGKHQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:16:13 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:52018
	"EHLO QMTA11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbZGKHQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:16:12 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jul 2009 03:16:12 EDT
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Remove spurious printk level from segfault message
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
From: Roland Dreier <roland@digitalvampire.org>
Date: Sat, 11 Jul 2009 00:10:04 -0700
Message-ID: <874otjitkj.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 5fd29d6c ("printk: clean up handling of log-levels and
newlines"), the kernel logs segfaults like:

    <6>gnome-power-man[24509]: segfault at 20 ip 00007f9d4950465a sp 00007fffbb50fc70 error 4 in libgobject-2.0.so.0.2103.0[7f9d494f7000+45000]

with the extra "<6>" being KERN_INFO.  This happens because the printk
in show_signal_msg() started with KERN_CONT and then used "%s" to pass
in the real level; and KERN_CONT is no longer an empty string, and
printk only pays attention to the level at the very beginning of the
format string.

Therefore, remove the KERN_CONT from this printk, since it is now
actively causing problems (and never really made any sense).

Signed-off-by: Roland Dreier <roland@digitalvampire.org>
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
