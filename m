Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbZDIVSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbZDIVSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZDIVRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:17:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54398 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbZDIVRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:17:52 -0400
Date: Thu, 9 Apr 2009 23:17:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
Message-ID: <20090409211733.GA23233@elte.hu>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com> <87tz4x97uq.fsf@basil.nowhere.org> <alpine.LFD.2.00.0904090831000.4583@localhost.localdomain> <20090409184022.GA2665@elte.hu> <20090409193635.GO14687@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409193635.GO14687@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > Using a mutex seems like the sane choice here. I'd advocate spinlocks 
> > for a new filesystem any day (but even there it's a fine choice to have 
> > a mutex, if top of the line scalability is not an issue).
> > 
> > But for a legacy filesystem like reiser3, which depended on the BKL 
> 
> reiser3 is much more widely used in the user base than a lot of 
> "non legacy" file systems. It's very likely it has significantly 
> more users than ext4 for example. Remember that it was the default 
> file system for a major distribution until very recently. [...]

( Drop the condescending tone please - i very much know that SuSE 
  installed reiser3 by default for years. It is still a legacy 
  filesystem and no new development has gone into it for years. )

> [...] I also got a few reiser3 fs still around, it tended to 
> perform very well on kernel hacker workloads.

Then i am sure you must like this patch: it introduces a per 
superblock lock, splitting up the big BKL serialization. You
totally failed to even acknowledge that advantage, maybe you
missed that aspect?

For example, if you have /home and / on separate reiser3 
filesystems, you could see as much as a 200% jump in performance 
straight away on certain workloads, on a dual-core box.

That big BKL overhead is a real reiser3 scalability problem - 
especially on reiser3 using servers which are likely to have several 
filesystems on the same box.

Frederic reported a slight drop in single-threaded performance,
to be expected from a work in progress patch.

	Ingo
