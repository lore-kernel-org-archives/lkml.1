Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbXJENkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbXJENkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 09:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXJENkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 09:40:25 -0400
Received: from rtr.ca ([76.10.145.34]:3308 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbXJENkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 09:40:25 -0400
Message-ID: <47063EC7.4060105@rtr.ca>
Date: Fri, 05 Oct 2007 09:40:23 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Brown, Len" <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, simon.derr@bull.net,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [patch 4/6] Fix SMP poweroff hangs
References: <200710010820.l918KApW006834@imap1.linux-foundation.org> <CFF307C98FEABE47A452B27C06B85BB603DA9AB8@hdsmsx411.amr.corp.intel.com> <m1hclascwo.fsf@ebiederm.dsl.xmission.com> <200710020048.38856.rjw@sisk.pl> <m1myv2o13c.fsf@ebiederm.dsl.xmission.com> <470198B1.2030003@rtr.ca> <m1ve9pn8d1.fsf@ebiederm.dsl.xmission.com> <470271EA.4040509@rtr.ca> <m1ejgdif0f.fsf@ebiederm.dsl.xmission.com> <4702C902.7000504@rtr.ca> <4702CCFB.1010000@pobox.com>
In-Reply-To: <4702CCFB.1010000@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(reposting this.. somehow left LKML off the TO/CC list)

Mark Lord wrote:
> Eric W. Biederman wrote:
>> Mark Lord <lkml@rtr.ca> writes:
..
>> The code path on i386 should be:
>> machine_power_off
>>   native_machine_power_off
>>      machine_shutdown(); (which disables the other cpus)
>>     smp_call_function
>>        stop_this_cpu (on each cpu to be stopped.
>>      pm_power_off(); (which turns off the power)
> ..
>> This does sound like a race of some sort.
>
> Mmm... thanks for the tour.
>
> The cpu hotplug code appears to take great precautions against internal races
> (dunno if it succeeds or not, though), but the correspond code in native_smp_send_stop()
> looks a bit iffy by comparison.  I wonder if that's where it gets stuck?
>
> static void native_smp_send_stop(void)
> {
>        /* Don't deadlock on the call lock in panic */
>        int nolock = !spin_trylock(&call_lock);
>        unsigned long flags;
>
>        local_irq_save(flags);
>        __smp_call_function(stop_this_cpu, NULL, 0, 0);
>        if (!nolock)
>                spin_unlock(&call_lock);
>        disable_local_APIC();
>        local_irq_restore(flags);
> }
>
> So basically, it tries to avoid races by grabbing the call_lock,
> but then ignores that lock and proceeds anyway.  Recipe for a race?

Hmmmm.. and that code also fails to wait for the other CPU(s)
to actually halt (not sure how it could wait, but it doesn't even try),
so the other CPU(s) could easily still be active when we then stumble
into our ACPI call to turn the power off.

I suppose that might possibly hurt something.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
