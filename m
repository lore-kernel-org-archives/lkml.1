Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYDEUiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYDEUiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 16:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYDEUiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 16:38:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:26936 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbYDEUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 16:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=A2QTV5BYzO00rWHO2UgoUXkOH0b2TG1+/gA/LRAdR5eepBezzgdYWA7+J5qimIUQsJ820WI3ZS4vvz99CM9sKKTM68+8zPLx9Ue3QrOt9A7L3kCyYSTmAf2EpnUwlXqInnsB8sWLmuyRfVObwXMwL3MluKyQgr/g3kTInwFFOtE=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm] [1/2] Simple stats for cpu resource controller
Date: Sun, 6 Apr 2008 02:01:52 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org, menage@google.com,
       a.p.zijlstra@chello.nl, balbir@in.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <200804052339.46632.balajirrao@gmail.com> <20080405194041.GB21279@linux.vnet.ibm.com>
In-Reply-To: <20080405194041.GB21279@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804060201.52726.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 April 2008 01:10:41 am Dhaval Giani wrote:
<snip>
> > 
> > +#ifdef CONFIG_CGROUP_SCHED
> > +enum cpu_cgroup_stat_index {
> > +	CPU_CGROUP_STAT_UTIME, /* Usertime of the task group */
> > +	CPU_CGROUP_STAT_STIME, /* Kerneltime of the task group */
> > +
> > +	CPU_CGROUP_STAT_NSTATS,
> 
> why the extra space?
Just to keep things clearly separated. If you've not noticed, 
CPU_CGROUP_STAT_NSTATS is not a stat.
> 
> > +};
> > +
> > +struct cpu_cgroup_stat_cpu {
> > +	s64 count[CPU_CGROUP_STAT_NSTATS];
> 
> u64? time does not go negative :)
Right. But these stats are not only going to measure time. We need the same 
variables for measuring other stats as well. I'm not sure if we would 
encounter scheduler stats that would count negative.

Balbir, what do you say ?

> count also is not very clear? Can you give a more descriptive name?
> 
ok. How does 'value' look  ?

<snip>

> > +static s64 cpu_cgroup_read_stat(struct cpu_cgroup_stat *stat,
> > +		enum cpu_cgroup_stat_index idx)
> > +{
> > +	int cpu;
> > +	s64 ret = 0;
> > +	unsigned long flags;
> 
> > +
> > +	local_irq_save(flags);
> 
> I am just wondering. Is local_irq_save() enough?
> 
Hmmm.. You are right.This does not prevent concurrent updates on other CPUs 
from crossing a 32bit boundary. Am not sure how to do this in a safe way. I 
can only think of using atomic64_t now..

> > +	for_each_possible_cpu(cpu)
> > +		ret += stat->cpustat[cpu].count[idx];
> > +	local_irq_restore(flags);
> > +
> > +	return ret;
> > +}
> > +

Thanks for the review.

-- 
regards,
Balaji Rao
Dept. of Mechanical Engineering,
National Institute of Technology Karnataka, India
