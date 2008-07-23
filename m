Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYGWQKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYGWQKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbYGWQJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:09:44 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:61677 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbYGWQJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:09:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApE6AD/0hkjVchRXPGdsb2JhbACBWpBrAQEBAS0Bn1Q
Message-ID: <57249.192.168.101.12.1216829380.squirrel@intranet>
In-Reply-To: <20080723143411.GA2905@tv-sign.ru>
References: <487F5D6B.1090007@hozac.com> <20080723143411.GA2905@tv-sign.ru>
Date: Wed, 23 Jul 2008 18:09:40 +0200 (CEST)
Subject: Re: [PATCH 1/2] signals: kill(-1) should only signal processes in 
     the same namespace
From: "Daniel Hokka Zakrisson" <daniel@hozac.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       ebiederm@xmission.com, xemul@openvz.org, akpm@linux-foundation.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 07/17, Daniel Hokka Zakrisson wrote:
>>
>> +int task_in_pid_ns(struct task_struct *tsk, struct pid_namespace *ns)
>> +{
>> +	struct pid *pid = task_pid(tsk);
>> +
>> +	if (!pid)
>> +		return 0;
>> +
>> +	if (pid->level < ns->level)
>> +		return 0;
>> +
>> +	if (pid->numbers[ns->level].ns != ns)
>> +		return 0;
>> +
>> +	return 1;
>> +}
>> +
>>  static __init int pid_namespaces_init(void)
>>  {
>>  	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index 6c0958e..93713a5 100644
>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -1145,7 +1145,8 @@ static int kill_something_info(int sig, struct
>> siginfo *info, int pid)
>>  		struct task_struct * p;
>>
>>  		for_each_process(p) {
>> -			if (p->pid > 1 && !same_thread_group(p, current)) {
>> +			if (p->pid > 1 && !same_thread_group(p, current) &&
>> +			    task_in_pid_ns(p, current->nsproxy->pid_ns)) {
>>  				int err = group_send_sig_info(sig, info, p);
>>  				++count;
>>  				if (err != -EPERM)
>
> Do we really need all these complications? Afaics, we can make
> a simpler patch,
>
> 	--- kernel/signal.c
> 	+++ kernel/signal.c
> 	@@ -1136,7 +1136,7 @@ static int kill_something_info(int sig,
> 			struct task_struct * p;
>
> 			for_each_process(p) {
> 	-			if (p->pid > 1 && !same_thread_group(p, current)) {
> 	+			if (task_pid_vnr(p) > 1 && !same_thread_group(p, current)) {
> 					int err = group_send_sig_info(sig, info, p);
> 					++count;
> 					if (err != -EPERM)
>
>
> task_pid_vnr(p) returns 0 if "p" is not visible from the current's
> namespace. "> 1" ensures we don't kill the child reaper as well.
>
> No?
>
> Oleg.

You are absolutely right, that is sufficient and much cleaner.

-- 
Daniel Hokka Zakrisson
