Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbXGBHGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbXGBHGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 03:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXGBHGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 03:06:39 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:48148 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750765AbXGBHGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 03:06:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=062isb6hQrERX8l9g/Fzl8dq+ubG2i9vUkvbrAAITW7aTweoHoxUMi65NGuATq0xyHusxd6oii0LEtItw8Q5SgAKtaHsKZ+SozKZ7bOzbGDqfd1DX+LuYE4+n+7XCK1rM6aylBL9ITVHg4b22eP6Xm7nZ9sLh0fYDQoIfnFAgzs=  ;
X-YMail-OSG: eDr_DJoVM1kI5pdBCJiOQJOzjVmk08lMQ9_mPMsal8qaxXIq3O2j4xtqNp74A1uxRmVGauQkcw--
Message-ID: <4688A3F7.8040806@yahoo.com.au>
Date: Mon, 02 Jul 2007 17:06:31 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       Miklos Szeredi <miklos@szeredi.hu>, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <4680D162.9050603@yahoo.com.au> <alpine.LFD.0.98.0706261016200.8675@woody.linux-foundation.org> <4681F448.3040201@yahoo.com.au> <alpine.LFD.0.98.0706262249590.8675@woody.linux-foundation.org> <alpine.LFD.0.98.0706271233300.8675@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706271233300.8675@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Nick,
>  call me a worry-wart, but I slept on this, and started worrying..
> 
> On Tue, 26 Jun 2007, Linus Torvalds wrote:
> 
>>So try it with just a byte counter, and test some stupid micro-benchmark 
>>on both a P4 and a Core 2 Duo, and if it's in the noise, maybe we can make 
>>it the normal spinlock sequence just because it isn't noticeably slower.
> 
> 
> So I thought about this a bit more, and I like your sequence counter 
> approach, but it still worried me.
> 
> In the current spinlock code, we have a very simple setup for a 
> successful grab of the spinlock:
> 
> 	CPU#0					CPU#1
...

Yeah, thanks.

> Now, I have good reason to believe that all Intel and AMD CPU's have a 
> stricter-than-documented memory ordering, and that your spinlock may 
> actually work perfectly well. But it still worries me. As far as I can 
> tell, there's a theoretical problem with your spinlock implementation.
> 
> So I'd like you to ask around some CPU people, and get people from both 
> Intel and AMD to sign off on your spinlocks as safe. I suspect you already 
> have the required contacts, but if you don't, I can send things off to the 
> appropriate people at least inside Intel.

Haven't made too much progress on this, but I have asked someone@amd who
might be able to at least know the right person to ask :P (might be faster
to ask Andi to ask :))

If you know someone at Intel then that would be appreciated.

It would be nice if it is safe (and can be guaranteed to be safe in future).

However OTOH, the fastpath may be even faster if we do it in a "definitely
safe" way.

That is, do the xaddw against 16-bits with the head in 8 of those and the
tail in the other 8. Then compare the byte registers of the register
returned by xaddw for the test. Although the xaddw is going to be slower
than an xaddb, this way we subsequently avoid the extra load completely,
while avoiding ordering issues.

In the slowpath we would have to have a token locked op in there (like
the current spinlocks do), but this could be taken out iff our inquiries
come back positive.

Anyway, I'll try redoing the patch and getting some numbers.

-- 
SUSE Labs, Novell Inc.
