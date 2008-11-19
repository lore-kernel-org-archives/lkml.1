Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbYKSTVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbYKSTVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYKSTUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:20:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:34992 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbYKSTUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:20:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Cyt5xEekkgBfuZajNtkXmmAJL+YNRUPZuMfBjzcl1luQ7Xab4LYbwo3L2LZzkqzXFj
         N1jULG28fzLMx5Pz1tVrZmnkDHnqt2o5nCCmXw0aTdzWygY+9VgtD4qXMoRpFNRzp/KJ
         nT7ivv7FjDBlAdOcjFRhtMzn/Wq9yRqx1vFRk=
Message-ID: <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
Date: Wed, 19 Nov 2008 20:20:52 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Markus Metzger" <markus.t.metzger@googlemail.com>
Subject: Re: debugctl msr
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1227119245.6025.12.camel@raistlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
	 <1226743286.6162.6.camel@raistlin>
	 <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,


On Wed, Nov 19, 2008 at 7:27 PM, Markus Metzger
<markus.t.metzger@googlemail.com> wrote:
> On Wed, 2008-11-19 at 18:13 +0100, stephane eranian wrote:
>
>> I found another issue with ds_release(). You need to skip freeing the
>> buffer when it
>> is NULL, i.e., was already allocated by caller of ds_request_pebs().
>
> ds_release() is not robust with respect to double release, if that's
> what you mean. Is that desirable?
>
I don't think so.

> For a single ds_release() call matching a corresponding successful
> ds_request() call, the buffer is freed if and only if it had been
> allocated by ds.c.
>
> Kfree() itself handles NULL pointers and scripts/checkpatch.pl warns on
> a check for NULL around a kfree() call.
>
Yes, I have narrowed this down to the following lines:
        current->mm->total_vm  -= context->pages[qual];
        current->mm->locked_vm -= context->pages[qual];

I think this is again related to the problem of which thread call
ds_release(). In my test
case, this is the monitored thread as it exits. By the time it gets
there current->mm is NULL.

>> As for handling the interrupt is ds.c, not clear how this could work
>> with current perfmon.
>> I don't know how this work on the BTS side. On the PMU side, that is not because
>> I am using PEBS, that I don't also use other counters as well. Longer
>> term, I think, there
>> needs to be a lower-level PMU interrupt service where you would
>> register a callback
>> on PMU interrupts. It would be used by NMI watchdog, perfmon,
>> Oprofile, ds.c.
>
> That's even preferable to having the interrupt code itself in ds.c
>
Yes!

> The point I was trying to make is that buffer overflows should not be
> handled on higher levels (i.e. users of ds.c). That's why I am so
> reluctant to expose the interrupt threshold in the ds.c interface.
>
But the threshold is a characteristic of the buffer, not the interrupt handler.
Depending on the tool, it may be interesting to set the threshold earlier than
at the end of the buffer.
