Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbZAKNh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbZAKNh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZAKNfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:35:38 -0500
Received: from kandzendo.ru ([195.178.208.66]:48642 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248AbZAKNfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:35:36 -0500
Date: Sun, 11 Jan 2009 16:35:33 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>, ben@zeus.com,
       jarkao2@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090111133533.GB25337@ioremap.net>
References: <20090109185448.GA1999@1wt.eu> <4967B8C5.10803@cosmosbay.com> <20090109212400.GA3727@1wt.eu> <20090109220737.GA4111@1wt.eu> <4967CBB9.1060403@cosmosbay.com> <20090109221744.GA4819@1wt.eu> <20090109224258.GA10257@ioremap.net> <496850D5.8040907@cosmosbay.com> <20090111125759.GB24173@ioremap.net> <4969F0D1.8020504@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4969F0D1.8020504@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 02:14:57PM +0100, Eric Dumazet (dada1@cosmosbay.com) wrote:
> >> 1) the release_sock/lock_sock done in tcp_splice_read() is not necessary
> >> to process backlog. Its already done in skb_splice_bits()
> > 
> > Yes, in the tcp_splice_read() they are added to remove a deadlock.
> 
> Could you elaborate ? A deadlock only if !SPLICE_F_NONBLOCK ?

Sorry, I meant that we drop lock in skb_splice_bits() to prevent the deadlock,
and tcp_splice_read() needs it to process the backlog.

I think that even with non-blocking splice that release_sock/lock_sock
is needed, since we are able to do a parallel job: to receive new data
(scheduled by early release_sock backlog processing) in bh and to
process already received data via splice codepath.
Maybe in non-blocking splice mode this is not an issue though, but for
the blocking mode this allows to grab more skbs at once in skb_splice_bits.

> > 
> >> 2) If we loop in tcp_read_sock() calling skb_splice_bits() several times
> >> then we should perform the following tests inside this loop ?
> >>
> >> if (sk->sk_err || sk->sk_state == TCP_CLOSE || (sk->sk_shutdown & RCV_SHUTDOWN) ||
> >>    signal_pending(current)) break;
> >>
> >> And removie them from tcp_splice_read() ?
> > 
> > It could be done, but for what reason? To detect disconnected socket early?
> > Does it worth the changes?
> 
> I was thinking about the case your thread is doing a splice() from tcp socket to
>  a pipe, while another thread is doing the splice from this pipe to something else.
> 
> Once patched, tcp_read_sock() could loop a long time...
 
Well, it maybe a good idea... Can not say anything against it :)

-- 
	Evgeniy Polyakov
