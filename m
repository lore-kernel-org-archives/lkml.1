Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbXKFKU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbXKFKU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbXKFKUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:20:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40980 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbXKFKUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:20:47 -0500
Subject: Re: writeout stalls in current -git
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, just.for.lkml@googlemail.com,
       maximlevitsky@gmail.com, linux-kernel@vger.kernel.org, dgc@sgi.com,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20071105155749.73e0e38e.akpm@linux-foundation.org>
References: <393056632.00561@ustc.edu.cn>
	 <200710221505.35397.maximlevitsky@gmail.com>
	 <20071022131045.GA5357@mail.ustc.edu.cn> <393060478.03650@ustc.edu.cn>
	 <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	 <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
	 <393999615.15343@ustc.edu.cn>
	 <20071105155749.73e0e38e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 11:20:41 +0100
Message-Id: <1194344441.6289.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-05 at 15:57 -0800, Andrew Morton wrote:

> > > Subject: mm: speed up writeback ramp-up on clean systems
> > > 
> > > We allow violation of bdi limits if there is a lot of room on the
> > > system. Once we hit half the total limit we start enforcing bdi limits
> > > and bdi ramp-up should happen. Doing it this way avoids many small
> > > writeouts on an otherwise idle system and should also speed up the
> > > ramp-up.
> 
> Given the problems we're having in there I'm a bit reluctant to go tossing
> hastily put together and inadequately tested stuff onto the fire.  And
> that's what this patch looks like to me.

Not really hastily, I think it was written before the stuff hit
mainline. Inadequately tested, perhaps, its been in my and probably Wu's
kernels for a while. Granted that's not a lot of testing in the face of
those who have problems atm.

> Wanna convince me otherwise?

I'm perfectly happy with this patch earning its credits in -mm for a
while and maybe going in around -rc4 or something like that (hoping that
by then we've fixed these nagging issues).

Another patch I did come up with yesterday - not driven by any problems
in that area - could perhaps join this one on that path:

---
Subject: mm: bdi: tweak task dirty penalty

Penalizing heavy dirtiers with 1/8-th the total dirty limit might be rather
excessive on large memory machines. Use sqrt to scale it sub-linearly.

Update the comment while we're there.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/page-writeback.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6-2/mm/page-writeback.c
===================================================================
--- linux-2.6-2.orig/mm/page-writeback.c
+++ linux-2.6-2/mm/page-writeback.c
@@ -213,17 +213,21 @@ static inline void task_dirties_fraction
 }
 
 /*
- * scale the dirty limit
+ * Task specific dirty limit:
  *
- * task specific dirty limit:
+ *   dirty -= 8 * sqrt(dirty) * p_{t}
  *
- *   dirty -= (dirty/8) * p_{t}
+ * Penalize tasks that dirty a lot of pages by lowering their dirty limit. This
+ * avoids infrequent dirtiers from getting stuck in this other guys dirty
+ * pages.
+ *
+ * Use a sub-linear function to scale the penalty, we only need a little room.
  */
 void task_dirty_limit(struct task_struct *tsk, long *pdirty)
 {
 	long numerator, denominator;
 	long dirty = *pdirty;
-	u64 inv = dirty >> 3;
+	u64 inv = 8*int_sqrt(dirty);
 
 	task_dirties_fraction(tsk, &numerator, &denominator);
 	inv *= numerator;


