Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYHNWvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYHNWvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYHNWvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:51:38 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:30088 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbYHNWvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:51:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4DABhSpEh5LAMbiGdsb2JhbACSAAEBAQ8gpFyBVQ
X-IronPort-AV: E=Sophos;i="4.32,211,1217773800"; 
   d="scan'208";a="182423267"
Date: Fri, 15 Aug 2008 08:51:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [GIT PULL] XFS update for 2.6.27-rc4
Message-ID: <20080814225130.GB19760@disturbed>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Lachlan McIlroy <lachlan@sgi.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>,
	Linux/m68k <linux-m68k@vger.kernel.org>
References: <20080813081147.8ECE258C52A8@chook.melbourne.sgi.com> <Pine.LNX.4.64.0808141738410.27466@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808141738410.27466@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 05:45:18PM +0200, Geert Uytterhoeven wrote:
> On Wed, 13 Aug 2008, Lachlan McIlroy wrote:
> > The following changes since commit 30a2f3c60a84092c8084dfe788b710f8d0768cd4:
> >   Linus Torvalds (1):
> >         Linux 2.6.27-rc3
> > 
> > are available in the git repository at:
> > 
> >   git://oss.sgi.com:8090/xfs/linux-2.6 master
> > 
> > David Chinner (12):
> >       [XFS] extend completions to provide XFS object flush requirements
> 
> This change (commit 39d2f1ab2a36ac527a6c41cfe689f50c239eaca3) seems to
> have broken the m68k build:
> 
> |   CC      arch/m68k/kernel/asm-offsets.s
> | In file included from linux/include/linux/mm_types.h:12,
> |                  from linux/include/linux/sched.h:61,
> |                  from linux/arch/m68k/kernel/asm-offsets.c:12:
> | linux/include/linux/completion.h: In function 'try_wait_for_completion':
> | linux/include/linux/completion.h:80: error: dereferencing pointer to incomplete type
> | linux/include/linux/completion.h: In function 'completion_done':
> | linux/include/linux/completion.h:99: error: dereferencing pointer to incomplete type
> | make[3]: *** [arch/m68k/kernel/asm-offsets.s] Error 1
> | make[2]: *** [prepare0] Error 2
> | make[1]: *** [sub-make] Error 2
> 
> (cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/42080/)
> 
> Apparently there was not sufficient time between entering linux-next and
> Linus' tree to notice this breakage before, while the original patch was already
> posted on July 11...

It spent the time between then and now in the -mm tree. Seems
like nobody is building m68k out of -mm.

I'm out for the next 3 days, but it seems to me that the easiest fix
is to move that code out of the header (i.e. uninline them) so the
patch below is only compile tested on x86_64 - I've got to go load a
trailer and get moving...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


Completions: Un-inline try_wait_for_completion and completion_done

m68k fails to build with these functions inlined in completion.h.
Move them out of line into sched.c and export them to avoid this
problem.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/linux/completion.h |   46 +------------------------------------------
 kernel/sched.c             |   46 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 44 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 57faa60..02ef883 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -49,6 +49,8 @@ extern unsigned long wait_for_completion_timeout(struct completion *x,
 						   unsigned long timeout);
 extern unsigned long wait_for_completion_interruptible_timeout(
 			struct completion *x, unsigned long timeout);
+extern bool try_wait_for_completion(struct completion *x);
+extern bool completion_done(struct completion *x);
 
 extern void complete(struct completion *);
 extern void complete_all(struct completion *);
@@ -56,48 +58,4 @@ extern void complete_all(struct completion *);
 #define INIT_COMPLETION(x)	((x).done = 0)
 
 
-/**
- *	try_wait_for_completion - try to decrement a completion without blocking
- *	@x:	completion structure
- *
- *	Returns: 0 if a decrement cannot be done without blocking
- *		 1 if a decrement succeeded.
- *
- *	If a completion is being used as a counting completion,
- *	attempt to decrement the counter without blocking. This
- *	enables us to avoid waiting if the resource the completion
- *	is protecting is not available.
- */
-static inline bool try_wait_for_completion(struct completion *x)
-{
-	int ret = 1;
-
-	spin_lock_irq(&x->wait.lock);
-	if (!x->done)
-		ret = 0;
-	else
-		x->done--;
-	spin_unlock_irq(&x->wait.lock);
-	return ret;
-}
-
-/**
- *	completion_done - Test to see if a completion has any waiters
- *	@x:	completion structure
- *
- *	Returns: 0 if there are waiters (wait_for_completion() in progress)
- *		 1 if there are no waiters.
- *
- */
-static inline bool completion_done(struct completion *x)
-{
-	int ret = 1;
-
-	spin_lock_irq(&x->wait.lock);
-	if (!x->done)
-		ret = 0;
-	spin_unlock_irq(&x->wait.lock);
-	return ret;
-}
-
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 04160d2..d3af81a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4663,6 +4663,52 @@ int __sched wait_for_completion_killable(struct completion *x)
 }
 EXPORT_SYMBOL(wait_for_completion_killable);
 
+/**
+ *	try_wait_for_completion - try to decrement a completion without blocking
+ *	@x:	completion structure
+ *
+ *	Returns: 0 if a decrement cannot be done without blocking
+ *		 1 if a decrement succeeded.
+ *
+ *	If a completion is being used as a counting completion,
+ *	attempt to decrement the counter without blocking. This
+ *	enables us to avoid waiting if the resource the completion
+ *	is protecting is not available.
+ */
+bool try_wait_for_completion(struct completion *x)
+{
+	int ret = 1;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 0;
+	else
+		x->done--;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+EXPORT_SYMBOL(try_wait_for_completion);
+
+/**
+ *	completion_done - Test to see if a completion has any waiters
+ *	@x:	completion structure
+ *
+ *	Returns: 0 if there are waiters (wait_for_completion() in progress)
+ *		 1 if there are no waiters.
+ *
+ */
+bool completion_done(struct completion *x)
+{
+	int ret = 1;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 0;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+EXPORT_SYMBOL(completion_done);
+
 static long __sched
 sleep_on_common(wait_queue_head_t *q, int state, long timeout)
 {
