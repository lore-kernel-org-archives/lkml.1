Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZBCCFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZBCCFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 21:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZBCCFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 21:05:31 -0500
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:23094 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750977AbZBCCFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 21:05:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CyObur4SbLZxkiWrwpZb76RA9yPty8n93OU2Ld75oGCnyIkAKwlBK3VUz/N9mnSyzZ4+BfJJ6E+ZWBq2ZoEM3WWRVOzjHTVC9T5pBXNLLu75vKK++5tGaXb+1bI4ZtWtdo69+xysSRkg6xpgjf5LfIJtxjklS314pYNC+e0vASo=  ;
X-YMail-OSG: i9o8LGsVM1lBjIb2q3WQLCijJDRIobiKbTHjb0y_RdMpDs5rcfXfoEnbobwK2SaQFtNru3sgZ4at8JOGPcSkZSjMC4ln5S11ZuXnMk21IDpy6Rw6QqsAoviQOrdcURVd5Wbv0fRI4KY5YJ6Z.YS3Tq641A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator (try 2)
Date: Tue, 3 Feb 2009 13:04:58 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <20090123154653.GA14517@wotan.suse.de> <1233047272.4984.12.camel@laptop> <alpine.DEB.1.10.0901271509170.3114@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0901271509170.3114@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031304.59592.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2009 07:21:58 Christoph Lameter wrote:
> On Tue, 27 Jan 2009, Peter Zijlstra wrote:
> > > Well there is the problem in SLAB and SLQB that they *continue* to do
> > > processing after an allocation. They defer queue cleaning. So your
> > > latency critical paths are interrupted by the deferred queue
> > > processing.
> >
> > No they're not -- well, only if you let them that is, and then its your
> > own fault.
>
> So you can have priority over kernel threads.... Sounds very dangerous.

Groan.


> > Like Nick has been asking, can you give a solid test case that
> > demonstrates this issue?
>
> Run a loop reading tsc and see the variances?
>
> In HPC apps a series of processors have to sync repeatedly in order to
> complete operations. An event like cache cleaning can cause a disturbance
> in one processor that delays this sync in the system as a whole. And
> having it run at offsets separately on all processor causes the
> disturbance to happen on one processor after another. In extreme cases all
> syncs are delayed. We have seen this effect have a major delay on HPC app
> performance.

Now we are starting to get somewhere slightly useful. Can we have more
details about this workload please? Was there a test program coded up
to run the same sequence of MPI operations? Or can they at least be
described?


> Note that SLAB scans through all slab caches in the system and expires
> queues that are active. The more slab caches there are and the more data
> is in queues the longer the process takes.

And the larger the number of nodes and CPUs, because SLAB can have so
many queues. This is not an issue with SLQB, so I don't think it will
be subject to the same magnitude of problem on your large machines.

Periodic cleaning in SLAB was never shown to be a problem with large
HPC clusters in the past, so that points to SGI's problem as being due
to explosion of queues in big machines rather than the whole concept
of periodic cleaning.

And we have lots of periodic things going on. Periodic journal flushing,
periodic dirty watermark checking, periodic timers, multiprocessor CPU
scheduler balancing etc etc. So no, I totally reject the assertion that
periodic slab cleaning is a showstopper. Without actual numbers or test
cases, I don't need to hear any more assertions in this vein.

(But note, numbers and/or test cases etc would be very very welcome
because I would like to tune SLQB performance on HPC as much as possible
and as I have already said, there are ways we can improve or mitigate
periodic trimming overheads).


> > I'm thinking getting git of those cross-bar queues hugely reduces that
> > problem.
>
> The cross-bar queues are a significant problem because they mean operation
> on objects that are relatively far away. So the time spend in cache
> cleaning increases significantly. But as far as I can see SLQB also has
> cross-bar queues like SLAB.

Well it doesn't.


> SLUB does all necessary actions during the
> actual allocation or free so there is no need to run cache cleaning.

And SLUB can actually leave free pages lying around that never get cleaned
up because of this. As I said, I have seen SLQB use less memory than SLUB
in some situations I assume because of this (although now that I think
about it, perhaps it was due to increased internal fragmentation in bigger
pages).

