Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbZHGDOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbZHGDOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 23:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbZHGDOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 23:14:17 -0400
Received: from [222.73.24.84] ([222.73.24.84]:54761 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbZHGDOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 23:14:16 -0400
Message-ID: <4A7B9BB5.3040005@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 11:12:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/filters: Support filtering for char * strings
References: <4A7A72BD.5030201@cn.fujitsu.com> <4A7A72FA.9040102@cn.fujitsu.com> <alpine.DEB.2.00.0908061020240.9870@gandalf.stny.rr.com> <4A7B8149.3070901@cn.fujitsu.com> <alpine.DEB.2.00.0908062251230.2840@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908062251230.2840@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 7 Aug 2009, Li Zefan wrote:
> 
>>>>  	if (is_string_field(field)) {
>>>> +		pred->str_len = field->size;
>>>> +
>>>>  		if (field->filter_type == FILTER_STATIC_STRING)
>>>>  			fn = filter_pred_string;
>>>> -		else
>>>> +		else if (field->filter_type == FILTER_DYN_STRING)
>>>>  			fn = filter_pred_strloc;
>>>> -		pred->str_len = field->size;
>>>> +		else {
>>>> +			fn = filter_pred_pchar;
>>>> +			pred->str_len = strlen(pred->str_val);
>>>> +		}
>>> I'm a little dense here, where do we protect against someone making a 
>>> tracepoint that points to unsafe data?
>>>
>> We can't prevent anyone from doing insane things deliberately, but
>> we prevent from doing wrong things unconsciously.
>>
>> Only if a TRACE_EVENT has a field defined as:
>>
>> 	__field_ext(char *, name, FILTER_PTR_STR)
>>
>> Here using FILTER_PTR_STR explicitly, he should know what he's doing.
>>
>> Anyway, he can make a ptr pointing to unsafe data this way:
>>
>> 	TP_STRUCT__entry(
>> 		__field(char *, name)
>> 	)
>> 	TP_printk("%s", name)
> 
> I guess the thing I'm missing is what's the difference of the two? Why 
> would a developer use __field_ext instead of doing it the unsafe way of 
> just __field?
> 
> I guess I don't see the developer doing something wrong unconsciously. 
> Well maybe I don't see this making the developer do it right 
> unconsciously.
> 
> What protection is this giving us?
> 

__field(char *) suggests it should be treated as plain pointer,
while __field_ext(char *, FILTER_PTR_STR) suggests he's aware it's
safe to dereference the pointer, for example the case in Frederic's
blk events.

In Frederic's initial version, "char *" field will always be
attached to ptr_str filter function. This is unsafe, because for
other fields defined as "char *" but not safe to dereference,
a user still can do this:

	# echo 'name == abc' > filter

Then we'll deref a pointer that can point to unsafe data.

In this patch, this won't happen, as long as the developer is
aware that his use of __field_ext(char *) is right.

Otherwise, he will just use normal __field(char *) and print
the pointer itself in TP_printk().

