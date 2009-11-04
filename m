Return-Path: <linux-kernel-owner+w=401wt.eu-S1751588AbZKDRZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbZKDRZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbZKDRZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:25:51 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48113 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbZKDRZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:25:50 -0500
Date: Wed, 4 Nov 2009 09:25:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Haskins <gregory.haskins@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com
Subject: Re: [PATCHv7 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20091104172542.GC6736@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1257267892.git.mst@redhat.com> <20091103172422.GD5591@redhat.com> <4AF0708B.4020406@gmail.com> <4AF07199.2020601@gmail.com> <4AF072EE.9020202@gmail.com> <20091103235744.GF6726@linux.vnet.ibm.com> <20091104115729.GD8398@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091104115729.GD8398@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 01:57:29PM +0200, Michael S. Tsirkin wrote:
> On Tue, Nov 03, 2009 at 03:57:44PM -0800, Paul E. McKenney wrote:
> > On Tue, Nov 03, 2009 at 01:14:06PM -0500, Gregory Haskins wrote:
> > > Gregory Haskins wrote:
> > > > Eric Dumazet wrote:
> > > >> Michael S. Tsirkin a écrit :
> > > >>> +static void handle_tx(struct vhost_net *net)
> > > >>> +{
> > > >>> +	struct vhost_virtqueue *vq = &net->dev.vqs[VHOST_NET_VQ_TX];
> > > >>> +	unsigned head, out, in, s;
> > > >>> +	struct msghdr msg = {
> > > >>> +		.msg_name = NULL,
> > > >>> +		.msg_namelen = 0,
> > > >>> +		.msg_control = NULL,
> > > >>> +		.msg_controllen = 0,
> > > >>> +		.msg_iov = vq->iov,
> > > >>> +		.msg_flags = MSG_DONTWAIT,
> > > >>> +	};
> > > >>> +	size_t len, total_len = 0;
> > > >>> +	int err, wmem;
> > > >>> +	size_t hdr_size;
> > > >>> +	struct socket *sock = rcu_dereference(vq->private_data);
> > > >>> +	if (!sock)
> > > >>> +		return;
> > > >>> +
> > > >>> +	wmem = atomic_read(&sock->sk->sk_wmem_alloc);
> > > >>> +	if (wmem >= sock->sk->sk_sndbuf)
> > > >>> +		return;
> > > >>> +
> > > >>> +	use_mm(net->dev.mm);
> > > >>> +	mutex_lock(&vq->mutex);
> > > >>> +	vhost_no_notify(vq);
> > > >>> +
> > > >> using rcu_dereference() and mutex_lock() at the same time seems wrong, I suspect
> > > >> that your use of RCU is not correct.
> > > >>
> > > >> 1) rcu_dereference() should be done inside a read_rcu_lock() section, and
> > > >>    we are not allowed to sleep in such a section.
> > > >>    (Quoting Documentation/RCU/whatisRCU.txt :
> > > >>      It is illegal to block while in an RCU read-side critical section, )
> > > >>
> > > >> 2) mutex_lock() can sleep (ie block)
> > > >>
> > > > 
> > > > 
> > > > Michael,
> > > >   I warned you that this needed better documentation ;)
> > > > 
> > > > Eric,
> > > >   I think I flagged this once before, but Michael convinced me that it
> > > > was indeed "ok", if but perhaps a bit unconventional.  I will try to
> > > > find the thread.
> > > > 
> > > > Kind Regards,
> > > > -Greg
> > > > 
> > > 
> > > Here it is:
> > > 
> > > http://lkml.org/lkml/2009/8/12/173
> > 
> > What was happening in that case was that the rcu_dereference()
> > was being used in a workqueue item.  The role of rcu_read_lock()
> > was taken on be the start of execution of the workqueue item, of
> > rcu_read_unlock() by the end of execution of the workqueue item, and
> > of synchronize_rcu() by flush_workqueue().  This does work, at least
> > assuming that flush_workqueue() operates as advertised, which it appears
> > to at first glance.
> > 
> > The above code looks somewhat different, however -- I don't see
> > handle_tx() being executed in the context of a work queue.  Instead
> > it appears to be in an interrupt handler.
> > So what is the story?  Using synchronize_irq() or some such?
> > 
> > 							Thanx, Paul
> 
> No, there has been no change (I won't be able to use a mutex in an
> interrupt handler, will I?).  handle_tx is still called in the context
> of a work queue: either from handle_tx_kick or from handle_tx_net which
> are work queue items.

Ah, my mistake -- I was looking at 2.6.31 rather than latest git with
your patches.

> Can you ack this usage please?

I thought I had done so in my paragraph above, but if you would like
something a bit more formal...

	I, Paul E. McKenney, maintainer of the RCU implmentation
	embodied in the Linux kernel and co-inventor of RCU, being of
	sound mind and body, notwithstanding the wear and tear inherent
	in my numerous decades sojourn on this planet, hereby declare
	that the following usage of work queues constitutes a valid
	RCU implementation:

	1.	Execution of a full workqueue item being substituted
		for a conventional RCU read-side critical section, so
		that the start of execution of the function specified to
		INIT_WORK() corresponds to rcu_read_lock(), and the end of
		this self-same function corresponds to rcu_read_unlock().

	2.	Execution of flush_workqueue() being substituted for
		the conventional synchronize_rcu().

	The kernel developer availing himself or herself of this
	declaration must observe the following caveats:

	a.	The function specified to INIT_WORK() may only be
		invoked via the workqueue mechanism.  Invoking said
		function directly renders this declaration null
		and void, as it prevents the flush_workqueue() function
		from delivering the fundamental guarantee inherent in RCU.

	b.	At some point in the future, said developer may be
		required to apply some gcc attribute or sparse annotation
		to the function passed to INIT_WORK().	Beyond that
		point, failure to comply will render this declaration
		null and void, as such failure would render inoperative
		some potential RCU-validation tools, as duly noted by
		Eric Dumazet.

	c.	This declaration in no way relieves the developer of
		the responsibility to use this and other synchronization
		mechanisms correctly, again, as duly noted by Eric
		Dumazet.

(Sorry, but, as always, I could not resist!)

							Thanx, Paul
