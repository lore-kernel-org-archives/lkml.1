Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbXK0NbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbXK0NbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXK0NbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:31:07 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34360 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbXK0NbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:31:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, hbabu@us.ibm.com, vgoyal@in.ibm.com,
       kexec@lists.infradead.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <20071127014740.GA28622@hmsreliant.think-freely.org>
	<m1d4twmimu.fsf@ebiederm.dsl.xmission.com>
	<20071127131355.GA14887@hmsendeavour.rdu.redhat.com>
Date: Tue, 27 Nov 2007 06:28:13 -0700
In-Reply-To: <20071127131355.GA14887@hmsendeavour.rdu.redhat.com> (Neil
	Horman's message of "Tue, 27 Nov 2007 08:13:55 -0500")
Message-ID: <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@redhat.com> writes:

> What makes you say this?  I don't see any need for interrupts prior to
> calibrate_delay()

Yes.  calibrate_delay() is the first place we send interrupts over
hypertransport.  However I/O still works.  Thus hypertransport from
the first cpu is working, and hypertransport itself is working.

This is an interrupt specific problem not some generic hypertransport
problem.

>> I agree that there is a problem.
>> 
>> The reliable fix is to totally skip the PIC interrupt mode and go directly
>> to apic mode.
>> 
>> To make the code kexec on panic code path reliable we need to remove code
>> not add it.
>> 
>> Frankly I think switching cpus is one of the least reliable things that
>> we can do in general.
>> 
> I understand the sentiment here, but its not like we're adding additional
> functionality with this patch.  We're already sending an IPI to all the
> processors to halt them

And we don't care if they halt.  If they don't get the IPI we timeout.
Making the IPI mandatory is a _singificant_ change.

The only reason that code is on the kexec on panic code path is that
there is no other possible place we could put it.

> , we're just adding logic here so that we can detect the
> boot cpu and use it to jump to the kexec image instead of halting.  I don't
> think this is any less reliable that what we have currently.

It doesn't make things more reliable, and it adds code to a code path
that already has to much code to be solid reliable (thus your
problem). 

Putting the system back in PIC legacy mode on the kexec on panic path
was supposed to be a short term hack until we could remove the need
by always deliver interrupts in apic mode.

If you can't root cause your problem and figure out how the apics
are misconfigured for legacy mode let's remove the need for going into
to legacy PIC mode and do what we should be able to do reliably.  The
reward is much higher, as we kill all possibility of restoring PIC
mode wrong because we don't need to bother.

Eric
