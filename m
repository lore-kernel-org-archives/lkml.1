Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYLaDbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYLaDbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 22:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbYLaDbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 22:31:00 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:41385 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbYLaDa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 22:30:59 -0500
Message-ID: <495AE76C.5040501@oracle.com>
Date: Tue, 30 Dec 2008 19:30:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Peter W. Morreale" <pmorreale@novell.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add /proc controls for pdflush threads
References: <20081230231152.10427.50620.stgit@hermosa.site>	 <20081230231233.10427.11443.stgit@hermosa.site>	 <495AB5DD.8040204@oracle.com> <1230691107.3470.55.camel@hermosa.site>
In-Reply-To: <1230691107.3470.55.camel@hermosa.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.495AE76E.0139:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter W. Morreale wrote:
> On Tue, 2008-12-30 at 15:59 -0800, Randy Dunlap wrote:
>> Peter W Morreale wrote:
>>> From: \"Peter W. Morreale\" <pmorreale@novell.com>
>>>
>>> This patch adds /proc entries to give the admin the ability to
>>> control the minimum and maximum number of pdflush threads.  This allows
>>> finer control of pdflush on both large and small machines.
>>>
>>> The patch adds '/proc/sys/vm/nr_pdflush_threads_min' and
>>> '/proc/sys/vm/nr_pdflush_threads_max' with r/w permissions.
>> These need to be documented in (ugh) either
>> Documentation/filesystems/proc.txt or
>> Documentation/sysctl/vm.txt.  Hard to say which one, but I'd
>> recommend the latter (vm.txt) since they are sysctls.
>>
>>
>> It looks like there is a lot of duplication between them.
>> That's not good IMO.
>>
> 
> Hummm... worse than that.  Documentation/sysctl/vm.txt is missing 9
> proc/sys/vm entries and hasn't been updated since (ahem) 2.2.10. 
> 
> Documentation/file_systems/proc.txt is much more recent -
> 2.4.0-test11-pre4.  My how time flies... :-)

Thanks for checking on those.

> I can take a stab at updating vm.txt.  Would it be ok to remove the vm
> verbiage from proc.txt and replace it with a pointer to vm.txt? 

Yes, sounds good to me (for sysctls).  Thanks again.

> 
> -PWM
>  
>>> ---
>>>
>>> Signed-off-by: Peter W Morreale <pmorreale@novell.com>
>>>
>>>  include/linux/sysctl.h    |    2 ++
>>>  include/linux/writeback.h |    2 ++
>>>  kernel/sysctl.c           |   16 ++++++++++++++++
>>>  mm/pdflush.c              |   19 ++++++++++++++-----
>>>  4 files changed, 34 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
>>> index d0437f3..9921e62 100644
>>> --- a/include/linux/sysctl.h
>>> +++ b/include/linux/sysctl.h
>>> @@ -205,6 +205,8 @@ enum
>>>  	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
>>>  	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
>>>  	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
>>> +	VM_NR_PDFLUSH_THREADS_MAX=36, /* nr_pdflush_threads_max */
>>> +	VM_NR_PDFLUSH_THREADS_MIN=37, /* nr_pdflush_threads_min */
>>>  };
>>>  
>>>  
>>> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
>>> index 12b15c5..ee566a0 100644
>>> --- a/include/linux/writeback.h
>>> +++ b/include/linux/writeback.h
>>> @@ -150,6 +150,8 @@ void writeback_set_ratelimit(void);
>>>  /* pdflush.c */
>>>  extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
>>>  				   read-only. */
>>> +extern int nr_pdflush_threads_max; /* Global so it can be exported to sysctl */
>>> +extern int nr_pdflush_threads_min; /* Global so it can be exported to sysctl */
>>>  
>>>  
>>>  #endif		/* WRITEBACK_H */
>>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>>> index 50ec088..6dae777 100644
>>> --- a/kernel/sysctl.c
>>> +++ b/kernel/sysctl.c
>>> @@ -948,6 +948,22 @@ static struct ctl_table vm_table[] = {
>>>  		.proc_handler	= &proc_dointvec,
>>>  	},
>>>  	{
>>> +		.ctl_name	= VM_NR_PDFLUSH_THREADS_MIN,
>>> +		.procname	= "nr_pdflush_threads_min",
>>> +		.data		= &nr_pdflush_threads_min,
>>> +		.maxlen		= sizeof nr_pdflush_threads_min,
>>> +		.mode		= 0644 /* read-only*/,
>>> +		.proc_handler	= &proc_dointvec,
>>> +	},
>>> +	{
>>> +		.ctl_name	= VM_NR_PDFLUSH_THREADS_MAX,
>>> +		.procname	= "nr_pdflush_threads_max",
>>> +		.data		= &nr_pdflush_threads_max,
>>> +		.maxlen		= sizeof nr_pdflush_threads_max,
>>> +		.mode		= 0644 /* read-only*/,
>>> +		.proc_handler	= &proc_dointvec,
>>> +	},
>>> +	{
>>>  		.ctl_name	= VM_SWAPPINESS,
>>>  		.procname	= "swappiness",
>>>  		.data		= &vm_swappiness,


-- 
~Randy
