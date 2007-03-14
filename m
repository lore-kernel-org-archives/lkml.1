Return-Path: <linux-kernel-owner+w=401wt.eu-S933076AbXCNUMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbXCNUMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933092AbXCNUMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:12:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39029 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076AbXCNUMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:12:10 -0400
Date: Wed, 14 Mar 2007 21:11:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314201156.GA9603@elte.hu>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <20070314180933.GA12994@elte.hu> <Pine.LNX.4.64.0703141120530.9690@woody.linux-foundation.org> <20070314195916.GA5674@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314195916.GA5674@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > Well, I'd like it to be 100% _eventually_, and just unify the 
> > architectures.
> 
> ok, having a single bi-arch final tree is indeed intriquing and i didnt 
> realize that you were suggesting that. [...]
>
> [...] But this really scares the sh*t out of me. [...]

i think the sanest (and pretty much only) way to do it would be to unify 
it _now_, in a single atomic step, safely and in a brute-force way:

 create arch/x86/

'unify' arch/i386/ and arch/x86_64/ into arch/x86/ by doing a 
brute-force prefix solution:

  arch/i386/kernel/process.c   => arch/x86/kernel/x32_process.c
  arch/x86_64/kernel/process.c => arch/x86/kernel/x64_process.c

create bi-arch Makefiles and enable the building of each arch.

obviously, for files that are already totally identical across the two 
arches, the x32_foo.c and x64_foo.c can be changed to foo.c, right away.

nothing else would be done in this step. We'd remove arch/i386/ and 
arch/x86_64/ after that.

new files for new functionality can only be added if they are bi-arch.

from this first 'brutal', 'flag day' intrusive step on, every further 
step would be more finegrained and per-file: an x32_bar.c and x64_bar.c 
file gets merged into bar.c. About 80-90% of our .c files have the same 
fundamental purpose in both arches, so this setup makes the most sense 
to me: first move them 'close' to each other and force them to be part 
of the same basic build architecture, then 'unify' them.

this way we'd also obviously see the costs of not having unified files: 
we'd have to change both the x32_ and the x64_ file for the same thing - 
while when they are unified, only one change is needed. It's easy to 
forget that when the arch directories are separate.

also, unifying two files will also be quite gratifying: one of the files 
vanishes, making up for a sail-through-lkml review.

also, this way it's harder for the two trees (and the shared tree) to 
get out of sync. If we did 3 separate hierarchies we'd have mixed state 
pretty quickly.

also, having the x32_ and x64_ prefix is a painful daily reminder for 
all of us changing the architecture that 'this stuff needs to be 
unified!'.

hm?

	Ingo
