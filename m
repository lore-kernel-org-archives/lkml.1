Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbXL1JId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbXL1JId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 04:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbXL1JIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 04:08:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33087 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbXL1JIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 04:08:23 -0500
Date: Fri, 28 Dec 2007 10:00:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Lameter <clameter@sgi.com>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>, Willy Tarreau <w@1wt.eu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071228090037.GA20372@elte.hu>
References: <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org> <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com> <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org> <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com> <20071224233701.GB9784@kernel.org> <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com> <20071226221631.GD27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071226221631.GD27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> > > So two questions: why isn't -f the default?  And is /sys/slab
> > 
> > Because it gives misleading output. It displays the name of the 
> > first of multiple slabs that share the same storage structures.
> 
> Erm...  Let me spell it out: current lifetime rules are completely 
> broken. As it is, create/destroy/create cache sequence will do 
> kobject_put() on kfree'd object.  Even without people playing with 
> holding sysfs files open or doing IO on those.
> 
> a) you have kobject embedded into struct with the lifetime rules of 
> its own.  When its refcount hits zero you kfree() the sucker, even if 
> you still have references to embedded kobject.
> 
> b) your symlinks stick around.  Even when cache is long gone you still 
> have a sysfs symlink with its embedded kobject as a target.  They are 
> eventually removed when cache with the same name gets created.  _Then_ 
> you get the target kobject dropped - when the memory it used to be in 
> had been freed for hell knows how long and reused by something that 
> would not appreciate slub.c code suddenly deciding to decrement some 
> word in that memory.
> 
> c) you leak references to these kobject; kobject_del() only removes it 
> from the tree undoing the effect of kobject_add() and you still need 
> kobject_put() to deal with the last reference.

as a sidenote: bugs like this seem to be reoccuring. People implement 
sysfs bindings (without being sysfs internals experts - and why should 
they be) - and create hard to debug problems. We've seen that with the 
scheduler's recent sysfs changes too.

shouldnt the sysfs code be designed in a way to not allow such bugs? The 
primary usecase of sysfs is by people who do _not_ deal with it on a 
daily basis. So if they pick APIs that look obvious and create hard to 
debug problems (and userspace incompatibilities) that's a primary 
failure of sysfs, not a failure of those who utilize it.

At a minimum there should be some _strong_ debugging facility that 
transparently detects and reports such bugs as they occur. 
CONFIG_DEBUG_KOBJECT is totally unusable right now, it spams the syslog 
(so no distro ever enables it - i disable it in random bootups as well 
because it takes _ages_ to even get to a boot prompt) and never finds 
any of these hard-to-find-but-easy-to-explain bugs.

or if sysfs/kobjects should be scrapped and rewritten, do you have any 
insight into what kind of abstraction could/should replace it? Should we 
go back to procfs and get rid of kobjects altogether? (as it's slowly 
turning into a /proc problem of itself, with worse compatibility and 
sneakier bugs.)

	Ingo
