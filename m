Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbXGJPLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbXGJPLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbXGJPLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:11:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:10478 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbXGJPLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=H88raJP0+oV+WtTfHspcxDt04lD9PQIuqLkJ046Yi75i0H2neTYJjW7mIMZ8Sbu+caq6fVWTJ/BOhGDGRxxQTpJB1hnhftzxkfuifBR7rxojW1Pnjbxwk6zdZZixyJSDSucZwZO3Tjpbv8PcGFanEh5faYEsZ3HDmpEiHFFL4bE=
Message-ID: <4693A1A5.9070900@gmail.com>
Date: Wed, 11 Jul 2007 00:11:33 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
References: <Pine.LNX.4.44L0.0707101015500.2595-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707101015500.2595-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alan Stern wrote:
> Instead we should broadcast a notification to all threads which might
> try to add a device, telling them not to do it until the suspend is
> over.  After that notification is sent and current additions have
> completed, the driver core can simply fail further calls to
> device_add().
> 
>> IMHO, what's needed is a giant rwlock protecting the whole device
>> addition/removal while suspend is in progress (addition/removal during
>> resume should be safe as long as we put the new devices on the already
>> processed list).  The lock can probably replace dpm_sem and dpm_list_sem.

Sans notification, the plan proposed in the first paragraph and rwlock
with down_read_trylock() for addition/removal is pretty similar.

> Addition during resume is _not_ safe.  The new device can easily get
> added to the already-processed list in the wrong position, so that the
> next time the system is suspended the PM core tries to suspend the new
> device's parent before suspending the new device.

When a bus device is being woken up and rescanning the bus, all
prerequisites for the bus should have been resumed already.  As long as
the newly added device is placed after the bus device itself, things
should be safe.  Well, that's the theory at least.

>> It's probably necessary to use trylock from addition/removal to avoid
>> deadlock.  Drivers which support hotplugging need to rescan/revalidate
>> the bus during resume anyway so failing addition/removal during suspend
>> shouldn't be a problem.
> 
> I had envisioned using SRCU to synchronize existing device additions
> with the beginning of a suspend.  down_read_trylock should work just as
> well (aside from cacheline bouncing).

How high performance device addition/removal should be?  Wouldn't rwlock
be enough?

> Device removal isn't as much of a problem as addition.  We could allow
> it with no difficulty.  Failing it isn't really an option because
> device_del() returns void.  And anyway, my idea was to have the PM core
> acquire all the device semaphores at the start of the suspend -- this
> would automatically block any attempted removal until the semaphore was
> released.

Hmmm... locking all device mutexes sounds scary to me but I tend to be a
chicken and lockdep is great, so it might just work.  :-)

>> Regardless of the suspend problem, I like the above idea.  Actually, I
>> was thinking about doing exactly that for suicidal nodes when I first
>> found out the problem.  All that's needed is an owner field which allows
>> the owning thread to reenter (what was the name for this type of mutex?
>>  BSD folks like it).  It's probably better to put some restrictions to
>> allow only the specific case tho.
> 
> What with all the sysfs changes, I wouldn't know where to begin
> looking.  The idea occurred to me mainly because I was considering
> blocking all access to sysfs during a suspend -- the problem being that
> a suspend is itself triggered by a write to a sysfs attribute!  
> Somehow that write would have to wait for all _other_ existing accesses
> to complete and block new ones.

Why is that necessary?  What happens if there's some long-running
read/write operation using bin attr?

>> I like it because it shifts complexity from the drivers into driver
>> core.  IOW, the driver model is kinder to drivers that way - the driver
>> writer doesn't have to care whether something is suicidal or not - and I
>> think that's the way we should be headed although we're not good at it yet.
> 
> It doesn't shift all the complexity.  The method still has to tell the 
> sysfs core that it's going to unregister its attribute and that the 
> unregistration has finished.  But this is simpler than the callback 
> method we use now.

Right, it's nothing major.  I just dislike such limitation is visible
from individual drivers and "echo 1 > /sys/whatever/kill-yourself"
returns before the suicide is actually complete.

Thanks.

-- 
tejun
