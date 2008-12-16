Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756883AbYLPXAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYLPXAk (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYLPXAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:00:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53118 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbYLPXAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:00:30 -0500
Date: Wed, 17 Dec 2008 00:00:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
        akpm@linux-foundation.org, acme@ghostprotocols.net
Subject: Re: Impact: (was Re: [PATCH] update rwlock initialization for
	nat_table)
Message-ID: <20081216230009.GO14787@elte.hu>
References: <alpine.DEB.1.10.0812101314460.11805@gandalf.stny.rr.com> <49400B7F.7040607@cosmosbay.com> <alpine.DEB.1.10.0812101504280.11805@gandalf.stny.rr.com> <20081215.002019.232912990.davem@davemloft.net> <20081216011039.GA2458@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216011039.GA2458@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, Dec 15, 2008 at 12:20:19AM -0800, David Miller wrote:
> > >     update rwlock initialization for nat_table
> > >     
> > >     Impact: clean up
> > >     
> > >     The commit e099a173573ce1ba171092aee7bb3c72ea686e59
> > >     (netfilter: netns nat: per-netns NAT table) renamed the
> > >     nat_table from __nat_table to nat_table without updating the
> > >     __RW_LOCK_UNLOCKED(__nat_table.lock).
> > >     
> > >     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > 
> > Applied to net-2.6, thanks Steven.
> > 
> > As Andrew mentioned this is a bug (albeit a "nano-bug" as you
> > called it :-) so I removed the Impact line in the commit
> > message when applying this.
> 
> Speaking of Impact: lines, is this a new fashion or what?
> 
> Looking at the ones which are already in official tree, they are either 
> trivially duplicating Subject: line, or effectively duplicating Subject: 
> line, or cover up for insufficiently informative (read: badly written) 
> Subject: line, or simply useless.

> 	Subject: sched: CPU remove deadlock fix
> 	Impact: fix possible deadlock in CPU hot-remove path
> 
> What prevented to write "Subject: sched: fix possible deadlock in CPU 
> hot-remove path"?

there are 655 Impact lines, right now, and we find them rather useful, for 
a multitude of reasons. The impact line is a secondary subject line in 
essence, describing the intended scope and practical impact of a change - 
and not describe the change itself. The advantages are:

 - they encourage a proper splitup of patches:

    - the more complex a patch is, the harder it is to write a proper 
      impact line for it. So when people complain to me that they find it 
      hard to describe the practical impact of a patch in a single line, i 
      ask them to split up the patch ;-)

 - they standardize and document impact analysis:

    - it helps -stable later on in filtering out fixes and ordering
      them by risk. We might not want to mark a commit as Cc: stable 
      straight away - but we want to describe the risk analysis we have 
      performed.

    - they also help filtering out the patches that go into -git versus 
      devel stuff.

 - they help bug analysis:

    - Impact lines make it abundantly clear what the intented scope of a 
      change was, on the first line of the commit. We had incidents in the 
      past where people bisected to a commit and were wondering whether a 
      change was intended to have side-effects or not - and the Impact 
      line made it clear that the side-effect was not intended.

    - they help bisection itself too: a couple of times i used it already 
      to home in on a suspected change that introduced a breakage. If 
      there's a material change in the middle of cleanups, it's hard to 
      see that in the changelogs immediately.

 - they ease review:

    - when a patch comes in that has an Impact line, i just look at the 
      impact line and match it up with what the patch actually does. If
      there's mismatch it raises a red flag. Subject lines and changelogs
      come from dozens and dozens of different authors, with different
      cultural and language backgrounds, with different levels of
      experience. It's much easier (and faster) to approach a patch with
      an impact line from the right angle.

    - they make it much harder to apply patches without a proper
      level of review. Creating a good impact line is a good last line of
      defense both at the submitter and at the applier level.

    - they make it clear to the patch submitter if i mis-judge a change. 
      They tell me when i create the wrong Impact line and i can 
      re-consider the change.

That is an overlapping but still different purpose from a subject line.

Subject lines are controlled by the 'what' and 'how' questions of a code 
change - while the Impact line is only controlled by the: 'risk'/'impact' 
aspect.

Subject lines are also often controlled by subsystem maintenance 
tradition, have various tags to distract from, etc. We try to match up 
subject lines close to the lkml subject were they were discussed - and 
only change them if they are really bad. That linkage is important. 
Appending and prepending impact information gets messy.

All kernel developers and maintainers who started using them (whom i 
talked to) found them rather useful - even if they had reservations about 
the seemingly duplicated subject line aspect in the beginning. I dont 
think you can judge this from an armchair - as you are only the reader of 
an impact line, not the creator of it. At least half of the good stuff 
happens while you active create them. Try it if you dont believe me ;-) In 
any case, you dont have to use it if you dont like it.

	Ingo
