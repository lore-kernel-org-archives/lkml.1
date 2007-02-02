Return-Path: <linux-kernel-owner+w=401wt.eu-S1946143AbXBBWtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946143AbXBBWtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 17:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946144AbXBBWtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 17:49:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946143AbXBBWtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 17:49:31 -0500
Date: Fri, 2 Feb 2007 23:42:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070202224259.GB1212@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202195932.15b9b4ed@localhost.localdomain> <Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org> <20070202213019.202e8db5@localhost.localdomain> <Pine.LNX.4.64.0702021322310.15057@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702021322310.15057@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> With cooperative scheduling (like the example Zach posted), there is 
> absolutely no "brown and sticky" wrt any CPU usage. Which is why 
> cooperative scheduling is a *good* thing. If you want to blow up your 
> 1024-node CPU cluster, you'd to it with "real threads".

i'm not worried about the 1024-node cluster case.

i also fully agree that in some cases /not/ going parallel and having a 
cooperative relationship between execution contexts can be good.

but if the application /has/ identified fundamental parallelism, we 
/must not/ shut that parallelism off by /designing/ this interface to 
use the fibril thing which is a limited cooperative, single-CPU entity. 
I cannot over-emphasise it how wrong that feels to me. Cooperativeness 
isnt bad, but it should be an /optional/ thing, not hardcoded into the 
design!

If the application tells us: "gee, you can execute this syscall in 
parallel!" (which AIO /is/ about after all), and if we have idle 
cores/hardware-threads nearby, it would be the worst thing to not 
execute that in parallel if the syscall blocks or if the app asks for 
that syscall to be executed in parallel right away, even in the cached 
case.

if we were in the 1.2 days i might agree that fibrils are perhaps easier 
on the kernel, but today the Linux kernel doesnt even use this 
cooperativeness anywhere. We have all the hard work done already. The 
full kernel is threaded. We can execute arbitrary number of kernel 
contexts off a single user context, we can execute parallel syscalls and 
we scale very well doing so.

all that is needed is this new facility and some scheduler hacking to 
enable "transparent, kernel-side threading". That enables AIO, 
coroutines and more. It brings threading to a whole new level, because 
it makes it readily and gradually accessible to single-threaded apps 
too.

[ and if we are worried about the 1024 CPU cluster (or about memory use) 
  then we could limit such threads to only overlap in a limited number, 
  etc. Just like we'd have to do with fibrils anyway. But with fibrils 
  we /force/ single-threadedness, which, i'm quite sure, is just about 
  the worst thing we can do. ]

	Ingo
