Return-Path: <linux-kernel-owner+w=401wt.eu-S932496AbXBNTrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbXBNTrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbXBNTrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:47:10 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:35656 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932496AbXBNTrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:47:09 -0500
Message-ID: <45D3673C.1070205@vmware.com>
Date: Wed, 14 Feb 2007 11:47:08 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
References: <200702060353.l163rUmj000771@zach-dev.vmware.com> <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com> <20070207123552.GD4481@ucw.cz> <1170880572.11736.4.camel@localhost.localdomain> <20070214122645.GE22008@elf.ucw.cz>
In-Reply-To: <20070214122645.GE22008@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2007-02-08 07:36:12, Rusty Russell wrote:
>   
>> On Wed, 2007-02-07 at 12:35 +0000, Pavel Machek wrote:
>>     
>>> Ugh, it sounds like paravirt is more b0rken then I thought. It should
>>> always to the proper delay, then replace those udelays that are not
>>> needed on virtualized hardware with something else.
>>>
>>> Just magically defining udelay into nop is broken.
>>>       
>> We'd have to audit and figure out what udelays are for hardware and
>> which are not, but the evidence is that the vast majority of them are
>> for hardware and not needed for virtualization.
>>     
>
> You did not time to do the full audit, so you just did #define.
>   

Yes, of course.  Since 99% of the drivers are completely irrelevant for 
paravirt, and 99% of the udelays are in drivers, there isn't much point 
to auditing a bunch of code we're not even going to be affected by.  The 
default case for udelay is it is not needed.


>> Changing udelay to "hardware_udelay" or something all over the kernel
>> would have delayed the paravirt_ops merge by an infinite amount 8)
>>     
>
> And here you claim you could not do the right thing, because people
> would notice you are doing huge search/replace without audit, and
> would stop you. So you simply hidden it from them :-(.
>   

What ludicrousness is this?  Hidden what?  That the default case for 
udelay is that it is not needed?

> Plus... udelay() should just work under virtualization, right? You get
> slightly slower kernel, but still working, so the "full audit" is not
> as hard as you are telling me.
>   

Save the time of doing a useless full audit and making sure we didn't 
accidentally redefine or misspell some symbol on a bunch of 
architectures we aren't even set up to compile for.

> Just replace udelay() with hardware_udelay() on places that matter in
> your workload...
>   

That's inconsistent.  We would be doing 2 SCSI drivers, part of the IDE 
code, some i386 arch code, some random places in the kernel... and now 
nobody else knows whether to use udelay or hardware_udelay and the code 
gets jumbled to the point that it is useless because there is no clear 
distinction between the two.  It is non-trivial to come up with a list 
of source files that we have to actually do this to.  One C-file calls a 
shared routine in a library, and now you've got a hidden udelay that you 
have absolutely no way of detecting.  The right thing to do if you want 
to do it on a line by line basis is exactly the opposite.  Remove udelay 
and find out what breaks.  Bugs are easier to find and fix than hidden 
code.  If I were to do it on a line by line basis, I would chose to 
replace udelay() with real_time_udelay() for those places that actually 
need it.

Zach
