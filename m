Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbXKNMEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbXKNMEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbXKNMEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:04:35 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:42519 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753147AbXKNMEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:04:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iCIosJf3xCJX3nwF+VqPnF3oH+wMhOmL2vccjDKrzc6JEjeu6Qfywfxpsvce32/RxLa4rGVpEe7Dpj0zntSqbv6pO57RHm8cpTRZiKVmlqSyY97KUaM5dVVS2rMoJOBYRsHonEpPSZu3dkVvFE6jEjKwCBLrNtoATk4gqBu5x/0=  ;
X-YMail-OSG: SbDkBnUVM1nnCwZyVA1Pmi4td7IES484S2fFyqQxWlbCBIEA9U9XB6DUWw1_miGSku3lXd862Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression with tbench
Date: Wed, 14 Nov 2007 11:02:11 +1100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, clameter@sgi.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200711140514.28159.nickpiggin@yahoo.com.au> <20071114.031022.183117678.davem@davemloft.net> <20071114114844.GA13927@gondor.apana.org.au>
In-Reply-To: <20071114114844.GA13927@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711141102.11477.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 22:48, Herbert Xu wrote:
> On Wed, Nov 14, 2007 at 03:10:22AM -0800, David Miller wrote:
> > So the thing that's being effected here in TCP is
> > net/ipv4/tcp.c:select_size(), specifically the else branch:
>
> Thanks for the pointer.  Indeed there is a bug in that area.
> I'm not sure whether it's causing the problem at hand but it's
> certainly suboptimal.
>
> [TCP]: Fix size calculation in sk_stream_alloc_pskb

This looks like it fixes the problem!

Still interested to know why SLAB didn't see the same thing...


> We round up the header size in sk_stream_alloc_pskb so that
> TSO packets get zero tail room.  Unfortunately this rounding
> up is not coordinated with the select_size() function used by
> TCP to calculate the second parameter of sk_stream_alloc_pskb.
>
> As a result, we may allocate more than a page of data in the
> non-TSO case when exactly one page is desired.
>
> In fact, rounding up the head room is detrimental in the non-TSO
> case because it makes memory that would otherwise be available to
> the payload head room.  TSO doesn't need this either, all it wants
> is the guarantee that there is no tail room.
>
> So this patch fixes this by adjusting the skb_reserve call so that
> exactly the requested amount (which all callers have calculated in
> a precise way) is made available as tail room.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Cheers,
