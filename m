Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811Ab0AGJyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab0AGJyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367Ab0AGJyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:54:36 -0500
Received: from smtp-out.google.com ([216.239.33.17]:54399 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab0AGJyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:54:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=DVqPtGpRV0eWBlUO8m8mh7gafylIxAd7G42Z8l3FgoalyGCn+s5ze9pRk1ZR2M/Np
	uzWt5ZnM9zmeWV0hp1Krw==
MIME-Version: 1.0
In-Reply-To: <1262854826.4049.91.camel@laptop>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
	 <1258561957.3918.661.camel@laptop>
	 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
	 <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
	 <1261410040.4314.178.camel@laptop> <20091222010238.GB31264@drongo>
	 <bd4cb8900912290647wa79615bs3ac8618ca36808c3@mail.gmail.com>
	 <20100107041340.GA30718@drongo> <1262854826.4049.91.camel@laptop>
Date: Thu, 7 Jan 2010 10:54:30 +0100
Message-ID: <bd4cb8901001070154x84a569t71ac317c95eb4683@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, eranian@gmail.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       perfmon2-devel@lists.sf.net, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ok, so I made some progress yesterday on all of this.

The key elements are:
  -  pmu->enable() is always called from generic with PMU disabled
  -  pmu->disable() is called with PMU possibly enabled
  - hw_perf_group_sched_in() is always called with PMU disabled

I got the n_added logic working now on X86.

I noticed the difference in pmu->enabled() between Power and X86.
On PPC, you disable the whole PMU. On X86, that's not the case.

Now, I do the scheduling in hw_perf_enable(). Just like on PPC, I also
move events around if their register assignment has changed. It is not
quite working yet. I must have something wrong with the read and rewrite
code.

I will experiment with pmu->enable(). Given the key elements above, I think
Paul is right, all scheduling can be deferred until hw_perf_enable().

But there is a catch. I noticed that hw_perf_enable() is void. In
other words, it
means that if scheduling fails, you won't notice. This is not a problem on PPC
but will be on AMD64. That's because the scheduling depends on what goes on
on the other cores on the socket. In other words, things can change between
pmu->enable()/hw_perf_group_sched_in() and hw_perf_enable(). Unless we lock
something down in between.


On Thu, Jan 7, 2010 at 10:00 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-01-07 at 15:13 +1100, Paul Mackerras wrote:
>>
>> > All the enable and disable calls can be called from NMI interrupt context
>> > and thus must be very careful with locks.
>>
>> I didn't think the pmu->enable() and pmu->disable() functions could be
>> called from NMI context.
>
> I don't think they're called from NMI context either, most certainly not
> from the generic code.
>
> The x86 calls the raw disable from nmi to throttle the counter, but all
> that (should) do is disable that counter, which is limited to a single
> msr write. After that it schedules a full disable by sending a self-ipi.
>
>
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
