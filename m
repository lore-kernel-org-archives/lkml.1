Return-Path: <linux-kernel-owner+w=401wt.eu-S932530AbXBNUE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbXBNUE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932532AbXBNUE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:04:28 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46893 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932530AbXBNUE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:04:26 -0500
Message-ID: <45D36B49.5090109@vmware.com>
Date: Wed, 14 Feb 2007 12:04:25 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>	<20070206122729.GC47229@muc.de>	<45C8FA2D.6010706@vmware.com>	<20070207123552.GD4481@ucw.cz>	<1170880572.11736.4.camel@localhost.localdomain> <20070214125216.2befda78@localhost.localdomain>
In-Reply-To: <20070214125216.2befda78@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>> We'd have to audit and figure out what udelays are for hardware and
>> which are not, but the evidence is that the vast majority of them are
>> for hardware and not needed for virtualization.
>>     
>
> Which is irrelevant since the hardware drivers won't be used in a
> virtualised environment with any kind of performance optimisation.
>   

Which is why an audit is irrelevant for the most part.  Note on the 
performance below.

>> Changing udelay to "hardware_udelay" or something all over the kernel
>> would have delayed the paravirt_ops merge by an infinite amount 8)
>>     
>
> paravirt_ops has no business fiddling with udelay. Not only does it
> create more code bloat and stalls in relatively fast paths but its
> optimising the wrong thing anyway.
>   

???  I fail to see the code bloat and also the fast paths.  Which fast 
paths use udelay?

> My performance sucks -> optimise out udelay is the wrong approach. My
> performance sucks, switch to the virtual block driver is the right
> approach, and a virtual block driver won't be using udelay anyway
>   

This is not to stop performance from sucking.  It doesn't.  This is not 
an "approach".  Sure, a virtual block driver won't be using udelay.  
Everyone else who writes hypervisors writes virtual block drivers 
because they don't have optimized I/O emulation for real hardware.  
Their performance sucks without it because they have to go switch to 
some other context and run a device emulator.  Our doesn't.  We have 
optimized almost every I/O device we emulate.  But sitting around 
spinning in udelay is wasting everybody's time.  There is an overhead 
cost to trapping out on I/O instructions.  Removing the udelays that 
typically happen around I/O instructions causes the emulation to break even.

And that is a good thing.  It's certainly not required, nor is it a 
significant win while the kernel is running.  It does cut the boot time 
by a lot, and you will notice an obvious difference with a much faster 
kernel boot simply because a lot of the hardware setup has very 
conservative udelays which take a lot of time during device 
initialization.  Since boot time * number of reboots has a direct impact 
on the number of 9's you can claim for uptime, this is actually a large 
win for reliability.

Zach
