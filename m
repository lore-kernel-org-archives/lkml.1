Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbYKTVTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbYKTVTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbYKTVTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:19:23 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:36495 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbYKTVTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:19:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=vXjkxHfISnJVs/AWgoTn8254XkN2fmrgcEeLMs734hSCCez+kcXfbO+BQpRVV19A5y
         uw7f2fs5Mg3m8vYrzx4dIgIlse7iRK00PCMExMSqN7gtto2TRUsMfuWPXIpAhtU8AYo2
         JHMj3+OOyp8VuV/loeTbU5ivaa712gagvFEsE=
Message-ID: <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
Date: Thu, 20 Nov 2008 22:19:18 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Markus Metzger" <markus.t.metzger@googlemail.com>
Subject: Re: debugctl msr
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1227133570.6104.10.camel@raistlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <1226743286.6162.6.camel@raistlin>
	 <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
	 <1227133570.6104.10.camel@raistlin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

I found a couple more bugs with ds.c:

- in ds_put_context(), you need to mark task->thread.ds_ctx = NULL or
this_system_context = NULL when you are
  done, otherwise a subsequent session on the same task or CPU will
think there is already a context allocated but
  the pointer will be stale.

- in ptrace.c:ptrace_disable(), you systematically invoke ds_release()
without checking if TIF_BTS_TRACE_TS
  is set. That causes extraneous calls to ds_release() which messes up
the reference counting if PEBS is in use.


I ran into those issues trying to make perfmon work. So far, I have
gotten per-thread PEBS to work. Per-cpu is still
crashing the machine.


On Wed, Nov 19, 2008 at 11:26 PM, Markus Metzger
<markus.t.metzger@googlemail.com> wrote:
> On Wed, 2008-11-19 at 20:20 +0100, stephane eranian wrote:
>
>> Yes, I have narrowed this down to the following lines:
>>         current->mm->total_vm  -= context->pages[qual];
>>         current->mm->locked_vm -= context->pages[qual];
>>
>> I think this is again related to the problem of which thread call
>> ds_release(). In my test
>> case, this is the monitored thread as it exits. By the time it gets
>> there current->mm is NULL.
>
> Yes, this is again the ptrace-ness of the approach. The entire code
> assumes that there is one tracer task that controls another traced task.
>
> You're right, though, that I should only do the memory accounting
> if the buffer had been allocated by ds.c.
> That's a plain bug. Perfmon2 is the first user that uses its own
> buffers.
>
>
>> > The point I was trying to make is that buffer overflows should not be
>> > handled on higher levels (i.e. users of ds.c). That's why I am so
>> > reluctant to expose the interrupt threshold in the ds.c interface.
>> >
>> But the threshold is a characteristic of the buffer, not the interrupt handler.
>> Depending on the tool, it may be interesting to set the threshold earlier than
>> at the end of the buffer.
>
> Good point.
>
> Would you want to change the threshold or would it be OK if this became
> another parameter to ds_request()?
>
> regards,
> markus.
>
>
