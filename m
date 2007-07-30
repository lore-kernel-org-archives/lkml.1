Return-Path: <linux-kernel-owner+w=401wt.eu-S966216AbXG3Q0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966216AbXG3Q0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938882AbXG3QQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:16:05 -0400
Received: from pfepc.post.tele.dk ([195.41.46.237]:42868 "EHLO
	pfepc.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939071AbXG3QQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:16:01 -0400
Subject: Re: Linus 2.6.23-rc1
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       CK Mailinglist <ck@vds.kolivas.org>
In-Reply-To: <20070729150436.GA6598@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185588279.1654.1.camel@localhost>  <20070729150436.GA6598@elte.hu>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 18:13:15 +0200
Message-Id: <1185811995.16584.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-29 at 17:04 +0200, Ingo Molnar wrote:
> hi Kasper,
> 
> * Kasper Sandberg <lkml@metanurb.dk> wrote:
> 
> > Im still not so keen about this, Ingo never did get CFS to match SD in 
> > smoothness for 3d applications, where my test subjects are quake(s), 
> > world of warcraft via wine, unreal tournament 2004. And this is 
> > despite many patches he sent me to try and tweak it. [...]
> 
> hey, i thought you vanished from the face of the earth :-) The last 
> email i got from you was more than 2 months ago, where you said that 
> you'll try the latest CFS version as soon as possible but that you were 
> busy with work. I sent 2 more emails to you about new CFS versions but 
> then stopped pestering you directly - work _does_ take precedence over 
> games =B-)
> 

I did respond to that one, but perhaps some mail have been getting lost,
cause i cant find any more from you in my inbox.

> CFS v14, v15, v16, v17, v18 and v19 was released meanwhile, CFS v20 went 
> upstream, there were no 3D related CFS regressions open for quite some 
> time and because i never heard back from you i assumed everything's 
> peachy.

I must admit i havent tested the very very latest, will do

> 
> In any case i'm glad you found the time to try CFS again, so please let 
> me know in what way it regresses. In your most recent emails you did not 
> indicate what specific problem you are having (and you did not reply to 
> my last emails from May) - are your old regression reports against CFS 
> v13 from May still true as of v2.6.23-rc1? If they are, could you please 
> indicate which specific report of yours describes it best and send me 
> (or upload to some webspace) the specific .config you are using on your 
> box, and the cfs-debug-info.sh snapshot taken when you are running your 
> game. (make sure you have CONFIG_SCHED_DEBUG=y enabled, for highest 
> quality debug output) You can pick the script up from:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> 
> Giving us that info would help us immensely with tracking down any CFS 
> problem you might still be having.

Sure.

> 
> Or, if you feel adventurous enough to look into the internals of the 
> kernel (which, considering your offer to take up SD maintenance, you 
> must be ;-), here's my kernel latency tracer:

Well, im not sure how good i would be at maintaining SD, my idea was
more or less just do the bare minimum to get the thing running on newer
kernels :)

> 
>    http://people.redhat.com/mingo/latency-tracing-patches/
> 
> ( see: latency-tracer-v2.6.23-rc1-combo.patch )
> 
> the simplest way to use it is to enable CONFIG_WAKEUP_TIMING, to set 
> /proc/sys/kernel/preempt_max_latency back to 0 (after bootup) and to 
> thus measure raw worst-case scheduler latencies - if you regularly see 
> the kernel report above say 1000 usecs latencies to the syslog, on a 
> PREEMPT kernel then there's definitely something foul going on. For 
> example, that's how i found an audio playback latency problem in an 
> early version of CFS:
> 
> (            sshd-14614|#1): new 5 us maximum-latency wakeup.
> (          ogg123-6603 |#1): new 6 us maximum-latency wakeup.
> (          ogg123-6608 |#1): new 6 us maximum-latency wakeup.
> (            sshd-14614|#1): new 10 us maximum-latency wakeup.
> (          ogg123-6607 |#0): new 15 us maximum-latency wakeup.
> (        events/0-9    |#0): new 789 us maximum-latency wakeup.
> (          ogg123-6603 |#0): new 2566 us maximum-latency wakeup.
> 

Actually, now that you mention ogg123, i've had some bugs on CFS with
this, i thought it was an ogg123 bug, but now that i remember it its
only on CFS i have it.. when i run multiple ogg123 instances, suddenly
they will just stop playing and lock up. This happens when someone
writes alot fast to me on kopete, where i use ogg123 to play a bling
sound..

> that 2.5 msecs latency in the ogg123 task was definitely the sign of a 
> kernel bug.
> 
> If plain WAKEUP_TIMING does not show anything suspicious, you can use 
> the latency tracer in more advanced ways as well to trace the whole 
> system and figure out the precise cause of your game latencies - i'll be 
> glad to help with that if no simpler measure helps. [see trace-it.c for 
> some of those details.]
> 
> > [...] As far as im concerned, i may be forced to unofficially maintain 
> > SD for my own systems(allthough lots in the gaming community is bound 
> > to be interrested, as it does make games lots better)
> 
> i'd encourage you to do it - in fact i already tried to prod Peter 
> Williams into doing exactly that ;) The more reality checks a scheduler 
> has, the better. [ Btw., after the obvious initial merging trouble it 
> should be much easier to keep SD maintained against future upstream 
> kernels due to the policy modularity that CFS introduces. (and which 
> policy-modularity should also help reduce the size and complexity of the 
> SD patch.) ]
> 
> Thanks,
> 
> 	Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

