Return-Path: <linux-kernel-owner+w=401wt.eu-S933061AbZJLTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbZJLTOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932718AbZJLTOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:14:17 -0400
Received: from claw.goop.org ([74.207.240.146]:59648 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643AbZJLTOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:14:16 -0400
Message-ID: <4AD37FE3.1010002@goop.org>
Date: Mon, 12 Oct 2009 12:13:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add	vsyscall	implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com>	<4ACB0833.2050203@redhat.com>	<4ACB9074.1000804@goop.org>	<4ACC6C9C.7080707@redhat.com>	<4ACFD43E.6000506@goop.org> <4AD0CDFB.9030704@redhat.com>	<4AD3738B.6050200@goop.org> <4AD375A5.8050205@redhat.com>
In-Reply-To: <4AD375A5.8050205@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/09 11:29, Avi Kivity wrote:
> Good catch.  Doesn't that invalidate rdtscp based vgettimeofday on
> non-virt as well (assuming p == cpu)?

The tsc clocksource assumes the tsc is (mostly?) synced; it doesn't use
rdtscp or make any attempt at per-cpu corrections.

>> I suppose that works if you assume that:
>>
>>     1. every task->vcpu migration is associated with a hv/guest context
>>        switch, and
>>     2. every hv/guest context switch is a write barrier
>>
>> I guess 2 is a given, but I can at least imagine cases where 1 might not
>> be true.  Maybe.  It all seems very subtle.
>>    
>
> What is 1 exactly?  task switching to another vcpu?  that doesn't
> incur hypervisor involvement.  vcpu moving to another cpu?  That does.
Aie... OK.  So no barrier is required for a task double migration on
vcpus, because it ends up on the same pcpu and the ordering is local; if
there's a vcpu migration to a new pcpu in there too, then we always
expect a barrier.

>> And I don't really see a gain.  You avoid maintaining a second version
>> number, but at the cost of two rdtscps.  In my measurements, the whole
>> vsyscall takes around 100ns to run, and a single rdtsc takes about 30,
>> so 30% of total.  Unlike rdtsc, rdtscp is documented as being ordered in
>> the instruction stream, and so will take at least as long; two of them
>> will completely blow the vsyscall execution time.
>>    
>
> I agree, let's stick with the rdtscpless implementation.

OK, I'll use PeterZ's hint to try and find a more complete set of
migration points.

    J
