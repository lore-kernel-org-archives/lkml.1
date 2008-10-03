Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYJCR1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYJCR1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYJCR1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:27:21 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:55395 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbYJCR1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:27:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEANjt5UhMQWq+/2dsb2JhbACBcbpWgWg
Date: Fri, 3 Oct 2008 13:21:43 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>, colpatch@us.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] x86 Topology cpu_to_node parameter check
Message-ID: <20081003172143.GA7733@Krystal>
References: <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu> <20081002090517.GA8708@elte.hu> <20081002093835.GA17699@elte.hu> <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com> <20081003045607.GA5940@Krystal> <alpine.DEB.1.10.0810030117280.26504@gandalf.stny.rr.com> <20081003155605.GC1607@Krystal> <alpine.DEB.1.10.0810031223060.26504@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810031223060.26504@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:15:17 up 120 days, 21:55,  5 users,  load average: 0.39, 0.45,
	0.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Fri, 3 Oct 2008, Mathieu Desnoyers wrote:
> > 
> > That's how I did it first, but then I looked at asm-generic/topology.h
> > and have seen it uses #defines. Should we change them too ?
> > 
> 
> The old way of doing this is with defines. But all new code should be 
> static inline functions when feasible. This way we can get typechecking 
> on the parameters even when the configuration is disabled.
> 
> Even if the rest of the file uses defines, the new code should be
> static inlines. Eventually, even the old defines will be converted.
> 
> -- Steve
> 

Argh, I think topology.h is utterly broken :-(

Have you noticed the subtile interaction between the

include/asm-x86/topology.h :

#define numa_node_id()          0
#define cpu_to_node(cpu)        0
#define early_cpu_to_node(cpu)  0
...
#include <asm-generic/topology.h>


and
include/asm-generic/topology.h :
#ifndef cpu_to_node
#define cpu_to_node(cpu)        ((void)(cpu),0)
#endif

If any architecture decide for some reason to use a static inline rather
than a define, as currently done with node_to_first_cpu :

include/asm-x86/topology.h :
static inline int node_to_first_cpu(int node)
{
        return first_cpu(cpu_online_map);
}
...
#include <asm-generic/topology.h>

include/asm-generic/topology.h :
#ifndef node_to_first_cpu
#define node_to_first_cpu(node) ((void)(node),0)
#endif

(which will override the static inline !)

It results in an override of the arch-specific version. Nice eh ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
