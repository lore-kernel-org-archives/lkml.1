Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbYCWFxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbYCWFxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 01:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbYCWFxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 01:53:06 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:56334 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYCWFxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 01:53:05 -0400
To: stefanr@s5r6.in-berlin.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <Pine.LNX.4.44L0.0803202301140.16520-100000@netrider.rowland.org>
	<20080320201723.b87b3732.akpm@linux-foundation.org>
	<200803220011.CEC82820.QSOtJOVFFHFMLO@I-love.SAKURA.ne.jp>
	<47E3E83F.3070508@s5r6.in-berlin.de>
	<47E3EA27.7020800@s5r6.in-berlin.de>
In-Reply-To: <47E3EA27.7020800@s5r6.in-berlin.de>
Message-Id: <200803231453.ACD04697.LOVQFtOFFSJHOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 23 Mar 2008 14:53:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> >> Is "if (in_atomic()) return;" check a correct method for avoiding 
> >> deadlocks when my code was accidentally called from a context
> >> where use of down()/mutex_lock()/kmalloc(GFP_KERNEL)/get_user_pages()/
> >> kmap() etc. are not permitted?
> 
> No.  Quoting Andrew:  "in_atomic() returns false inside spinlock on 
> non-preemptible kernels."

So, just "if (in_atomic()) return;" check is insufficient for detecting
all cases when it is not permitted to sleep. I see.

Is "in_atomic() returns false inside spinlock on non-preemptible kernels."
the only case that the in_atomic() can't tell whether it is permitted to sleep or not?
If this is the only case, can't we somehow know it by remembering
"how many spinlocks does this CPU is holding now" since
"it is not permitted to sleep inside the spinlock" means
"the CPU the current process is running will not change".
Something like

#ifdef CONFIG_COUNT_SPINLOCKS_HELD
atomic_t spinlock_held_counter[NR_CPUS];
#endif

void spin_lock(x)
{
	/* obtain this spinlock. */
#ifdef CONFIG_COUNT_SPINLOCKS_HELD
	/* increment spinlock_held_counter[this_CPU]. */
#endif
}

void spin_unlock(x)
{
#ifdef CONFIG_COUNT_SPINLOCKS_HELD
	/* decrement spinlock_held_counter[this_CPU]. */
#endif
	/* release this spinlock. */
}

bool in_spinlock()
{
#ifdef CONFIG_COUNT_SPINLOCKS_HELD
	/* return spinlock_held_counter[this_CPU] != 0. */
#else
	return false;
#endif
}

and use "if (in_atomic() || in_spinlock()) return;" instead of "if (in_atomic()) return;" ?
