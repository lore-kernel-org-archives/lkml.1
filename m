Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZJFBGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZJFBGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbZJFBGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:06:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbZJFBGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:06:36 -0400
Message-ID: <4ACA9848.7060200@redhat.com>
Date: Mon, 05 Oct 2009 21:07:20 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v2 2/5] tracing/kprobes: Avoid field name
 confliction
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>	 <20091002214850.30906.25919.stgit@dhcp-100-2-132.bos.redhat.com> <1254788218.13160.198.camel@gandalf.stny.rr.com>
In-Reply-To: <1254788218.13160.198.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Steven Rostedt wrote:
> On Fri, 2009-10-02 at 17:48 -0400, Masami Hiramatsu wrote:
>> Check whether the argument name is conflict with other field names.
>>
>> Changes in v2:
>>  - Add common_lock_depth to reserved name list.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Mike Galbraith <efault@gmx.de>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Jim Keniston <jkenisto@us.ibm.com>
>> Cc: Frank Ch. Eigler <fche@redhat.com>
>> ---
>>
>>  kernel/trace/trace_kprobe.c |   65 +++++++++++++++++++++++++++++++++++--------
>>  1 files changed, 53 insertions(+), 12 deletions(-)
>>
>> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
>> index f63ead0..eb1fa0f 100644
>> --- a/kernel/trace/trace_kprobe.c
>> +++ b/kernel/trace/trace_kprobe.c
>> @@ -38,6 +38,25 @@
>>  #define MAX_EVENT_NAME_LEN 64
>>  #define KPROBE_EVENT_SYSTEM "kprobes"
>>  
>> +/* Reserved field names */
>> +#define FIELD_STRING_IP "ip"
>> +#define FIELD_STRING_NARGS "nargs"
>> +#define FIELD_STRING_RETIP "ret_ip"
>> +#define FIELD_STRING_FUNC "func"
>> +
>> +const char *reserved_field_names[] = {
>> +	"common_type",
>> +	"common_flags",
>> +	"common_preempt_count",
>> +	"common_pid",
>> +	"common_tgid",
>> +	"common_lock_depth",
>> +	FIELD_STRING_IP,
>> +	FIELD_STRING_NARGS,
>> +	FIELD_STRING_RETIP,
>> +	FIELD_STRING_FUNC,
>> +};
>> +
>>  /* currently, trace_kprobe only supports X86. */
>>  
>>  struct fetch_func {
>> @@ -551,6 +570,20 @@ static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
>>  	return ret;
>>  }
>>  
>> +/* Return 1 if name is reserved or already used by another argument */
>> +static int conflict_field_name(const char *name,
>> +			       struct probe_arg *args, int narg)
>> +{
>> +	int i;
>> +	for (i = 0; i < ARRAY_SIZE(reserved_field_names); i++)
>> +		if (!strcmp(reserved_field_names[i], name))
>> +			return 1;
>> +	for (i = 0; i < narg; i++)
>> +		if (!strcmp(args[i].name, name))
>> +			return 1;
> 
> Just a coding preference, but still, I've seen too many mistakes (made
> them myself too).
> 
> 	if (strcmp(args[i].name, name) == 0)
> 
> Looks better as a match then
> 
> 	if (!strcmp(args[i].name, name))
> 
> That stands out to me as a miss match. But this is still just a
> preference and not something to make me argue the patch.

Agreed, !strcmp() pattern would better be warned by checkpatch.pl :-)
I'll fix that.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

