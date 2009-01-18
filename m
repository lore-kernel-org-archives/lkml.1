Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbZARBjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbZARBjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 20:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbZARBjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 20:39:00 -0500
Received: from cmpxchg.org ([85.214.51.133]:56871 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbZARBjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 20:39:00 -0500
Date: Sun, 18 Jan 2009 02:38:02 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH v3] wait: prevent waiter starvation in __wait_on_bit_lock
Message-ID: <20090118013802.GA12214@cmpxchg.org>
References: <20090117215110.GA3300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117215110.GA3300@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added linux-mm to CC]

On Sat, Jan 17, 2009 at 10:51:10PM +0100, Oleg Nesterov wrote:
> I think the patch is correct, just a question,
> 
> >  int __lock_page_killable(struct page *page)
> >  {
> >  	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
> > +	int ret;
> >
> > -	return __wait_on_bit_lock(page_waitqueue(page), &wait,
> > +	ret = __wait_on_bit_lock(page_waitqueue(page), &wait,
> >  					sync_page_killable, TASK_KILLABLE);
> > +	/*
> > +	 * wait_on_bit_lock uses prepare_to_wait_exclusive, so if multiple
> > +	 * procs were waiting on this page, we were the only proc woken up.
> > +	 *
> > +	 * if ret != 0, we didn't actually get the lock.  We need to
> > +	 * make sure any other waiters don't sleep forever.
> > +	 */
> > +	if (ret)
> > +		wake_up_page(page, PG_locked);
> 
> This patch assumes that nobody else calls __wait_on_bit_lock() with
> action which can return !0. Currently this is correct, but perhaps
> it makes sense to move this wake_up_page() into __wait_on_bit_lock ?
> 
> Note that we need to "transfer" the wakeup only if wake_up_page()
> has already removed us from page_waitqueue(page), this means we
> don't need to check ret != 0 twice in __wait_on_bit_lock(), afaics
> we can do
> 
> 	if ((ret = (*action)(q->key.flags))) {
> 		__wake_up_bit(wq, q->key.flags, q->key.bit_nr);
> 		// or just __wake_up(wq, TASK_NORMAL, 1, &q->key);
> 		break;
> 	}
> 
> IOW, imho __wait_on_bit_lock() is buggy, not __lock_page_killable(),
> no?

I agree with you, already replied with a patch to linux-mm where Chris
posted it originally.

Peter noted that we have a spurious wake up in the case where A holds
the page lock, B and C wait, B gets killed and does a wake up, then A
unlocks and does a wake up.  Your proposal has this problem too,
right?  For example when C is killed it will wake up B without reason.

I included an extra test_bit() to check if it's really up to us to
either lock or wake the next contender.

	Hannes

---

__wait_on_bit_lock() employs exclusive waiters, which means that every
contender has to make sure to wake up the next one in the queue after
releasing the lock.

If the passed in action() returns a non-zero value, the lock is not
taken but the next waiter is not woken up either, leading to endless
waiting on an unlocked lock.

This has been observed with lock_page_killable() as a user which
passes an action function that can fail.

Fix it in __wait_on_bit_lock() by waking up the next contender if
necessary when we abort the acquisition.

Reported-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/wait.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

v3: check ret only once per Oleg Nesterov and don't do unnecessary
    wake ups per Peter Zijlstra

v2: v1 fixed something unrelated. duh.

--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -182,8 +182,20 @@ __wait_on_bit_lock(wait_queue_head_t *wq
 	do {
 		prepare_to_wait_exclusive(wq, &q->wait, mode);
 		if (test_bit(q->key.bit_nr, q->key.flags)) {
-			if ((ret = (*action)(q->key.flags)))
+			ret = action(q->key.flags);
+			if (ret) {
+				/*
+				 * Contenders are woken exclusively.  If
+				 * we do not take the lock when woken up
+				 * from an unlock, we have to make sure to
+				 * wake the next waiter in line or noone
+				 * will and shkle will wait forever.
+				 */
+				if (!test_bit(q->key.bit_nr, q->key.flags))
+					__wake_up_bit(wq, q->key.flags,
+							q->key.bit_nr);
 				break;
+			}
 		}
 	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
 	finish_wait(wq, &q->wait);
