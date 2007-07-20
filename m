Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbXGTUUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbXGTUUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759453AbXGTUUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:20:16 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:50099 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbXGTUUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:20:14 -0400
Date: Fri, 20 Jul 2007 16:20:10 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: menage@google.com
cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
       devel@openvz.org
Subject: Re: [PATCH 02/10] Task Containers(V11):  Add tasks file interface
In-Reply-To: <20070720191247.556709000@menage.corp.google.com>
Message-ID: <Line.LNX.4.64.0707201616240.9702@d.namei>
References: <20070720183152.637820000@menage.corp.google.com>
 <20070720191247.556709000@menage.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, menage@google.com wrote:

> +/*
> + * Attach task with pid 'pid' to container 'cont'. Call with
> + * container_mutex, may take task_lock of task
> + */
> +static int attach_task_by_pid(struct container *cont, char *pidbuf)
> +{
> +	pid_t pid;
> +	struct task_struct *tsk;
> +	int ret;
> +
> +	if (sscanf(pidbuf, "%d", &pid) != 1)
> +		return -EIO;
> +
> +	if (pid) {
> +		rcu_read_lock();
> +		tsk = find_task_by_pid(pid);
> +		if (!tsk || tsk->flags & PF_EXITING) {
> +			rcu_read_unlock();
> +			return -ESRCH;
> +		}
> +		get_task_struct(tsk);
> +		rcu_read_unlock();
> +
> +		if ((current->euid) && (current->euid != tsk->uid)
> +		    && (current->euid != tsk->suid)) {
> +			put_task_struct(tsk);
> +			return -EACCES;

I wonder if we should allow CAP_SYS_ADMIN to do this, too.

-- 
James Morris
<jmorris@namei.org>
