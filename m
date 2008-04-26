Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbYDZQ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbYDZQ3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYDZQ3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:29:48 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:49107 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754504AbYDZQ3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:29:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oLZauIEV50U8pnRtGURtQNEZfga4u3wiMcwnN4m7vsVQPJM2PnyMvM8FppVeo/bzJmbehQE/Zosq4jKPPpEpHuGODkEUPKRjKtKH1WR1MLv+zjq+dBD09RR3j9eJvFLYs6At9lXUbJY9ZA0ko5RcNM9s/aC3wNm1oBGK5Jr4lo4=  ;
X-YMail-OSG: xBi7gxkVM1kMj.r2Ez3BxhYJ.VkptBqMvrxJXqVWEyQCZElxu3_n3uueBzUy5KxXKqQy5YZzfZlANxEV2w7MYsTesjJCaJ7JK3JHnGHB0ojlsFiFv5NwaEsCC8F0flCN2Y0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dmitry <dbaryshkov@gmail.com>
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Date: Sat, 26 Apr 2008 09:29:44 -0700
User-Agent: KMail/1.9.6
Cc: "Paul Walmsley" <paul@pwsan.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>, tony@atomide.com, hiroshi.DOYU@nokia.com
References: <20080420082925.GA32739@doriath.ww600.siemens.net> <200804251546.52495.david-b@pacbell.net> <bc64b4640804260138v29fada38m55f3e4c053aa1a41@mail.gmail.com>
In-Reply-To: <bc64b4640804260138v29fada38m55f3e4c053aa1a41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804260929.44928.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 April 2008, Dmitry wrote:
> > > Also once we get to multiple chips providers/users, we'll see,
> > > that the clock simply can't have just one record in the clocks tree.
> >
> >  I don't follow.  Why not?  If a clock has multiple records, I'd
> >  expect its refcounts would easily get borked.  I think I don't
> >  like your notion of a "wrapper clock".
> 
> It seems, I failed to describe it correctly.
> Let's suppose this situation:
> We have CLK, that is connected to the pin CK1 of the device dev_A and to the pin
> CK36M of the device dev_B.
> 
> The we'll have these clocks:
> .CLK count=0
> \- CK1 count=0 for dev_A
> \- CK36M count=0 for dev_B

But that's incorrect.  What we have is

  CLK users=0
    aliased as CK1 for dev_A
    aliased as CK36M for dev_b

The difference being that you are showing that CK1 and CK36M have
independent clock gates ... which are not actually present.

The difference between this and the at91_clk_associate() example
is that with clk_associate(), there is only one alias per clock.
There are cases where multiple aliases would be better ... TCB
modules, the "system" clock, and so on.


> When device dev_A enables it's clock,
> we'll have this:
> .CLK count=1
> \- CK1 count=1 for dev_A
> \- CK36M count=0 for dev_B

No, we have

  CLK users=1
    ... same aliases


> After that dev_B enables it's clock:
> .CLK count=2
> \- CK1 count=1 for dev_A
> \- CK36M count=1 for dev_B

Should be

  CLK users=2
    ... same aliases


> So refcounting is correct.

No.  When someone's looking at the clock tree to see what clocks
are active, and thus deduce which silicon is incurring switching
costs, these "wrapper clocks" are not telling the correct story.

- Dave



