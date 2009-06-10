Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbZFJKgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbZFJKgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZFJKf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:35:56 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:50657 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbZFJKfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:35:55 -0400
Date: Wed, 10 Jun 2009 12:35:42 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikael Starvik <mikael.starvik@axis.com>, Martin Ettl <ettl.martin@gmx.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fw: [Bugme-new] [Bug 13476] New: wrong #endif
Message-ID: <20090610103541.GL20504@axis.com>
References: <20090609141739.c922705e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609141739.c922705e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 11:17:39PM +0200, Andrew Morton wrote:
> Begin forwarded message:
> 
> Date: Sun, 7 Jun 2009 14:02:50 GMT
> From: bugzilla-daemon@bugzilla.kernel.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 13476] New: wrong #endif
> 
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13476
> 
>            Summary: wrong #endif
>            Product: Other
>            Version: 2.5
>     Kernel Version: 2.6.29.4
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: other_other@kernel-bugs.osdl.org
>         ReportedBy: ettl.martin@gmx.de
>         Regression: No
> 
> 
> Hello,
> 
> i've detected a wrong #ifdef ...#endif sequence. This was detected by cppcheck,
> a static code analysis tool.
> 
> At file :
> linux-2.6.29.4/arch/cris/arch-v32/kernel/irq.c
> 
> Take a look at the code, to function 
> void crisv32_do_multiple(struct pt_regs* regs)
> {
>     int cpu;
>     int mask;
>     int masked[NBR_REGS];
>     int bit;
>     int i;
> 
>     cpu = smp_processor_id();
> 
>     /* An extra irq_enter here to prevent softIRQs to run after
>          * each do_IRQ. This will decrease the interrupt latency.
>      */
>     irq_enter();
> 
>     for (i = 0; i < NBR_REGS; i++) {
>         /* Get which IRQs that happend. */
>         masked[i] = REG_RD_INT_VECT(intr_vect, irq_regs[cpu],
>             r_masked_vect, i);
> 
>         /* Calculate new IRQ mask with these IRQs disabled. */
>         mask = REG_RD_INT_VECT(intr_vect, irq_regs[cpu], rw_mask, i);
>         mask &= ~masked[i];
> 
>     /* Timer IRQ is never masked */
> #ifdef TIMER_VECT1
>         if ((i == 1) && (masked[0] & TIMER_MASK))
>             mask |= TIMER_MASK;
> #else
>         if ((i == 0) && (masked[0] & TIMER_MASK))
>             mask |= TIMER_MASK;
> #endif
>         /* Block all the IRQs */
>         REG_WR_INT_VECT(intr_vect, irq_regs[cpu], rw_mask, i, mask);
> 
>     /* Check for timer IRQ and handle it special. */
> #ifdef TIMER_VECT1
>         if ((i == 1) && (masked[i] & TIMER_MASK)) {
>             masked[i] &= ~TIMER_MASK;
>             do_IRQ(TIMER0_INTR_VECT, regs);
>         }
> #else
>         if ((i == 0) && (masked[i] & TIMER_MASK)) {
>              masked[i] &= ~TIMER_MASK;
>              do_IRQ(TIMER0_INTR_VECT, regs);
>         }
>     }
> #endif
> 
> .....
> 
> Here, the last #endif is at the wrong place. It has to be before the bracket is
> closed. This is the corrected version:
> 
> #ifdef TIMER_VECT1
>         if ((i == 1) && (masked[i] & TIMER_MASK)) {
>             masked[i] &= ~TIMER_MASK;
>             do_IRQ(TIMER0_INTR_VECT, regs);
>         }
> #else
>         if ((i == 0) && (masked[i] & TIMER_MASK)) {
>              masked[i] &= ~TIMER_MASK;
>              do_IRQ(TIMER0_INTR_VECT, regs);
>         }
> #endif
>     }
> 
> 
> Best regards
> 
> Martin Ettl
> 
> -- 
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug.

I'm unsure how to handle sign-off-by in this case, but I've queued the
following for the CRIS tree:

Subject: [PATCH] CRISv32: irq.c - Move end brace outside #endif

The end brace for a larger for statement was placed inside the #else
part of #ifdef TIMER_VECT1. However, for all current chips, the
define TIMER_VECT1 is always unset, and the error was never triggered.

Move the brace down below the #endif.

Fixes:
http://bugzilla.kernel.org/show_bug.cgi?id=13476

Reported-by: Martin Ettl <ettl.martin@gmx.de>
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <mikael.starvik@axis.com>
---
 arch/cris/arch-v32/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index df3925c..9c9eb5b 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -428,8 +428,8 @@ crisv32_do_multiple(struct pt_regs* regs)
 			 masked[i] &= ~TIMER_MASK;
 			 do_IRQ(TIMER0_INTR_VECT, regs);
 		}
-	}
 #endif
+	}
 
 #ifdef IGNORE_MASK
 	/* Remove IRQs that can't be handled as multiple. */
-- 
1.6.1


Unless anyone have objections I'll push this to the cris for-next branch
in a day or two.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
