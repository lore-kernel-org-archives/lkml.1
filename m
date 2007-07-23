Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbXGWMCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbXGWMCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXGWMCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:02:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42790 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbXGWMCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:02:40 -0400
Date: Mon, 23 Jul 2007 14:02:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Ni@m" <niam.niam@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sound is interrupting with new kernels
Message-ID: <20070723120233.GA28222@elte.hu>
References: <a9e22dff0707211510o3b5e108dk354f5f15ad3ba498@mail.gmail.com> <6bffcb0e0707221716k67815a2ai7f35606b1effa6a3@mail.gmail.com> <a9e22dff0707222125i49adade7seea63f12672aa701@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9e22dff0707222125i49adade7seea63f12672aa701@mail.gmail.com>
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


* Ni@m <niam.niam@gmail.com> wrote:

> >Please run this script while using mplayer or audacious
> >http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> >and send results
> >
> I did it anyway ... see the attachment. The script has been running
> while mplayer has been running and sound has been interrupting.

firstly, could you check whether the ogg123/mpg321 console apps work 
without any audio skipping? If they work fine, does Amarok work fine? 
(Amarok is an X apps that has a high-quality latency design - most other 
X based players are affected by X communication latencies.)

Can you see any ALSA xruns related to any of the apps that skips sound? 
For that, first enable CONFIG_SND_DEBUG and CONFIG_SND_PCM_XRUN_DEBUG 
and reboot into such an xrun-debug enabled kernel. Once you have booted 
into it, you should see the xrun_debug flag of your audio driver, under 
/proc/asound/card*/pcm*/xrun_debug. Do something like this:

   echo 1 > /proc/asound/card0/pcm0p/xrun_debug

can you see any ALSA xruns reported to the syslog at the same time the 
audio apps are skipping?

Plus if any of the above apps causes audio skipping then to further 
debug this, could you try the latency tracer:

 http://redhat.com/~mingo/latency-tracing-patches/latency-tracing-v2.6.23-rc1-combo.patch

apply the combo patch to v2.6.23-rc1, enable CONFIG_WAKEUP_TIMING and 
CONFIG_FUNCTION_TRACING, boot into the new kernel and do this to start 
the latency tracer:

  echo 0 > /proc/sys/kernel/preempt_max_latency

you should start seeing such messages in the syslog:

 (            sshd-2254 |#1): new 2 us maximum-latency wakeup.
 (           sleep-2310 |#0): new 4 us maximum-latency wakeup.
 (          auditd-1856 |#1): new 6 us maximum-latency wakeup.
 (          auditd-1857 |#0): new 9 us maximum-latency wakeup.
 (       kjournald-1455 |#1): new 10 us maximum-latency wakeup.
 (              ls-2318 |#1): new 11 us maximum-latency wakeup.
 (       kjournald-623  |#1): new 15 us maximum-latency wakeup.
 (            bash-2324 |#1): new 15 us maximum-latency wakeup.
 (       kjournald-623  |#1): new 50 us maximum-latency wakeup.
 (        events/0-9    |#0): new 262 us maximum-latency wakeup.

it will increase monotonically - always showing the worst-case latency 
it detected. What kind of numbers do you get, while the sound is 
skipping? If it's in the milliseconds, then wakeup latencies could be 
the cause of your sound skipping. Send the contents of the 
/proc/latency_trace file in that case.

( if the reported latencies are low, but sound is skipping too and ALSA 
  reports xrun, then we can use the tracer to debug audio latencies 
  directly as well, but that will need an extra patch. )

	Ingo
