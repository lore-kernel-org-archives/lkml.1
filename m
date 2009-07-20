Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbZGTBAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbZGTBAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 21:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZGTBAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 21:00:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52084 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbZGTBAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 21:00:51 -0400
Message-ID: <4A63C166.8010201@cn.fujitsu.com>
Date: Mon, 20 Jul 2009 08:59:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: Improve subsystem filter
References: <4A5EECDC.4080500@cn.fujitsu.com> <20090717203422.GA7136@nowhere>
In-Reply-To: <20090717203422.GA7136@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -static void filter_free_subsystem_preds(struct event_subsystem *system)
>> +/*
>> + * flag == 0: remove all events' filter
>> + * flag == 1: clear filter->no_reset
>> + * flag == 2: remove all preds with no_reset == false
>> + */
> 
> Once an option overlap the boolean binary range, it's better
> to start thinking about an enum type, for better self-explaining code.
> 

Ok.

I was lazy to think of proper names for those enums..

>> +static void filter_free_subsystem_preds(struct event_subsystem *system,
>> +					int flag)
>>  {
>>  	struct ftrace_event_call *call;
>>  
>> @@ -428,6 +434,14 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
>>  		if (!call->define_fields)
>>  			continue;
>>  
>> +		if (flag == 1) {
>> +			call->filter->no_reset = false;
>> +			continue;
>> +		}
>> +
>> +		if (flag == 2 && call->filter->no_reset == true)
> 
> Or simply if (flag == 2 && call->filter->no_reset)
> 

Sure.

>> +			continue;
>> +
>>  		if (!strcmp(call->system, system->name)) {
>>  			filter_disable_preds(call);
>>  			remove_filter_string(call->filter);
>> @@ -529,7 +543,8 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
>>  
>>  static int filter_add_pred(struct filter_parse_state *ps,
>>  			   struct ftrace_event_call *call,
>> -			   struct filter_pred *pred)
>> +			   struct filter_pred *pred,
>> +			   bool apply)
> 
> 
> bool dry_run sounds perhaps more intuitive for what is happening there.

I guess you "try_run". ;)

> Because "apply" is surprising in a "add_thing" function, it's like
> a field to confirm that we know what what we are doing :)
> 
> (May be I start to become a PITA with my naming worries, especially
> since I'm usually not good at it in my patches :)
> 

I'll take "try_run". Naming is often hard for me.

> Otherwise, the rest looks good.
> 

Thanks!
