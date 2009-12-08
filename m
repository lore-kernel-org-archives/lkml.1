Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbZLHKEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbZLHKEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 05:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZLHKEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 05:04:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZLHKEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 05:04:05 -0500
Message-ID: <4B1E2482.8040203@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 18:03:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/13] ftrace: Call trace_parser_clear() properly
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC4D2.3000406@cn.fujitsu.com> <20091208094825.GA5035@nowhere>
In-Reply-To: <20091208094825.GA5035@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Dec 08, 2009 at 11:15:30AM +0800, Li Zefan wrote:
>> I found a weird behavior:
>>
>>   # echo 'fuse:*' > set_ftrace_filter
>>   bash: echo: write error: Invalid argument
>>   # cat set_ftrace_filter
>>   fuse_dev_fasync
>>   fuse_dev_poll
>>   fuse_copy_do
>>
>> We should call trace_parser_clear() no matter ftrace_process_regex()
>> returns 0 or -errno.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/trace/ftrace.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 08a3fb5..ff8aecd 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -2208,10 +2208,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
>>  	    !trace_parser_cont(parser)) {
>>  		ret = ftrace_process_regex(parser->buffer,
>>  					   parser->idx, enable);
>> +		trace_parser_clear(parser);
>>  		if (ret)
>>  			goto out_unlock;
>> -
>> -		trace_parser_clear(parser);
>>  	}
> 
> 
> I'm missing something. How that can happen. Anytime we reopen
> the file, the parser is re-allocated.
> 

It happened at file closing..

static int
ftrace_regex_release(struct inode *inode, struct file *file, int enable)
{
	...
        parser = &iter->parser;
        if (trace_parser_loaded(parser)) {
                parser->buffer[parser->idx] = 0;
		/* here ! */
                ftrace_match_records(parser->buffer, parser->idx, enable);
        }
	...
}

> I guess that happens if you open in rw mode? But not using the
> example in the changelog?

I've confirmed that example I was using can reveal this bug.
