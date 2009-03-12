Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZCLNiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZCLNiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbZCLNin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:38:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60678 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbZCLNim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:38:42 -0400
Date: Thu, 12 Mar 2009 09:38:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] ring-buffer: only allocate buffers for online cpus
In-Reply-To: <20090312162722.43B1.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0903120933400.3062@gandalf.stny.rr.com>
References: <20090312023720.144716747@goodmis.org> <20090312023936.696105567@goodmis.org> <20090312162722.43B1.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Mar 2009, KOSAKI Motohiro wrote:

> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: save on memory
> > 
> > Currently, a ring buffer was allocated for each "possible_cpus". On
> > some systems, this is the same as NR_CPUS. Thus, if a system defined
> > NR_CPUS = 64 but it only had 1 CPU, we could have possibly 63 useless
> > ring buffers taking up space. With a default buffer of 3 megs, this
> > could be quite drastic.
> > 
> > This patch changes the ring buffer code to only allocate ring buffers
> > for online CPUs.  If a CPU goes off line, we do not free the buffer.
> > This is because the user may still have trace data in that buffer
> > that they would like to look at.
> > 
> > Perhaps in the future we could add code to delete a ring buffer if
> > the CPU is offline and the ring buffer becomes empty.
> 
> I don't like this patch.
> your [1/4] and [2/4] already solve Pierre's problem.
> 
> using online cpu (not possible cpu) increase performance overhead 
> and messiness.
> but nobody get benefit ;)

Well, the fact that you can have 15 buffers for non existent CPUs is a big 
benefit. And the overhead was only on the read side, not the write, and 
very limited in overhead for that matter.

But, looking at this, I realized I can get rid of all the 
"get_online_cpus". I originally had the CPU_DOWN_PREPARE remove the 
buffer. But I found it highly annoying during tests, that I lose my data 
when I brought down a CPU. Thus, I removed the code to free the buffer and 
replaced it with the comment explaining this.

The get_online_cpus is to prevent the race where we might remove a buffer. 
But since we do not do that anymore, those get_online_cpus are pretty 
useless.

I'll update the code in a bit.

-- Steve

