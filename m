Return-Path: <linux-kernel-owner+w=401wt.eu-S935785AbZDISkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935785AbZDISkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZDISke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:40:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40147 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244AbZDISkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:40:33 -0400
Date: Thu, 9 Apr 2009 20:40:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
Message-ID: <20090409184022.GA2665@elte.hu>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com> <87tz4x97uq.fsf@basil.nowhere.org> <alpine.LFD.2.00.0904090831000.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904090831000.4583@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Better would be to use spinlocks if possible. I guess you just would 
> > need to find all sleep points and wrap them with lock dropping?
> 
> I do agree that a filesystem should try to avoid sleeping locks if at 
> all possible, especially on the paths that the VM uses for writeback. 
> But on the other hand, I think the issue with reiserfs is just the bad 
> latencies that the BKL can cause, and then it doesn't matter.

The main motivator is the tip:core/kill-the-BKL tree: we are working on 
removing the BKL from all of the kernel, once and forever. We are 
actually quite close to that end goal: reiser3 was the last big 
stumbling block and it's great that Frederic is tackling that.

Using a mutex seems like the sane choice here. I'd advocate spinlocks 
for a new filesystem any day (but even there it's a fine choice to have 
a mutex, if top of the line scalability is not an issue).

But for a legacy filesystem like reiser3, which depended on the BKL 
auto-dropping on schedule() it would be rather fragile to use spinlocks, 
and it would take forever to validate the result. Just one codepath 
missed with having some rare scheduling possibility and we'd have a 
kernel crash down the road.

	Ingo
