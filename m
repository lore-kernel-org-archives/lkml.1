Return-Path: <linux-kernel-owner+w=401wt.eu-S1762483AbXJENqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762483AbXJENqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 09:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbXJENqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 09:46:13 -0400
Received: from rtr.ca ([76.10.145.34]:1757 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344AbXJENqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 09:46:12 -0400
Message-ID: <47064023.7080703@rtr.ca>
Date: Fri, 05 Oct 2007 09:46:11 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Brown, Len" <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, simon.derr@bull.net,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/6] Fix SMP poweroff hangs
References: <200710010820.l918KApW006834@imap1.linux-foundation.org>	<CFF307C98FEABE47A452B27C06B85BB603DA9AB8@hdsmsx411.amr.corp.intel.com>	<m1hclascwo.fsf@ebiederm.dsl.xmission.com>	<200710020048.38856.rjw@sisk.pl>	<m1myv2o13c.fsf@ebiederm.dsl.xmission.com> <470198B1.2030003@rtr.ca>	<m1ve9pn8d1.fsf@ebiederm.dsl.xmission.com> <470271EA.4040509@rtr.ca>	<m1ejgdif0f.fsf@ebiederm.dsl.xmission.com> <4702C902.7000504@rtr.ca>	<4702CCFB.1010000@pobox.com> <47052292.3090400@rtr.ca> <m1myuyv6qu.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1myuyv6qu.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Mark Lord <lkml@rtr.ca> writes:
>> Comments?  Eric?
> 
> Sorry -EBUSY.
> 
> The trylock on call_lock is a recent thing (.22), added to keep panic
> from hanging.   It probably makes more sense to move bust_spinlocks(0)
> down a few lines in kernel/panic.c and to test oops_in_progress in
> smp_send_stop and make all screwy locking behavior depend on that.

I've seen this issue (to a much lessor extent) on 2.6.17 as well.
So if earlier kernels had the regular spin_lock() there (rather than trylock)
then this is still *an* issue, but not *the* issue.  And in my specific
case (only 2 CPUs), the trylock cannot be the problem here.
But with more cores it definitely could be an issue.

> As for not waiting until cpus are in their stop loop that looks easy
> enough to remedy.  I don't know if any of those is our culprit but
> it certainly looks worth cleaning up.  If you are interested in
> testing I will cook up a patch.

I suspect this one more, as there really are not many other possibilities.
One thing to try might be to just have the power_off() code do msleep(1000)
before the ACPI poweroff call.  That would give enough time for the other
core to "halt", and is easy enough to try for diagnosis purposes.

I'm off rock climbing for a week or so, but if you cook something up
in the meanwhile then I'll test it on return.

> I haven't had a chance yet to walk through the other possible x86
> sysdev devices to see if there are any other canidates.

Cheers!

