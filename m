Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZIWIRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZIWIRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZIWIRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:17:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbZIWIRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:17:32 -0400
Message-ID: <4AB9D975.1060403@redhat.com>
Date: Wed, 23 Sep 2009 01:16:53 -0700
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 19/24] ftrace: Fix trace_add_event_call() to initialize
 list
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com> <1253648302-5771-20-git-send-email-fweisbec@gmail.com> <4AB975DD.9040205@cn.fujitsu.com>
In-Reply-To: <4AB975DD.9040205@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index ba34920..83cc2c0 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -1010,9 +1010,12 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
>>  		return -ENOENT;
>>  
>>  	list_add(&call->list, &ftrace_events);
>> -	return event_create_dir(call, d_events, &ftrace_event_id_fops,
>> +	ret = event_create_dir(call, d_events, &ftrace_event_id_fops,
>>  				&ftrace_enable_fops, &ftrace_event_filter_fops,
>>  				&ftrace_event_format_fops);
>> +	if (ret < 0)
>> +		list_del(&call->list);
>> +	return ret;
> 
> seems it's a bit better to call list_add() after event_create_dir()
> returns 0.

Sure, that's another way to do. But I'm afraid that will make a difference
from trace_module_add_events() path.

---
                call->mod = mod;
                list_add(&call->list, &ftrace_events);
                event_create_dir(call, d_events,
                                 &file_ops->id, &file_ops->enable,
                                 &file_ops->filter, &file_ops->format);
---
Anyway, this also needs to check the result of event_create_dir().

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

