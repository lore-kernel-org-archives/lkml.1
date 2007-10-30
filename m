Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbXJ3WCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbXJ3WCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXJ3WCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:02:34 -0400
Received: from styx.suse.cz ([82.119.242.94]:37126 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751878AbXJ3WCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:02:33 -0400
Date: Tue, 30 Oct 2007 23:02:09 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, benjamin.serebrin@amd.com
Subject: Re: Whats the purpose of get_cycles_sync()
Message-ID: <20071030220209.GA21142@suse.cz>
References: <20071030174452.GA18619@amd.com> <p73sl3s2w29.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73sl3s2w29.fsf@bingen.suse.de>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 09:21:02PM +0100, Andi Kleen wrote:
> "Joerg Roedel" <joerg.roedel@amd.com> writes:
> 
> > I would like to answer what the special purpose of the get_cycles_sync()
> > function is in the x86 architecture. In special I ask myself why
> > this function has to be *sync*?
> 
> Vojtech had one test that tested time monotonicity over CPUs 
> and it constantly failed until we added the CPUID on K8 C stepping. 
> He can give details on the test.
> 
> I suspect the reason was because the CPU reordered the RDTSCs so that
> a later RDTSC could return a value before an earlier one. This can
> happen because gettimeofday() is so fast that a tight loop calling it can
> fit more than one iteration into the CPU's reordering window.

The K8's still guarantee that subsequent RDTSCs return increasing
values, even if the processor reorders them.

What could have been happening then was that the RDTSC instruction might
have been reordered by the CPU out of the seqlock, causing trouble in
the calculation.

Anyway, adding the CPUID didn't solve all the problems we've seen back
then, and so far none of the approaches for using TSC without acquiring
a spinlock on multi-socket AMD boxes worked 100% correctly.

> That is why newer kernels use RDTSCP if available which doesn't need
> to be intercepted and is synchronous.  And since all AMD SVM systems
> have RDTSCP they are fine.
> 
> On Intel Core2 without RDTSCP the CPUID can be still intercepted right
> now, but the real fix there is to readd FEATURE_SYNC_TSC for Core2 --
> the RDTSC there is always monotonic per CPU and the patch that changed
> that (f3d73707a1e84f0687a05144b70b660441e999c7) was bogus and must be
> reverted. I didn't catch that in time unfortunately.

-- 
Vojtech Pavlik
Director SuSE Labs
