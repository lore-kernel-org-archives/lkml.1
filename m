Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbZFYJgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbZFYJgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbZFYJgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:36:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37266 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758984AbZFYJgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:36:40 -0400
Date: Thu, 25 Jun 2009 11:36:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 2/2] procfs: provide stack information for threads V0.10
Message-ID: <20090625093627.GE23547@elte.hu>
References: <20090623233247.7ed661b7.akpm@linux-foundation.org> <1245825903.23818.4.camel@wall-e> <20090624001302.18de9e21.akpm@linux-foundation.org> <m1my7ykrs7.fsf@fess.ebiederm.org> <1245854033.10579.4.camel@wall-e> <20090624152019.GD15037@elte.hu> <1245858590.13531.2.camel@wall-e> <20090624174025.GA13170@cmpxchg.org> <20090624174637.GA7576@elte.hu> <20090624190835.GA25548@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624190835.GA25548@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Wed, Jun 24, 2009 at 07:46:37PM +0200, Ingo Molnar wrote:
> > 
> > * Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> > > On Wed, Jun 24, 2009 at 05:49:50PM +0200, Stefani Seibold wrote:
> > > > Am Mittwoch, den 24.06.2009, 17:20 +0200 schrieb Ingo Molnar:
> > > > > * Stefani Seibold <stefani@seibold.net> wrote:
> > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > this is the newest version of the formaly named "detailed stack info"
> > > > > > patch which give you a better overview of the userland application stack
> > > > > > usage, especially for embedded linux.
> > > > > > 
> > > > > > Currently you are only able to dump the main process/thread stack usage
> > > > > > which is showed in /proc/pid/status by the "VmStk" Value. But you get no
> > > > > > information about the consumed stack memory of the the threads.
> > > > > > 
> > > > > > There is an enhancement in the /proc/<pid>/{task/*,}/*maps and which
> > > > > > marks the vm mapping where the thread stack pointer reside with "[thread
> > > > > > stack xxxxxxxx]". xxxxxxxx is the maximum size of stack. This is a
> > > > > > value information, because libpthread doesn't set the start of the stack
> > > > > > to the top of the mapped area, depending of the pthread usage.
> > > > > > 
> > > > > > A sample output of /proc/<pid>/task/<tid>/maps looks like:
> > > > > > 
> > > > > > 08048000-08049000 r-xp 00000000 03:00 8312       /opt/z
> > > > > > 08049000-0804a000 rw-p 00001000 03:00 8312       /opt/z
> > > > > > 0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
> > > > > > a7d12000-a7d13000 ---p 00000000 00:00 0 
> > > > > > a7d13000-a7f13000 rw-p 00000000 00:00 0          [thread stack: 001ff4b4]
> > > > > 
> > > > > I have the same question as before: have you checked the use of that 
> > > > > field in tools/perf/builtin-record.c, and how your change will 
> > > > > impact that?
> > > > > 
> > > > 
> > > > Good question... i have another one: What is 
> > > > tools/perf/builtin-record.c and where can i find it? Then i 
> > > > could check it.
> > > 
> > > You can find it in a recent git tree from Linus.
> > > 
> > > On the original question: builtin-record.c is unaffected by this 
> > > patch as this exact field will only be parsed if the mapping is 
> > > executable.
> > 
> > A stack can be executable too. It is not common, but possible.
> 
> It also ignores the field if it doesn't start with a slash, so 
> it's even safe for executable stacks.
> 
> On a different note, I think that parser is not working for file 
> mappings with paths containing spaces.  Not common, but possible 
> :)
> 
> The below, sorry: untested, should fix this up.  I think we don't 
> expect a slash in those lines except in a pathname, so looking for 
> the first slash should be okay.  What do you think?

heh - good one - applied, thanks Johannes!

	Ingo
