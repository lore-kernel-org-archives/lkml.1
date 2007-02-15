Return-Path: <linux-kernel-owner+w=401wt.eu-S1751510AbXBOBci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbXBOBci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 20:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbXBOBci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 20:32:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:36069 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbXBOBch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 20:32:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NgJetbh113pTrep3w9L0cIm3QpDExyaWIR9hqgkb3XYz4/QqQzZf7Ldv+5VgyH3K7twxf7ewepi3BxN3vQ16OH8cYt0DXxsMmZHuemRqClJF11u/FCxV2LWadniE842IOZAmA0zapYyUtTTNLp2PG85CDFyrC/yKcTP3+VBXSHo=
Message-ID: <f2b55d220702141732k642f17ccnc2256e54383e713@mail.gmail.com>
Date: Wed, 14 Feb 2007 17:32:33 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Benjamin LaHaise" <bcrl@kvack.org>
Subject: Re: [patch 06/11] syslets: core, documentation
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070214214409.GM32271@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070214103655.GB4241@flint.arm.linux.org.uk>
	 <20070214110419.GC4241@flint.arm.linux.org.uk>
	 <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com>
	 <20070214180344.GI32271@kvack.org>
	 <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com>
	 <20070214200347.GK32271@kvack.org>
	 <Pine.LNX.4.64.0702141206190.7796@alien.or.mcafeemobile.com>
	 <20070214203438.GL32271@kvack.org>
	 <Pine.LNX.4.64.0702141241030.7796@alien.or.mcafeemobile.com>
	 <20070214214409.GM32271@kvack.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/07, Benjamin LaHaise <bcrl@kvack.org> wrote:
> My opinion of this whole thread is that it implies that our thread creation
> and/or context switch is too slow.  If that is the case, improve those
> elements first.  At least some of those optimizations have to be done in
> hardware on x86, while on other platforms are probably unnecessary.

Not necessarily too slow, but too opaque in terms of system-wide
impact and global flow control.  Here are the four practical use cases
that I have seen come up in this discussion:

1) Databases that want to parallelize I/O storms, with an emphasis on
getting results that are already cache-hot immediately (not least so
they don't get evicted by other I/O results); there is also room to
push some of the I/O clustering and sequencing logic down into the
kernel.

2) Static-content-intensive network servers, with an emphasis on
servicing those requests that can be serviced promptly (to avoid a
ballooning connection backlog) and avoiding duplication of I/O effort
when many clients suddenly want the same cold content; the real win
may be in "smart prefetch" initiated from outside the network server
proper.

3) Network information gathering GUIs, which want to harvest as much
information as possible for immediate display and then switch to an
event-based delivery mechanism for tardy responses; these need
throttling of concurrent requests (ideally, in-kernel traffic shaping
by request group and destination class) and efficient cancellation of
no-longer-interesting requests.

4) Document search facilities, which need all of the above (big
surprise there) as well as a rich diagnostic toolset, including a
practical snooping and profiling facility to guide tuning for
application responsiveness.

Even if threads were so cheap that you could just fire off one per I/O
request, they're a poor solution to the host of flow control issues
raised in these use cases.  A sequential thread of execution per I/O
request may be the friendliest mental model for the individual delayed
I/Os, but the global traffic shaping and scheduling is a data
structure problem.

The right question to be asking is, what are the operations that need
to be supported on the system-wide pool of pending AIOs, and on what
data structure can they be implemented efficiently?  For instance, can
we provide an RCU priority queue implementation (perhaps based on
splay trees) so that userspace can scan a coherent read-only snapshot
of the structure and select candidates for cancellation, etc., without
interfering with kernel completions?  Or is it more important to have
a three-sided query operation (characteristic of priority search
trees), or perhaps a lower amortized cost bulk delete?

Once you've thought through the data structure manipulation, you'll
know what AIO submission / cancellation / reprioritization interfaces
are practical.  Then you can work on a programming model for
application-level "I/O completions" that is library-friendly and
allows a "fast path" optimization for the fraction of requests that
can be served synchronously.  Then and only then does it make sense to
code-bum the asynchronous path.  Not that it isn't interesting to
think in advance about what stack space completions will run in and
which bits of the task struct needn't be in a coherent condition; but
that's probably not going to guide you to the design that meets the
application needs.

I know I'm teaching my grandmother to suck eggs here.  But there are
application programmers high up the code stack whose code makes
implicit use of asynchronous I/O continuations.  In addition to the
GUI example I blathered about a few days ago, I have in mind Narrative
Javascript's "blocking operator" and Twisted Python's Deferred.  Those
folks would be well served by an async I/O interface to the kernel
which mates well to their language's closure/continuation facilities.
If it's usable from C, that's nice too.  :-)

Cheers,
- Michael
