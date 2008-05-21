Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbYEUCO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbYEUCO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbYEUCOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:14:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757235AbYEUCOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:14:47 -0400
Date: Tue, 20 May 2008 19:14:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signals: collect_signal: remove the unneeded
 sigismember() check
In-Reply-To: <20080521005646.1BD5426FA1C@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0805201903150.3081@woody.linux-foundation.org>
References: <20080517151424.GA9505@tv-sign.ru> <20080521005646.1BD5426FA1C@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 May 2008, Roland McGrath wrote:
> 
> drm_lock is using block_all_signals to catch all the stop signals
> for a purpose that is not immediately clear to me.  

It's basically the equivalent of a "spin_lock_irq()" for DRM, where 
signals are the "interrupts" that need to be blocked while holding the 
lock.

In order for the user-level direct-rendering code to be able to do a lock 
that is safe in the presense of signals, the locking code needs to have 
some way to basically disable signals. And it could disable/re-enable them 
all the time, but that would be very expensive and defeat the whole 
purpose (which is that you can get the lock cheaply in user space and only 
take a system call on a lock conflict).

So instead, when it gets the DRM lock, it also does that 
"block_all_signals()" thing, which means that *if* a signal happens, it 
can temporarily disable the signal so that the handler won't be invoced in 
the critical region.

Now, I have to admit that I do not know if the current user-level code 
needs that any more, and even if it does, if it could possibly be replaced 
by better models. It's a hack, no question about it. The whole DRI locking 
is something really odd. Don't even ask me how it's supposed to work.

			Linus
