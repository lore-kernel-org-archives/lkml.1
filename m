Return-Path: <linux-kernel-owner+w=401wt.eu-S1422856AbXDTF1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422856AbXDTF1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422888AbXDTF1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:27:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:47247 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422856AbXDTF1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:27:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DIXKCmCy/IGzafNeM8yESTeSKZ9JZD8rumnZVgVjL6WjKlgPhaQ/E63OgcotiZKrrdr3YPEGvHXiTakN4oTXc3mvK1818DJJY8l7JasDQs8c7JBEsJPBdRShqahC0uk2ImIotY7fA+2+2ckwP9kLIKzmgKG5w34Pvfgxix2gMc0=
Message-ID: <46284F2A.4000401@gmail.com>
Date: Fri, 20 Apr 2007 14:27:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <Pine.LNX.4.44L0.0704181219250.12246-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704181219250.12246-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Stern wrote:
> This doesn't solve a related problem: a subsystem wants to register
> devices and to provide a set of mutually-exclusive services to the
> devices' drivers.  The mutual exclusion has to be provided by a mutex or
> something similar, and the drivers need a way to unbind even while waiting
> to acquire the mutex.

I don't really follow why the drivers need a way to unbind even while
waiting to acquire the mutex.  Care to enlighten me?

> The obvious answer is to introduce a different sort of synchronization 
> primitive: a mutex (or semaphore or rwsem) which can be invalidated.
> 
> The semantics would be straightforward.  When mutex_invalidate() is
> called, it marks the mutex so that all future lock attempts will fail with
> -ENODEV.  It also wakes up all threads that are blocked trying to lock the
> mutex and causes them to fail with the same error.  Once all that is done
> mutex_invalidate() returns.  In particular, it doesn't wait for the
> current lock to be released -- in fact, you would call it while holding
> the lock.
> 
> This would solve a lot of your problems.  But it would also mean making 
> extensive changes to the kernel.  For one thing, mutex_lock() would return 
> int instead of void, and you would want to mark it __must_check.  Every 
> place where a mutex is locked, the code would have to be changed to add an 
> error pathway.  That's the sort of thing I was talking about when I said 
> it was going to be a tremendous job.

I think we both agree that's not a good idea.  :-)

> I thought of something else that could also be done: There should be a way
> to cancel an outstanding workqueue request.  At the moment all you can do
> is call flush_workqueue(), which will hang if you are already executing in
> a workqueue routine.  You should be able to delete a particular entry from
> the workqueue (or wait for it to complete if it has already started
> running).  This could be implemented right away.

It all depends on how a particular subsystem is shaped but having such
thing would definitely help.

> More problems with immediate detach -- it would have to apply to char
> devices.  When a char device is unregistered you can't force user
> processes to close their open file handles.  Instead something like your
> change to sysfs is needed -- wait for outstanding calls to complete and
> fail any future calls.  This means that registering a device will use up
> more than just a pointer in a table of minor device numbers.  Each entry
> would require at least an rwsem, and device I/O would be slowed down by
> the need to get a read-lock each time before entering the device driver.
> 
> The same idea applies to block devices, although here the problems center 
> more around the block core and request queues.

Yeah, exactly.  My argument is that that impedance matching between
lifetime rules must happen at some place and it's better if we can do in
the higher layer where we can afford more effort and thus complexity.
We're currently pushing that down to each drivers and not too many are
getting it right.  I think it's just unrealistic to expect every and
each driver subsystems to get it right, so some overhead at higher layer
is acceptable and we can definitely afford much more optimization at
higher layer.

Thanks.

-- 
tejun
