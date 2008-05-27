Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYE0PSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYE0PSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYE0PS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:18:26 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:59132 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbYE0PSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:18:25 -0400
Date: Tue, 27 May 2008 08:18:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
Message-ID: <20080527151809.GA14296@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080428120412.GY12774@kernel.dk> <20080428195509.GA5247@martell.zuzino.mipt.ru> <20080429062116.GA5059@martell.zuzino.mipt.ru> <20080429090604.GK12774@kernel.dk> <20080430221250.GA10150@martell.zuzino.mipt.ru> <20080504190811.GP12774@kernel.dk> <20080504201542.GA1040@martell.zuzino.mipt.ru> <20080510103719.GA4967@martell.zuzino.mipt.ru> <20080527052740.GB28301@martell.zuzino.mipt.ru> <20080527133510.GV7712@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527133510.GV7712@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 03:35:10PM +0200, Jens Axboe wrote:
> On Tue, May 27 2008, Alexey Dobriyan wrote:
> > On Sat, May 10, 2008 at 02:37:19PM +0400, Alexey Dobriyan wrote:
> > > > > > > @@ -41,8 +41,8 @@ int put_io_context(struct io_context *ioc)
> > > > > > >  		rcu_read_lock();
> > > > > > >  		if (ioc->aic && ioc->aic->dtor)
> > > > > > >  			ioc->aic->dtor(ioc->aic);
> > > > > > > -		rcu_read_unlock();
> > > > > > >  		cfq_dtor(ioc);
> > > > > > > +		rcu_read_unlock();
> > > > > > >  
> > > > > > >  		kmem_cache_free(iocontext_cachep, ioc);
> > > > > > >  		return 1;
> > > > > > 
> > > > > > This helps in sense that 3 times bulk cross-compiles finish to the end.
> > > > > > You'll hear me if another such oops will resurface.
> > > > > 
> > > > > Still looking good?
> > > > 
> > > > Yup!
> > > 
> > > And this with patch in mainline, again with PREEMPT_RCU.
> > 
> > Ping, this happened again with 2.6.26-rc4 and PREEMPT_RCU.
> 
> Worrisome... Paul, would you mind taking a quick look at cfq
> and see if you can detect why breaks with preempt rcu? It's
> clearly a use-after-free symptom, but I don't see how it can
> happen.

Some quick and probably off-the-mark questions...

o	What is the purpose of __call_for_each_cic()?  When called
	from call_for_each_cic(), it is under rcu_read_lock(), as
	required, but it is also called from cfq_free_io_context(),
	which is assigned to the ->dtor and ->exit members of the
	cfq_io_context struct.  What protects calls through these
	members?

	(This is for the ->cic_list field of the cfq_io_context structure.
	One possibility is that the io_context's ->lock member is held,
	but I don't see this.  Not that I looked all that hard...)

	My suggestion would be to simply change all invocations of
	__call_for_each_cic() to instead invoke call_for_each_cic().
	The rcu_read_lock()/rcu_read_unlock() pair is pretty
	lightweight, even in CONFIG_PREEMPT_RCU.

o	When calling cfq_slab_kill(), for example from cfq_exit(),
	what ensures that all previous RCU callbacks have completed?
	
	I suspect that you need an rcu_barrier() at the beginning
	of cfq_slab_kill(), but I could be missing something.

o	Updates to the ->ioc_data field of the cfq_io_context
	seem to be protected by the request_queue ->queue_lock
	field.  This seems very strange to me.  It is OK if every
	cfq_io_context is associated with only one request_queue
	structure -- is this the case?

o	What protects the first rcu_dereference() in cfq_cic_lookup()?
	There needs to be either an enclose rcu_read_lock() on the
	one hand or the ->queue_lock needs to be held.

	(My guess is the latter, given the later rcu_assign_pointer()
	in this same function, but I don't see a lock acquisition
	in the immediate vicinity -- might be further up the function
	call stack, though.)

o	Why is there no grace period associated with the ioc_data?
	For example, what happens to the old value of ->ioc_data
	after the rcu_assign_pointer() in cfq_cic_lookup()?  Readers
	might still be referencing the old version, right?  If so,
	how do we avoid messing them up?

	Or are we somehow leveraging the call_rcu() in cfq_cic_free()?

Any of this at all helpful?

							Thanx, Paul
