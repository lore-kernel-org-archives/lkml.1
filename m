Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZJLVSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZJLVSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZJLVR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:17:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:43450 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZJLVR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:17:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MztZOzFm/zH8sm2wspsaDUP5BsihbuzoZUjVc/gI8WU4BWtsO4NlG74ycte/UKVY7x
         uHIh+PSEZ0MJIaCv/qrDalaywsg5FZvP/XmxqOYd+sIntyItOXuXdflGE3mdAlRmIjPy
         bimxNX46ccbd566J/jiragJOzjKlETnm5fCVA=
Date: Mon, 12 Oct 2009 23:16:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH tracing/kprobes v3 4/7] tracing/kprobes: Avoid field
	name confliction
Message-ID: <20091012211645.GD4748@nowhere>
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com> <20091007222807.1684.26880.stgit@dhcp-100-2-132.bos.redhat.com> <20091012173752.GB5059@nowhere> <4AD37FEF.9050807@redhat.com> <20091012194852.GB4748@nowhere> <4AD39002.2080907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD39002.2080907@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 04:22:26PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>> On Mon, Oct 12, 2009 at 03:13:51PM -0400, Masami Hiramatsu wrote:
>>> Frederic Weisbecker wrote:
>>>> The conflict issue might not be obvious for a user desperately trying to set
>>>> a kprobe. Even for other failcases, it might not be obvious (blacklisted
>>>> symbols, syntax errors...)
>>>>
>>>> May be should you improve the error granularity and print a KERN_DEBUG
>>>> message?
>>>
>>> Agreed, and kprobes error handling should be improved too (in the most cases,
>>> it just returns -EINVAL).
>>>
>>> Thank you.
>>>
>>
>>
>> And btw, I'm enable to create a probe, neither through ftrace nor perf:
>>
>> 	$ sudo ./perf probe -P 'p:sys_close sys_close $retval'
>> 	Adding new event: p:sys_close sys_close+0 $retval
>>
>> 	Error: Failed to create event: Invalid argument
>>
>>
>> 	# echo 'p:sys_open sys_open $retval'>  /debug/tracing/kprobe_events
>> 	bash: echo: write error : Invalid argument
>>
>> I suspect I missed something very obvious with the syntax :)
>
> Ah, only kretprobe events can use $retval :-)
> So, you should specify 'r' instead of 'p'.
>
> -P 'r:sys_close sys_close $retval'
>

Hehe, I was sure I was doing something silly but couldn't figure
out what :-)

So that works, at least without libdwarf, I can't test with it for
now but this tool looks very promising.

I really think it would be great to be able to cut the

	./perf probe
	./perf record
	./perf trace

batch into one step through a single

	./perf probe -t -P "probe definition" [-a|cmdline]

That would do the probe creation, the record, and stop
once the given process finishes, or once we Ctrl+C (especially
useful in wide tracing with -a, but sometimes also with processes).
Not a lot of changes are required to do that.

I can already see printk() whining on the horizon...

Thanks!

