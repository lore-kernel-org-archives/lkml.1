Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbYA1KEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbYA1KEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYA1KEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:04:00 -0500
Received: from sacred.ru ([62.205.161.221]:36546 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbYA1KD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:03:59 -0500
Message-ID: <479DA711.3080301@openvz.org>
Date: Mon, 28 Jan 2008 12:57:37 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Vinay Sridhar <vinay@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
       drepper@redhat.com, wli@holomorphy.com, sripathik@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] Per-thread getrusage
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>	<20080127215242.b873c341.akpm@linux-foundation.org>	<479D88C7.5030101@openvz.org>	<20080128011010.d162d336.akpm@linux-foundation.org>	<479DA289.7090403@openvz.org> <20080128014534.17630ddd.akpm@linux-foundation.org>
In-Reply-To: <20080128014534.17630ddd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 28 Jan 2008 12:57:21 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 28 Jan 2008 12:38:17 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>>> If the code was using find_task_by_vpid() then OK (I guess).  But it is
>> Yup, find_task_by_vpid() will find the proper (i.e. in your namespace) task.
>>
>>> looking the tids up in the init_pid_ns.  Which I assume means that if it's
>>> in a new namespace and is looking up a sibling thread it will simply fail?
>> If it looks in the init_pid_ns, then it can either fail or obtain a task 
>> from different namespace. The find_task_by_pid_ns() was intended to be used
>> in proc mainly, to get tasks from the namespace pointed by the super-block
>> being explored.
>>
>> Please excuse my lamentable ignorance, but which code does such things with
>> init_pid_ns? I followed the 'per-thread rusage' thread and didn't find any.
> 
> From: Vinay Sridhar <vinay@linux.vnet.ibm.com>
> To: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
> Cc: drepper@redhat.com, wli@holomorphy.com, akpm@linux-foundation.org, sripathik@in.ibm.com
> Subject: [RFC] Per-thread getrusage

Ouch. Thanks, I've missed that and looked just at the Roland's patch :(

> ...
> +asmlinkage long sys_thread_getrusage(int tid, struct rusage __user *ru)
> +{
> +	struct task_struct *tsk;
> +	tsk = find_task_by_pid(tid);
> +	return getrusage(tsk, RUSAGE_THREAD, ru);
> +}

Well, the find_task_by_pid() is really wrong here.

Besides (just in case this system call is going to be developed further), 
the tsk == NULL  case is not checked inside the getrusage and may OOPS 
even if the proper namespace is used.

Thanks,
Pavel

