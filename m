Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbZBZHwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbZBZHwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZBZHwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:52:24 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53033 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZBZHwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:52:24 -0500
Date: Thu, 26 Feb 2009 13:22:59 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 1/2] New cgroup subsystem API (->initialize())
Message-ID: <20090226075259.GA3312@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090225105730.GA4008@in.ibm.com> <20090225105831.GB4008@in.ibm.com> <49A604BA.9090407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A604BA.9090407@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 10:55:54AM +0800, Li Zefan wrote:
> Bharata B Rao wrote:
> > From: Balaji Rao <balajirrao@gmail.com>
> > 
> > cgroup: Add ->initialize() to cgroup_subsys structure
> > 
> > Some cgroup subsystems (like cpu controller) would need subsystem
> > specific initialization. Such subsystems can define ->initialize()
> > which gets called during cgroup_init() (and not cgroup_init_early()).
> > 
> 
> I think it's better to avoid adding this.
> 
> It would be best if we can add a hook to initialize init_task_group.stat where
> kmalloc is available but acount_xxx_time() hasn't been called. Otherwise, we
> have to check (tg->stat == NULL) in account_task_group_time(), then why not add
> a hook in smp_init_smp() to do initialization?

account_xxx_time() is called from scheduler ticks and AFAICS they end up
getting called much before kmalloc is available. In any case, I would think
any hook to just initialize stats for init_task_group would be
very very (cpu controller) subsytem specific. Isn't that bad ?

Another solution I see which can prevent all this is not to collect
stats for init_task_group at all with the understanding that system wide
stime/utime accounting (which is already present) is essentially the
accounting for init_task_group because init_task_group comprises of all
the tasks in the system. But this would necessiate us to make collection
of cpu controller stats hierarchial. This was one of the questions I asked
in my 0/2 thread. Shouldn't we be doing hierarchial accounting for
cpu controller ?

Another thing that could be done is to enhance already existing
cpuacct controller to do stime/utime accouting also. cpuacct controller
exists precisely for doing per-cgroup accounting and is there any reason
why these stats shouldn't be part of cpuacct controller. If we do this,
users would be forced to use cpu controller and cpuacct controller
together. Is that a problem ?

Regards,
Bharata.
