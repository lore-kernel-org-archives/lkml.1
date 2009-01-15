Return-Path: <linux-kernel-owner+w=401wt.eu-S1762860AbZAOKT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860AbZAOKT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZAOKTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:19:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61513 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbZAOKTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:19:20 -0500
Message-ID: <496F0D9B.9010906@cn.fujitsu.com>
Date: Thu, 15 Jan 2009 18:19:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] ftrace: show ftrace_bprintk()'s formats
References: <495ADF57.8030008@cn.fujitsu.com> <20090113231617.GD3210@redhat.com> <496D52D4.70202@cn.fujitsu.com> <20090114142546.GA3141@redhat.com>
In-Reply-To: <20090114142546.GA3141@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> On Wed, Jan 14, 2009 at 10:49:56AM +0800, Lai Jiangshan wrote:
>> Jason Baron wrote:
>>> On Wed, Dec 31, 2008 at 10:56:23AM +0800, Lai Jiangshan wrote:
>>>> Impact: let user knows the format
>>>>
>>>> Create a file on <debugfs-dir>/tracing/ to show ftrace_bprintk()'s formats.
>>>>
>>>> This formats will help for these condition:
>>>> 1) User get binary data from core file.(formats are backup before coredump)
>>>> 2) User splice ring_buffer to a file.
>>>> User can use formats for parsing the binary data in userspace.
>>>>
>>> When I 'cat' trace_bprintk_formats on my system the file is empty. This
>>> seems to be b/c 'ftrace_bprintk' is not being used in this patchset. It
>>> can't be used in patch #5 during marker register b/c the format wouldn't
>>> be known at runtime. Thus, as it currently stands this patch, patch 4/5,
>>> isn't adding much?
>> If you don't use ftrace_bprintk(), the file trace_bprintk_formats is empty.
>> This file record all formats which ftrace_bprintk() uses.
>>
>> You can use ftrace_bprintk() everywhere as another printk().
>>
>> Patch #5 enables binary printk for markers, this is another additional tool
>> for tracing markers.
>>
>>> A thought on how this might be resolved would be to have the core marker
>>> code pass us its address so this could be recorded in the trace buffer.
>>> Then, also add some debug file that displays the markers and maps marker
>>> addresses with format strings.
>>>
>> Patch#5 does it as you said.
>>
>>
>>
> 
> hmm...i'm still not clear on this. in patch #5 you have:
> 
> 
> +static void marker_bprintk_probe(void *probe_private, void *call_private,
> +		const char *fmt, va_list *args)
> +{
> +	struct marker_bprintk_struct *p = probe_private;
> +
> +	if (p->fmt_state == MARKER_FMT_LACK) {
> +		int flen = strlen(fmt);
> +		if (p->fmt - p->name + flen < MARKER_NAME_FMT_LEN) {
> +			memcpy(p->fmt, fmt, flen + 1);
> +			p->fmt_state = MARKER_FMT_OK;
> +		} else
> +			p->fmt_state = MARKER_FMT_INVALID;
> +	}
> +
> +	if (p->fmt_state == MARKER_FMT_OK)
> +		trace_vbprintk(0, p->name, *args);
> +}
> +
> 
> trace_vbprintk first argument is 'ip'. So I don't see how we are
> associating instruction pointers with each 'ftrace' record? Aren't we
> just recording each entry with '0' for the 'ip'?
> 
argument 'ip' is used for ftrace_bprintk(), the caller of ftrace_bprintk()
will be output in the message.

argument 'ip' is not used when trace markers.
we may can use:
trace_vbprintk(CALLER_ADDR2, p->name, *args);
but this cannot work for !CONFIG_FRAME_POINTER.

I will remove argument 'ip' in next version.(if users need know the call_addr
when he use ftrace_bprintk(), just use "%pS":
ftrace_bprintk("%pS: msgfmt example %d, %d", _THIS_IP_, msgarg1, msgarg2);)

Thanks for pointed it out.

Lai.

