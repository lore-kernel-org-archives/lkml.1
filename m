Return-Path: <linux-kernel-owner+w=401wt.eu-S1765396AbXF1Sl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765396AbXF1Sl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759724AbXF1Slx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:41:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936AbXF1Slw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:41:52 -0400
Date: Thu, 28 Jun 2007 14:41:39 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] RFC: have tcp_recvmsg() check kthread_should_stop() and
 treat it as if it were signalled
Message-Id: <20070628144139.343eb0dd.jlayton@redhat.com>
In-Reply-To: <20070628170825.GA549@tv-sign.ru>
References: <20070608123527.9b4cdafe.jlayton@redhat.com>
	<E1HwpmG-0008LW-00@gondolin.me.apana.org.au>
	<20070609070826.7bd3480c.jlayton@redhat.com>
	<a781481a0706251241n36126456x7f4b445a86d1a68f@mail.gmail.com>
	<20070626115449.GA92@tv-sign.ru>
	<a781481a0706261553i1e65e620o884708d0b068b0f8@mail.gmail.com>
	<20070627122437.GA158@tv-sign.ru>
	<a781481a0706271744i9181641sff43e2053dde0f9@mail.gmail.com>
	<20070628141246.GA95@tv-sign.ru>
	<a781481a0706280844l7eec6067gd576d88619463fe9@mail.gmail.com>
	<20070628170825.GA549@tv-sign.ru>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 21:08:25 +0400
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 06/28, Satyam Sharma wrote:
> >
> > Second, we *must* break that tcp_recvmsg() inside the kthread's
> > main loop, of course! We want it stopped, after all, and if we don't
> > make it "break" out of that function, the kthread _will_never_exit_.
> 
> In that case this kthread is buggy. We have sock->sk_rcvtimeo.
> 
> > Please note that this
> > whole thing is about functions that will _simply_*never*_exit_ever_
> > _unless_ given a signal.
> 
> ditto. kthread should not do this.
> 
> OK, I suggest to stop this thread. I don't claim you are wrong, just
> we think differently ;)
> 
> > >This is what I can't understand completely. Why should we check SIGKILL
> > >or signal_pending() in addition to kthread_stop_info.k, what is the point?
> >
> > ... so kthread_stop_info will go away too.
> 
> it should go away regardless, we have patches. Still I see no point
> to check signal_pending() in kthread_stop().
> 
> Oleg.
> 

Again, this isn't an area where I have great expertise...

Adding signalling into kthread_stop would seem to be making some
assumptions about how kthreads are used and how they should respond to
signals. That sounds unsafe and might potentially limit flexibility.

agree with Oleg here -- I don't see the benefit to doing this for all
kthreads. If you're aware that your kthread might be blocked on a call,
then it doesn't seem burdensome to add in an extra send/force_sig call. 

-- 
Jeff Layton <jlayton@redhat.com>
