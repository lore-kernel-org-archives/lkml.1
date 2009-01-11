Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbZAKM6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbZAKM6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZAKM6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:58:05 -0500
Received: from matrixpower.ru ([195.178.208.66]:47558 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbZAKM6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:58:02 -0500
Date: Sun, 11 Jan 2009 15:58:00 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>, ben@zeus.com,
       jarkao2@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090111125759.GB24173@ioremap.net>
References: <4966F2F4.9080901@cosmosbay.com> <49677074.5090802@cosmosbay.com> <20090109185448.GA1999@1wt.eu> <4967B8C5.10803@cosmosbay.com> <20090109212400.GA3727@1wt.eu> <20090109220737.GA4111@1wt.eu> <4967CBB9.1060403@cosmosbay.com> <20090109221744.GA4819@1wt.eu> <20090109224258.GA10257@ioremap.net> <496850D5.8040907@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496850D5.8040907@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric.

On Sat, Jan 10, 2009 at 08:40:05AM +0100, Eric Dumazet (dada1@cosmosbay.com) wrote:
> > Not to interrupt the discussion, but for the clarification, that
> > release_sock/lock_sock is used to process the backlog accumulated while
> > socket was locked. And while dropping additional pair before the final
> > release is ok, but moving this itself should be thought of twice.
> > 
> 
> Hum... I just caught the release_sock(sk)/lock_sock(sk) done in skb_splice_bits()
> 
> So :
> 
> 1) the release_sock/lock_sock done in tcp_splice_read() is not necessary
> to process backlog. Its already done in skb_splice_bits()

Yes, in the tcp_splice_read() they are added to remove a deadlock.

> 2) If we loop in tcp_read_sock() calling skb_splice_bits() several times
> then we should perform the following tests inside this loop ?
> 
> if (sk->sk_err || sk->sk_state == TCP_CLOSE || (sk->sk_shutdown & RCV_SHUTDOWN) ||
>    signal_pending(current)) break;
> 
> And removie them from tcp_splice_read() ?

It could be done, but for what reason? To detect disconnected socket early?
Does it worth the changes?

-- 
	Evgeniy Polyakov
