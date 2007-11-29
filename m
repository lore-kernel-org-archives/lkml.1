Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbXK2AmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbXK2AmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbXK2AmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:42:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759082AbXK2AmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:42:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH x86/mm 5/6] x86-32 ptrace get/putreg current task
In-Reply-To: Roland McGrath's message of  Wednesday, 28 November 2007 16:38:49 -0800 <20071129003849.428E026F8E7@magilla.localdomain>
References: <20071129003849.428E026F8E7@magilla.localdomain>
X-Zippy-Says: ..Wait 'til those ITALIAN TEENAGERS get back to their HONDAS &
    discover them to be FILLED to the BRIM with MAZOLA!!
Message-Id: <20071129004205.B4BFD26F8E7@magilla.localdomain>
Date: Wed, 28 Nov 2007 16:42:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This generalizes the getreg and putreg functions so they can be used on the
current task, as well as on a task stopped in TASK_TRACED and switched off.
This lays the groundwork to share this code for all kinds of user-mode
machine state access, not just ptrace.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace_32.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index 5aca84e..2607130 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -55,6 +55,12 @@ static int putreg(struct task_struct *child,
 		if (value && (value & 3) != 3)
 			return -EIO;
 		child->thread.gs = value;
+		if (child == current)
+			/*
+			 * The user-mode %gs is not affected by
+			 * kernel entry, so we must update the CPU.
+			 */
+			loadsegment(gs, value);
 		return 0;
 	case DS:
 	case ES:
@@ -104,6 +110,8 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
 		break;
 	case GS:
 		retval = child->thread.gs;
+		if (child == current)
+			savesegment(gs, retval);
 		break;
 	case DS:
 	case ES:
