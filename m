Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbXJ3UVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbXJ3UVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbXJ3UVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:21:05 -0400
Received: from mail.suse.de ([195.135.220.2]:45897 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbXJ3UVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:21:04 -0400
To: "Joerg Roedel" <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, benjamin.serebrin@amd.com,
       vojtech@suse.cz
Subject: Re: Whats the purpose of get_cycles_sync()
From: Andi Kleen <andi@firstfloor.org>
References: <20071030174452.GA18619@amd.com>
Date: Tue, 30 Oct 2007 21:21:02 +0100
In-Reply-To: <20071030174452.GA18619@amd.com> (Joerg Roedel's message of "Tue\, 30 Oct 2007 18\:44\:52 +0100")
Message-ID: <p73sl3s2w29.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Joerg Roedel" <joerg.roedel@amd.com> writes:

> I would like to answer what the special purpose of the get_cycles_sync()
> function is in the x86 architecture. In special I ask myself why
> this function has to be *sync*?

Vojtech had one test that tested time monotonicity over CPUs 
and it constantly failed until we added the CPUID on K8 C stepping. 
He can give details on the test.

I suspect the reason was because the CPU reordered the RDTSCs so that
a later RDTSC could return a value before an earlier one. This can
happen because gettimeofday() is so fast that a tight loop calling it can
fit more than one iteration into the CPU's reordering window.

> I mean, the sync should guarantee here that the CPU does not execute the
> RDTSC instruction out-of-order, thats clear. But does that really
> matter? If there is a cache/tlb miss before the function returns all
> accuracy that should be won by the synchronous RDTSC is lost anyway.
>
> The problem here is, that this function executes CPUID if RDTSC itself
> is not a synchronizing instruction and CPUID is very often intercepted
> by hypervisors (KVM intercepts it for example). This makes this function
> very expensive if the kernel is executed as a guest.

That is why newer kernels use RDTSCP if available which doesn't need
to be intercepted and is synchronous.  And since all AMD SVM systems
have RDTSCP they are fine.

On Intel Core2 without RDTSCP the CPUID can be still intercepted right
now, but the real fix there is to readd FEATURE_SYNC_TSC for Core2 --
the RDTSC there is always monotonic per CPU and the patch that changed
that (f3d73707a1e84f0687a05144b70b660441e999c7) was bogus and must be
reverted. I didn't catch that in time unfortunately.

-Andi
