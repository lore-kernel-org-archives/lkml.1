Return-Path: <linux-kernel-owner+w=401wt.eu-S1765820AbXF1TXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765820AbXF1TXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 15:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763995AbXF1TXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 15:23:00 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:10161 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764767AbXF1TW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 15:22:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nVeyzjt3AMqz5pDh8kbvqWbDAPzVIBqJ0PGYL7VF0873HmvGp3NVRPzNngKAoLWiKLO4v54lgIYGhUaE2odVLDEBE559Q9znbHJetRbjwPBtIMUoBgpjJFWTdH7PPPP53xcjoD7IYPey+24t6lq6q3VMnqWaLAejYwvSV50d1OE=
Message-ID: <a781481a0706281222l6bd21c9fgda1554db97825514@mail.gmail.com>
Date: Fri, 29 Jun 2007 00:52:56 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [PATCH] RFC: have tcp_recvmsg() check kthread_should_stop() and treat it as if it were signalled
Cc: "Jeff Layton" <jlayton@redhat.com>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070628170825.GA549@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608123527.9b4cdafe.jlayton@redhat.com>
	 <20070609070826.7bd3480c.jlayton@redhat.com>
	 <a781481a0706251241n36126456x7f4b445a86d1a68f@mail.gmail.com>
	 <20070626115449.GA92@tv-sign.ru>
	 <a781481a0706261553i1e65e620o884708d0b068b0f8@mail.gmail.com>
	 <20070627122437.GA158@tv-sign.ru>
	 <a781481a0706271744i9181641sff43e2053dde0f9@mail.gmail.com>
	 <20070628141246.GA95@tv-sign.ru>
	 <a781481a0706280844l7eec6067gd576d88619463fe9@mail.gmail.com>
	 <20070628170825.GA549@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On 6/28/07, Oleg Nesterov <oleg@tv-sign.ru> wrote:
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

Well, I definitely wouldn't call it "buggy" ... skb_recv_datagram()
(if with sock->sk_rcvtimeo != MAX_SCHEDULE_TIMEOUT) would then
needlessly have to be put into it's own little while(1) (or put a
"continue;" after it back to main kthread loop). A question arises,
what timeout value to use? (too little => needless wastage of CPU;
too high => see below)

More importantly, the other thread that does a kthread_stop() on our
kthread (probably a umount(2) or rmmod) would then unfortunately hang
(on wait_for_completion i.e. TASK_UNINTERRUPTIBLE) for the duration
of the time it takes for our kthread to finish it's timeout, which plays
havoc with userspace scripts.

> OK, I suggest to stop this thread. I don't claim you are wrong, just
> we think differently ;)

That's fine, we can still "agree to disagree" here :-)

Cheers,
Satyam
