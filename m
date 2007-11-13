Return-Path: <linux-kernel-owner+w=401wt.eu-S1764312AbXKNGRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764312AbXKNGRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760488AbXKNGQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:16:51 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:30700 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750727AbXKNGQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:16:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yeMeHbBlSBVPtBgwxhGld8M6Uyg2K/e7KUjQjyM9C3ROgLJgXuJ6L82Of1N9lbDWDB0EyDn8yT4gxAW6LGuO9jGflr39huak4jeE7tLleb3F09pm/K+xHMGtZ0p7uPN2xm1ybB/PmLzpDIvLyGt4SpK8wMFe1N8ySb+eu2mYAqU=  ;
X-YMail-OSG: CK4n.3AVM1k80puSAQ.owsJvAg9pvTfY6SWwObdFbWfTfi0EfBZ9FBG3Ro.pnie0HsNKreon6A--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression with tbench
Date: Wed, 14 Nov 2007 05:14:27 +1100
User-Agent: KMail/1.9.5
Cc: clameter@sgi.com, netdev@vger.kernel.org, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
References: <200711132241.59074.nickpiggin@yahoo.com.au> <200711140436.24492.nickpiggin@yahoo.com.au> <20071113.221242.153352652.davem@davemloft.net>
In-Reply-To: <20071113.221242.153352652.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711140514.28159.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 17:12, David Miller wrote:
> From: Nick Piggin <nickpiggin@yahoo.com.au>
> Date: Wed, 14 Nov 2007 04:36:24 +1100
>
> > On Wednesday 14 November 2007 12:58, David Miller wrote:
> > > I suspect the issue is about having a huge skb->data linear area for
> > > TCP sends over loopback.  We're likely getting a much smaller
> > > skb->data linear data area after the patch in question, the rest using
> > > the sk_buff scatterlist pages which are a little bit more expensive to
> > > process.
> >
> > It didn't seem to be noticeable at 1 client. Unless scatterlist
> > processing is going to cause cacheline bouncing, I don't see why this
> > hurts more as you add CPUs?
>
> Is your test system using HIGHMEM?
>
> That's one thing the page vector in the sk_buff can do a lot,
> kmaps.

No, it's an x86-64, so no highmem.

What's also interesting is that SLAB apparently doesn't have this
condition. The first thing that sprung to mind is that SLAB caches
order > 0 allocations, while SLUB does not. However if anything,
that should actually favour the SLUB numbers if network is avoiding
order > 0 allocations.

I'm doing some oprofile runs now to see if I can get any more info.
