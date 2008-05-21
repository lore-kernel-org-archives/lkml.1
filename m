Return-Path: <linux-kernel-owner+w=401wt.eu-S935236AbYEUNVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935236AbYEUNVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762314AbYEUNUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:20:52 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49513 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760229AbYEUNUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:20:50 -0400
Date: Wed, 21 May 2008 16:20:32 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signals: collect_signal: remove the unneeded sigismember() check
Message-ID: <20080521122032.GA179@tv-sign.ru>
References: <20080517151424.GA9505@tv-sign.ru> <20080521005646.1BD5426FA1C@magilla.localdomain> <alpine.LFD.1.10.0805201903150.3081@woody.linux-foundation.org> <20080521025617.612D726FA1C@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521025617.612D726FA1C@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Roland McGrath wrote:
>
> > It's basically the equivalent of a "spin_lock_irq()" for DRM, where 
> > signals are the "interrupts" that need to be blocked while holding the 
> > lock.
> 
> Well, sure, that makes sense.  But that's not what it does.  I can see what
> it does, I just can't tell why it really makes any sense.

As for me, I can't even see what it does,

> Despite the name, block_all_signals() in fact blocks no signals.  What
> it does is install notifier/notifier_mask, which makes the hook get
> called for those particular signals and it can decide to delay the
> signal (in a kooky fashion that's not really reliable).

Suppose that the task has the pending SIG which is "blocked" by DRM.

dequeue_signal() calls ->notifier(), it nacks the signal, we clear
TIF_SIGPENDING. Then dequeue_signal() does recalc_sigpending() and
sets TIF_SIGPENDING again. We return 0 to get_signal_to_deliver(),
and then return to user-space with TIF_SIGPENDING. Endless loop ?

Even if it works somehow... "blocking" SIG means that in fact we
"block" SIG+1, SIG+2, etc if SIG is pending.

> drm_lock uses a mask containing only the stop signals (SIGSTOP, SIGTSTP,
> SIGTTOU, SIGTTIN).

and of course this can't work for multithread programs, another
thread can dequeue SIGTSTP and initiate a group stop.

Oleg.

