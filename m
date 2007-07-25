Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbXGYUTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbXGYUTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbXGYUTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:19:13 -0400
Received: from [212.12.190.190] ([212.12.190.190]:33080 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751999AbXGYUTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:19:12 -0400
From: Al Boldi <a1426z@gawab.com>
To: "Ray Lee" <ray-lk@madrabbit.org>, "david@lang.hm" <david@lang.hm>
Subject: Re: -mm merge plans for 2.6.23
Date: Wed, 25 Jul 2007 23:16:01 +0300
User-Agent: KMail/1.5
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "ck list" <ck@vds.kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Jackson" <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <Pine.LNX.4.64.0707242130470.2229@asgard.lang.hm> <2c0942db0707250855v414cd72di1e859da423fa6a3a@mail.gmail.com>
In-Reply-To: <2c0942db0707250855v414cd72di1e859da423fa6a3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707252316.01021.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On 7/24/07, david@lang.hm <david@lang.hm> wrote:
> > by the way, I've also seen comments on the Postgres performance mailing
> > list about how slow linux is compared to other OS's in pulling data back
> > in that's been pushed out to swap (not a factor on dedicated database
> > machines, but a big factor on multi-purpose machines)
>
> Yeah, akpm and... one of the usual suspects, had mentioned something
> such as 2.6 is half the speed of 2.4 for swapin. (Let's see if I can
> find a reference for that, it's been a year or more...) Okay,
> misremembered. Swap in is half the speed of swap out (
> http://lkml.org/lkml/2007/1/22/173 ). Al Boldi (added to the CC:, poor
> sod), is the one who knows how to measure that, I'm guessing.
>
> Al? How are you coming up with those figures? I'm interested in
> reproducing it. It could be due to something stupid, such as the VM
> faulting things out in reverse order or something...

Thanks for asking.  I'm rather surprised why nobody's noticing any of this 
slowdown.  To be fair, it's not really a regression, on the contrary, 2.4 is 
lot worse wrt swapin and swapout, and Rik van Riel even considers a 50% 
swapin slowdown wrt swapout something like better than expected (see thread 
'[RFC] kswapd: Kernel Swapper performance').  He probably meant random 
swapin, which seems to offer a 4x slowdown.

There are two ways to reproduce this:

1. swsusp to disk reports ~44mb/s swapout, and ~25mb/s swapin during resume

2. tmpfs swapout is superfast, whereas swapin is really slow
(see thread '[PATCH] free swap space when (re)activating page')

Here is an excerpt from that thread (note machine config in first line):

============================================
 RAM 512mb , SWAP 1G
 #mount -t tmpfs -o size=1G none /dev/shm
 #time cat /dev/full > /dev/shm/x.dmp
 15sec
 #time cat /dev/shm/x.dmp > /dev/null
 58sec
 #time cat /dev/shm/x.dmp > /dev/null
 72sec
 #time cat /dev/shm/x.dmp > /dev/null
 85sec
 #time cat /dev/shm/x.dmp > /dev/null
 93sec
 #time cat /dev/shm/x.dmp > /dev/null
 99sec
============================================

As you can see, swapout is running full wirespeed, whereas swapin not only is 
4x slower, but increasingly gets the VM tangled up to end at a ~6x slowdown.

So again, I'm really surprised people haven't noticed.


Thanks!

--
Al

