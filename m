Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZF3NVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZF3NVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 09:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZF3NVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 09:21:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:49762 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbZF3NVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 09:21:21 -0400
Subject: Re: [PATCH -tip] perf_counter: Add Generalized Hardware FPU
 support for AMD
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090630101105.GF6942@elte.hu>
References: <1246267985.3185.3.camel@hpdv5.satnam>
	 <20090630101105.GF6942@elte.hu>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 18:50:49 +0530
Message-Id: <1246368049.3026.11.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 12:11 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> >  $./perf stat -e add -e multiply -e fpu-store -e fpu-empty -e fpu-busy -e x87 -e mmx-3dnow -e sse-sse2 -- ls -lR /usr/include/ > /dev/null
> > 
> >  Performance counter stats for 'ls -lR /usr/include/':
> > 
> >            7335  add                       (   2.00x scaled)
> >            8012  multiply                  (   1.99x scaled)
> >            5229  fpu-store                 (   2.00x scaled)
> >       793097355  fpu-empty                 (   2.00x scaled)
> >             182  fpu-busy                  (   2.00x scaled)
> >               6  x87                       (   2.01x scaled)
> >               4  mmx-3dnow                 (   2.00x scaled)
> >            8933  sse-sse2                  (   2.00x scaled)
> > 
> >     0.393548820  seconds time elapsed
> > 
> >  $./perf stat -e add -e multiply -e fpu-store -e fpu-empty -e fpu-busy -e x87 -e mmx-3dnow -e sse-sse2 -- /usr/bin/rhythmbox ~jaswinder/Music/singhiskinng.mp3
> > 
> >  Performance counter stats for '/usr/bin/rhythmbox /home/jaswinder/Music/singhiskinng.mp3':
> > 
> >        19583739  add                       (   2.01x scaled)
> >        20856051  multiply                  (   2.01x scaled)
> >        18669503  fpu-store                 (   2.00x scaled)
> >     25100224054  fpu-empty                 (   1.99x scaled)
> >        12540131  fpu-busy                  (   1.99x scaled)
> >          207228  x87                       (   1.99x scaled)
> >         1768418  mmx-3dnow                 (   2.00x scaled)
> >        42286702  sse-sse2                  (   2.01x scaled)
> > 
> >   302.698647617  seconds time elapsed
> > 
> >  $./perf stat -e add -e multiply -e fpu-store -e fpu-empty -e fpu-busy -e x87 -e mmx-3dnow -e sse-sse2 -- /usr/bin/vlc ~jaswinder/Videos/Linus_Torvalds_interview_with_Charlie_Rose_Part_1.flv
> > 
> >  Performance counter stats for '/usr/bin/vlc /home/jaswinder/Videos/Linus_Torvalds_interview_with_Charlie_Rose_Part_1.flv':
> > 
> >      6572682335  add                       (   2.00x scaled)
> >     11131555181  multiply                  (   2.00x scaled)
> >      1317520699  fpu-store                 (   2.00x scaled)
> >      9089415134  fpu-empty                 (   1.99x scaled)
> >      2902772713  fpu-busy                  (   2.00x scaled)
> >           26047  x87                       (   2.00x scaled)
> >     24850978532  mmx-3dnow                 (   2.00x scaled)
> >       262276117  sse-sse2                  (   2.01x scaled)
> > 
> >    96.169312358  seconds time elapsed
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/kernel/cpu/perf_counter.c |   34 ++++++++++++++++++++++++++++++
> >  include/linux/perf_counter.h       |   17 +++++++++++++++
> >  kernel/perf_counter.c              |    1 +
> >  tools/perf/util/parse-events.c     |   40 ++++++++++++++++++++++++++++++++++++
> >  4 files changed, 92 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> > index b83474b..4417edf 100644
> > --- a/arch/x86/kernel/cpu/perf_counter.c
> > +++ b/arch/x86/kernel/cpu/perf_counter.c
> > @@ -372,6 +372,12 @@ static const u64 atom_hw_cache_event_ids
> >   },
> >  };
> >  
> > +/*
> > + * Generalized hw fpu event table
> > + */
> > +
> > +static u64 __read_mostly hw_fpu_event_ids[PERF_COUNT_HW_FPU_MAX];
> 
> ok, this looks genuinely useful, but there are some gaps. Where's 
> the divides? 

I was also surprised divide is not available for AMD. Thats why I did
not included it. You are right it should be there.

> Plus things like mmx-3dnow are AMD specific, sse-sse2 
> is x86 specific. We definitely want this general table, but the 
> events should be truly general.
> 

mmx and sse are available for both Intel and AMD. Thats why I added both
of them. Is it OK.

> Also, how would this look like on Intel, roughly?
> 

Intel have almost all of them + divide.

As you know I work from home and I do not have any Intel machine which
supports PMU.

Can you suggest your machine name so that I can prepare the FPU events
list for your machine and you can verify it on your side.

Thanks,
--
JSR


