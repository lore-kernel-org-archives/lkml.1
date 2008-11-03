Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYKCIQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYKCIQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYKCIQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:16:39 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:5969 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbYKCIQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:16:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IPvkhffcn3/Q8Sc8SiW09bg419/5GfzupfSeuSjTsHJW9i4ZBLDn2tf0yDOHZxYD8c
         zFBlWvJe1SQ+Lcw3M8aD2q+JKqWCXtoZVB1DjvmfjjQuVTz3A7aayZmL2RUL8+eLbrHX
         g3ThsCamN+/GofRqsuK0M6B54raJISxikL1II=
Message-ID: <490EB361.9090007@gmail.com>
Date: Mon, 03 Nov 2008 10:16:33 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
 belongs to. Store thread group leader id, and use it to lookup the address
 in the process's map. We could have looked up the address on thread's map,
 but the thread might not exist by the time we are called. The process might
 not exist either, but if you are reading trace_pipe, that is unlikely.
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081103074754.GB13727@elte.hu>
In-Reply-To: <20081103074754.GB13727@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-03 09:47, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>
>   
>> +		struct task_struct *task;
>> +		/* we do the lookup on the thread group leader,
>> +		 * since individual threads might have already quit! */
>>     
>
> please use the customary comment style:
>
>   /*
>    * Comment .....
>    * ...... goes here:
>    */
>
>   

. Can checkpatch.pl warn me of situations like this?

>> -		if (ret /*&& (sym_flags & TRACE_ITER_SYM_ADDR)*/)
>> +		if (mm) {
>> +			const struct vm_area_struct *vma = find_vma(mm, ip);
>> +			if (vma) {
>> +				file = vma->vm_file;
>> +				vmstart = vma->vm_start;
>> +			}
>> +		}
>> +		if (file) {
>> +			ret = trace_seq_path(s, &file->f_path);
>> +			if (ret)
>> +				ret = trace_seq_printf(s, "[+0x%lx]",
>> +						ip - vmstart);
>> +		}
>> +		if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
>>  			ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
>>     
>
> the function is getting a bit large - would it make sense to split out 
> this section into a helper inline function?
>   

Yes, I'll do that.

> another small nit: i cleaned up the subject line and the commit log 
> message for you - see the two patches below - could you please keep it 
> for future (v3) submissions of these patches? It's just small 
> formatting changes.
>   

Ok, luckily git-rebase -i allows me to rewrite the log message too ;)

> Your patches are a nice feature we want to have nevertheless - to be 
> able to see where a user-space app is running has been one of the 
> historically weak points of kernel instrumentation.

Thanks.
It currently works for x86 only, but architecture porters can add
support for theirs quite easily, it just needs to modeled after how
oprofile does it for example.
BTW would it make sense to change oprofile and the sysprof tracer to use
save_stack_trace_user? It would eliminate some code duplication.

Would it make sense to add a script that post-processes the output to
scripts/tracing?
It would parse a trace log (from trace or latency_trace) and use
addr2line to resolve the address to source:line, and if successful
replace the relative address with that; and also
group identical stack traces together.

Best regards,
--Edwin
