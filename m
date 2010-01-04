Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144Ab0ADAip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0ADAip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 19:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514Ab0ADAin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 19:38:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43233 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0ADAim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 19:38:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 4 Jan 2010 09:35:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-Id: <20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100104000752.GC16187@balbir.in.ibm.com>
References: <20091229182743.GB12533@balbir.in.ibm.com>
	<20100104085108.eaa9c867.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104000752.GC16187@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010 05:37:52 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-04 08:51:08]:
> 
> > On Tue, 29 Dec 2009 23:57:43 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > Hi, Everyone,
> > > 
> > > I've been working on heuristics for shared page accounting for the
> > > memory cgroup. I've tested the patches by creating multiple cgroups
> > > and running programs that share memory and observed the output.
> > > 
> > > Comments?
> > 
> > Hmm? Why we have to do this in the kernel ?
> >
> 
> For several reasons that I can think of
> 
> 1. With task migration changes coming in, getting consistent data free of races
> is going to be hard.

Hmm, Let's see real-worlds's "ps" or "top" command. Even when there are no guarantee
of error range of data, it's still useful.

> 2. The cost of doing it in the kernel is not high, it does not impact
> the memcg runtime, it is a request-response sort of cost.
>
> 3. The cost in user space is going to be high and the implementation
> cumbersome to get right.
>  
I don't like moving a cost in the userland to the kernel. Considering 
real-time kernel or full-preemptive kernel, this very long read_lock() in the
kernel is not good, IMHO. (I think css_set_lock should be mutex/rw-sem...)
cgroup_iter_xxx can block cgroup_post_fork() and this may cause critical
system delay of milli-seconds.

BTW, if you really want to calculate somthing in atomic, I think following
interface may be welcomed for freezing.

  cgroup.lock
  # echo 1 > /...../cgroup.lock 
    All task move, mkdir, rmdir to this cgroup will be blocked by mutex.
    (But fork/exit will not be blocked.)

  # echo 0 > /...../cgroup.lock
    Unlock.

  # cat /...../cgroup.lock
    show lock status and lock history (for debug).

Maybe good for some kinds of middleware.
But this may be difficult if we have to consider hierarchy.

Thanks,
-Kame



