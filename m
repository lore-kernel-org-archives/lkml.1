Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbZBKHDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbZBKHDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZBKHDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:03:11 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:57166 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZBKHDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:03:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iT3LrmN4ZtfrndndOzye5XnXnG2QEGo3Db4blIF73OtviMxvBYVzqk9ZTzZQ7wYlX3
         zIqRkBgrcGYK98JYiC8Uv++CsQOIU3pWPQ5ZTp1cASKjKCIeDE3nwcz/6mv0u6zxVWan
         X3/SibUBW1dEFjtfmoR1yRgE2HbSfp0kbNNCw=
Message-ID: <49927828.5090300@gmail.com>
Date: Wed, 11 Feb 2009 08:03:04 +0100
From: Markus Metzger <markus.t.metzger@googlemail.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Markus Metzger <markus.t.metzger@googlemail.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
References: <20090209010233.GA26444@redhat.com> <20090209012824.GA26461@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E4A1E7C8B@irsmsx504.ger.corp.intel.com> <20090209193625.GA4808@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E4A1E82FE@irsmsx504.ger.corp.intel.com> <20090210184014.GA30545@redhat.com> <1234297319.6112.23.camel@raistlin> <1234299614.6112.55.camel@raistlin> <20090210214804.GB4257@redhat.com>
In-Reply-To: <20090210214804.GB4257@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 02/10, Markus Metzger wrote:
>> On Tue, 2009-02-10 at 21:21 +0100, Markus Metzger wrote:
>>> On Tue, 2009-02-10 at 19:40 +0100, Oleg Nesterov wrote:
>>>> Perhaps, for 2.6.29, we can do something like the "patch" below?
>>>>
>>>> --- a/arch/x86/kernel/ptrace.c
>>>> +++ b/arch/x86/kernel/ptrace.c
>>>> @@ -810,11 +810,15 @@ static void ptrace_bts_untrace(struct ta
>>>>  
>>>>  static void ptrace_bts_detach(struct task_struct *child)
>>>>  {
>>>> +	// We can race with de_thread/do_wait which
>>>> +	// can do ptrace_bts_untrace() before us
>>>>  	if (unlikely(child->bts)) {
>>>> -		ds_release_bts(child->bts);
>>>> -		child->bts = NULL;
>>>> -
>>>> -		ptrace_bts_free_buffer(child);
>>>> +		// This all will be freed by ptrace_bts_untrace()
>>>> +		// later, but we should update ->mm
>>>> +		down_write(->mmap_sem);
>>>> +		mm->total_vm  -= bts_size;
>>>> +		mm->locked_vm -= bts_size);
>>>> +		up_write(->mmap_sem);
>>>>  	}
>>>>  }
>>>>  #else
>>>>

> The goal of this patch is to avoid the crash. The memory accounting
> in ->mm is still not right. But at least, the tracer can not "steal"
> the memory above the limits. And the "good" tracer should not exit
> without detach, and it shouldn't release the tracee from sub-thread
> if this can race with detach.
> 
> So, afaics, the worst thing which can happen is: the "bad" tracer
> is punished by the "unfair" mm->xxx_vm numbers.
> 
> Except exec() can release the main thread whatever the tracer does...
> 
>> We need to make ptrace_bts_untrace() ignore child->bts_size and clear
>> it in ptrace_bts_detach().
> 
> This is worse, now we can leak the memory if the tracer doesn't
> do ptrace_detach().

I see.

If the tracer dies and bypasses detach, the next tracer to trace the tracee
would get the memory refunded when he configures branch tracing - unless we take 
care about this in ptrace_bts_configure() and only refund the memory when there 
was a buffer to free.

But this would complicate the code even more.

I think that the underlying problem is that ptrace_detach() can be bypassed.
This bypasses also arch-specific cleanup code - that's why I added 
arch_ptrace_untrace().
It would all be very simple if that were not the case.

regards,
markus.
