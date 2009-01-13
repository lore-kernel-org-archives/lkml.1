Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbZAMABh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbZAMABh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 19:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZAMAB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 19:01:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41103 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbZAMAB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 19:01:28 -0500
Date: Tue, 13 Jan 2009 01:01:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, andi@firstfloor.org,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090113000112.GA10368@elte.hu>
References: <20090112213539.GA10720@gambetta> <496BCA21.2010709@sgi.com> <20090112235156.GC10720@gambetta> <496BD8FB.1050101@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496BD8FB.1050101@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Frederik Deweerdt wrote:
> > On Mon, Jan 12, 2009 at 02:54:25PM -0800, Mike Travis wrote:
> >> Frederik Deweerdt wrote:
> >>> Hi,
> >>>
> >>> On x86_64 flush tlb data is stored in per_cpu variables. This is
> >>> unnecessary because only the first NUM_INVALIDATE_TLB_VECTORS entries
> >>> are accessed.
> >>> This patch aims at making the code less confusing (there's nothing
> >>> really "per_cpu") by using a plain array. It also would save some memory
> >>> on most distros out there (Ubuntu x86_64 has NR_CPUS=64 by default).
> >>>
> >>> Regards,
> >>> Frederik
> >>>
> >>> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
> >> Here is the net change in memory usage with this patch on a allyesconfig
> >> with NR_CPUS=4096.
> 
> > Yes, this point wrt. memory was based on my flawed understanding of how
> > per_cpu actually allocates the data. There is however 1) a confusing use
> > of per_cpu removed, 2) faster access to the flush data.
> 
> Is this true?  On a widely separated NUMA system, requiring all CPU's to 
> access memory on NODE 0 for every tlb flush would seem expensive.  
> That's another benefit of per_cpu data, it's local to the node's cpus.

That's irrelevant here: we only have 8 IPI slots for the TLB flush, so 
we'll use the first 8 per_cpu areas (note how all access is cpu-nr modulo 
8 in essence). That is going to be node 0 anyway in most NUMA setups.

> (And was it determined yet, that a cacheline has to be tossed around as 
> well?)

No, that assertion of Andi is wrong.

	Ingo
