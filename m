Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZDVJCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZDVJCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZDVJCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:02:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbZDVJCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:02:23 -0400
Date: Wed, 22 Apr 2009 10:58:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>, Andi Kleen <andi@firstfloor.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [rfc] built-in native compiler for Linux?
Message-ID: <20090422085828.GA16917@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> I think it was Ingo that let out the idea, and I'm starting to 
> like it.
> 
> Perhaps we should fork off gcc and ship Linux with its own 
> compiler. This way we can optimize it for the kernel and not worry 
> about any userland optimizations.

I didnt suggest forking GCC. A kernel-special GCC would likely just 
become an inferior fork of GCC over time and would fizzle out. 
There's 100 times more user-space code than kernel-space code and 
GCC is too large and too legacy-laden to really be appropriate for 
that purpose.

What i think makes sense is to build a _new_ precompiler / compiler 
/ assembler / linker combo for Linux, from scratch, hosted in the 
kernel proper.

In the past 15 years of Linux we've invested a lot of time and 
effort into working around and dealing with compiler crap. We wasted 
a lot of opportunities waiting years for sane compiler features to 
show up. We might as well have invested that effort into building 
our own compiler and could stop bothering about externalities. The 
Linux kernel project certainly involves the right kind of people who 
could make something like this happen.

A good technical basis for that would be Sparse, and it could start 
by acting as a drop-in replacement for CPP and it could feed its 
output to GCC with little changes. Sparse is small, has a very tidy 
code base and is already useful today as an extended static source 
code checker.

The Sparse codebase could move into the kernel proper, under 
linux/sparse/ or so - so the preprocessor/compiler and the kernel 
could be in precise feature and bugfix lock-step with no artificial 
external synchronization.

We have a lot of annoying preprocessor limitations that Sparse could 
help with straight away. We'd also get Sparse type checking by 
default. So it's helpful even without any code generator support.

Then, if this model works out, we could experiment with adding a 
code generator backend to Sparse. I think Jeff Garzik experimented 
with that in the past with some surprisingly quick (but incomplete) 
results.

Since most of the performance-critical code in Linux is 
hand-optimized already, we dont even need all that many complex, 
exotic optimizations - we want to encourage common-sense coding 
practices. Furthermore, a lot of optimizations in GCC are driven by 
SPECint and SPECfp benchmarketing, with little practical relevance 
to 99% of the apps, including the kernel.

There would always be an 'output to GCC' kind of compatible build 
channel as well, for CPU architectures that dont have native code 
generator support yet. We'd also do that to generally keep our 
options open, in case we are wrong about it all or in case some even 
better compiler project pops up.

	Ingo
