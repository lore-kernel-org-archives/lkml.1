Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbZKSD4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbZKSD4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 22:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbZKSD4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 22:56:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45817 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbZKSD4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 22:56:50 -0500
Date: Thu, 19 Nov 2009 04:56:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Beulich <JBeulich@novell.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line size
 config options
Message-ID: <20091119035640.GA18236@elte.hu>
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com>
 <20091116041407.GB5818@wotan.suse.de>
 <4B011677020000780001FD9D@vpn.id2.novell.com>
 <20091116105657.GE5818@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116105657.GE5818@wotan.suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> The only other use for L1 cache size macro is to pack objects to 
> cachelines better (so they always use the fewest number of lines). But 
> this case is more rare nowadays people don't really count cachelines 
> anymore, but I think even then it makes sense for it to be the largest 
> line size in the system because we don't know how big L1s are, and if 
> you want opimal L1 packing, you likely also want optimal Ln packing.

We could do that - but then this default of X86_INTERNODE_CACHE_SHIFT:

+       default "7" if NUMA

will bite us and turns the 64 bytes L1_CACHE_BYTES into an effective 128 
bytes value.

So ... are you arguing for an increase of the default x86 linesize to 
128 bytes?

If yes then i'm not 100% against it, but we need more data and a careful 
analysis of the bloat effect: a vmlinux comparizon plus an estimation of 
any dynamic bloat effects on this in a representative bootup with an 
enterprise distro config. (SLAB uses the dynamic cacheline size value so 
it's not affected - but there are some other runtime dependencies on 
these kconfig values in the kernel.)

Furthermore, if we do it (double the default line size on x86), then we 
in essence will standardize almost everything on 
X86_INTERNODE_CACHE_SHIFT and CACHE_BYTES loses much of its meaning. If 
we do then we need a vSMP measurement of the effects of this (and an Ack 
from the vSMP folks) - it might work - or it might not.

If that all works out fine (which is a big if) then we can also 
eliminate INTERNODE_CACHE_SHIFT and just have a single 
CACHE_SHIFT/CACHE_BYTES arch tunable.

In any case i will apply Jan's current patch as it certainly is a step 
forward that corrects a few inconsistencies and streamlines the status 
quo. We can then do another patch to change the status quo.

Thanks,

	Ingo
