Return-Path: <linux-kernel-owner+w=401wt.eu-S1764475AbXFAUUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764475AbXFAUUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762851AbXFAUTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:19:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48571 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762537AbXFAUTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:19:53 -0400
Date: Fri, 1 Jun 2007 13:19:50 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: srinivasa@in.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vatsa@in.ibm.com, dino@in.ibm.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
Message-Id: <20070601131950.0f3a507b.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706011305230.3976@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com>
	<200706011620.05756.srinivasa@in.ibm.com>
	<Pine.LNX.4.64.0706011107540.2284@schroedinger.engr.sgi.com>
	<20070601121114.b165f1e8.pj@sgi.com>
	<Pine.LNX.4.64.0706011217510.3406@schroedinger.engr.sgi.com>
	<20070601124757.fe91a002.pj@sgi.com>
	<Pine.LNX.4.64.0706011249530.3598@schroedinger.engr.sgi.com>
	<20070601130212.7be4432a.pj@sgi.com>
	<Pine.LNX.4.64.0706011305230.3976@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There are no checks necessary. Your function worked fine so far for 
> the case of zero objects with the pointer returned by kmalloc. If the 
> code is correct then it will not dereference the pointer to the zero 
> sized array. If not then we may find a bug and fix it.

I suspect you got lucky.  The check for a full pidarray[] in the routine
pid_array_load() occurs -after- a pid is put in the array.  If a task
showed up in this cpuset at the wrong time, we would fall over and die
in the code:

static int pid_array_load(pid_t *pidarray, int npids, struct cpuset *cs)
{
        int n = 0;
        struct task_struct *g, *p;

        read_lock(&tasklist_lock);

        do_each_thread(g, p) {
                if (p->cpuset == cs) {
                        pidarray[n++] = p->pid;		/* Death if pidarray == NULL */
                        if (unlikely(n == npids))
                                goto array_full;
                }

        } while_each_thread(g, p);

Perhaps if you moved the "if (unlikely(n == npids))" test before the
"pidarray[n++] = p->pid" assignment, it would be safe.

And does the next line of code, the call to sort() after the call of
pid_array_load(), work with pidarray == NULL and npids == 0:

        npids = pid_array_load(pidarray, npids, cs);
        sort(pidarray, npids, sizeof(pid_t), cmppid, NULL);	/* <== ?? */

Off hand, I didn't know.  I guess it must, or you would have already
tripped over it.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
