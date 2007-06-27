Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbXF0B3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbXF0B3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 21:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbXF0B3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 21:29:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:8741 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbXF0B3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 21:29:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=htSvLEMya/O+4jk/TeLeFEE1zIv1qiY+Zy4HnkVvFcQS0EJ+VUZPbMMtqYnh2Ns9nIF+h36+TeW7KE3/b9ixpLK3eNvvuHg1Chx7xJ3JBbWy7Bo/FIIfK182OzP9tbUYn/yrLvtj+qezUwr9VQ9jiAvs3u4w7L7/fLUBQHTsxv0=
Message-ID: <a781481a0706261829l4a5c19cey7e1e75157fb74ce2@mail.gmail.com>
Date: Wed, 27 Jun 2007 06:59:35 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [PATCH] RFC: have tcp_recvmsg() check kthread_should_stop() and treat it as if it were signalled
Cc: "Jeff Layton" <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Herbert Xu" <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
       linux-cifs-client@lists.samba.org
In-Reply-To: <a781481a0706261553i1e65e620o884708d0b068b0f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608123527.9b4cdafe.jlayton@redhat.com>
	 <E1HwpmG-0008LW-00@gondolin.me.apana.org.au>
	 <20070609070826.7bd3480c.jlayton@redhat.com>
	 <a781481a0706251241n36126456x7f4b445a86d1a68f@mail.gmail.com>
	 <20070626115449.GA92@tv-sign.ru>
	 <a781481a0706261553i1e65e620o884708d0b068b0f8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> [...]
> On 6/26/07, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > On 06/26, Satyam Sharma wrote:
> [...]
> > > So could we have signals in _addition_ to kthread_stop_info and change
> > > kthread_should_stop() to check for both:
> > >
> > > kthread_stop_info.k == current && signal_pending(current)
> >
> > No, this can't work in general. Some kthreads do flush_signals/dequeue_signal,
> > so TIF_SIGPENDING can be lost anyway.
>
> Yup, I had thought of precisely this issue yesterday as well. The mental note
> I made to myself was that the force_sig(SIGKILL) and wake_up_process() in
> kthread_stop() must be atomic so that the following race is not possible:

Hmm, the issue seems to have more to do with the ordering of
flush_signals() w.r.t. checking kthread_should_stop() in the kthread's
code. I thought about how to tackle this, but there's no easy way to make
the stuff atomic like I thought earlier. The problem, like you mentioned,
is if the target kthread proactively flushes its signals by hand *before*
checking kthread_should_stop().

The only way out seems to be to simply outlaw flush_signals() in kthreads
(or anything to do with signals), but that would be impossible to enforce ...

Satyam
