Return-Path: <linux-kernel-owner+w=401wt.eu-S1161218AbXCGCId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161218AbXCGCId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXCGCId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:08:33 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41694 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161218AbXCGCIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:08:32 -0500
Message-ID: <45EE1EA3.90803@vmware.com>
Date: Tue, 06 Mar 2007 18:08:35 -0800
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
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com>	 <1173225182.24738.507.camel@localhost.localdomain>	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com>	 <1173228544.24738.514.camel@localhost.localdomain>	 <45EE0D10.7070807@vmware.com> <1173230305.24738.529.camel@localhost.localdomain>
In-Reply-To: <1173230305.24738.529.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 02:08:30.0199 (UTC) FILETIME=[802CC070:01C7605D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2007 05:18 PM, Thomas Gleixner wrote:
> On Tue, 2007-03-06 at 16:53 -0800, Dan Hecht wrote:
>>> Ooops. I completely forgot, that you get the absolute expiry time
>>> already in ktime_t format (nanoseconds) when dev->set_next_event() is
>>> called.
>>>
>>> 	dev->next_event = expires;
>>>
>>> is done right before the call. 
>>>
>>> So it's already there for free.
>>>
>>>
>> Okay.  I noticed that but didn't think it was okay to use since it 
>> didn't seem like it was set up for the clock_event_device code's use, so 
>> seemed like a conceptual interface violation to go digging around in 
>> there.
> 
> Yes it is. 
> 
> I just wanted to point out that you can use it until I'm awake enough to
> implement it proper.
> 

Well, we'll probably just live with using the relative expiry for the 
first pass, and then revisit this later once that is working, rather 
than resort to hacking it out by reading ->next_event.

>> Also, wasn't one of the points of clockevents to prevent the device code 
>> from doing conversions between nanoseconds and clicks themselves?  Don't 
>> we really want the clockevents generic layer to do this conversion 
>> between monotonic nanonseconds to absolute device clicks and then give 
>> the device code that value, so the device layer doesn't perform any 
>> conversions?
> 
> Right. But this applies only to deltas, as the conversion of absolute
> time values gets ugly, i.e. 128bit math
> 

Yeah, hopefully we can come up with a clean way to do this.  But, like I 
said early, until we do, we'll stick with the relative expiry.

> IMO the paravirt interfaces should use nanoseconds anyway for both
> readout and next event programming. That way the conversion is done in
> the hypervisor once and the clocksources and clockevents are simple and
> unified (except for the underlying hypervisor calls).
> 

I disagree.  The clocksource/clockevents layer are always going to have 
to convert nanoseconds to/from hardware units, so why not use it?  And, 
some guests (say, a future version of linux that does trace-based 
process accounting) may want higher resolution than nanoseconds for 
certain uses.  In any case, this is beside the point; I'd prefer to 
stick to using the clockevents interface in the way it was intended 
rather than reaching into ->next_event.

thanks,
Dan
