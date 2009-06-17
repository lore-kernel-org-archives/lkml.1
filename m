Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbZFQUdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbZFQUdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZFQUdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:33:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZFQUda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:33:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=E502nO8s3XHyJftqMHxDKMcYRJ5KA9VJdBHe2wlgiC1mS18fwJ8Mp09JIzTF/DZDU
	Udr3lenWTd2c/ykrVindQ==
Date: Wed, 17 Jun 2009 13:33:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: "David S. Miller" <davem@davemloft.net>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
In-Reply-To: <4A394F27.8060308@gmail.com>
Message-ID: <alpine.DEB.2.00.0906171326120.4786@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <alpine.DEB.2.00.0906171227040.1089@chino.kir.corp.google.com> <4A394F27.8060308@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Eric Dumazet wrote:

> > ipv4: don't warn about skb ack allocation failures
> > 
> > tcp_send_ack() will recover from alloc_skb() allocation failures, so avoid 
> > emitting warnings.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -2442,7 +2442,7 @@ void tcp_send_ack(struct sock *sk)
> >  	 * tcp_transmit_skb() will set the ownership to this
> >  	 * sock.
> >  	 */
> > -	buff = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC);
> > +	buff = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC | __GFP_NOWARN);
> >  	if (buff == NULL) {
> >  		inet_csk_schedule_ack(sk);
> >  		inet_csk(sk)->icsk_ack.ato = TCP_ATO_MIN;
> 
> I count more than 800 GFP_ATOMIC allocations in net/ tree.
> 
> Most (if not all) of them can recover in case of failures.
> 
> Should we add __GFP_NOWARN to all of them ?
> 

Yes, if they are recoverable without any side effects.  Otherwise, they 
will continue to emit page allocation failure messages which cause users 
to waste their time when they recognize a problem of an unknown 
seriousness level in both reporting the issue and looking for resulting 
corruption.  The __GFP_NOWARN annotation suppresses such warnings for 
those very reasons.
