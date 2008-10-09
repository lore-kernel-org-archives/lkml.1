Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYJICVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYJICVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 22:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYJICV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 22:21:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54312 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbYJICV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 22:21:26 -0400
Message-ID: <48ED6A29.3080903@cn.fujitsu.com>
Date: Thu, 09 Oct 2008 10:19:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: remove 2 exported symbols
References: <48EC199D.40808@cn.fujitsu.com> <20081008024325.GA29227@Krystal> <48EC2377.6020706@cn.fujitsu.com> <20081008035325.GA31788@Krystal>
In-Reply-To: <20081008035325.GA31788@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
>> Mathieu Desnoyers wrote:
>>> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
>>>> __mark_empty_function() and marker_probe_cb_noarg()
>>>> should not be seen by outer code. this patch remove them.
>>>>
>>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>>> ---
>>>> diff --git a/include/linux/marker.h b/include/linux/marker.h
>>>> index 1290653..f4d4d28 100644
>>>> --- a/include/linux/marker.h
>>>> +++ b/include/linux/marker.h
>>>> @@ -132,12 +132,8 @@ static inline void __printf(1, 2) ___mark_check_format(const char *fmt, ...)
>>>>  			___mark_check_format(format, ## args);		\
>>>>  	} while (0)
>>>>  
>>>> -extern marker_probe_func __mark_empty_function;
>>>> -
>>> Hi Lai,
>>>
>>> Hrm ? Have a good look at the macro __trace_mark() in
>>> include/linux/marker.h, you'll see that __mark_empty_function is
>>> referenced. Have you tested this against code with declared markers ?
>> Sorry for this,
>> I have markers in my kernel test code.
>> I hasn't tested this patch, for I thought it's to simple.
>> I used "grep" to find "__mark_empty_function",
>> but I missed one line of the results.
>>
>> Other problems:
>> 1)
>> why we need marker_probe_cb_noarg()?
>> marker_probe_cb_noarg() has no performance optimization,
>> and no additional format check, or other thing?
>>
> 
> marker_probe_cb_noarg() does not need to setup the variable arguments,
> because the format string explicitly contains the MARK_NOARGS string. So
> this is a performance optimization.

marker_probe_cb_noarg()/marker_probe_cb() are really critical path,
but I think saving a "va_start" is not performance optimization.
"va_start" is just several machine instructions after compiled.

if marker_probe_cb_noarg() is removed, kernel size will be reduced
also, and cache missing will be reduced.

> 
[...]
>>
>> 2)
>> why we use va_list *?
>> As I know, sizeof(va_list) = 4 or 8.
>>
> 
> It becomes hellish when we want to pass it as parameter to another C
> function, because va_list is typedef'd as an array on some
> architectures, and the array gets propoted to a pointer type, which is
> in turn incompatible with the array. C language mess :-( Not much we can
> do about it.

va_list is platform-dependent, but it's transplantable. So I don't think
it's a problem.

And pass-by-value vs. pass-by-reference:
marker_probe_cb() don't need see what have been changed with "args"
by the probes/callbacks.

So I think pass-by-value is better than pass-by-reference here.

code piece:
 typedef void marker_probe_func(void *probe_private, void *call_private,
-		const char *fmt, va_list *args);
+		const char *fmt, va_list args);

marker_probe_cb():
		multi = mdata->multi;
+		va_start(args, call_private);
		for (i = 0; multi[i].func; i++) {
-			va_start(args, call_private);
			multi[i].func(multi[i].probe_private, call_private,
-				mdata->format, &args);
-			va_end(args);
+				mdata->format, args);
		}
+		va_end(args);


The only problem is that API is changed, and we need changed LTTng
and SYSTEMTAP also.



> 
> Mathieu
> 
[...]

