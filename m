Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYHZUXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYHZUXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYHZUXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:23:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47003 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYHZUXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:23:15 -0400
Date: Tue, 26 Aug 2008 22:22:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH 2/2] poll: allow f_op->poll to sleep
Message-ID: <20080826202250.GA16072@elte.hu>
References: <48B40BD4.7040004@kernel.org> <48B40C2F.3050700@gmail.com> <alpine.LFD.1.10.0808260954040.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808260954040.3363@nehalem.linux-foundation.org>
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

> On Tue, 26 Aug 2008, Tejun Heo wrote:
> > 
> > This patch converts poll/select to use custom wake up function and use
> > separate triggered variable to synchronize against wake up events.
> > The only added overhead is an extra function call during wake up and
> > negligible.
> 
> I don't really see the point.
> 
> poll() isn't allowed to sleep for many reasons. Some are technical. 
> But the most obvious one is that a sleeping "poll()" is totally 
> against the whole point of polling in the first place!
> 
> So is there some big conceptual reason to change how poll() has always 
> worked?

i think the point is to replace potentially fragile atomic code with 
less restricted 'potentially sleeping' code.

For example a GFP_KERNEL allocation will not sleep in 99% of the cases, 
and if it sleeps we are under such memory pressure that we dont really 
care all that much whether we happen to sleep in poll() or in the next 
userspace pagefault.

The whole ->poll() handler model would be less restricted. I dont think
that's a bad idea - all our atomic contexts suffer from programmability
restrictions, and people are trying to get away from them.

Plus it seems to enable FUSE some more as well - and FUSE has been 
spearheading a lot of filesystem development lately. FUSE is IMO the 
useful form of microkernels - a fast prototyping platform with a very 
friendly user-space programming and debugging interface. (and the fact 
that FUSE based filesystems can be packaged up and distributed a lot 
easier than kernel changes is an argument in favor of FUSE as well)

	Ingo
