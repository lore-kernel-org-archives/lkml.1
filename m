Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZI3Jpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZI3Jpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 05:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZI3Jpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 05:45:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50987 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZI3Jpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 05:45:38 -0400
Date: Wed, 30 Sep 2009 11:44:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Roland Dreier <rdreier@cisco.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20090930094456.GD24621@elte.hu>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins> <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929171332.GD14405@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> On Thu 2009-09-17 08:45:29, Roland Dreier wrote:
> > 
> >
[...]
> > OK.  It would be nice to tie into something more general, but I 
> > think I agree -- perf counters are missing the filtering and the "no 
> > lost events" that ummunotify does have. [...]

Performance events filtering is being worked on and now with the proper 
non-DoS limit you've added you can lose events too, dont you? So it's 
all a question of how much buffering to add - and with perf events too 
you can buffer arbitrary large amount of events.

> > [...]  And I'm not sure it's worth messing up the perf counters 
> > design just to jam one more not totally related thing in.

Nobody suggested details for any redesign yet (so far it seems like a 
perfect match, to me at least) so i'm wondering what messup you are 
referring to.

> I believe that extending perf counters to do what you want is better 
> than adding one more, very strange, user<->kernel interface.

Agreed.

Lemme react to the original description of the code:

>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git ummunotify
>
> This will get "ummunotify," a new character device that allows a 
> userspace library to register for MMU notifications; this is 
> particularly useful for MPI implementions (message passing libraries 
> used in HPC) to be able to keep track of what wacky things consumers 
> do to their memory mappings.

I test-pulled this code and had a look at it.

I think this could be done in a simpler, less limited, more generic, 
more useful form by using some variation of perf events.

You should be able to get all that you want by adding two TRACE_EVENT() 
tracepoints and using the existing perf event syscall to get the events 
to user-space.

Meaning that this:

  9 files changed, 1060 insertions(+), 1 deletions(-)

Would be replaced with something like:

  2 files changed, 100 insertions(+), 0 deletions(-)

[ the +100 lines would (roughly) would add tracepoints to 
  invalidate_page and invalidate_range_start. (possibly via 
  mmu_notifier_register() like the ummunotify code does) Most of that 
  linecount would be comments. ]

Another upside, beyond the reduction in complexity is that we'd have one 
less special char driver based ABI. Which is a big plus in my opinion, 
especially if this goes towards HPC folks and if it's used for real. Why 
should such a MM capability hidden behind a character device and an 
ioctl?

The perf event approach is beneficial to non-HPC as well: MM 
instrumentation for example - page range invalidates are interesting to 
all sorts of modi of analysis.

A question: what is the typical size/scope of the rbtree of the watched 
regions of memory in practical (test) deployments of the ummunofity 
code?

Per tracepoint filtering is possible via the perf event patches Li Zefan 
has posted to lkml recently, under this subject:

   [PATCH 0/6] perf trace: Add filter support

They are still being worked on but it's very clear that flexible 
in-kernel filtering support will be a natural part of the perf event 
design in the very near future, so if that alone is your reason not to 
use it it would be better if you helped us complete/test the filter 
support and use that, instead of a parallel framework.

Or if that's not desirable or not possible, or if there's any other 
technical roadblock, i'd like to know the particulars of that.

Thanks,

	Ingo
