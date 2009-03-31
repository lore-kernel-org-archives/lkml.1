Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbZCaCRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbZCaCRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbZCaCQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:16:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:42830 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbZCaCQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:16:45 -0400
Message-ID: <49D17C6A.5050603@kernel.org>
Date: Tue, 31 Mar 2009 11:14:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       david@fromorbit.com
Subject: Re: [PATCH 2/7] ext3: call blkdev_issue_flush() on fsync()
References: <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B70E.8060506@oss.ntt.co.jp> <20090330140427.GG13356@mit.edu> <1238422551.30488.47.camel@think.oraclecorp.com> <20090330143343.GJ13356@mit.edu> <49D17162.1090207@kernel.org> <20090331015850.GY13356@mit.edu>
In-Reply-To: <20090331015850.GY13356@mit.edu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 31 Mar 2009 02:13:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Theodore Tso wrote:
> On Tue, Mar 31, 2009 at 10:26:58AM +0900, Tejun Heo wrote:
>> How about having something like blk_ensure_cache_flushed() which
>> issues flush iff there hasn't been any write since the last flush?
>> It'll be easy to implement and will filter out duplicate flushes in
>> most cases.
> 
> I thought about such a thing, but my concern is that while this might
> suppress most unnecessary double flushes, some intervening write from
> another process might slip in which doesn't need to be flushed out.
> In other words "in most cases" means that "in some cases" we will take
> a performance hit thanks to the duplicate flushes.  So this isn't
> something we should depend upon, although if we do detect back-to-back
> flushes, obviously we should filter them out.

Yeah, well, it all comes down to how most the "most" is.  If all
that's between the first flush and the second one are some code the
cpu has to eat through, I don't think there's high chance of an IO
going inbetween unless the IO was already there and gets scheduled
inbetween (which can be avoided).

The thing is that detecting dup is possible but missing is not.  If
flush is missing in certain corner paths, nobody would know till
somebody reviews the code.  Even when the problem triggers, it would
be rare and obscure enough to avoid proper diagnosis, so I think if
the "most" is most enough, it could be the better way to do it.  But,
then again, I'm not a FS guy, so if such thing can be guaranteed in
FSes without too much problem, no need to pull such a stunt at the
block layer.

> So if we did something like this, it would be good if we had a
> debugging option which would detect double flushes, and printk a
> warning identifying where the call sites first and second flushes (by
> function name and line number), so that filesystem developers could
> detect the double flushes, and work to eliminate them.
> 
> Does that make sense?

Yeap, that definitely sounds like a good idea.  I'll put it on my todo
list.

Thanks.

-- 
tejun
