Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZLHFhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZLHFhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 00:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZLHFhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 00:37:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54942 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbZLHFhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 00:37:19 -0500
Message-ID: <4B1DE5D4.4070805@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 13:36:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 02/13] tracing: Extract calls to trace_define_common_fields()
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC49C.8000107@cn.fujitsu.com>
In-Reply-To: <4B1DC49C.8000107@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Call trace_define_common_fields() in event_create_dir() only.
> 
>    text    data     bss     dec     hex filename
> 5346802 1961864 7103260 14411926         dbe896 vmlinux.o.old
> 5345151 1961864 7103260 14410275         dbe223 vmlinux.o
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

I think this is a urgent patch for mainline.

I have found a regression at trace_kprobe, and I'm lucky to find that this
patch can also fix this regression.


> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1113,10 +1113,6 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
>  	struct kprobe_trace_entry field;
>  	struct trace_probe *tp = (struct trace_probe *)event_call->data;
>  
> -	ret = trace_define_common_fields(event_call);
> -	if (!ret)
> -		return ret;
> -
>  	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
>  	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
>  	/* Set argument names as fields */
> @@ -1131,10 +1127,6 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
>  	struct kretprobe_trace_entry field;
>  	struct trace_probe *tp = (struct trace_probe *)event_call->data;
>  
> -	ret = trace_define_common_fields(event_call);
> -	if (!ret)
> -		return ret;
> -
>  	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
>  	DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
>  	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);

"if (!ret)" is wrong. trace_define_common_fields() returns zero when success.
So "unsigned long, func", "unsigned long, ret_ip" ...etc are NOT "defined"
and filters can not be applied for trace_kprobe.

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

