Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbZFBQ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbZFBQ2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZFBQ2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:28:07 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:64177 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZFBQ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:28:07 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:perfcounters/core] perf_counter: Use PID namespaces
 properly
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       acme@redhat.com, paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, efault@gmx.de, ebiederm@xmission.com,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090602154816.GA15734@redhat.com>
References: <tip-709e50cf870e61745b39552044aa6c7c38e4f9e0@git.kernel.org>
	 <20090602154816.GA15734@redhat.com>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 18:28:05 +0200
Message-Id: <1243960085.13761.190.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 17:55 +0200, Oleg Nesterov wrote:
> On 06/02, tip-bot for Peter Zijlstra wrote:
> >
> > +static u32 perf_counter_pid(struct perf_counter *counter, struct task_struct *p)
> > +{
> > +	/*
> > +	 * only top level counters have the pid namespace they were created in
> > +	 */
> > +	if (counter->parent)
> > +		counter = counter->parent;
> > +
> > +	return task_tgid_nr_ns(p, counter->ns);
> > +}
> > +
> > +static u32 perf_counter_tid(struct perf_counter *counter, struct task_struct *p)
> > +{
> > +	/*
> > +	 * only top level counters have the pid namespace they were created in
> > +	 */
> > +	if (counter->parent)
> > +		counter = counter->parent;
> > +
> > +	return task_pid_nr_ns(p, counter->ns);
> 
> Perhaps this should be
> 
> 	return task_pid_nr_ns(p->group_leader);
> 
> ?

That seems to be exactly what task_tgid_nr_ns() does.

so  pid = task->group_leader->pids[PIDTYPE_PID].pid
and tid = task->pids[PIDTYPE_PID].pid

> > +		tid_entry.pid = perf_counter_pid(counter, current);
> > +		tid_entry.tid = perf_counter_tid(counter, current);
> 
> 
> Otherwise we seem to always report .pid == .tid

tgid vs pid, I don't think they end up being equal. Are they?

