Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab0BYFdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 00:33:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0BYFdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 00:33:18 -0500
Date: Thu, 25 Feb 2010 16:33:10 +1100
From: Nick Piggin <npiggin@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [RFC patch] introduce sys_membarrier(): process-wide memory
 barrier (v9)
Message-ID: <20100225053310.GA9738@laptop>
References: <20100212224606.GA30280@Krystal>
 <4B82CF1A.3010501@nortel.com>
 <20100222212321.GA2573@Krystal>
 <20100224091052.GY9738@laptop>
 <20100224152251.GA16295@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224152251.GA16295@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 10:22:52AM -0500, Mathieu Desnoyers wrote:
> * Nick Piggin (npiggin@suse.de) wrote:
> > On Mon, Feb 22, 2010 at 04:23:21PM -0500, Mathieu Desnoyers wrote:
> > > * Chris Friesen (cfriesen@nortel.com) wrote:
> > > > On 02/12/2010 04:46 PM, Mathieu Desnoyers wrote:
> > > > 
> > > > > Editorial question: 
> > > > > 
> > > > > This synchronization only takes care of threads using the current process memory
> > > > > map. It should not be used to synchronize accesses performed on memory maps
> > > > > shared between different processes. Is that a limitation we can live with ?
> > > > 
> > > > It makes sense for an initial version.  It would be unfortunate if this
> > > > were a permanent limitation, since using separate processes with
> > > > explicit shared memory is a useful way to mitigate memory trampler issues.
> > > > 
> > > > If we were going to allow that, it might make sense to add an address
> > > > range such that only those processes which have mapped that range would
> > > > execute the barrier.  Come to think of it, it might be possible to use
> > > > this somehow to avoid having to execute the barrier on *all* threads
> > > > within a process.
> > > 
> > > The extensible system call mandatory and optional flags will allow this kind of
> > > improvement later on if this appears to be needed. It will also allow user-space
> > > to detect if later kernels support these new features or not. But meanwhile I
> > > think it's good to start with this implementation that covers 99.99% of
> > > use-cases I can currently think of (ok, well, maybe I'm just unimaginative) ;)
> > 
> > It's a good point, I think having at least the ability to do
> > process-shared or process-private in the first version of the API might
> > be a good idea. That matches glibc's synchronisation routines so it
> > would probably be a desirable feature even if you don't implement it in
> > your library initially.
> 
> I am tempted to say that we should probably wait for users of this API feature
> to manifest themselves before we go on and implement it. This will ensure that
> we don't end up maintaining an unused feature and this provides a minimum
> testability. For now, returning -EINVAL seems like an appropriate response for
> this system call feature.

It would be very trivial compared to the process-private case. Just IPI
all CPUs. It would allow older kernels to work with newer process based
apps as they get implemented. But... not a really big deal I suppose.


> As I said above, given the exensible nature of the sys_membarrier flags, we can
> assign a MEMBARRIER_SHARED_MEM or something like that to a mandatory flag bit
> later on. So when userspace start using this flag on old kernels that do not
> support it, -EINVAL will be returned, and then the application will know it must
> use a fallback. So, basically, we don't even need to define this flag now.
> 
> > 
> > When writing multiprocessor scalable software, threads should often be
> > avoided. They share so much state that it is easy to run into
> > scalability issues in the kernel. So yes it would be really nice to
> > have userspace RCU available in a process-shared mode.
> > 
> 
> Agreed, although some major modifications would also be needed in the userspace
> RCU library to do that, because it currently rely on being able to access other
> thread's TLS.

OK. It would be a good feature to keep in mind, I believe.

