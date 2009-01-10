Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbZAJHlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbZAJHlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 02:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZAJHk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 02:40:59 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:39160 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZAJHk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 02:40:58 -0500
Message-ID: <496850D5.8040907@cosmosbay.com>
Date: Sat, 10 Jan 2009 08:40:05 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>, ben@zeus.com,
       jarkao2@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
References: <49667534.5060501@zeus.com> <20090108.135515.85489589.davem@davemloft.net> <4966F2F4.9080901@cosmosbay.com> <49677074.5090802@cosmosbay.com> <20090109185448.GA1999@1wt.eu> <4967B8C5.10803@cosmosbay.com> <20090109212400.GA3727@1wt.eu> <20090109220737.GA4111@1wt.eu> <4967CBB9.1060403@cosmosbay.com> <20090109221744.GA4819@1wt.eu> <20090109224258.GA10257@ioremap.net>
In-Reply-To: <20090109224258.GA10257@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 10 Jan 2009 08:40:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov a écrit :
> On Fri, Jan 09, 2009 at 11:17:44PM +0100, Willy Tarreau (w@1wt.eu) wrote:
>> However I'm OK for the !timeo before release_sock/lock_sock. I just
>> don't know if we can put the rest of the if above or not. I don't
>> know what changes we're supposed to collect by doing release_sock/
>> lock_sock before the if().
> 
> Not to interrupt the discussion, but for the clarification, that
> release_sock/lock_sock is used to process the backlog accumulated while
> socket was locked. And while dropping additional pair before the final
> release is ok, but moving this itself should be thought of twice.
> 

Hum... I just caught the release_sock(sk)/lock_sock(sk) done in skb_splice_bits()

So :

1) the release_sock/lock_sock done in tcp_splice_read() is not necessary
to process backlog. Its already done in skb_splice_bits()

2) If we loop in tcp_read_sock() calling skb_splice_bits() several times
then we should perform the following tests inside this loop ?

if (sk->sk_err || sk->sk_state == TCP_CLOSE || (sk->sk_shutdown & RCV_SHUTDOWN) ||
   signal_pending(current)) break;

And removie them from tcp_splice_read() ?



