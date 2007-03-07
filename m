Return-Path: <linux-kernel-owner+w=401wt.eu-S1161051AbXCGAxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161051AbXCGAxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161070AbXCGAxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:53:34 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53016 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161051AbXCGAxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:53:33 -0500
Message-ID: <45EE0D10.7070807@vmware.com>
Date: Tue, 06 Mar 2007 16:53:36 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Dan Hecht <dhecht@vmware.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com>	 <1173225182.24738.507.camel@localhost.localdomain>	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com> <1173228544.24738.514.camel@localhost.localdomain>
In-Reply-To: <1173228544.24738.514.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 00:53:31.0577 (UTC) FILETIME=[06C98290:01C76053]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2007 04:49 PM, Thomas Gleixner wrote:
> On Tue, 2007-03-06 at 16:35 -0800, Dan Hecht wrote:
>>>> There is no problem for realtime uses, as the reprogramming path is
>>>> running with local interrupts disabled. I can see the point for paravirt
>>>> and I'm not opposed to change / expand the interface for that. It might
>>>> be done by an extra clockevents feature flag, which requests absolute
>>>> time instead of relative time.
>>>>   
>>> I'm not sure how much different it makes overall.  It's true that
>>> absolute time would be a more useful interface, but because the guest
>>> vcpu can be preempted at any time, we could miss the timeout
>>> regardless.  In Xen if you set a timeout for the past you get an
>>> immediate interrupt; I presume the clockevent code can deal with that?
>>>
>> That's the problem though, you won't know to set it for the past since 
>> the expiry is relative.  When the vcpu starts running again, it will set 
>> the timer to expire X ns from now, not Xns from when the timer was 
>> requested.
> 
> Ooops. I completely forgot, that you get the absolute expiry time
> already in ktime_t format (nanoseconds) when dev->set_next_event() is
> called.
> 
> 	dev->next_event = expires;
> 
> is done right before the call. 
> 
> So it's already there for free.
> 
>

Okay.  I noticed that but didn't think it was okay to use since it 
didn't seem like it was set up for the clock_event_device code's use, so 
seemed like a conceptual interface violation to go digging around in 
there.

Also, wasn't one of the points of clockevents to prevent the device code 
from doing conversions between nanoseconds and clicks themselves?  Don't 
we really want the clockevents generic layer to do this conversion 
between monotonic nanonseconds to absolute device clicks and then give 
the device code that value, so the device layer doesn't perform any 
conversions?


On an unrelated note, can you explain what the difference between 
CLOCK_EVT_MODE_UNUSED and CLOCK_EVT_MODE_SHUTDOWN modes are and what the 
legal state transitions are? (or point me to a document describing 
this).  At least on i386, all clock event devices treat them the same; 
do we really need both?

