Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZHGBVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZHGBVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 21:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZHGBVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 21:21:46 -0400
Received: from [222.73.24.84] ([222.73.24.84]:52995 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756495AbZHGBVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 21:21:45 -0400
Message-ID: <4A7B8149.3070901@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 09:20:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <f.weisbecker@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/filters: Support filtering for char * strings
References: <4A7A72BD.5030201@cn.fujitsu.com> <4A7A72FA.9040102@cn.fujitsu.com> <alpine.DEB.2.00.0908061020240.9870@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908061020240.9870@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  	if (is_string_field(field)) {
>> +		pred->str_len = field->size;
>> +
>>  		if (field->filter_type == FILTER_STATIC_STRING)
>>  			fn = filter_pred_string;
>> -		else
>> +		else if (field->filter_type == FILTER_DYN_STRING)
>>  			fn = filter_pred_strloc;
>> -		pred->str_len = field->size;
>> +		else {
>> +			fn = filter_pred_pchar;
>> +			pred->str_len = strlen(pred->str_val);
>> +		}
> 
> I'm a little dense here, where do we protect against someone making a 
> tracepoint that points to unsafe data?
> 

We can't prevent anyone from doing insane things deliberately, but
we prevent from doing wrong things unconsciously.

Only if a TRACE_EVENT has a field defined as:

	__field_ext(char *, name, FILTER_PTR_STR)

Here using FILTER_PTR_STR explicitly, he should know what he's doing.

Anyway, he can make a ptr pointing to unsafe data this way:

	TP_STRUCT__entry(
		__field(char *, name)
	)
	TP_printk("%s", name)

