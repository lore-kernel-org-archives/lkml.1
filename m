Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbXE3V3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbXE3V3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbXE3V3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:29:15 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409AbXE3V3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:29:14 -0400
Date: Wed, 30 May 2007 14:27:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
In-Reply-To: <465DE992.6070803@redhat.com>
Message-ID: <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
 <465DE992.6070803@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Ulrich Drepper wrote:
> 
> I don't like special cases.  For me things better come in quantities 0,
> 1, and unlimited (well, reasonable high limit).  Otherwise, who gets to
> use that special namespace?  The C library is not the only body of code
> which would want to use descriptors.

Well, don't think of it as a special case at all: think of bit 30 as a 
"the user asked for a non-linear fd".

In fact, to make it effective, I'd suggest literally scrambling the low 
bits (using, for example, some silly per-boot xor value to to actually 
generate the "true" index - the equivalent of a really stupid randomizer). 

That way you'd have the legacy "linear" space, and a separate "non-linear 
space" where people simply *cannot* make assumptions about contiguous fd 
allocations. There's no special case there - it's just an extension which 
explicitly allows us to say "if you do that, your fd's won't be allocated 
the traditional way any more, but you *can* mix the traditional and the 
non-linear allocation".

> And then the semantics: do these descriptors should show up in
> /proc/self/fd?  Are there separate directories for each namespace?  Do
> they count against the rlimit?

Oh, absolutely. The'd be real fd's in every way. People could use them 
100% equivalently (and concurrently) with the traditional ones. The whole, 
and the _only_ point, would be that it breaks the legacy guarantees of a 
dense fd space.

Most apps don't actually *need* that dense fd space in any case. But by 
defaulting to it, we wouldn't break those (few) apps that actually depend 
on it.

		Linus
