Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621Ab0AUJQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0AUJQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 04:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923Ab0AUJQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 04:16:42 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:49619 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab0AUJQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 04:16:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=aarEbik0+Ec157xvXeTQdiADuIy+6j9zExEFw55k6JZPjDfM1Z1Yrsm35gP3CCIgMv
         Ze6+MS3bxVqKYrpq9u7KFPFX2o6rNKxcJZRSifU4cln92WzGC6Nh4ZmFNMHCq2yctMNw
         f41ThOpmwOGqYTK525bcGMp2Dn/5l24g2m4aQ=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1264064344.4283.1136.camel@laptop>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <1263994448.4283.1052.camel@laptop>
	 <1264023204.4283.1124.camel@laptop>
	 <7c86c4471001210047v5907f9d8ncecc1f5441afab3a@mail.gmail.com>
	 <1264064344.4283.1136.camel@laptop>
Date: Thu, 21 Jan 2010 10:16:37 +0100
Message-ID: <7c86c4471001210116v2d5e53cak399be8a1cd335efb@mail.gmail.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The offcore_response register is a CORE PMU register.
I know the name is confusing.

OFFCORE_RESPONSE_0 is not a counter but rather an
extension of the filtering capabilities of regular counters.
To use offcore_response_0, you will need to program
a generic counter (1 config, 1 data) + offcore_response_0.
This is a very useful feature to understand memory traffic.

There is an associated difficulty though. The
offcore_response_0 MSR is shared between HT threads.
Thus the kernel needs to arbitrate. That should be taken
care of by the event scheduling code which I am working
on.

In the context of perf_event, you need to find some encoding
of the event to pass as RAW. The raw event code + umask
is 0x01B7. Then, you need to encode the value for the
offcore_response_0 MSR, which is 16 bits on NHM/WSM.
You could either stash this into the config field or use an extended
field. The kernel would detect 0x01B7 and use the value in the
extra config field.

As described in vol3b, Intel Westmere adds a second
offcore_response counter. It behaves the same way with
the same restrictions.

The debugctl bit controls uncore activation not offcore.

On Thu, Jan 21, 2010 at 9:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-01-21 at 09:47 +0100, stephane eranian wrote:
>> I don't think that is correct. You can be using the uncore PMU on Nehalem
>> without any core PMU event. The only thing to realize is that uncore PMU
>> shares the same interrupt vector as core PMU. You need to configure which
>> core the uncore is going to interrupt on. This is done via a bitmask, so you
>> can interrupt more than one core at a time. Several strategies are possible.
>
> Ah, sharing the IRQ line is no problem. But from reading I got the
> impression you need to configure an Offcore counter. See 30.6.2.1:
>
> • EN_PMI_COREn (bit n, n = 0, 3 if four cores are present): When set, processor
> core n is programmed to receive an interrupt signal from any interrupt enabled
> uncore counter. PMI delivery due to an uncore counter overflow is enabled by
> setting IA32_DEBUG_CTL.Offcore_PMI_EN to 1.
>
> Which seems to indicate a link with the off-core response thing.
>
> However I would be very glad to be wrong :-)
>
>
