Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYDAAIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYDAAIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 20:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYDAAIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 20:08:37 -0400
Received: from styx.suse.cz ([82.119.242.94]:43291 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751251AbYDAAIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 20:08:36 -0400
Date: Tue, 1 Apr 2008 02:08:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: spinlocks -- why are releases inlined and acquires are not?
Message-ID: <Pine.LNX.4.64.0804010202390.5541@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

include/linux/spinlock.h shows:

	#define spin_lock_irq(lock)             _spin_lock_irq(lock)

unconditionally, i.e. irrespectible of config options, we always (on SMP) 
call kernel/spinlock.c:_spin_lock_irq(), which is even not inlined.

Contrary to that, unlocks are written as one would expect, i.e:

	#if defined(CONFIG_DEBUG_SPINLOCK) || defined(CONFIG_PREEMPT) || \
        	!defined(CONFIG_SMP)
	# define spin_unlock_irq(lock)          _spin_unlock_irq(lock)
	#else
	# define spin_unlock_irq(lock)                  \
	do {                                            \
        	__raw_spin_unlock(&(lock)->raw_lock);   \
	        __release(lock);                        \
	        local_irq_enable();                     \
	} while (0)

and __raw_spin_unlock() is of course properly inlined.

What is the reason for this asymetry? Shouldn't the acquiring functions be 
implemented in the very same way? Or at least, shouldn't all the 
__lockfunc functions be inlined?

Thanks,

-- 
Jiri Kosina
SUSE Labs
