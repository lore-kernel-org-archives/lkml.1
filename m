Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYGHHPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYGHHPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYGHHPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:15:33 -0400
Received: from gw.goop.org ([64.81.55.164]:47530 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbYGHHPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:15:32 -0400
Message-ID: <48731409.9070304@goop.org>
Date: Tue, 08 Jul 2008 00:15:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 4/4] xen: implement Xen-specific spinlocks
References: <20080707190749.299430659@goop.org>	<20080707190838.710151521@goop.org> <87tzf0q3te.fsf@saeurebad.de>
In-Reply-To: <87tzf0q3te.fsf@saeurebad.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
>> +static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
>> +static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
>>     
>
> The plural is a bit misleading, as this is a single pointer per CPU.
>   

Yeah.  And it's wrong because it's specifically *not* spinning, but 
blocking.

>> +static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
>> +{
>> +	int cpu;
>> +
>> +	for_each_online_cpu(cpu) {
>>     
>
> Would it be feasible to have a bitmap for the spinning CPUs in order to
> do a for_each_spinning_cpu() here instead?  Or is setting a bit in
> spinning_lock() and unsetting it in unspinning_lock() more overhead than
> going over all CPUs here?
>   

Not worthwhile, I think.  This is a very rare path: it will only happen 
if 1) there's lock contention, that 2) wasn't resolved within the 
timeout.  In practice, this gets called a few thousand times per cpu 
over a kernbench, which is nothing.

My very original version of this code kept a bitmask of interested CPUs 
within the lock, but there's only space for 24 cpus if we still use a 
byte for the lock itself.  It all turned out fairly awkward, and this 
version is a marked improvement.

    J
