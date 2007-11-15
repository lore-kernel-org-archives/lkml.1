Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbXKOS3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbXKOS3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759150AbXKOS3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:29:07 -0500
Received: from rtr.ca ([76.10.145.34]:2014 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758131AbXKOS3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:29:06 -0500
Message-ID: <473C8FF0.4050702@rtr.ca>
Date: Thu, 15 Nov 2007 13:29:04 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: EIP is at device_shutdown+0x32/0x60
References: <20071115091158.GB6216@localhost.sw.ru> <20071115014446.f943d835.akpm@linux-foundation.org> <20071115213345.B3C1.Y-GOTO@jp.fujitsu.com> <20071115163435.GC24087@suse.de> <473C7CE4.5000702@rtr.ca> <20071115182310.GF24531@suse.de>
In-Reply-To: <20071115182310.GF24531@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Nov 15, 2007 at 12:07:48PM -0500, Mark Lord wrote:
..
>> Greg, I don't know if this is relevant or not,
>> but x86 has bugs in the halt/reboot code for SMP.
>>
>> Specifically, in native_smp_send_stop() the code now uses
>> spin_trylock() to "lock" the shared call buffers,
>> but then ignores the result.
>>
>> This means that multiple CPUs can/will clobber each other
>> in that code.
>>
>> The second bug, is that this code does not wait for the
>> target CPUs to actually stop before it continues.
>>
>> This was the real cause of the failure-to-poweroff problems
>> I was having with 2.6.23, which we fixed by using CPU hotplug
>> to disable_nonboot_cpus() before the above code ever got run.
> 
> I have noticed that the shutdown path is quite weird, shutting down
> sysdev devices differently depending on the type of shutdown, which is
> probably not good.
> 
> But what change are you talking about for the poweroff problem?  I have
> a _lot_ of people reporting that 2.6.22 is not powering off for them and
> I can't seem to figure it out.  Do you have a changeset for something
> that went in to fix this issue?
..

Well, the real bugs that cause the problem are described by me above.
I don't have a fix for those, but the workaround is in 2.6.23
under git 4047727e5ae33f9b8d2b7766d1994ea6e5ec2991 Fix SMP poweroff hangs.

With that workaround, there's no more hanging on halt,
though there could still be a hang on reboot.

A problem with that workaround is that it has no effect unless
the CPU hotplug code is configured (CONFIG_PM_SLEEP_SMP and pals).

Cheers
