Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYHDNNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYHDNNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYHDNNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:13:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47423 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752529AbYHDNNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:13:31 -0400
Message-ID: <4896FFFE.7080400@sgi.com>
Date: Mon, 04 Aug 2008 06:11:26 -0700
From: Stephen Champion <schamp@sgi.com>
Organization: Silicon Graphics, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on num_possible_cpus().
References: <20080731170022.GE9663@sgi.com>	<m1prot297c.fsf@frodo.ebiederm.org> <20080731193204.GG9663@sgi.com>	<m1iqul25rk.fsf@frodo.ebiederm.org> <20080731200835.GK9663@sgi.com>	<m1bq0d1zhz.fsf@frodo.ebiederm.org> <20080801120455.GP9663@sgi.com>	<m1proszj3r.fsf@frodo.ebiederm.org> <20080801191336.GK10501@sgi.com> <m14p64zetj.fsf@frodo.ebiederm.org>
In-Reply-To: <m14p64zetj.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Robin Holt <holt@sgi.com> writes:
>> Oops, confusing details.  That was a different problem we had been
>> tracking.
> 
> Which leads back to the original question.  What were you measuring
> that showed improvement with a larger pid hash size?
> 
> Almost by definition a larger hash table will perform better.  However
> my intuition is that we are talking about something that should be in
> the noise for most workloads.

Robin asked me to chime in on this, as I did the early "look at that" 
work and suggested it to Robin.

I noticed the potential for increasing pid_shift while chasing down a 
patch to our kernel (2.6.16 stable based) which had proc_pid_readdir() 
calling find_pid() for init_task through the highest pid #.  This patch 
caused a rather serious problem on a 2048 core Altix.  Before 
identifying the culprit, I increased pidhash_shift.  This made a *huge* 
difference: enough to get the box marginally functional while I tracked 
down the origins of the problem.

After backing out the problematic patch, I took a look at pidhash_shift 
in normal circumstances:  With pidhash_shift == 12, running only a few 
common services and monitoring tools (sendmail, nagios, etc for ~28k 
active processes, mostly of the kernel variety), the 20 cpu boot cpuset 
we use on that system to confine normal system processes and interactive 
logins was spending >1% of it's time in find_pid(), and an 'ls /proc > 
/dev/null' took >0.4s.  With pidhash_shift == 16, the timing went to 
<0.2, and the total time spent in find_pid() was reduced to noise level.

In addition to raising the limit on larger systems, it looked reasonable 
to scale the pid hash with the # processors instead of memory.  While I 
observed variably high process:cpu ratios on small systems (2c - 32c), 
they also have relatively few processes.  The 192c - 2048c systems I was 
able to look at were all hovering at 13 +/- 2 processes per cpu, even 
with wildly varying memory sizes.

Despite more recent changes in proc_pid_readdir, my results should apply 
to current source.  It looks like both the old 2.6.16 implementation and 
the current version will call find_pid (or equivalent) once for each 
successive getdents() call on /proc, excepting when the cursor is on the 
first entry.  A quick look, and we have 88 getdents64() calls both  'ps' 
and 'ls /proc' with 29k processes running, which appears to be the 
primary source of calls.

It's not giganormous, although I probably could come up with a pointless 
microbenchmark to show it's 300% better.  Importantly, it does 
noticeably improve normal interactive tools like 'ps' and 'top', a 
performance visualization tool developed by a customer (nodemon) 
refreshes faster.  For a 512k init allocation, that seems like a very 
good deal.


I'd like to lose 20,000 kernel processes in addition to growing the pid 
hash!
