Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbXJHJAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbXJHJAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 05:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbXJHJAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 05:00:43 -0400
Received: from sacred.ru ([62.205.161.221]:45215 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbXJHJAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 05:00:42 -0400
Message-ID: <4709F112.60204@openvz.org>
Date: Mon, 08 Oct 2007 12:57:54 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, devel@openvz.org, hpa@zytor.com,
       menage@google.com
Subject: Re: [PATCH] Use task_pid_nr() instead of pid_nr(task_pid())
References: <4703A67E.1070209@openvz.org> <20071005161521.cae8c531.akpm@linux-foundation.org>
In-Reply-To: <20071005161521.cae8c531.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 08 Oct 2007 13:00:22 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 03 Oct 2007 18:26:06 +0400
> Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> There are two places that do so - the cgroups subsystem 
>> and the autofs code.
>>
>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>>
>> ---
>>
>> diff --git a/fs/autofs/root.c b/fs/autofs/root.c
>> index 592f640..5efff3c 100644
>> --- a/fs/autofs/root.c
>> +++ b/fs/autofs/root.c
>> @@ -214,7 +214,7 @@ static struct dentry *autofs_root_lookup
>>  
>>  	oz_mode = autofs_oz_mode(sbi);
>>  	DPRINTK(("autofs_lookup: pid = %u, pgrp = %u, catatonic = %d, "
>> -				"oz_mode = %d\n", pid_nr(task_pid(current)),
>> +				"oz_mode = %d\n", task_pid_nr(current),
>>  				task_pgrp_nr(current), sbi->catatonic,
>>  				oz_mode));
>>  
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 1e8aa53..8720881 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1762,7 +1762,7 @@ static int pid_array_load(pid_t *pidarra
>>  	while ((tsk = cgroup_iter_next(cont, &it))) {
>>  		if (unlikely(n == npids))
>>  			break;
>> -		pidarray[n++] = pid_nr(task_pid(tsk));
>> +		pidarray[n++] = task_pid_nr(tsk);
>>  	}
>>  	cgroup_iter_end(cont, &it);
>>  	return n;
> 
> And more will appear over time unless we remove pid_nr() altogether.
> 
> Can we do that?

Hardly. 

There are places that store the struct pid and try to obtain its number
later. E.g. tiocgpgrp() wants to tell user the pgrp nr of the tty's 
active group; fgetown() tells user the number of file's owner pid or (!)
pgrp; file locks need to store the pid and report it later (this is not 
implemented yet, I'm still working on it) and so on and so forth.

Thanks,
Pavel
