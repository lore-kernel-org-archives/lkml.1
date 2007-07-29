Return-Path: <linux-kernel-owner+w=401wt.eu-S934996AbXG2PXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934996AbXG2PXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765731AbXG2PEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:04:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57175 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbXG2PEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:04:52 -0400
Date: Sun, 29 Jul 2007 17:04:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       CK Mailinglist <ck@vds.kolivas.org>
Subject: Re: Linus 2.6.23-rc1
Message-ID: <20070729150436.GA6598@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185588279.1654.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185588279.1654.1.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


hi Kasper,

* Kasper Sandberg <lkml@metanurb.dk> wrote:

> Im still not so keen about this, Ingo never did get CFS to match SD in 
> smoothness for 3d applications, where my test subjects are quake(s), 
> world of warcraft via wine, unreal tournament 2004. And this is 
> despite many patches he sent me to try and tweak it. [...]

hey, i thought you vanished from the face of the earth :-) The last 
email i got from you was more than 2 months ago, where you said that 
you'll try the latest CFS version as soon as possible but that you were 
busy with work. I sent 2 more emails to you about new CFS versions but 
then stopped pestering you directly - work _does_ take precedence over 
games =B-)

CFS v14, v15, v16, v17, v18 and v19 was released meanwhile, CFS v20 went 
upstream, there were no 3D related CFS regressions open for quite some 
time and because i never heard back from you i assumed everything's 
peachy.

In any case i'm glad you found the time to try CFS again, so please let 
me know in what way it regresses. In your most recent emails you did not 
indicate what specific problem you are having (and you did not reply to 
my last emails from May) - are your old regression reports against CFS 
v13 from May still true as of v2.6.23-rc1? If they are, could you please 
indicate which specific report of yours describes it best and send me 
(or upload to some webspace) the specific .config you are using on your 
box, and the cfs-debug-info.sh snapshot taken when you are running your 
game. (make sure you have CONFIG_SCHED_DEBUG=y enabled, for highest 
quality debug output) You can pick the script up from:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

Giving us that info would help us immensely with tracking down any CFS 
problem you might still be having.

Or, if you feel adventurous enough to look into the internals of the 
kernel (which, considering your offer to take up SD maintenance, you 
must be ;-), here's my kernel latency tracer:

   http://people.redhat.com/mingo/latency-tracing-patches/

( see: latency-tracer-v2.6.23-rc1-combo.patch )

the simplest way to use it is to enable CONFIG_WAKEUP_TIMING, to set 
/proc/sys/kernel/preempt_max_latency back to 0 (after bootup) and to 
thus measure raw worst-case scheduler latencies - if you regularly see 
the kernel report above say 1000 usecs latencies to the syslog, on a 
PREEMPT kernel then there's definitely something foul going on. For 
example, that's how i found an audio playback latency problem in an 
early version of CFS:

(            sshd-14614|#1): new 5 us maximum-latency wakeup.
(          ogg123-6603 |#1): new 6 us maximum-latency wakeup.
(          ogg123-6608 |#1): new 6 us maximum-latency wakeup.
(            sshd-14614|#1): new 10 us maximum-latency wakeup.
(          ogg123-6607 |#0): new 15 us maximum-latency wakeup.
(        events/0-9    |#0): new 789 us maximum-latency wakeup.
(          ogg123-6603 |#0): new 2566 us maximum-latency wakeup.

that 2.5 msecs latency in the ogg123 task was definitely the sign of a 
kernel bug.

If plain WAKEUP_TIMING does not show anything suspicious, you can use 
the latency tracer in more advanced ways as well to trace the whole 
system and figure out the precise cause of your game latencies - i'll be 
glad to help with that if no simpler measure helps. [see trace-it.c for 
some of those details.]

> [...] As far as im concerned, i may be forced to unofficially maintain 
> SD for my own systems(allthough lots in the gaming community is bound 
> to be interrested, as it does make games lots better)

i'd encourage you to do it - in fact i already tried to prod Peter 
Williams into doing exactly that ;) The more reality checks a scheduler 
has, the better. [ Btw., after the obvious initial merging trouble it 
should be much easier to keep SD maintained against future upstream 
kernels due to the policy modularity that CFS introduces. (and which 
policy-modularity should also help reduce the size and complexity of the 
SD patch.) ]

Thanks,

	Ingo
