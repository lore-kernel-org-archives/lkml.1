Return-Path: <linux-kernel-owner+w=401wt.eu-S932393AbZLFJah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbZLFJah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbZLFJac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:30:32 -0500
Received: from toro.web-alm.net ([62.245.132.31]:46286 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbZLFJaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:30:30 -0500
Message-ID: <4B1B785E.8010501@osadl.org>
Date: Sun, 06 Dec 2009 10:24:46 +0100
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] tracing: Fix trace_marker output
References: <4B01AE5D.1010801@osadl.org> <tip-c13d2f7c3231e873f30db92b96c8caa48f100f33@git.kernel.org> <20091206051352.GA4628@lixom.net>
In-Reply-To: <20091206051352.GA4628@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof,

> On Sun, Nov 22, 2009 at 10:24:48AM +0000, tip-bot for Carsten Emde wrote:
>> Commit-ID:  c13d2f7c3231e873f30db92b96c8caa48f100f33
>> Gitweb:     http://git.kernel.org/tip/c13d2f7c3231e873f30db92b96c8caa48f100f33
>> Author:     Carsten Emde<Carsten.Emde@osadl.org>
>> AuthorDate: Mon, 16 Nov 2009 20:56:13 +0100
>> Committer:  Steven Rostedt<rostedt@goodmis.org>
>> CommitDate: Tue, 17 Nov 2009 09:19:06 -0500
>> tracing: Fix trace_marker output
>> When a string was written to<debugfs>/tracing/trace_marker, some
>> strange characters appeared in the trace output instead of the
>> string, since a vprint function erroneously called a vararg print
>> function with a va_list argument. This patch fixes the problem and
>> simplifies the related code.
>
> [...]
>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 03c7fd5..12b49ca 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -1361,10 +1361,11 @@ int trace_array_vprintk(struct trace_array *tr,
>>   	pause_graph_tracing();
>>   	raw_local_irq_save(irq_flags);
>>   	__raw_spin_lock(&trace_buf_lock);
>> -	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
>> -
>> -	len = min(len, TRACE_BUF_SIZE-1);
>> -	trace_buf[len] = 0;
>> +	if (args == NULL) {
>> +		strncpy(trace_buf, fmt, TRACE_BUF_SIZE);
>> +		len = strlen(trace_buf);
>> +	} else
>> +		len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
> Comparing a va_list with NULL is bogus. It's supposed to be treated like
> an opaque type and only be manipulated with va_* accessors.
>
> I wouldn't really care much, but it broke builds on some ARM platforms:
>
> kernel/trace/trace.c: In function 'trace_array_vprintk':
> kernel/trace/trace.c:1364: error: invalid operands to binary == (have 'va_list' and 'void *')
> kernel/trace/trace.c: In function 'tracing_mark_write':
> kernel/trace/trace.c:3349: error: incompatible type for argument 3 of 'trace_vprintk'
Oops, sorry. Didn't know that the gcc warn/error level is so much 
different across platforms.

>[..]
> Oh, and I haven't had a chance to actually test and make sure it does
> what is expected, since I don't have a testcase for it.
The testcase is:
# cd /sys/kernel/debug/tracing/
[root@deliv1 tracing]# echo "I am a marker" >trace_marker
[root@deliv1 tracing]# tail -1 trace
             bash-6347  [002] 303160.793532: 0: I am a marker

> +	ret = trace_vprintk(ip, "%s", ap);
This prevents the '%' character to be used in an output string. If used, 
it may horribly crash the kernel.

I'll investigate the situation further and try to come back with a 
better solution.

	Carsten.
