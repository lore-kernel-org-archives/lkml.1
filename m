Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYKZW12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYKZW12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYKZW1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:27:20 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:43998 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752248AbYKZW1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:27:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAH9YLUlMROB9/2dsb2JhbACBbdFpgn0
Date: Wed, 26 Nov 2008 17:27:15 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew McDermott <andrew.mcdermott@windriver.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       ltt-dev@lists.casi.polymtl.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [ltt-dev] [PATCH] Poll : introduce poll_wait_exclusive() new
	function
Message-ID: <20081126222714.GA10981@Krystal>
References: <20081124205512.26C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081124121659.GA18987@Krystal> <20081125194700.26EB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.1.10.0811251316590.32523@alien.or.mcafeemobile.com> <20081126111511.GE14826@Krystal> <v4skpeent3.fsf@swi-aim.swindon.wrsec.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <v4skpeent3.fsf@swi-aim.swindon.wrsec.fr>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:24:12 up 9 days, 23:04,  1 user,  load average: 0.86, 0.61,
	0.62
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew McDermott (andrew.mcdermott@windriver.com) wrote:
> 
> Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:
> 
> [...]
> 
> >> > Mathieu Desnoyers explained it cause following problem to LTTng.
> >> > 
> >> >    In LTTng, all lttd readers are polling all the available debugfs files
> >> >    for data. This is principally because the number of reader threads is
> >> >    user-defined and there are typical workloads where a single CPU is
> >> >    producing most of the tracing data and all other CPUs are idle,
> >> >    available to consume data. It therefore makes sense not to tie those
> >> >    threads to specific buffers. However, when the number of threads grows,
> >> >    we face a "thundering herd" problem where many threads can be woken up
> >> >    and put back to sleep, leaving only a single thread doing useful work.
> >> 
> >> Why do you need to have so many threads banging a single device/file?
> >> Have one (or any other very little number) puller thread(s), that 
> >> activates with chucks of pulled data the other processing threads. That 
> >> way there's no need for a new wakeup abstraction.
> >> 
> >> 
> >> 
> >> - Davide
> >
> > One of the key design rule of LTTng is to do not depend on such
> > system-wide data structures, or entity (e.g. single manager thread).
> > Everything is per-cpu, and it does scale very well.
> >
> > I wonder how badly the approach you propose can scale on large NUMA
> > systems, where having to synchronize everything through a single thread
> > might become an important point of contention, just due to the cacheline
> > bouncing and extra scheduler activity involved.
> 
> But at the end of the day these threads end up writing to the (possibly)
> single spindle.  Isn't that the biggest bottlneck here?
> 

Not if those threads are either

- analysing the data on-the-fly without exporting it to disk
- sending the data through more than one network card
- Writing data to multiple disks

There are therefore ways to improve scalability by adding more data
output paths. Therefore, I don't want to limit scalability due to the
inner design, so that if someone has the resources to send the
information out at great speed scaleably, he can.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
