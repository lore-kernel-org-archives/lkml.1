Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbZF1VTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbZF1VTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZF1VSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:18:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40574 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZF1VSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:18:52 -0400
Date: Sun, 28 Jun 2009 20:04:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Eric Dumazet <eric.dumazet@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] net: fix race in the receive/select
Message-ID: <20090628180412.GA9171@redhat.com>
References: <alpine.DEB.1.10.0906251827510.9517@makko.or.mcafeemobile.com> <4A442B65.8040701@gmail.com> <alpine.DEB.1.10.0906251858520.9517@makko.or.mcafeemobile.com> <4A443033.8060401@gmail.com> <alpine.DEB.1.10.0906251947530.9517@makko.or.mcafeemobile.com> <20090626135742.GB3845@redhat.com> <alpine.DEB.1.10.0906261018580.16400@makko.or.mcafeemobile.com> <20090626145027.GA6534@redhat.com> <4A474FB5.4070901@gmail.com> <4A475266.9040203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A475266.9040203@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, Jarek Poplawski wrote:
>
> Jarek Poplawski wrote, On 06/28/2009 01:10 PM:
>
> > Oleg Nesterov wrote, On 06/26/2009 04:50 PM:
> >
> >> Perhaps we can add
> >>
> >> 	void sock_poll_wait(struct file *file, struct sock *sk, poll_table *pt)
> >> 	{
> >> 		if (pt) {
> >> 			poll_wait(file, sk->sk_sleep, pt);
> >> 			/*
> >> 			 * fat comment
> >> 			 */
> >> 			smp_mb(); // or smp_mb__after_unlock();
> >> 		}
> >> 	}
> >>
> >> Oleg.
> >
> >
> > Maybe 'a bit' further?:
> >
> > static inline void __poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
> > {
> > 	p->qproc(filp, wait_address, p);
> > }
> >
> > static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
> > {
> > 	if (p && wait_address)
> > 		__poll_wait(filp, wait_address, p);
> > }
> >
> > static inline void sock_poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
> > {
> > 	if (p && wait_address) {
> > 		__poll_wait(filp, wait_address, p);
> > 		/*
> > 		 * fat comment
> > 		 */
> > 		smp_mb(); // or smp_mb__after_unlock();
> > 	}
> > }
> >
>
>
> Hmm... of course:
>
> static inline void sock_poll_wait(struct file * filp, struct sock *sk, poll_table *p)
> {
>  	if (p && sk->sk_sleep) {
>  		__poll_wait(filp, sk->sk_sleep, p);
>  		/*
>  		 * fat comment
>  		 */
>  		smp_mb(); // or smp_mb__after_unlock();
>  	}
> }

Perhaps it makes sense to check ->sk_sleep != NULL in sock_poll_wait(), but
I don't think we need __poll_wait(). poll_wait() is inline, I think gcc
will optimize out "if (p && wait_address)" check if poll_wait() is called
from sock_poll_wait().

This all is up to Jiri of course. But speaking about cosmetic changes, I
think it is better to make 2 patches. The first one fixes the problem using
smp_mb(), another introduces smp_mb__xxx_lock() to optimize the code.

Oleg.

