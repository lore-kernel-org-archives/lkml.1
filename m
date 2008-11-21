Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYKUIsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYKUIsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYKUIrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:47:53 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:26187 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbYKUIrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:47:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=JVWZ0JZ8h82Z0lLnxfxrqM/8pVW2c2Ihun1DqnCt4Q5P4jZieb5CW976awpJLdYeM4
         KFv40ho7vVyHb08ADm8BFlLyLsOiNaNhFOvtm5SUIADnwEFwbbZ2FJSVqDQtx+5fGynq
         DMOcunpxjUWYWbcMKKOXq//543qVaS3nQ/c7o=
Message-ID: <7c86c4470811210047u66a4c188nb99785527f1718ef@mail.gmail.com>
Date: Fri, 21 Nov 2008 09:47:50 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: debugctl msr
Cc: "Markus Metzger" <markus.t.metzger@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
	 <1227133570.6104.10.camel@raistlin>
	 <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

On Fri, Nov 21, 2008 at 9:22 AM, Metzger, Markus T
<markus.t.metzger@intel.com> wrote:
>>-----Original Message-----
>>From: stephane eranian [mailto:eranian@googlemail.com]
>>Sent: Donnerstag, 20. November 2008 22:19
>>To: Markus Metzger
>
>>- in ds_put_context(), you need to mark task->thread.ds_ctx = NULL or
>>this_system_context = NULL when you are
>>  done, otherwise a subsequent session on the same task or CPU will
>>think there is already a context allocated but
>>  the pointer will be stale.
>
> This should happen in:
>    *(context->this) = NULL;
>
Ah, I missed that. I admit this code is hard to follow. Maybe it would easier to
explicitly use the actual fields.
>
>>- in ptrace.c:ptrace_disable(), you systematically invoke ds_release()
>>without checking if TIF_BTS_TRACE_TS
>>  is set. That causes extraneous calls to ds_release() which messes up
>>the reference counting if PEBS is in use.
>
> That TIF only triggers the recording of scheduling timestamps.
>
> That ds_release_bts() call should:
> - get the context
> - fail the ownership validation in ds_validate()
> - put the context
>
> If ds_validate() is disabled, it would put the context twice.
>
Yes, that was my case.


>
> I am currently working on a patch to replace the validation
> mechanism by using a handle returned from ds_request().
>
Yes, that's the solution.

> I also added the interrupt threshold to the parameters of ds_request().
> It will be fix for one tracing session, if that's OK with you.
>
Yes.

I found the reason why in system-wide my kernel was crashing.
It was due to the way you are writing DS_AREA_MSR in
ds_allocate_context():

                if (!task || (task == current))
                        wrmsr(MSR_IA32_DS_AREA, (unsigned long)context->ds, 0);


This does not work in 64-bit, you truncate the DS address. You must use wrmsrl()
and let the macro break it down in two halves.

I am still seeing an issue whereby I have a buffer with > 100 entries
but I get an interrupt
or each sample, which is wrong. I am investigating why this is. There
should only be one
interrupt per buffer full. This use to work with my old ways of handling PEBS.

Thanks.
