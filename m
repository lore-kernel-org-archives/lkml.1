Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYFYOyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYFYOyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYFYOxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:53:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYFYOxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:53:54 -0400
Date: Wed, 25 Jun 2008 16:53:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Jackson <pj@sgi.com>, hpa@zytor.com, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, steiner@sgi.com,
       travis@sgi.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
       andi@firstfloor.org, Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
	in some kernel info printks
Message-ID: <20080625145331.GA20941@elte.hu>
References: <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com> <20080623060939.6b6b3183.pj@sgi.com> <86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com> <20080624203252.f932c631.pj@sgi.com> <4861A5DF.5010104@zytor.com> <20080624211711.8c6d5105.pj@sgi.com> <4861AAEF.3020103@zytor.com> <alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org> <20080624220810.b2ec0c6a.pj@sgi.com> <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,URIBL_BLACK autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: checkpatch.pl]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The format warnings are too useful to drop entirely. I guess sparse 
> could be taught to do them, and then we could drop the gcc support for 
> them. But that would still limit coverage a _lot_.

i think the main problem with Sparse isnt even technical but just a few 
minor gotchas IMO that artificially work against the widespread use of 
Sparse in various common workflows.

Sparse is a cool tool that extends upon C types (and more), but it's 
been made too hard to use widely:

 - right now it's opt-in with no ability for testers to use it
   transparently while also building the kernel. Forcing a second
   kernel build just for 'debugging' reduces the userbase.

 - it produces way too much output for people to act upon and see any 
   real "improvement" in the end result. (Obviously this is partly a 
   side-effect of its shallow use.) Producing too much output by default 
   reduces the userbase further.

 - delta analysis (watching what new Sparse warnings pop up) is 
   possible, Al Viro has the "remapper" tool:

      git://git.kernel.org/pub/scm/linux/kernel/git/viro/remapper.git/

   but forcing delta analysis as the only viable Sparse use poses yet 
   another barrier against use and does not allow state-less,
   single-pass test feedback.

There are simpler tools (like for example checkpatch.pl) which are much 
cruder in many aspects, but still they are used much more because they 
do not have such basic usage problems. The artificial limitations on 
Sparse usage keep it from being the tool it could be, IMO.

A tool that has quality assurance effects _must_ be actionable by a 
broad developer base and needs to be no-hassle enabled by testers - 
otherwise it will just drown in sheer entropy.

Fortunately these problems are all solvable gradually:

 - a kbuild mechanism to get _parallel_ Sparse checks. I.e. both the 
   real .o gets produced but also the "make C=1" output is produced. 
   Testers would be enabled to do Sparse checks "alongside" of a normal 
   kernel build. (Sparse is plenty fast for this to be practical)

 - kbuild mechanism with which subsystem maintainers could mark specific 
   files (or all of their subdirectories) of their subsystem as to be 
   Sparse-checked by default. [if a .config debug option is enabled]
   For example we'd mark all of arch/x86/*.o and kernel/sched*.o in such 
   a way for example.

 - a second layer would be very useful as well: failures would turn into 
   build failures if a debug .config switch is enabled.

this (and i'm sure some other, simple measures) would push Sparse into 
the mainstream and it would allow us to integrate it into existing 
practices of automated testing.

if we did all that Sparse might even turn into the native, built-in 
Linux kernel compiler of the future: it already has the hardest bit 
implemented as it can parse the kernel source and generates syntax trees 
from it, generating a real .o from it is just one next step.

On a similar note, it would be nice if subsystem maintainers had a 
kbuild mechanism to have the fails they maintain to be built via -Werr 
(if an opt-in .config option is enabled).

I'd enforce it in a heartbeat on all files i'm involved with - but i 
cannot enforce it on the more than 10,000 files the kernel has. Grepping 
the warnings of files i'm interested is not possible reliably from make 
-j builds.

So if someone wants me to try a kbuild patch to that end, i'd love to 
give it a shot :-)

	Ingo
