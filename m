Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYK0BOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYK0BOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYK0BOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:14:04 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:59027 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYK0BOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:14:03 -0500
Date: Thu, 27 Nov 2008 02:17:38 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       xemul@openvz.org
Subject: Re: [RFC][PATCH 2/5] pid: Generalize task_active_pid_ns
Message-ID: <20081127011738.GC13545@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, oleg@redhat.com,
	ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
	linux-kernel@vger.kernel.org, xemul@openvz.org
References: <20081126034242.GA23120@us.ibm.com> <20081126034528.GB23238@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081126034528.GB23238@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 07:45:28PM -0800, Sukadev Bhattiprolu wrote:
> Currently task_active_pid_ns is not safe to call after a
> task becomes a zombie and exit_task_namespaces is called,
> as nsproxy becomes NULL.

Why do you need to be able to get the pid namespace from zombie
processes? Also according to nsproxy.h this access variant is only
allowed for the current task, anything else needs to take a rcu lock.

>                           By reading the pid namespace from
> the pid of the task we can trivially solve this problem at
> the cost of one extra memory read in what should be the
> same cacheline as we read the namespace from.

The pid namespace may not be destructed yet?

> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1111,12 +1111,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  
>  	if (pid != &init_struct_pid) {
>  		retval = -ENOMEM;
> -		pid = alloc_pid(task_active_pid_ns(p));
> +		pid = alloc_pid(p->nsproxy->pid_ns);

Why do you expand the old version of the function?

Bastian

-- 
Women professionals do tend to over-compensate.
		-- Dr. Elizabeth Dehaver, "Where No Man Has Gone Before",
		   stardate 1312.9.
