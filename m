Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZGAHFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZGAHFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZGAHFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:05:44 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:56997 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZGAHFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:05:43 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 1 Jul 2009 00:04:56 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Jiri Olsa <jolsa@redhat.com>
cc: Davide Libenzi <davidel@xmailserver.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       jarkao2@gmail.com, oleg@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCHv3 1/2] net: adding memory barrier to the poll and receive
 callbacks
In-Reply-To: <20090701065724.GA2852@jolsa.lab.eng.brq.redhat.com>
Message-ID: <alpine.DEB.1.10.0907010002010.8492@makko.or.mcafeemobile.com>
References: <20090630125240.GB4406@jolsa.lab.eng.brq.redhat.com> <20090630125425.GC4406@jolsa.lab.eng.brq.redhat.com> <alpine.DEB.1.10.0906301210210.3968@makko.or.mcafeemobile.com> <20090701065724.GA2852@jolsa.lab.eng.brq.redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Jiri Olsa wrote:

> On Tue, Jun 30, 2009 at 12:13:40PM -0700, Davide Libenzi wrote:
> > On Tue, 30 Jun 2009, Jiri Olsa wrote:
> > 
> > > Adding memory barrier after the poll_wait function, paired with
> > > receive callbacks. Adding fuctions sock_poll_wait and sock_has_sleeper
> > > to wrap the memory barrier.
> > > 
> > > Without the memory barrier, following race can happen.
> > > The race fires, when following code paths meet, and the tp->rcv_nxt 
> > > and __add_wait_queue updates stay in CPU caches.
> > > 
> > > 
> > > CPU1                         CPU2
> > > 
> > > sys_select                   receive packet
> > >   ...                        ...
> > >   __add_wait_queue           update tp->rcv_nxt
> > >   ...                        ...
> > >   tp->rcv_nxt check          sock_def_readable
> > >   ...                        {
> > >   schedule                      ...
> > >                                 if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
> > >                                         wake_up_interruptible(sk->sk_sleep)
> > >                                 ...
> > >                              }
> > > 
> > > If there was no cache the code would work ok, since the wait_queue and
> > > rcv_nxt are opposit to each other.
> > > 
> > > Meaning that once tp->rcv_nxt is updated by CPU2, the CPU1 either already
> > > passed the tp->rcv_nxt check and sleeps, or will get the new value for
> > > tp->rcv_nxt and will return with new data mask.
> > > In both cases the process (CPU1) is being added to the wait queue, so the
> > > waitqueue_active (CPU2) call cannot miss and will wake up CPU1.
> > > 
> > > The bad case is when the __add_wait_queue changes done by CPU1 stay in its
> > > cache, and so does the tp->rcv_nxt update on CPU2 side.  The CPU1 will then
> > > endup calling schedule and sleep forever if there are no more data on the
> > > socket.
> > 
> > > +static inline int sk_has_sleeper(struct sock *sk)
> > > +{
> > > +	/*
> > > +	 * We need to be sure we are in sync with the
> > > +	 * add_wait_queue modifications to the wait queue.
> > > +	 *
> > > +	 * This memory barrier is paired in the sock_poll_wait.
> > > +	 */
> > > +	smp_mb();
> > > +	return sk->sk_sleep && waitqueue_active(sk->sk_sleep);
> > > +}
> > 
> > Jiri, since this is a pretty tricky condition, would you mind to have a 
> > reduced version of the patch comment added to the source code?
> > Patch comments are not really useful when you're trying to make sense of 
> > some code ;)
> > 
> 
> well, to be honest I thought it was already reduced :) however I have
> no problem to make it shorter.. any suggestions? 
> 
> "This memory barrier protects the add_wait_queue modifications.
> It is paired in the sock_poll_wait."
> 
> or do you want only the 
> 
> "This memory barrier is paired in the sock_poll_wait."

Heh, no, not that comment :)
You detailed very clearly why the MB machinery is needed in your email 
body, but the comment in the source code is pretty vague.
So when I was talking about comment reduction, I meant using a reduced 
version of the comment in the email body, into the proper place in the 
source code.


- Davide


