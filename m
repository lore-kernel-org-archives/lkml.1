Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbYKZLP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbYKZLP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYKZLPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:15:17 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:54224 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954AbYKZLPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:15:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQFANq9LElMROB9/2dsb2JhbACBbdEKgn0
Date: Wed, 26 Nov 2008 06:15:11 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, ltt-dev@lists.casi.polymtl.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [ltt-dev] [PATCH] Poll : introduce poll_wait_exclusive() new
	function
Message-ID: <20081126111511.GE14826@Krystal>
References: <20081124205512.26C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081124121659.GA18987@Krystal> <20081125194700.26EB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.1.10.0811251316590.32523@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811251316590.32523@alien.or.mcafeemobile.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 06:06:50 up 9 days, 11:47,  1 user,  load average: 0.46, 0.44,
	0.42
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Davide Libenzi (davidel@xmailserver.org) wrote:
> On Tue, 25 Nov 2008, KOSAKI Motohiro wrote:
> 
> > 
> > patch againt: tip/tracing/marker
> > 
> > ==========
> > Currently, wake_up() function behavior depend on the way of
> > wait queue adding function.
> > 
> > 
> >                               wake_up()          wake_up_all()
> > ---------------------------------------------------------------
> > add_wait_queue()              wake up all        wake up all
> > add_wait_queue_exclusive()    wake up one task   wake up all
> > 
> > 
> > Unforunately, poll_wait() always use add_wait_queue().
> > it means there is no way that wake up only one process in polled processes.
> > wake_up() also wake up all sleeping processes, not 1 process.
> > 
> > 
> > Mathieu Desnoyers explained it cause following problem to LTTng.
> > 
> >    In LTTng, all lttd readers are polling all the available debugfs files
> >    for data. This is principally because the number of reader threads is
> >    user-defined and there are typical workloads where a single CPU is
> >    producing most of the tracing data and all other CPUs are idle,
> >    available to consume data. It therefore makes sense not to tie those
> >    threads to specific buffers. However, when the number of threads grows,
> >    we face a "thundering herd" problem where many threads can be woken up
> >    and put back to sleep, leaving only a single thread doing useful work.
> 
> Why do you need to have so many threads banging a single device/file?
> Have one (or any other very little number) puller thread(s), that 
> activates with chucks of pulled data the other processing threads. That 
> way there's no need for a new wakeup abstraction.
> 
> 
> 
> - Davide

One of the key design rule of LTTng is to do not depend on such
system-wide data structures, or entity (e.g. single manager thread).
Everything is per-cpu, and it does scale very well.

I wonder how badly the approach you propose can scale on large NUMA
systems, where having to synchronize everything through a single thread
might become an important point of contention, just due to the cacheline
bouncing and extra scheduler activity involved.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
