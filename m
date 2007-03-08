Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbXCHRpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbXCHRpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXCHRpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:45:45 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49210 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbXCHRpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:45:44 -0500
Date: Thu, 8 Mar 2007 23:22:33 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 3/7] containers (V7): Add generic multi-subsystem API to containers
Message-ID: <20070308175233.GK6504@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.485337000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085104.485337000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:15:24AM -0800, menage@google.com wrote:
> +static struct container_group *find_container_group(
> +	struct container_group *oldcg, struct container *cont)
> +{
> +	struct container_group *res;
> +	struct container_subsys *ss;
> +	int h = cont->hierarchy;
> +	int i;
> +
> +	BUG_ON(oldcg->container[h] == cont);
> +	/* First see if we already have a container group that matches
> +	 * the desired set */
> +	spin_lock(&container_group_lock);

I think this should be spin_lock_irq().

I have been bitten by lockdep warning in the rcfs patchs. But I think
they should apply here as well.

Essentially, container_task_count() is called from cpuset.c after doing
write_lock_irq(tasklist_lock). This creates the dependency:

	tasklist_lock (irqs disabled)  -> container_group_lock

However in above function, find_container_group (and several other
functions) we take container_group_lock w/o blocking interrupts. An
interrupt handler now trying to take tasklist_lock will cause a
deadlock.

-- 
Regards,
vatsa
