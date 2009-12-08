Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZLHMXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZLHMXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZLHMXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:23:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:54797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbZLHMXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:23:05 -0500
Message-ID: <4B1E4548.5040408@kernel.org>
Date: Tue, 08 Dec 2009 21:23:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-5-git-send-email-tj@kernel.org>	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>	 <1260262963.3935.1002.camel@laptop>  <4B1E189B.1070204@kernel.org>	 <1260268453.3935.1106.camel@laptop>  <4B1E378A.5050101@kernel.org>	 <1260272885.3935.1189.camel@laptop>  <4B1E3EE0.7030001@kernel.org> <1260274232.3935.1223.camel@laptop>
In-Reply-To: <1260274232.3935.1223.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2009 09:10 PM, Peter Zijlstra wrote:
> Hotplug and deterministic are not to be used in the same sentence, its
> an utter slow path and I'd much rather have simple code than clever code
> there -- there's been way too many 'interesting' hotplug problems.

Slow and indeterminism comes in different magnitudes.

> If there is work being enqueued that takes more than a few seconds to
> complete then I'm thinking there's something seriously wrong and up to
> that point its perfectly fine to simply wait for it.
> 
> Furthermore if it's objective is to cater to generic thread pools then I
> think its an utter fail simply because it mandates strict cpu affinity,
> that basically requires you to write a work scheduler to balance work
> load etc.. Much easier is a simple unbounded thread pool that gets
> balanced by the regular scheduler.

The observation was that for most long running async jobs, most time
is spent sleeping instead of burning cpu cycles and long running ones
are relatively few compared to short ones so the strict affinity would
be more helpful.  That is the basis of whole design and why it has
scheduler callbacks to regulate concurrency instead of creating a
bunch of active workers and letting the scheduler take care of it.
Works wouldn't be competing for cpu cycles.

In short, the target workload is the current short works + long
running mostly sleeping async works, which cover most of worker pools
we have in kernel.  I thought about adding an unbound pool of workers
for cpu intensive works for completeness but I really couldn't find
much use for that.  If enough number of users would need something
like that, we can add an anonymous pool but for now I really don't see
the need to worry about that.

Thanks.

-- 
tejun
