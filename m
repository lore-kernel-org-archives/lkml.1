Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbZHFBhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbZHFBhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZHFBhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:37:11 -0400
Received: from [222.73.24.84] ([222.73.24.84]:49565 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbZHFBhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:37:10 -0400
Message-ID: <4A7A336B.4040708@cn.fujitsu.com>
Date: Thu, 06 Aug 2009 09:35:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 5/5] tracing/filters: Provide support for char *
 pointers
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com> <1249111408-8657-6-git-send-email-fweisbec@gmail.com> <4A768A87.6090800@cn.fujitsu.com> <20090805230257.GI5025@nowhere>
In-Reply-To: <20090805230257.GI5025@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Aug 03, 2009 at 02:58:15PM +0800, Li Zefan wrote:
>> Frederic Weisbecker wrote:
>>> Provide support for char * pointers in the filtering framework.
>>> Usually, char * entries are dangerous in traces because the string
>>> can be released whereas a pointer to it can still wait to be read from
>>> the ring buffer. But sometimes we can assume it's safe, like in case
>>> of RO data (eg: __file__ or __line__, used in bkl trace event). If
>>> these RO data are in a module and so is the call to the trace event,
>>> then it's safe, because the ring buffer will be flushed once this
>>> module get unloaded.
>>>
>> The problem is we don't distinguish dangerous char * from
>> safe char *... They are both defined as:
>> 	__field(char *, str)
>>
>> So for those dangerous ones, a string filter still can be applied,
>> which will dereference those pointers.
> 
> Yeah, but only reviewing can distinguish them. It depends on the
> context.
> IMO, a __builtin_constant check would be wrong. I don't remember who
> posted recently tracepoints with char * types that were safe although he
> didn't use string constants.
> 

IMO it's really bad to rely on review to prevent wrong use of
an API..

Other developers won't know this restriction, and not all tracepoint
patches go through -tip tree, and not all trace_event source files
are in include/trace/events/.

How about add __field_type()? So we can define:

	__field_type(char *, str, FILTER_PTR_STR)

the advantage is he who wrote the code really knows this field is safe
to be used in filtering as a string.

I had some patches that does similar job. I can rewrite and post them.
