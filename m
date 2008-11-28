Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYK1NNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYK1NNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYK1NNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:13:14 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:57964 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbYK1NNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:13:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAA97L0lMROB9/2dsb2JhbACBbc8+gn0
Date: Fri, 28 Nov 2008 08:13:11 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, ltt-dev@lists.casi.polymtl.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [ltt-dev] [PATCH] Poll : introduce poll_wait_exclusive() new
	function
Message-ID: <20081128131311.GC10401@Krystal>
References: <20081124205512.26C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081124121659.GA18987@Krystal> <20081125194700.26EB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.1.10.0811251316590.32523@alien.or.mcafeemobile.com> <20081126111511.GE14826@Krystal> <alpine.DEB.1.10.0811261559180.11771@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811261559180.11771@alien.or.mcafeemobile.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:05:20 up 11 days, 13:45,  2 users,  load average: 0.25, 0.54,
	0.64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Davide Libenzi (davidel@xmailserver.org) wrote:
> On Wed, 26 Nov 2008, Mathieu Desnoyers wrote:
> 
> > One of the key design rule of LTTng is to do not depend on such
> > system-wide data structures, or entity (e.g. single manager thread).
> > Everything is per-cpu, and it does scale very well.
> > 
> > I wonder how badly the approach you propose can scale on large NUMA
> > systems, where having to synchronize everything through a single thread
> > might become an important point of contention, just due to the cacheline
> > bouncing and extra scheduler activity involved.
> 
> I dunno the LTT architecture, so I'm staying out of that discussion.
> But, if the patch you're trying to push is to avoid thundering herd of so 
> many threads waiting on the single file*, you've got the same problem 
> right there. You've got at least the spinlock protecting the queue 
> where these threads are focusing, whose cacheline is bounced gets bounced 
> all over the CPUs.
> Do you have any measure of the improvements that such poll_wait_exclusive()
> will eventually lead to?
> 

Nope, sorry, I don't own any machine with such huge amount of CPUs,
therefore I can't afford to test that scalability level.

You say that "You've got at least the spinlock protecting the queue
where these threads are focusing", you assume we stay limited to the
current implementation inability to scale correctly. We could think of a
scheme with :

- Per cpu waiters. Waiters are added to their own CPU waiting list.
- Per cpu wakeups, where the wakeup will try to wake up a waiter on the
  local CPU first.

If there happens to be no waiters for a local CPU wakeup, the wakeup
would then be broadcasted to other CPUs, which involves proper locking
which I think could be done pretty efficiently so we don't hurt the "add
waiter" fastpath.

By doing this, we could end up not even taking a global spinlock in the
add waiter/wakeup fastpaths. So then we would have fixed both the
thundering herd problem _and_ the global spinlock issue altogether.

Any thought ?

Mathieu

> 
> 
> - Davide
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
