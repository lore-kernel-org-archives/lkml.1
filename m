Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbYIJH5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbYIJH5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 03:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYIJH5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 03:57:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:58810 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYIJH5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 03:57:44 -0400
Subject: Re: [2.6.27-rc5] inotify_read's ev_mutex vs do_page_fault's
 mmap_sem...
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo <mingo@elte.hu>
In-Reply-To: <200809101407.16323.nickpiggin@yahoo.com.au>
References: <6278d2220809091403k65187128keec3b401717f1ec0@mail.gmail.com>
	 <200809101407.16323.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 09:57:35 +0200
Message-Id: <1221033455.31904.1221.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 14:07 +1000, Nick Piggin wrote:
> On Wednesday 10 September 2008 07:03, Daniel J Blueman wrote:
> > I observed this locking violation [1] while gnome-panel was loading;
> > this was previously reported at
> > http://uwsg.iu.edu/hypermail/linux/kernel/0806.3/2881.html .
> >
> > Let me know for more information/config/testing. Thanks!
> 
> Thanks for the report. I've attached a patch you could test. It compiles
> (and boots a UML here) but I don't think I've actually tested the inotify
> path at all, so it may explode on you.
> 
> Peter, this copy_*_user stuff is quite a nightmare... Well actually it
> isn't, if the code is designed with it in mind from the start, but it is
> easy for people to forget it can take mmap_sem and filesystem locks... Is
> there a way to annotate it and say "might take mmap_sem for read" for
> example? So that these LORs will _always_ trigger rather than just once
> in a million times when the reclaim gods frown on us?

Sure, how about the below - untested - uncompiled, might eat kittens,
etc..

Just sprinkle something like:

  might_lock_read(&mm->mmap_sem);

in the right places.

---
Subject: lockdep: might_lock annotation

useful to establish a lock dependency in case the actual dependency is
rare or hard to trigger.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 331e5f1..0aa657a 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -480,4 +480,22 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 # define lock_map_release(l)			do { } while (0)
 #endif
 
+#ifdef CONFIG_PROVE_LOCKING
+# define might_lock(lock) 						\
+do {									\
+	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
+	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2, NULL, _THIS_IP_);	\
+	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
+} while (0)
+# define might_lock_read(lock) 						\
+do {									\
+	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
+	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2, NULL, _THIS_IP_);	\
+	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
+} while (0)
+#else
+# define might_lock(lock) do { } while (0)
+# define might_lock_read(lock) do { } while (0)
+#endif
+
 #endif /* __LINUX_LOCKDEP_H */


