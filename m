Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbYCFAD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbYCFAD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbYCFADO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:03:14 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43367 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619AbYCFADN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:03:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: paulmck@linux.vnet.ibm.com
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH] Make /proc/net a symlink on /proc/self/net
References: <47CE8FF7.7000701@openvz.org>
	<20080305191501.GF8728@linux.vnet.ibm.com>
Date: Wed, 05 Mar 2008 16:59:56 -0700
In-Reply-To: <20080305191501.GF8728@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Wed, 5 Mar 2008 11:15:01 -0800")
Message-ID: <m1ablc3eo3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 
>> +static struct net *get_proc_task_net(struct inode *dir)
>> +{
>> +	struct task_struct *task;
>> +	struct nsproxy *ns;
>> +	struct net *net = NULL;
>> +
>> +	rcu_read_lock();
>> +	task = get_proc_task(dir);
>
> This implies a get_task_struct(), as get_proc_task() invokes get_proc_task()
> which invokes get_pid_task() which invokes get_task_struct().
>
> I don't see the corresponding put_task_struct() -- what am I missing here?

You aren't.  However we can easily make this:
	task = pid_task(proc_pid(dir), PIDTYPE_PID);
And we won't need to increment the count on the task_struct.

Good catch.

>> +	if (task != NULL) {
>> +		ns = task_nsproxy(task);
>> +		if (ns != NULL)
>> +			net = get_net(ns->net_ns);
>> +	}
>> +	rcu_read_unlock();
>> +
>> +	return net;
>> +}
>> +
