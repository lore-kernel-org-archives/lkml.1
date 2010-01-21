Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703Ab0AUJnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0AUJnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 04:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669Ab0AUJnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 04:43:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:37652 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab0AUJnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 04:43:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=VNywK2qMXbsufPtVfBk1I5/ldLv/dwpSzPmysbGSLgRSg818ZdQle30zq94RvA8GYc
         EebJ+1PXKPHKOyzdDVAtQws38id+qpNNq0o8XSDw/r2GHzhTfAoGaYqVbIGpafPcw1ji
         FVHo4PeWcp5n3QU3j6rQ/sWkTmiBm1Q1K/tCM=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1264064344.4283.1136.camel@laptop>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <1263994448.4283.1052.camel@laptop>
	 <1264023204.4283.1124.camel@laptop>
	 <7c86c4471001210047v5907f9d8ncecc1f5441afab3a@mail.gmail.com>
	 <1264064344.4283.1136.camel@laptop>
Date: Thu, 21 Jan 2010 10:43:09 +0100
Message-ID: <7c86c4471001210143v5f9f54dbx6026949ced7d6ca@mail.gmail.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       eranian@google.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 9:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-01-21 at 09:47 +0100, stephane eranian wrote:
>> I don't think that is correct. You can be using the uncore PMU on Nehalem
>> without any core PMU event. The only thing to realize is that uncore PMU
>> shares the same interrupt vector as core PMU. You need to configure which
>> core the uncore is going to interrupt on. This is done via a bitmask, so you
>> can interrupt more than one core at a time. Several strategies are possible.
>
> Ah, sharing the IRQ line is no problem. But from reading I got the

Given the PMU sharing model of perf_events, it seems you may have
multiple consumers of uncore PMU at the same time. That means you
will need to direct the interrupt onto all the CPU for which you currently
have a user. You may have multiple users per CPU, thus you need some
reference count to track all of that. The alternative is to systematically
broadcast the uncore PMU interrupt. Each core then checks whether or
not it has uncore users.

Note that all of this is independent of the type of event, i.e., per-thread
or system-wide.
