Return-Path: <linux-kernel-owner+w=401wt.eu-S1763947AbZAOSJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763947AbZAOSJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbZAOSJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:09:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43279 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbZAOSJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:09:08 -0500
Date: Thu, 15 Jan 2009 19:08:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-ID: <20090115180844.GL22472@elte.hu>
References: <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu> <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org> <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain>
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

> > Has anyone found a non-synthetic benchmark where this makes a 
> > significant difference?  Aside from btrfs, I mean.
> 
> Yea, if you have some particular filesystem (or other subsystem) that 
> uses a global mutex, you'll obviously see way more contention. Btrfs may 
> not be _unique_ in this regard, but it's definitely doing something that 
> isn't good.
> 
> Btw, it's doing something that ext3 also used to do iirc, until we fixed 
> it to use spinlocks instead (the block group lock in particular).
> 
> Yeah - just double-checked. Commit c12b9866ea52 in the historical Linux 
> archive, from 2003. Which made block allocation protected by a per-group 
> spinlock, rather than lock_super().

btw., i think spin-mutexes have a design advantage here: in a lot of code 
areas it's quite difficult to use spinlocks - cannot allocate memory, 
cannot call any code that can sporadically block (but does not _normally_ 
block), etc.

With mutexes those atomicity constraints go away - and the performance 
profile should now be quite close to that of spinlocks as well.

	Ingo
