Return-Path: <linux-kernel-owner+w=401wt.eu-S2992829AbXDRQiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992829AbXDRQiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992830AbXDRQiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:38:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:54661 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992829AbXDRQiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CpLpXB1XGgMg5gNmkQLcNXKUjqXROBf6yWRxNq17+dA7eTaVtVGFFgqOlYF4jMOXHfkmIIyT01TIyS/6WpLgqhUZoSQCR9iwjCjYrfrbcIXJ2Po1x/A99Iv4Oz78i35mfEC3kSZZl4cYf77vXJhv+Ytura6cQquWM9oAmzmjdWI=
Message-ID: <46264969.5050003@gmail.com>
Date: Thu, 19 Apr 2007 01:38:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <Pine.LNX.4.44L0.0704181149280.12246-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704181149280.12246-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alan Stern wrote:
> On Thu, 19 Apr 2007, Tejun Heo wrote:
> 
>> The goal of immediate-disconnect is to remove such lingering reference
>> counts so that device_unregister() or driver detach puts the last
>> reference count.
> 
> Yes, I understand.  If you had immediate-disconnect then you wouldn't need 
> device_unregister_wait().  In fact, you wouldn't need any reference counts 
> at all.  It would be guaranteed that when the unregister call returned, 
> all references would be gone.
> 
>> You tell a higher layer that a device is going away, on return from the
>> function, that layer isn't gonna access the device anymore.
> 
> No, no.  You tell somebody (it might be a higher layer, it might be a 
> lower layer, or it might be a same-height layer -- doesn't matter) that a 
> device is going away.

Yeap, right.  I higher, lower, same, whatever.  I was using the term as
drivers usually register to upper layers.

> On return from the function, that layer isn't going 
> to access the device any more, _nor_ will anyone else who has obtained a 
> reference from that layer.  This last clause is very important.

Agreed.  That layer is responsible for managing lingering objects and
telling its users that the device is a zombie now.

>> I don't think this is gonna be too difficult to do.  I think I can
>> convert block layer and IDE/SCSI drivers without too much problem.
>> Dunno much about other layers tho.
> 
> You have to convert more than layers (or core subsystems).  You also have 
> to audit and convert drivers.  It will be tremendously difficult to do.

I definitely can be mis-assessing the problem.  I'll first give a shot
at the block/SCSI layer.  How about that?

> You did misunderstand.  Here's what I was talking about:
> 
> Driver A:
> ---------
> 	unregister_device(dev);
> 
> 		/* inside the driver core */
> 		down(&dev->sem);
> 		if (dev->driver)
> 			dev->driver->remove(dev);
> 		up(&dev->sem);
> 		device_put(dev);	/* or device_put_wait */
> 
> 
> Driver B:
> ---------
> void remove(struct device *dev)
> {
> 	struct my_device *mydev = dev_get_drvdata(dev);
> 
> 	mydev->gone = 1;
> 	kref_put(&mydev->kref, my_device_release);
> }
> 
> 
> Driver B's kernel thread:
> -------------------------
> 	kref_get(&mydev->kref);
> 	down(&mydev->dev.sem);
> 	if (mydev->gone)
> 		goto finished;
> 	...
>  finished:
> 	up(&mydev->dev.sem);
> 	kref_put(&mydev->kref, my_device_release);
> 
> Consider what happens if the kernel thread blocks on its down() while the
> remove() method is running.  It will be impossible for Driver B to
> eliminate the reference to dev held by mydev and by the down() routine.
> 
> In short, Driver B _can't_ provide an immediate detach.  Not unless 
> someone figures out a way to cancel a blocked down().  And do the same 
> thing for other blocking primitives.

Ah.. I see.  You're right in that driver B cannot wait for disconnect in
its remove routine in the above code but using a separate mutex to
protect ->gone should do the trick, so I don't think the above case is a
big problem.  It's a pretty specific case which is easy to spot and update.

Thanks.

-- 
tejun
