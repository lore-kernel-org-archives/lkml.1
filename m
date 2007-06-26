Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbXFZInN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbXFZInN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXFZIm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:42:59 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:47023 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751045AbXFZIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:42:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=PcHQ1kmGqAbnlhefz/m75DQAFlKoPigzJR5lWXRTbA3kuI1Pqw5LboqKhv1Utuhq3vvLEHB8dria5cJOgrxq45mVBSGJSw8Pj2dLT477RAfrQhh4W28TDpHyW2IPqW+QOZJLBjju+tA94+5OBeNAdPNc8r2WbxWi49c305R2p5Y=  ;
X-YMail-OSG: WweqwvkVM1lpkp28D5lAZzjzf3d7E5x0pGKuLbQvji2q8kYtiynCS5xUCT0JS31V2dyCQYK7CA--
Message-ID: <4680D162.9050603@yahoo.com.au>
Date: Tue, 26 Jun 2007 18:42:10 +1000
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
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 21 Jun 2007, Eric Dumazet wrote:
> 
>>This reminds me Nick's proposal of 'queued spinlocks' 3 months ago
>>
>>Maybe this should be re-considered ? (unlock is still a non atomic op, 
>>so we dont pay the serializing cost twice)
> 
> 
> No. The point is simple:
> 
> 	IF YOU NEED THIS, YOU ARE DOING SOMETHING WRONG!
> 
> I don't understand why this is even controversial. Especially since we 
> have a patch for the problem that proves my point: the _proper_ way to fix 
> things is to just not do the bad thing, instead of trying to allow the bad 
> behaviour and try to handle it.
> 
> Things like queued spinlocks just make excuses for bad code. 
> 
> We don't do nesting locking either, for exactly the same reason. Are 
> nesting locks "easier"? Absolutely. They are also almost always a sign of 
> a *bug*. So making spinlocks and/or mutexes nest by default is just a way 
> to encourage bad programming!

Hmm, not that I have a strong opinion one way or the other, but I
don't know that they would encourage bad code. They are not going to
reduce latency under a locked section, but will improve determinism
in the contended case.

They should also improve performance in heavily contended case due to
the nature of how they spin, but I know that's not something you want
to hear about. And theoretically there should be no reason why xadd is
any slower than dec and look at the status flags, should there? I never
implementedit in optimised assembly to test though...

Some hardware seems to have no idea of fair cacheline scheduling, and
especially when there are more than 2 CPUs contending for the
cacheline, there can be large starvations.

And actually some times we have code that really wants to drop the
lock and queue behind other contenders. Most of the lockbreak stuff
for example.

Suppose we could have a completely fair spinlock primitive that has
*virtually* no downsides over the unfair version, you'd take the fair
one, right?

Not that I'm saying they'd ever be a good solution to bad code, but I
do think fairness is better than none, all else being equal.


>>extract : 
>>
>>Implement queued spinlocks for i386. This shouldn't increase the size of
>>the spinlock structure, while still able to handle 2^16 CPUs.
> 
> 
> Umm. i386 spinlocks could and should be *one*byte*.
> 
> In fact, I don't even know why they are wasting four bytes right now: the 
> fact that somebody made them an "int" just wastes memory. All the actual 
> code uses "decb", so it's not even a question of safety. I wonder why we 
> have that 32-bit thing and the ugly casts.

Anyway, I think the important point is that they can remain within 4
bytes, which is obviously the most important boundary (they could be
2 bytes on i386).

-- 
SUSE Labs, Novell Inc.
