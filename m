Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbXJWGHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbXJWGHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXJWGHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:07:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15041 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbXJWGHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:07:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Chk3y1MZZwvrWqcN6gBLcRBQVM7N0f/fF7risoLFzj74lLnNYWoIzO2mHBLHQRDbL
	2LJsjx7GL9Oc/c4tvCgQQ==
Message-ID: <6599ad830710222306m6a3e3f52k4daf501836c05274@mail.gmail.com>
Date: Mon, 22 Oct 2007 23:06:54 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071023024036.GC3324@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471D4523.4040509@google.com>
	 <20071023024036.GC3324@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> On Mon, Oct 22, 2007 at 05:49:39PM -0700, Paul Menage wrote:
> > +static u64 cpu_usage_read(struct cgroup *cgrp, struct cftype *cft)
> > +{
> > +     struct task_group *tg = cgroup_tg(cgrp);
> > +     int i;
> > +     u64 res = 0;
> > +     for_each_possible_cpu(i) {
> > +             unsigned long flags;
> > +             spin_lock_irqsave(&tg->cfs_rq[i]->rq->lock, flags);
>
> Is the lock absolutely required here?

I'm not sure, I was hoping you or Ingo could comment on this. But some
kind of locking seems to required at least on 32-bit platforms, since
sum_exec_runtime is a 64-bit number.

>
> Hmm .. I hope the cgroup code prevents a task group from being destroyed while
> we are still reading a task group's cpu usage. Is that so?

Good point - cgroups certainly prevents a cgroup itself from being
freed while a control file is being read in an RCU section, and
prevents a task group from being destroyed when that task group has
been read via a task's cgroups pointer and the reader is still in an
RCU section, but we need a generic protection for subsystem state
objects being accessed via control files too.

Using cgroup_mutex is certainly possible for now, although more
heavy-weight than I'd like long term. Using css_get isn't the right
approach, I think - we shouldn't be able to cause an rmdir to fail due
to a concurrent read.

Paul
