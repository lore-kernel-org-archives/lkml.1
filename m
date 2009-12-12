Return-Path: <linux-kernel-owner+w=401wt.eu-S934208AbZLMBse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208AbZLMBse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934180AbZLMBsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:48:31 -0500
Received: from www.tglx.de ([62.245.132.106]:34360 "HELO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934158AbZLMBsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:48:30 -0500
Date: Sat, 12 Dec 2009 22:48:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
In-Reply-To: <20091212214235.31429790@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0912122244530.3089@localhost.localdomain>
References: <20091211232805.GA10652@kroah.com> <20091212084611.GA28266@elte.hu> <20091212013927.58d386d1.akpm@linux-foundation.org> <20091212101032.GB25286@elte.hu> <20091212023603.93768833.akpm@linux-foundation.org> <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
 <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain> <20091212214235.31429790@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009, Alan Cox wrote:
> > I think we could possibly add a "__might_sleep()" to _lock_kernel(). It 
> > doesn't really sleep, but it's invalid to take the kernel lock in an 
> > atomic region, so __might_sleep() might be the right thing anyway.
> 
> It's only invalid if you don't already hold the lock. The old tty code
> worked because every path into tty_fasync already held the lock ! That
> specific case - taking it the first time should definitely
> __might_sleep().
> 
> Mind you it's probably still rather dumb and would be a good debugging
> aid for -next to be able to warn on all offences if only to catch this
> stuff for the future BKL removal work.

Just patched the following in and it catched your problem nicely. With
your AB/BA fix patch applied everything is fine.

Thanks,

	tglx
---
Subject: BKL: Add might sleep to __lock_kernel
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 12 Dec 2009 20:29:00 +0100

Catches all offenders which take the BKL first time in an atomic
region. Recursive lock_kernel calls are not affected.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 lib/kernel_lock.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/lib/kernel_lock.c
===================================================================
--- linux-2.6.orig/lib/kernel_lock.c
+++ linux-2.6/lib/kernel_lock.c
@@ -64,6 +64,8 @@ void __lockfunc __release_kernel_lock(vo
 #ifdef CONFIG_PREEMPT
 static inline void __lock_kernel(void)
 {
+	might_sleep();
+
 	preempt_disable();
 	if (unlikely(!_raw_spin_trylock(&kernel_flag))) {
 		/*
