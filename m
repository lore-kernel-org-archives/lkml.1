Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbXLFTTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbXLFTTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbXLFTS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:18:56 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60712 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbXLFTSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:18:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>, sukadev@us.ibm.com
Subject: Re: [PATCH] pid: sys_wait... fixes (v2)
References: <m17ijsv7iu.fsf@ebiederm.dsl.xmission.com>
	<20071206170145.GA10674@tv-sign.ru>
	<m1k5nrsn18.fsf_-_@ebiederm.dsl.xmission.com>
	<20071206184502.GA11752@tv-sign.ru>
Date: Thu, 06 Dec 2007 12:11:20 -0700
In-Reply-To: <20071206184502.GA11752@tv-sign.ru> (Oleg Nesterov's message of
	"Thu, 6 Dec 2007 21:45:02 +0300")
Message-ID: <m1fxyfsko7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 12/06, Eric W. Biederman wrote:
>> 
>> +static struct pid *task_pid_type(struct task_struct *task, enum pid_type
> type)
>> +{
>> +	struct pid *pid = NULL;
>> +	if (type == PIDTYPE_PID)
>> +		pid = task->pids[type].pid;
>> +	else if (type < PIDTYPE_MAX)
>> +		pid = task->group_leader->pids[type].pid;
>> +	return pid;
>> +}
>
> Looks like a useful helper regardless.

Sort of.  We don't have any place else that could use it yet.

>> +static int eligible_child(enum pid_type type, struct pid *pid, int options,
>> +			  struct task_struct *p)
>>  {
>>  	int err;
>> -	struct pid_namespace *ns;
>>  
>> -	ns = current->nsproxy->pid_ns;
>> -	if (pid > 0) {
>> -		if (task_pid_nr_ns(p, ns) != pid)
>> -			return 0;
>> -	} else if (!pid) {
>> -		if (task_pgrp_nr_ns(p, ns) != task_pgrp_vnr(current))
>> -			return 0;
>> -	} else if (pid != -1) {
>> -		if (task_pgrp_nr_ns(p, ns) != -pid)
>> +	if (type < PIDTYPE_MAX) {
>> +		if (task_pid_type(p, type) != pid)
>>  			return 0;
>>  	}
>
> Minor, minor nit.
>
> If type == PIDTYPE_MAX, pid must be == NULL. but task_pid_type(PIDTYPE_PID)
> also returns NULL. So we can just do
>
> 	if (task_pid_type(p, type) != pid)
> 		return 0;
>
> Not that it really makes a difference though.

No.

Your comments are good but I figure this patch is now correct and thus
good enough for me.

Eric
