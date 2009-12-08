Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZLHHtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZLHHtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbZLHHtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:49:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59692 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbZLHHtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:49:50 -0500
Message-ID: <4B1E0507.2060403@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 15:49:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/13] tracing: Move a printk out of	ftrace_raw_reg_event_foo()
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC4AC.802@cn.fujitsu.com> <20091208074342.GB4989@nowhere>
In-Reply-To: <20091208074342.GB4989@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -static void ftrace_event_enable_disable(struct ftrace_event_call *call,
>> +static int ftrace_event_enable_disable(struct ftrace_event_call *call,
>>  					int enable)
>>  {
>> +	int ret = 0;
>> +
>>  	switch (enable) {
>>  	case 0:
>>  		if (call->enabled) {
>> @@ -131,12 +133,19 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
>>  		break;
>>  	case 1:
>>  		if (!call->enabled) {
>> +			ret = call->regfunc(call);
>> +			if (ret) {
>> +				pr_info("event trace: Could not enable event "
>> +					"%s\n", call->name);
>> +				break;
>> +			}
>>  			call->enabled = 1;
>>  			tracing_start_cmdline_record();
>> -			call->regfunc(call);
> 
> That seems to open a tiny window during which we'll lose
> some pid -> comm resolution records.
> 
> We should probably keep the previous call order.
> 

Hm, actually the tiny window is already there in that
tracing_stop_cmdline_record() is called before call->unregfunc()..

So I can send a fix-up patch later.

> Other than that:
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 

Thanks.
