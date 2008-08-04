Return-Path: <linux-kernel-owner+w=401wt.eu-S1763486AbYHDUn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763486AbYHDUn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYHDUnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:43:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46662 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbYHDUnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:43:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Champion <schamp@sgi.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080731170022.GE9663@sgi.com>
	<m1prot297c.fsf@frodo.ebiederm.org> <20080731193204.GG9663@sgi.com>
	<m1iqul25rk.fsf@frodo.ebiederm.org> <20080731200835.GK9663@sgi.com>
	<m1bq0d1zhz.fsf@frodo.ebiederm.org> <20080801120455.GP9663@sgi.com>
	<m1proszj3r.fsf@frodo.ebiederm.org> <20080801191336.GK10501@sgi.com>
	<m14p64zetj.fsf@frodo.ebiederm.org> <4896FFFE.7080400@sgi.com>
Date: Mon, 04 Aug 2008 13:36:38 -0700
In-Reply-To: <4896FFFE.7080400@sgi.com> (Stephen Champion's message of "Mon,
	04 Aug 2008 06:11:26 -0700")
Message-ID: <m17iawy0tl.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Champion <schamp@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on num_possible_cpus().
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Champion <schamp@sgi.com> writes:

> Despite more recent changes in proc_pid_readdir, my results should apply to
> current source.  It looks like both the old 2.6.16 implementation and the
> current version will call find_pid (or equivalent) once for each successive
> getdents() call on /proc, excepting when the cursor is on the first entry.  A
> quick look, and we have 88 getdents64() calls both 'ps' and 'ls /proc' with 29k
> processes running, which appears to be the primary source of calls.

Yes.  proc_pid_readdir->next_tgid->find_ge_pid does a hash table lookup.

> It's not giganormous, although I probably could come up with a pointless
> microbenchmark to show it's 300% better.  Importantly, it does noticeably
> improve normal interactive tools like 'ps' and 'top', a performance
> visualization tool developed by a customer (nodemon) refreshes faster.  For a
> 512k init allocation, that seems like a very good deal.

Alright.  The fact that it really is tools like ps and top that are proc intensive
shapes my opinion somewhat.  At it is doing lots and lots of hash tables lookups
so we can see each process that is expensive.  Rather then simple one at
a time lookups.

Hash table sizing gets us into a guessing game of how many pids do we expect
to deal with on this work load.  And we guess by either memory (how many hash
table entries can we afford) or cpu how many hash table entries can we expect.

There is an alternative to growing the hash table that I was playing
with at one time.  Use a radix tree that has essentially the same
properties for insert and delete as today's hash table. rcu for lookup
and a lock (spin lock?) for insert (memory allocation for the intermediate
nodes is the tricky bit).

Because pids are naturally dense we can accelerate the /proc accesses
by walking the radix tree and with a good implementation we only spend
as much memory as we have pids to worry about.

This is particular appealing to me in the context of pid namespaces.

I did not pursue it at the time I thought of it because I could not think
of a real workload that had enough pids to make the performance of the
current pid hash be noticable.  For our normal workload today my rough numbers
said the pid hash is optimal.

The interesting twist to this tale is that you have 29k processes, and
20k of them are kernel threads.  Which seems to say that it isn't user
space that is putting a heavy workloads on the pid infrastructure but
all of the per cpu kernel threads.

At only 9k processes we will have an average hash chain length of 2.25
which should perform well, as we have a good hash function and hash chain
lengths cluster well.  This is as opposed to the average hash chain length
of 7.25 which you are seeing now.

It looks to me like a cap of 64k is excessive we could place it down
at 16k (pid_hash_shift = 14) and your machines should perform well in
ps and top related activities, and it would only cost 128k.  If
you killed the excess kernel processes you could live very happily
with a 8k (pid_hash_shift = 13).

If we want something that tunes to the work load I expect a radix tree
would be best.  If the goal after 4k cpus is 64k cpus which I heard someone
mention I think that is what you really want.  A design that scales to
the workload on the system.

Eric
