Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZFETTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZFETTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZFETTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:19:09 -0400
Received: from mail-qy0-f177.google.com ([209.85.221.177]:39063 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZFETTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:19:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=B9jCkc8u1/IcywVymTBUxRgN7pnH1E/wQ5SDczKmwyKYcplUXgz8DYD2Rg/4CfR9qe
         4rUBjE4d0OQanK07EPsItcBu71pG/ifcHX3wo2lry46OmMEGJ/0XR1EblSjmVAiYpsWa
         peTwFVYMzTu10d3mMH2r0nVBHzsvegiD+UayU=
MIME-Version: 1.0
In-Reply-To: <18983.26015.413162.445846@notabene.brown>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005951.4104.27062.stgit@dwillia2-linux.ch.intel.com>
	 <18983.26015.413162.445846@notabene.brown>
Date: Fri, 5 Jun 2009 12:19:07 -0700
X-Google-Sender-Auth: 2014f6eed6a1ea62
Message-ID: <e9c3a7c20906051219x122f443dtc7836f0c16ae9f27@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] md/raid5: add scribble region for buffer lists
From: Dan Williams <dan.j.williams@intel.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, maan@systemlinux.org,
       linux-kernel@vger.kernel.org, yur@emcraft.com, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 11:11 PM, Neil Brown<neilb@suse.de> wrote:
> On Monday May 18, dan.j.williams@intel.com wrote:
>> Hang some memory off of each stripe_head which can be used for storing
>> the buffer lists used in parity calculations.  Include space for dma
>> address conversions and pass that to async_tx via the
>> async_submit_ctl.scribble pointer.
>>
>> [ Impact: move memory pressure from stack to heap ]
>
> I've finally had a look at this and I cannot say that I like it.
>
> We don't really need one scribble-buffer per stripe_head.
> And in fact, that isn't even enough because you find you need a mutex
> to avoid multiple-use.

The mutex is probably not necessary, just need to audit the
stripe_operations state machine to make sure threads don't overlap in
raid_run_ops()...  but the point is mute when we move to per-cpu
resources.

> We really want one scribble-buffer per thread, or per CPU, or
> something like that.

One of the design goals was to prevent the occurrence of the
softlockup watchdog events which seem to trigger on large raid6
resyncs.  A per-cpu scheme would still require preempt_disable() while
the calculation is active, so perhaps we just need a call to
cond_resched() in raid5d to appease the scheduler.

> You could possibly handle it a bit like ->spare_page, though we cope
> with that being NULL some times, and you might not be able to do that
> with scribble-buffer.
> How do the async-raid6 patches cope with possible multiple users of
> ->spare_page now that the computations are async and so possible in
> parallel?

Currently the code just takes a spare page lock.

>
> Maybe a little mempool would be best?.... though given that in most
> cases, the stack solution is really quite adequate it would be good to
> make sure the replacement isn't too heavy-weight....
>
> I'm not sure what would be best, but I really don't like the current
> proposal.
>

I'll take a look at a per-cpu implementation.

Thanks,
Dan
