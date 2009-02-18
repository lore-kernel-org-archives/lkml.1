Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbZBRVjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbZBRVjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZBRVfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:35:37 -0500
Received: from kroah.org ([198.145.64.141]:56153 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754745AbZBRVfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:36 -0500
Date: Wed, 18 Feb 2009 13:32:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 10/39] x86, vm86: fix preemption bug
Message-ID: <20090218213232.GK19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-vm86-fix-preemption-bug.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit be716615fe596ee117292dc615e95f707fb67fd1 upstream.

Commit 3d2a71a596bd9c761c8487a2178e95f8a61da083 ("x86, traps: converge
do_debug handlers") changed the preemption disable logic of do_debug()
so vm86_handle_trap() is called with preemption disabled resulting in:

 BUG: sleeping function called from invalid context at include/linux/kernel.h:155
 in_atomic(): 1, irqs_disabled(): 0, pid: 3005, name: dosemu.bin
 Pid: 3005, comm: dosemu.bin Tainted: G        W  2.6.29-rc1 #51
 Call Trace:
  [<c050d669>] copy_to_user+0x33/0x108
  [<c04181f4>] save_v86_state+0x65/0x149
  [<c0418531>] handle_vm86_trap+0x20/0x8f
  [<c064e345>] do_debug+0x15b/0x1a4
  [<c064df1f>] debug_stack_correct+0x27/0x2c
  [<c040365b>] sysenter_do_call+0x12/0x2f
 BUG: scheduling while atomic: dosemu.bin/3005/0x10000001

Restore the original calling convention and reenable preemption before
calling handle_vm86_trap().

Reported-by: Michal Suchanek <hramrach@centrum.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/traps.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -104,6 +104,12 @@ static inline void preempt_conditional_s
 		local_irq_enable();
 }
 
+static inline void conditional_cli(struct pt_regs *regs)
+{
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_disable();
+}
+
 static inline void preempt_conditional_cli(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
@@ -629,8 +635,10 @@ clear_dr7:
 
 #ifdef CONFIG_X86_32
 debug_vm86:
+	/* reenable preemption: handle_vm86_trap() might sleep */
+	dec_preempt_count();
 	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
-	preempt_conditional_cli(regs);
+	conditional_cli(regs);
 	return;
 #endif
 

