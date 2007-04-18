Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbXDRPem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbXDRPem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXDRPem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:34:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:17582 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbXDRPel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=J7tKjDaQSHmA0Qo6Emmqz6WkTtB7ef8bRCaxVyvSujVej2JfMsWOO6qRJ+qrLvXnjjXjCS4XHmSW8Mp2Dr+JuIysuZYVK5MyU3bGy7P/YIzgMRSqS3dUMs1OoSOY9u2de30ojDeyI6CYFfvtUems1kl21sznF5BA5kX01nsbqAU=
Message-ID: <46263A82.1030703@gmail.com>
Date: Thu, 19 Apr 2007 00:34:26 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alan Stern wrote:
> On Wed, 18 Apr 2007, Tejun Heo wrote:
> 
>> Hello, all.
>>
>> Agreed with the problem but I'm not very enthusiastic for adding
>> kobj->owner.  How about the following?  exit() routines will have to
>> do device_unregister_wait() instead of device_unregister().  On return
>> from it, it's guaranteed that all references to it are dropped and
>> ->release is finished.  The caller is responsible for avoiding
>> deadlock, of course.
> 
> There's a problem with this approach.
> 
> Many drivers, especially those for hot-pluggable buses, register and
> unregister devices dynamically.  These events can occur in time-critical
> situations, where the driver cannot afford to wait for all the references
> to be dropped when unregistering a device.  It's okay to wait in a module
> exit routine, but to make things work the routine would have to wait for
> references to _all_ unregistered objects to go away, not just the
> references for the objects it unregisters at exit time.
> 
> So let's see what changes are needed to make the approach workable.  We
> will have to maintain a count of objects whose release methods haven't
> been called yet.  The count has to be incremented every time an object is
> unregistered (or registered, it doesn't matter which) and decremented
> _after_ the release method returns -- meaning somewhere in the driver
> core.  When the count goes to zero, the exit routine is then allowed to
> terminate.
> 
> Hmmm, this is beginning to sound like a module-wide refcount which serves
> to block mod->exit().  In fact, it sounds almost identical to what
> Cornelia wrote, except that the refcount refers only to devices rather
> than arbitrary kobjects (and except that the blockage just before
> mod->exit returns instead of just after).  You can see where I'm
> leading...

The goal of immediate-disconnect is to remove such lingering reference
counts so that device_unregister() or driver detach puts the last
reference count.

You tell a higher layer that a device is going away, on return from the
function, that layer isn't gonna access the device anymore.  ie. On
return from the unregistration function, the upper layer shouldn't have
any reference to the device.  If you unregister from all layers a device
is registered to, you are left with only 1 reference which you put with
device_unregister().  After all are converted, reference count doesn't
mean much.  struct device isn't a reference counted object anymore.

I don't think this is gonna be too difficult to do.  I think I can
convert block layer and IDE/SCSI drivers without too much problem.
Dunno much about other layers tho.

> Incidentally, Tejun, I'm all in favor of a immediate-detach driver model 
> approach.  Unfortunately it's impossible to realize fully, although we 
> could come much closer than we are now.
> 
> Here's an example where immediate-detach cannot be implemented.  A driver 
> binds to a device and uses that device is a kernel thread.  The thread 
> carries out certain operations which require it to hold the device 
> semaphore (because, for example, they need to be mutually exclusive with 
> unbind).
> 
> The driver's remove() method is called with the semaphore held.  If the
> thread tries to lock the semaphore at the same time and blocks, there is
> no way at all for the remove() method to force the thread to drop its
> reference.
> 
> This isn't merely a theoretical example.  The USB hub driver works in
> exactly this way.

Dunno if I understood the problem right but can't we do the following?

remove()
{
	acquire sem;
	device_del();
	release sem;
	device_put_wait();
}

-- 
tejun
