Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbXJWVqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbXJWVqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXJWVqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:46:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36072 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752597AbXJWVqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:46:19 -0400
Date: Tue, 23 Oct 2007 14:46:15 -0700
From: Paul Jackson <pj@sgi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: menage@google.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, mingo@elte.hu, dmitry.adamushko@gmail.com,
       ghaskins@novell.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH -v2 4/7] RT overloaded runqueues accounting
Message-Id: <20071023144615.89ed9c86.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.58.0710230844040.29506@gandalf.stny.rr.com>
References: <20071023025900.927578809@goodmis.org>
	<20071023032916.651749224@goodmis.org>
	<20071022211709.7be79fea.pj@sgi.com>
	<6599ad830710222311x402c3d1agcc458742fb5e219c@mail.gmail.com>
	<Pine.LNX.4.58.0710230844040.29506@gandalf.stny.rr.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven wrote:
> Ingo Molnar and Peter Zijlstra pointed out to me that this global cpumask
> would kill performance on >64 CPU boxes due to cacheline bouncing. To
> solve this issue, I placed the RT overload mask into the cpusets.

This feels rather like sched domains to me (which I can't claim
to understand very well.)  That is, you need to subdivide the
overload masks, so as to avoid contention on a single mask in a
large system, making the tradeoff that you will sometimes resolve
overloads less aggressively.

With sched domains, we added cpuset code, that is only called in the
infrequent event that the cpusets are reconfigured, to update the
kernel's sched domains.  It hasn't been easy code, but at least the
main line scheduler code paths remain oblivious to cpusets.

Can you create "RT domains", each with their own overload mask?
Perhaps even attach the overload masks to the existing sched domains?

The essential approach here, as with all things involving cpusets and
the scheduler, is to not have the scheduler code access cpusets, but
rather to have the scheduler code have its own controlling data
structures, which it can access with locking suitable to its fast path
requirements, and then have the cpuset code ~~delicately~~ update those
structures on the infrequent occassion that something changes in the
cpuset configuration.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
