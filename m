Return-Path: <linux-kernel-owner+w=401wt.eu-S1760840AbXIXQ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840AbXIXQ2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760521AbXIXQZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:29 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47283 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760510AbXIXQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:25:27 -0400
Date: Mon, 24 Sep 2007 09:20:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kumar Gala <galak@kernel.crashing.org>
Subject: [11/50] POWERPC: Flush registers to proper task context
Message-ID: <20070924162023.GL13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-flush-registers-to-proper-task-context.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>

commit 0ee6c15e7ba7b36a217cdadb292eeaf32a057a59 in mainline.

When we flush register state for FP, Altivec, or SPE in flush_*_to_thread
we need to respect the task_struct that the caller has passed to us.

Most cases we are called with current, however sometimes (ptrace) we may
be passed a different task_struct.

This showed up when using gdbserver debugging a simple program that used
floating point. When gdb tried to show the FP regs they all showed up as
0, because the child's FP registers were never properly flushed to memory.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/process.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -83,7 +83,7 @@ void flush_fp_to_thread(struct task_stru
 			 */
 			BUG_ON(tsk != current);
 #endif
-			giveup_fpu(current);
+			giveup_fpu(tsk);
 		}
 		preempt_enable();
 	}
@@ -143,7 +143,7 @@ void flush_altivec_to_thread(struct task
 #ifdef CONFIG_SMP
 			BUG_ON(tsk != current);
 #endif
-			giveup_altivec(current);
+			giveup_altivec(tsk);
 		}
 		preempt_enable();
 	}
@@ -182,7 +182,7 @@ void flush_spe_to_thread(struct task_str
 #ifdef CONFIG_SMP
 			BUG_ON(tsk != current);
 #endif
-			giveup_spe(current);
+			giveup_spe(tsk);
 		}
 		preempt_enable();
 	}

-- 
