Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZKCX5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZKCX5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZKCX5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:57:41 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48390 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZKCX5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:57:40 -0500
Date: Tue, 3 Nov 2009 15:57:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com
Subject: Re: [PATCHv7 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20091103235744.GF6726@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1257267892.git.mst@redhat.com> <20091103172422.GD5591@redhat.com> <4AF0708B.4020406@gmail.com> <4AF07199.2020601@gmail.com> <4AF072EE.9020202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AF072EE.9020202@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 01:14:06PM -0500, Gregory Haskins wrote:
> Gregory Haskins wrote:
> > Eric Dumazet wrote:
> >> Michael S. Tsirkin a écrit :
> >>> +static void handle_tx(struct vhost_net *net)
> >>> +{
> >>> +	struct vhost_virtqueue *vq = &net->dev.vqs[VHOST_NET_VQ_TX];
> >>> +	unsigned head, out, in, s;
> >>> +	struct msghdr msg = {
> >>> +		.msg_name = NULL,
> >>> +		.msg_namelen = 0,
> >>> +		.msg_control = NULL,
> >>> +		.msg_controllen = 0,
> >>> +		.msg_iov = vq->iov,
> >>> +		.msg_flags = MSG_DONTWAIT,
> >>> +	};
> >>> +	size_t len, total_len = 0;
> >>> +	int err, wmem;
> >>> +	size_t hdr_size;
> >>> +	struct socket *sock = rcu_dereference(vq->private_data);
> >>> +	if (!sock)
> >>> +		return;
> >>> +
> >>> +	wmem = atomic_read(&sock->sk->sk_wmem_alloc);
> >>> +	if (wmem >= sock->sk->sk_sndbuf)
> >>> +		return;
> >>> +
> >>> +	use_mm(net->dev.mm);
> >>> +	mutex_lock(&vq->mutex);
> >>> +	vhost_no_notify(vq);
> >>> +
> >> using rcu_dereference() and mutex_lock() at the same time seems wrong, I suspect
> >> that your use of RCU is not correct.
> >>
> >> 1) rcu_dereference() should be done inside a read_rcu_lock() section, and
> >>    we are not allowed to sleep in such a section.
> >>    (Quoting Documentation/RCU/whatisRCU.txt :
> >>      It is illegal to block while in an RCU read-side critical section, )
> >>
> >> 2) mutex_lock() can sleep (ie block)
> >>
> > 
> > 
> > Michael,
> >   I warned you that this needed better documentation ;)
> > 
> > Eric,
> >   I think I flagged this once before, but Michael convinced me that it
> > was indeed "ok", if but perhaps a bit unconventional.  I will try to
> > find the thread.
> > 
> > Kind Regards,
> > -Greg
> > 
> 
> Here it is:
> 
> http://lkml.org/lkml/2009/8/12/173

What was happening in that case was that the rcu_dereference()
was being used in a workqueue item.  The role of rcu_read_lock()
was taken on be the start of execution of the workqueue item, of
rcu_read_unlock() by the end of execution of the workqueue item, and
of synchronize_rcu() by flush_workqueue().  This does work, at least
assuming that flush_workqueue() operates as advertised, which it appears
to at first glance.

The above code looks somewhat different, however -- I don't see
handle_tx() being executed in the context of a work queue.  Instead
it appears to be in an interrupt handler.

So what is the story?  Using synchronize_irq() or some such?

							Thanx, Paul
