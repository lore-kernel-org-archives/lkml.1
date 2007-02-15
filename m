Return-Path: <linux-kernel-owner+w=401wt.eu-S1161566AbXBOWeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161566AbXBOWeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161568AbXBOWeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:34:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:5203 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161566AbXBOWeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:34:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OQy6jvL1RGyIes2l6qwhgR+HGZzMvz67+yy+oEwPNCBDDCPhF9Jf9RdiymfPDfEuhxrkOblypqYgehnoPMzxM0VLGMmLxv+WkJocZaJQya+A5DAGzJos+0MeHiFS4vxrwBfLFRH1+T774sPPgdV4TIMLRlm8WzhcuwV3/UIZ8Xo=
Message-ID: <f2b55d220702151434m6aa09827y23d700978fd115a0@mail.gmail.com>
Date: Thu, 15 Feb 2007 14:34:04 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch 05/11] syslets: core code
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Benjamin LaHaise" <bcrl@kvack.org>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0702151159410.20368@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070213142035.GF638@elte.hu> <20070215133550.GA29274@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
	 <20070215163704.GA32609@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
	 <20070215181059.GC20997@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org>
	 <20070215190413.GA23953@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0702151159410.20368@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Would it make the interface less cool? Yeah. Would it limit it to just a
> few linked system calls (to avoid memory allocation issues in the kernel)?
> Yes again. But it would simplify a lot of the interface issues.

Only in toy applications.  Real userspace code that lives between
networks+disks and impatient humans is 80% exception handling,
logging, and diagnostics.  If you can't do any of that between stages
of an async syscall chain, you're fscked when it comes to performance
analysis (the "which 10% of the traffic do we not abort under
pressure" kind, not the "cut overhead by 50%" kind).  Not that real
userspace code could get any simpler by using this facility anyway,
since you can't jump the queue, cancel in bulk, or add cleanup hooks.

Efficiently interleaved execution of high-latency I/O chains would be
nice.  Low overhead for cache hits would be nicer.  But least for the
workloads that interest me, neither is anywhere near as important as
the ability to say, "This 10% (or 90%) of my requests are going to
take forever?  Nevermind -- but don't cancel the 1% I can't do
without."

This is not a scheduling problem, it is a caching problem.  Caches are
data structures, not thread pools.  Assume that you need to design for
dynamic reprioritization, speculative fetch, and opportunistic flush,
even if you don't implement them at first.  Above all, stay out of the
way when a synchronous request misses cache -- and when application
code decides that a bunch of its outstanding requests are no longer
interesting, take the hint!

Oh, and while you're at it: I'd like to program AIO facilities using a
C compiler with an explicitly parallel construct -- something along
the lines of:

try (my_aio_batch, initial_priority, ...) {
} catch {
} finally {
}

Naturally the compiler will know how to convert synchronous syscalls
to their asynchronous equivalent, will use an analogue of IEEE NaNs to
minimize the hits to the exception path, and won't let you call
functions that aren't annotated as safe in IO completion context.  I
would also like five acres in town and a pony.

Cheers,
- Michael
