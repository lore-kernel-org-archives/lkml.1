Return-Path: <linux-kernel-owner+w=401wt.eu-S1762728AbYEUC4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762728AbYEUC4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbYEUC4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:56:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbYEUC4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:56:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signals: collect_signal: remove the unneeded
 sigismember() check
In-Reply-To: Linus Torvalds's message of  Tuesday, 20 May 2008 19:14:15 -0700 <alpine.LFD.1.10.0805201903150.3081@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080517151424.GA9505@tv-sign.ru>
	<20080521005646.1BD5426FA1C@magilla.localdomain>
	<alpine.LFD.1.10.0805201903150.3081@woody.linux-foundation.org>
X-Zippy-Says: Hmmm...  a PINHEAD, during an EARTHQUAKE, encounters an ALL-MIDGET
    FIDDLE ORCHESTRA...  ha..  ha..
Message-Id: <20080521025617.612D726FA1C@magilla.localdomain>
Date: Tue, 20 May 2008 19:56:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's basically the equivalent of a "spin_lock_irq()" for DRM, where 
> signals are the "interrupts" that need to be blocked while holding the 
> lock.

Well, sure, that makes sense.  But that's not what it does.  I can see what
it does, I just can't tell why it really makes any sense.

Despite the name, block_all_signals() in fact blocks no signals.  What
it does is install notifier/notifier_mask, which makes the hook get
called for those particular signals and it can decide to delay the
signal (in a kooky fashion that's not really reliable).

drm_lock uses a mask containing only the stop signals (SIGSTOP, SIGTSTP,
SIGTTOU, SIGTTIN).  So for other signals, its hook (drm_notifier) never
gets called, and signal_pending() stays set, handlers get run, etc.

So I can't tell what it's actually good for (that's at all reliable
now).  But you just told me not to ask you how it's supposed to work,
and I respect that. ;-)

The best I can figure is that the user-level code in question really
does want to have signal handlers run, and to process fatal signals,
during those critical sections.  It just wants to prevent a ^Z or
SIGSTOP at the critical spot leaving the lock held while the process
goes into TASK_STOPPED for an arbitrary period.


Thanks,
Roland
