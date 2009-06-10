Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZFJKnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZFJKnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZFJKmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:42:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36428 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZFJKmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:42:55 -0400
Date: Wed, 10 Jun 2009 12:42:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -tip] perf_counter/x86: Correct some event and umask
	values for Intel processors
Message-ID: <20090610104242.GB27724@elte.hu>
References: <20090609131553.GA12489@ywang-moblin2.bj.intel.com> <20090609141621.GA32703@elte.hu> <20090610053623.GC30923@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610053623.GC30923@ywang-moblin2.bj.intel.com>
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


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> On Tue, Jun 09, 2009 at 04:16:21PM +0200, Ingo Molnar wrote:
> > 
> > * Yong Wang <yong.y.wang@linux.intel.com> wrote:
> > 
> > > Correct some event and UMASK values according to Intel SDM.
> > 
> > Very nice, thanks!
> > 
> > were you able to test the Atom ones by any chance?
> > 
> 
> You bet I was as I'm working on Moblin ;-) [...]

Heh :-)

> [...] However, some work while some do not. I'll take a look at 
> the problematic ones. With the previous event and umask values, 
> the pmc does not count at all for some events, like l1d-write-ops.

Interesting. I had a good look at the Atom details in the docs but 
couldnt find anything suspicious. There's various umask level 
extensions (sometimes cflags level ones) like whether to measure the 
core or the thread, but the defaults (zero) seem to have OK 
semantics for most of the events.

Btw., when mapping out event tables there's one little trick i used 
to 'scan' an event, using 'perf stat' and raw event numbers:

  for ((i=0;i<256;i++)); do                                    \
    perf stat -e $(printf "r%02x%02x\n" $i 0xc0) true 2>&1 |   \
      grep -w raw | grep -vw 0;                                \
  done

This scans all 256 umask values for the main event code of 0xc0, and 
displays the umask values where the counter show some activity.

( if it's some rare event then you might want to run something else 
  that excercises that event, not /bin/true. )

> Btw, one thing I don't quite understand is why you aliased 
> dtlb-write-ops to l1d-write-ops when setting event and umask 
> values. Are they the same event?

No, they are indeed different events - that's a bug in the table, 
good spotting. Mind sending a (tested) patch for it?

Thanks,

	Ingo
