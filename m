Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbYB2FtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbYB2FtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbYB2FtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:49:07 -0500
Received: from smtp-out.google.com ([216.239.33.17]:55329 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbYB2FtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:49:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VH6a33uqGD8UNqMHY0kvGCLkTVOxy6aFGQT7IjnrQVtHyy8yxWfT3PADJCO5wKfPE
	1w6jZQun41qHZ3t8FRutw==
Message-ID: <6599ad830802282148g7f309995l450fc15074234cd7@mail.gmail.com>
Date: Thu, 28 Feb 2008 21:48:51 -0800
From: "Paul Menage" <menage@google.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: [patch 2/2] sched: allow cpuacct stats to be reset
Cc: vatsa@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
In-Reply-To: <20080229043751.555866685@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080229043242.110741439@linux.vnet.ibm.com>
	 <20080229043751.555866685@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 8:32 PM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> Currently the schedstats implementation does not allow the statistics
>  to be reset. This patch aims to allow that.
>
>  echo 0 > cpuacct.usage
>
>  resets the usage. Any other value is not allowed and returns -EINVAL.
>
>  Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
>
>  ---
>   kernel/sched.c |   24 ++++++++++++++++++++++++
>   1 files changed, 24 insertions(+)
>
>  Index: linux-2.6/kernel/sched.c
>  ===================================================================
>  --- linux-2.6.orig/kernel/sched.c       2008-02-28 20:05:27.000000000 +0530
>  +++ linux-2.6/kernel/sched.c    2008-02-28 20:05:30.000000000 +0530
>  @@ -8243,10 +8243,34 @@ static u64 cpuusage_read(struct cgroup *
>         return totalcpuusage;
>   }
>
>  +static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
>  +                                                               u64 reset)
>  +{
>  +       struct cpuacct *ca = cgroup_ca(cgrp);
>  +       int err = 0;
>  +       int i;
>  +
>  +       if (reset) {
>  +               err = -EINVAL;
>  +               goto out;
>  +       }
>  +
>  +       for_each_possible_cpu(i) {
>  +               u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
>  +
>  +               spin_lock_irq(&cpu_rq(i)->lock);
>  +               *cpuusage = 0;
>  +               spin_unlock_irq(&cpu_rq(i)->lock);
>  +       }
>  +out:
>  +       return err;
>  +}
>  +
>   static struct cftype files[] = {
>         {
>                 .name = "usage",
>                 .read_uint = cpuusage_read,
>  +               .write_uint = cpuusage_write,
>         },
>   };
>

Can I suggest, in order to be more generic, that this patch instead
set each CPU's counter to the written value divided by the number of
CPUs? (Either forgetting the remainder, or spreading it among the
first few CPUs).

Paul
