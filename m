Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYHSJHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYHSJHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYHSJGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:06:50 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:55144 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYHSJGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:06:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIFAHQkqkhMRKxB/2dsb2JhbACBYrMUgVg
Date: Tue, 19 Aug 2008 05:06:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Fair low-latency rwlock v5
Message-ID: <20080819090645.GA1368@Krystal>
References: <20080816154330.GA5880@Krystal> <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org> <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org> <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080819073345.GA30285@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 04:52:05 up 75 days, 13:32,  6 users,  load average: 1.46, 1.37,
	0.97
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> [...]
> > The problem of this approach wrt RT kernels is that we cannot provide
> > enough "priority groups" (current irq, softirq and threads in mainline
> > kernel) for all the subtile priority levels of RT kernels. The more
> > groups we add, the less threads we allow on the system.
> > 
> > So basically, the relationship between the max number of threads (T) and
> > the number of reader priorities goes as follow on a 64 bits machine :
> > 
> > T writers subscribed count bits
> > 1 bit for writer mutex
> > 
> > for first priority group :
> > T reader count bits
> > (no need of reader exclusion bit because the writer subscribed count
> > bits and the writer mutex act as exclusion)
> > 
> > for each other priority group :
> > T reader count bits
> > 1 reader exclusion bit (set by the writer)
> > 
> > We have the inequality :
> > 
> > 64 >= (T + 1) + T + (NR_PRIORITIES - 1) * (T + 1)
> > 
> > 64 >= (2T + 1) + (NR_PRIORITIES - 1) * (T + 1)
> > 63 - 2T >= (NR_PRIORITIES - 1) * (T + 1)
> > ((63 - 2T) / (T + 1)) + 1 >= NR_PRIORITIES
> > 
> > Therefore :
> > 
> > Thread bits  |  Max number of threads  |  Number of priorities
> >   31         |    2147483648           |          1
> >   20         |       1048576           |          2
> >   15         |         32768           |          3
> >   12         |          4096           |          4
> >    9         |           512           |          5
> >    8         |           256           |          6
> >    7         |           128           |          7
> >    6         |            64           |          8
> >    5         |            32           |          9
> >    4         |            16           |         10
> >    3         |             8           |         15
> > 
> > Starting from here, we have more priority groups than threads in the
> > system, which becomes somewhat pointless... :)
> > 
> > So currently, for the mainline kernel, I chose 3 priority levels thread,
> > softirq, irq), which gives me 32768 max CPU in the system because I
> > choose to disable preemption. However, we can think of ways to tune that
> > in the direction we prefer. We could also hybrid those : having more
> > bits for some groups which have preemptable threads (for which we need
> > a max. of nr. threads) and less bits for other groups where preemption
> > is disabled (where we only need enough bits to cound NR_CPUS)
> > 
> > Ideas are welcome...
> > 
> > 
> 
> It strikes me that Intel has a nice (probably slow?) cmpxchg16b
> instruction on x86_64. Therefore, we could atomically update 128 bits,
> which gives the following table :
> 
> ((127 - 2T) / (T + 1)) + 1 >= NR_PRIORITIES
> 
> Thread bits  |  Max number of threads  |  Number of priorities
> 63           |            2^63         |            1
> 42           |            2^42         |            2
> 31           |            2^31         |            3
> 24           |            2^24         |            4
> 20           |            2^20         |            5
> 17           |          131072         |            6
> 15           |           32768         |            7
> 13           |            8192         |            8
> 11           |            2048         |            9
> 10           |            1024         |           10
> 9            |             512         |           11
> 8            |             256         |           13
> 7            |             128         |           15
> 6            |              64         |           17
> 5            |              32         |           20
> 4            |              16         |           24
> 
> .. where we have more priorities than threads.
> 
> So I wonder if having in the surrounding of 10 priorities, which could
> dynamically adapt the number of threads to the number of priorities
> available, could be interesting for the RT kernel ?
> 
> That would however depend on the very architecture-specific cmpxchg16b.
> 
> Mathieu
> 

Still thinking about RT :

The good news is : we don't really need all those bits to be updated
atomically. The bit groups which must be atomically updated are :

- Writer and first priority group
T writers subscribed count bits
1 bit for writer mutex
T reader count bits

- For each other priority group :
T reader count bits
1 reader exclusion bit (set by the writer)

I also noticed that the writer and the first reader priority group
happen to be at the same priority level. When the writer want to exclude
readers from higher priority groups, it must take their priority,
exclude them using the reader exclusion bit, wait for all readers of
that group to be out of their critical section and then proceed to the
next priority group until all the groups are locked.

The reader of the first priority group must check that both the writer
mutex and the writers subscribed count bits are not set.

The readers in the other groups only have to check the reader exclusion
bit associated to their own group.

So if we simplify the problem a bit for RT, let's fix a maximum of 32768
threads on the system (15 bits). Let's also assume we have 19
priorities.

- Writer and first priority group (fits in 31 bits)
15 bits for writers subscribed count
1 bit for writer mutex
15 bits reader count

Then we have an array of 18 : (each fit in 16 bits)
15 reader count bits
1 reader exclusion bit

Therefore, the whole data would fit in 40 bytes.

The only thing we would not have is the ability to do a single cmpxchg
on all the bits in the writer fast path, making the writer common case
much much slower.

However, the reader side would still be lightning-fast as it would only
have to do a cmpxchg on its own 16 or 32 bits bitfield.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
