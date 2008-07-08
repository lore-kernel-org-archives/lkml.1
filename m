Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYGHHaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYGHHaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYGHHaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:30:11 -0400
Received: from saeurebad.de ([85.214.36.134]:50308 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYGHHaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:30:10 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 4/4] xen: implement Xen-specific spinlocks
References: <20080707190749.299430659@goop.org>
	<20080707190838.710151521@goop.org> <87tzf0q3te.fsf@saeurebad.de>
	<48731409.9070304@goop.org>
Date: Tue, 08 Jul 2008 09:30:00 +0200
In-Reply-To: <48731409.9070304@goop.org> (Jeremy Fitzhardinge's message of
	"Tue, 08 Jul 2008 00:15:21 -0700")
Message-ID: <87lk0cq1dz.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Johannes Weiner wrote:
>>> +static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
>>> +static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
>>>     
>>
>> The plural is a bit misleading, as this is a single pointer per CPU.
>>   
>
> Yeah.  And it's wrong because it's specifically *not* spinning, but
> blocking.

I thought of it as `virtually spinning', so had no problems with the
naming itself :)

>>> +static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
>>> +{
>>> +	int cpu;
>>> +
>>> +	for_each_online_cpu(cpu) {
>>>     
>>
>> Would it be feasible to have a bitmap for the spinning CPUs in order to
>> do a for_each_spinning_cpu() here instead?  Or is setting a bit in
>> spinning_lock() and unsetting it in unspinning_lock() more overhead than
>> going over all CPUs here?
>>   
>
> Not worthwhile, I think.  This is a very rare path: it will only
> happen if 1) there's lock contention, that 2) wasn't resolved within
> the timeout.  In practice, this gets called a few thousand times per
> cpu over a kernbench, which is nothing.

Okay, I agree.

	Hannes
