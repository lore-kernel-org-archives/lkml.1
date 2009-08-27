Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbZH0CtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbZH0CtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbZH0CtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:49:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZH0Cs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:48:59 -0400
Message-ID: <4A95F3BC.3080502@cn.fujitsu.com>
Date: Thu, 27 Aug 2009 10:47:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXcgUGF3ZcWCY3p5aw==?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 06/18] tracing: Ftrace dynamic ftrace_event_call support
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251340337-5640-7-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1251340337-5640-7-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -int trace_define_field(struct ftrace_event_call *call, const char *type,
> -		       const char *name, int offset, int size, int is_signed,
> +int trace_define_field(struct ftrace_event_call *call, char *type,
> +		       char *name, int offset, int size, int is_signed,
>  		       int filter_type)

I don't see why you remove "const"? 

>  {
>  	struct ftrace_event_field *field;
> @@ -92,9 +92,7 @@ int trace_define_common_fields(struct ftrace_event_call *call)
>  }
>  EXPORT_SYMBOL_GPL(trace_define_common_fields);

...

>  	for (i = 0; i < meta->nb_args; i++) {
> -		ret = trace_define_field(call, meta->types[i],
> -					 meta->args[i], offset,
> +		ret = trace_define_field(call, (char *)meta->types[i],
> +					 (char *)meta->args[i], offset,

This is not good..

>  					 sizeof(unsigned long), 0,
>  					 FILTER_OTHER);
>  		offset += sizeof(unsigned long);
> @@ -277,13 +277,13 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
>  		trace_current_buffer_unlock_commit(event, 0, 0);
>  }

...

> -int reg_event_syscall_exit(void *ptr)
> +int reg_event_syscall_exit(struct ftrace_event_call *call)
>  {
>  	int ret = 0;
>  	int num;
>  	char *name;
>  
> -	name = (char *)ptr;
> +	name = (char *)call->data;

nitpick: implicit cast is fine.

>  	num = syscall_name_to_nr(name);
>  	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
>  		return -ENOSYS;
> @@ -342,12 +342,12 @@ int reg_event_syscall_exit(void *ptr)
>  	return ret;
>  }
>  
> -void unreg_event_syscall_exit(void *ptr)
> +void unreg_event_syscall_exit(struct ftrace_event_call *call)
>  {
>  	int num;
>  	char *name;
>  
> -	name = (char *)ptr;
> +	name = (char *)call->data;

ditto

>  	num = syscall_name_to_nr(name);
>  	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
>  		return;
