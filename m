Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170Ab0AROad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0AROad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133Ab0AROac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:30:32 -0500
Received: from mail.windriver.com ([147.11.1.11]:59145 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0AROab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:30:31 -0500
Message-ID: <4B54706C.20202@windriver.com>
Date: Mon, 18 Jan 2010 08:30:04 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 20/40] arm,kgdb: Add hook to catch an oops with	debugger
References: <20100114174821.GB21385@n2100.arm.linux.org.uk> <4B4F7EC2.6030000@windriver.com> <20100114204647.GE21385@n2100.arm.linux.org.uk>
In-Reply-To: <20100114204647.GE21385@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jan 2010 14:29:55.0885 (UTC) FILETIME=[B49FBDD0:01CA984A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Thu, Jan 14, 2010 at 02:29:54PM -0600, Jason Wessel wrote:
>   
>> Russell King - ARM Linux wrote:
>>     
>>> I have a similar patch which implements the hook properly - but
>>> with one caveat.  It needs a review to ensure that its safe to return
>>> from die().  Until that's established, this patch can not be merged.
>>>       
>> I completed the analysis on your patch and yes, it is safe to return
>> from __die() and die() the way you currently structured it, but it
>> doesn't work quite the same as on some other architectures.
>>
>> After changing kgdb.c to register with the die notifier, I stepped
>> through your code with an ICE, as well as running my regression tests
>> which panic, oops, bad access etc...
>>
>> While kernel execution does happen to continue to work, I don't know
>> that you really want to continue execution.
>>
>> 1) The kernel is marked tainted
>> 2) bust_spinlocks() was toggled for a while
>>
>> On x86 for example, the notifier is invoked prior to the
>> bust_spinlocks() etc... and then it can pass the exception along to
>> the rest of the system (which can result in something bad, but
>> remember the human behind the kernel debugger controls did it for some
>> reason or another).
>>     
>
> On x86, it's called in multiple places - both before die(), and also
> inside __die().
>
> In __die(), notify_die() gets called with DIE_OOPS.  There's also a
> pile of notify_die() calls in arch/x86/kernel/traps.c, which we don't
> implement on ARM yet - it's unclear what's required here, and until
> we have a user of notify_die()...
>
>   

Initially I was just looking to get the memory violation tests to pass
on ARM, where the kernel debugger can catch an invalid memory write for
instance.  That means anything that generates any kind of system fault
should jump into the debugger via the die notifier.  There might be
other places for this on ARM, but I figured we could start with the
passing the memory fault tests first.

>> I made the following addition to your patch, and then it behaved as
>> the other archs do with respect to passing along the result of the
>> exception.  Given this information, would you be willing to merge your
>> patch and possibly fold in the change below, or further comment?
>>     
>
> This changes the behaviour away from x86, so I'm not sure it's the
> right thing to do.  For instance, it means that kexec won't get to
> know about the oops on ARM if NOTIFY_STOP is returned, whereas on
> x86 it will.
>
> Maybe this hook wasn't meant for kgdb - what does kgdb use on x86?
>   

On x86, kgdb uses the notify die hook.  It is possible that there are
some inconsistent uses of the notifiy_die(), but the general idea is
that any user in the hook path can elect to consume the exception and
allow the system to restore.

In terms of kgdb's use of this, I have only found it useful for
programmatic testing of exception cases.  Specifically when using kdb,
the default are always to propagate exceptions unless it was a
breakpoint or single step exception which was set by the kernel debugger.

That being said, you patch works for the purpose of catching the
exception and returning with or without the addition of an earlier
return before bust_spinlocks() which I had proposed.

Jason.
