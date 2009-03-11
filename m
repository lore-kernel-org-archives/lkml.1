Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZCKJOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZCKJOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 05:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZCKJOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 05:14:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54838 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZCKJOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 05:14:32 -0400
Date: Wed, 11 Mar 2009 18:13:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] cpuacct: per-cgroup utime/stime statistics - v1
Message-Id: <20090311181302.77c1de0b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090311085316.GA5592@in.ibm.com>
References: <20090310124208.GC3902@in.ibm.com>
	<20090311093812.298a0b21.kamezawa.hiroyu@jp.fujitsu.com>
	<20090311085316.GA5592@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 14:23:16 +0530
Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> On Wed, Mar 11, 2009 at 09:38:12AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Tue, 10 Mar 2009 18:12:08 +0530
> > Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> > 
> > > Hi,
> > > 
> > > Based on the comments received during my last post
> > > (http://lkml.org/lkml/2009/2/25/129), here is a fresh attempt
> > > to get per-cgroup utime/stime statistics as part of cpuacct controller.
> > > 
> > > This patch adds a new file cpuacct.stat which displays two stats:
> > > utime and stime. I wasn't too sure about the usefulness of providing
> > > per-cgroup guest and steal times and hence not including them here.
> > > 
> > > Note that I am using percpu_counter for collecting these two stats.
> > > Since percpu_counter subsystem doesn't protect the readside, readers could
> > > theoritically obtain incorrect values for these stats on 32bit systems.
> > 
> > Using percpu_counter_read() means that .. but is it okay to ignore "batch"
> > number ? (see FBC_BATCH)
> 
> I would think it might be ok with the understanding that read is not
> a frequent operation. The default value of percpu_counter_batch is 32.
> Ideally it should have been possible to set this value independently
> for each percpu_counter. That way, users could have chosen an appropriate
> batch value for their counter based on the usage pattern of their
> counters.
>
Hmm, in my point of view, stime/utime's unit is mili second and it's enough
big to be expected as "correct" value.
If read is not frequent, I love precise value.


> > 
> > 
> > > I hope occasional wrong values is not too much of a concern for
> > > statistics like this. If it is a problem, we have to either fix
> > > percpu_counter or do it all by ourselves as Kamezawa attempted
> > > for cpuacct.usage (http://lkml.org/lkml/2009/3/4/14)
> > > 
> > Hmm, percpu_counter_sum() is bad ?
> 
> It is slow and it doesn't do exactly what we want. It just adds the
> 32bit percpu counters to the global 64bit counter under lock and returns
> the result. But it doesn't clear the 32bit percpu counters after accummulating
> them in the 64bit counter.
> 
> If it is ok to be a bit slower on the read side, we could have something
> like percpu_counter_read_slow() which would do what percpu_counter_sum()
> does and in addition clear the 32bit percpu counters. Will this be
> acceptable ? It slows down the read side, but will give accurate count.
> This might slow down the write side also(due to contention b/n readers
> and writers), but I guess due to batching the effect might not be too
> pronounced. Should we be going this way ?
> 
I like precise one.  Maybe measuring overhead and comparing them and making a
decision is a usual way to go.
This accounting is once-a-tick event. (right?) So, how about measuring read-side
over head ?

> > 
> > BTW, I'm not sure but don't we need special handling if
> > CONFIG_VIRT_CPU_ACCOUNTING=y ?
> 
> AFAICS no. Architectures which define CONFIG_VIRT_CPU_ACCOUNTING end up calling
> account_{system,user}_time() where we have placed our hooks for
> cpuacct charging. So even on such architectures we should be able to
> get correct per-cgroup stime and utime.
> 
ok,

Thanks,
-Kame

