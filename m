Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYDBQIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYDBQIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYDBQIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:08:14 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34017 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbYDBQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:08:13 -0400
Date: Wed, 2 Apr 2008 09:08:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402160809.GA4123@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI> <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu> <20080402105539.GA5610@linux.vnet.ibm.com> <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 02:01:13PM +0300, Pekka Enberg wrote:
> Hi Paul,
> 
> On Wed, Apr 2, 2008 at 1:55 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >  I will check this when I get back to some bandwidth -- but in the meantime,
> >  does kmemcheck special-case SLAB_DESTROY_BY_RCU?  It is legal to access
> >  newly-freed items in that case, as long as you did rcu_read_lock()
> >  before gaining a reference to them and don't hold the reference past
> >  the matching rcu_read_unlock().
> 
> No, kmemcheck is work in progress and does not know about
> SLAB_DESTROY_BY_RCU yet. The reason I asked Vegard to post the warning
> was because Peter, Vegard, and myself identified this particular
> warning as a real problem. But yeah, kmemcheck can cause false
> positives for RCU for now.

Would the following be an appropriate fix?  It seems to me to be in
the same spirit as the existing check for s->ctor.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 slub_kmemcheck.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub_kmemcheck.c b/mm/slub_kmemcheck.c
index 8620a8b..e07f62a 100644
--- a/mm/slub_kmemcheck.c
+++ b/mm/slub_kmemcheck.c
@@ -93,6 +93,6 @@ kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object)
 void
 kmemcheck_slab_free(struct kmem_cache *s, void *object)
 {
-	if (!s->ctor)
+	if (!s->ctor && !(s->flags & SLAB_DESTROY_BY_RCU))
 		kmemcheck_mark_freed(object, s->objsize);
 }
