Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbZBXRva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbZBXRva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZBXRvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:51:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57362 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbZBXRvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:51:21 -0500
Date: Tue, 24 Feb 2009 18:50:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: Another Performance Regression in write() syscall
Message-ID: <20090224175055.GA14534@elte.hu>
References: <20090224060558.GA14812@google.com> <1235456745.26788.237.camel@nimitz> <200902241947.53180.nickpiggin@yahoo.com.au> <1235494732.26788.256.camel@nimitz> <alpine.LFD.2.00.0902240924490.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902240924490.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 24 Feb 2009, Dave Hansen wrote:
> > 
> > Yeah, that's a good point.  Are we sure that's what is 
> > happening here, though?  That's one thing a profile would 
> > hopefully help with.
> 
> One thing to note is that _if_ it's purely an issue of 
> nontemporal stores vs normal stores, then profiling is very 
> likely going to be almost entirely useless. You'll get 
> "results", but the results have nothing what-so-ever to do 
> with reality or anything interesting.
> 
> The nontemporal stores may stand out in the profiles, but the 
> actual performance impact will be all about whether totally 
> unrelated code got cache misses or not. Quite often those 
> cache misses will also be in user mode, and very possibly in 
> other processes.
> 
> So profiles can certainly be interesting, but if Salman says 
> that his patch makes a difference for his benchmark, then 
> profiling is almost certainly not interesting FOR THAT PATCH. 
> It's interesting mainly as a way to look at whether there are 
> then also _other_ issues that are worth addressing (ie the 
> whole atime thing is in a whole different dimension and an 
> independent issue).

a 'perfstat' run would certainly be interesting (for cases where 
a pure /usr/bin/time run is inconclusive), comparing the 
unpatched and patched kernel.

That way we can see summary counts for the whole workload, like:

 -----------------------------------------------
 | Performance counter stats for './mmap-perf' |
 -----------------------------------------------
 |                |
 |  x86-defconfig |   PARAVIRT=y
 |------------------------------------------------------------------
 |
 |    1311.554526 |  1360.624932  task clock ticks (msecs)    +3.74%
 |                |
 |              1 |            1  CPU migrations
 |             91 |           79  context switches
 |          55945 |        55943  pagefaults
 |    ............................................
 |     3781392474 |   3918777174  CPU cycles                  +3.63%
 |     1957153827 |   2161280486  instructions               +10.43%
 |       50234816 |     51303520  cache references            +2.12%
 |        5428258 |      5583728  cache misses                +2.86%
 |
 |      437983499 |    478967061  branches                    +9.36%
 |       32486067 |     32336874  branch-misses               -0.46%
 |                |
 |    1314.782469 |  1363.694447  time elapsed (msecs)        +3.72%
 |                |
 -----------------------------------

Such a comparison of would certainly be more meaningful for such 
things than a profile.

Salman, if you are interested in doing a perfstat comparison, 
just pick up a tip:master kernel [perfcounters are 
default-enabled in it]:

   http://people.redhat.com/mingo/tip.git/README

and run perfstat on it (as root, to get the kernel-mode counts 
too):

   http://redhat.com/~mingo/perfcounters/perfstat.c

	Ingo
