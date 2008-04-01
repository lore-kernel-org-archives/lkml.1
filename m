Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbYDAAkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbYDAAkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 20:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYDAAkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 20:40:39 -0400
Received: from styx.suse.cz ([82.119.242.94]:43827 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751309AbYDAAki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 20:40:38 -0400
Date: Tue, 1 Apr 2008 02:40:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: Re: spinlocks -- why are releases inlined and acquires are not?
In-Reply-To: <Pine.LNX.4.64.0804010202390.5541@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0804010236110.5541@jikos.suse.cz>
References: <Pine.LNX.4.64.0804010202390.5541@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Jiri Kosina wrote:

> What is the reason for this asymetry? Shouldn't the acquiring functions 
> be implemented in the very same way? Or at least, shouldn't all the 
> __lockfunc functions be inlined?

i.e. is there any particular reason why we don't have something like the 
patch below (implemented for all the lock variants of course, this is 
just to demonstrate what I mean)?


spinlocks: inline spin_lock() in non-debug cases

inline spin_lock() in the non-debug case.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 576a5f7..30922ba 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -178,7 +178,12 @@ do {								\
 #define read_trylock(lock)		__cond_lock(lock, _read_trylock(lock))
 #define write_trylock(lock)		__cond_lock(lock, _write_trylock(lock))
 
+#if defined(CONFIG_DEBUG_SPINLOCK) || defined(CONFIG_PREEMPT) || \
+	!defined(CONFIG_SMP)
 #define spin_lock(lock)			_spin_lock(lock)
+#else
+#define spin_lock(lock) \
+	 do { __raw_spin_lock(&(lock)->raw_lock); __acquire(lock); } while (0)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define spin_lock_nested(lock, subclass) _spin_lock_nested(lock, subclass)
