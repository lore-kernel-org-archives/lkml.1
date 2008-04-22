Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbYDVHHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbYDVHHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 03:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbYDVHHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:07:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694AbYDVHHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:07:08 -0400
Date: Tue, 22 Apr 2008 09:06:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       Junio C Hamano <junio@pobox.com>
Subject: Re: sched tree bisectability
Message-ID: <20080422070644.GA7068@elte.hu>
References: <20080421.203212.262634448.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421.203212.262634448.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> While trying to bisect a regression added by the sched tree merges 
> today, I found the following gem that broke compilation mid-bisect:
[...]

> rt_bandwidth does not have a rt_runtime_lock member, so the compile 
> fails.  The very next changeset adds it:

sorry, i broke that bisection point and i should have noticed this and 
should have backmerged that chunk.

i've just added some scripting to avoid this in the future - the 
scheduler tree gets built on every commit point before it's pushed out. 
I just ran it through the outstanding scheduler patches (there's a 
hundred more pending) and they all pass this test.

I'm wondering whether there are any other maintenance practices others 
use to keep things like this slip through.

It could be caught on the testing side via a new git-checkout feature:

   git-checkout --random base..head

which would pick a random commit from a git tree (from the range of 
commits given), which could be combined with make randconfig? This could 
be used in pre-push testing.

Another thing we might think about is when neither care from the 
maintainer nor any testing caught an unusable commit - then we could 
perhaps, as a last-ditch effort teach git-bisect to avoid known "100% 
unusable" commit points.

Something like a (append-only, constantly growing, but not too huge) 
repository of known-unusable commits via a special exceptions file like 
.gitignore - say .git/git-bisect-unusable. [Plus perhaps a git-bisect 
--ignore-bad option so that if someone wants to run a pristine bisection 
it can be done too.]

The semantics would be to pass along this information across a pull as 
well, so that the known-unusable commit points would.

The downside of such an approach would be that the file would grow 
indefinitely, and would never shrink. That does not feel too good.

	Ingo
