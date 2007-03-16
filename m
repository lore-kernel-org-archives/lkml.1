Return-Path: <linux-kernel-owner+w=401wt.eu-S965887AbXCPUZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965887AbXCPUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965890AbXCPUZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:25:58 -0400
Received: from 27.mail-out.ovh.net ([213.186.38.137]:46238 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965887AbXCPUZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:25:57 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2007 16:25:57 EDT
Date: Fri, 16 Mar 2007 22:19:00 +0200
From: Samuel Ortiz <samuel@sortiz.org>
To: David Miller <davem@davemloft.net>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: irda rmmod lockdep trace.
Message-ID: <20070316201900.GA3396@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <20070312003843.GA3394@sortiz.org> <20070312.164921.71090866.davem@davemloft.net> <20070314005003.GA15151@sortiz.org> <20070313.192237.112853631.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313.192237.112853631.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Ovh-Remote: 90.36.150.252 (aannecy-257-1-95-252.w90-36.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 07:22:37PM -0700, David Miller wrote:
> From: Samuel Ortiz <samuel@sortiz.org>
> Date: Wed, 14 Mar 2007 02:50:03 +0200
> 
> > On Mon, Mar 12, 2007 at 04:49:21PM -0700, David Miller wrote:
> > > I would strongly caution against adding any run-time overhead just to
> > > cure a false lockdep warning.  Even adding a new function argument
> > > is too much IMHO.
> > > 
> > > Make the cost show up for lockdep only, perhaps by putting each
> > > hashbin lock into a seperate locking class?
> > Does that look better to you:
> 
> Yes, it does.:)
Unfortunately, it doesn't work, as the lock key is not on the stack. We get
hit by the lockdep code checking if our lock key is static:

      if (!static_obj(key)) {
                printk("BUG: key %p not in .data!\n", key);
                DEBUG_LOCKS_WARN_ON(1);
                return;
        }

So, instead, I propose the following, which does work, and adds runtime
overhead only when LOCKDEP is enabled:

---
 net/irda/irqueue.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/irda/irqueue.c b/net/irda/irqueue.c
index 9266233..d058b46 100644
--- a/net/irda/irqueue.c
+++ b/net/irda/irqueue.c
@@ -384,6 +384,9 @@ EXPORT_SYMBOL(hashbin_new);
  *    for deallocating this structure if it's complex. If not the user can
  *    just supply kfree, which should take care of the job.
  */
+#ifdef CONFIG_LOCKDEP
+static int hashbin_lock_depth = 0;
+#endif
 int hashbin_delete( hashbin_t* hashbin, FREE_FUNC free_func)
 {
 	irda_queue_t* queue;
@@ -395,7 +398,8 @@ int hashbin_delete( hashbin_t* hashbin, FREE_FUNC free_func)
 
 	/* Synchronize */
 	if ( hashbin->hb_type & HB_LOCK ) {
-		spin_lock_irqsave(&hashbin->hb_spinlock, flags);
+		spin_lock_irqsave_nested(&hashbin->hb_spinlock, flags,
+					 hashbin_lock_depth++);
 	}
 
 	/*
@@ -419,6 +423,9 @@ int hashbin_delete( hashbin_t* hashbin, FREE_FUNC free_func)
 	/* Release lock */
 	if ( hashbin->hb_type & HB_LOCK) {
 		spin_unlock_irqrestore(&hashbin->hb_spinlock, flags);
+#ifdef CONFIG_LOCKDEP
+		hashbin_lock_depth--;
+#endif
 	}
 
 	/*

