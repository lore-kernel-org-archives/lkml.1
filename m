Return-Path: <linux-kernel-owner+w=401wt.eu-S2992835AbXDRQlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992835AbXDRQlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992848AbXDRQlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:41:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:56753 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992835AbXDRQlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p7wIgIqdUm+ofwAPZ97wTsfMQcNMzP5KL4rfKQTWf6CZQUbhsBUXbjdG2PqdTrMfhzAUi/uiaSlF4hDA4OKf+ba2jcyBB2B1+NQbavql5joj8in/dBZtvqp8i445a+n92W693LW2c67Q7EpsMlJg7aDBgB3dnjhDDPq3TpgTz24=
Message-ID: <d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>
Date: Wed, 18 Apr 2007 12:41:36 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Greg K-H" <greg@kroah.com>, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <46263A82.1030703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>
	 <46263A82.1030703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/07, Tejun Heo <htejun@gmail.com> wrote:
> Hello,
>
> Alan Stern wrote:
> > On Wed, 18 Apr 2007, Tejun Heo wrote:
> >
> >> Hello, all.
> >>
> >> Agreed with the problem but I'm not very enthusiastic for adding
> >> kobj->owner.  How about the following?  exit() routines will have to
> >> do device_unregister_wait() instead of device_unregister().  On return
> >> from it, it's guaranteed that all references to it are dropped and
> >> ->release is finished.  The caller is responsible for avoiding
> >> deadlock, of course.
> >
> > There's a problem with this approach.
> >
> > Many drivers, especially those for hot-pluggable buses, register and
> > unregister devices dynamically.  These events can occur in time-critical
> > situations, where the driver cannot afford to wait for all the references
> > to be dropped when unregistering a device.  It's okay to wait in a module
> > exit routine, but to make things work the routine would have to wait for
> > references to _all_ unregistered objects to go away, not just the
> > references for the objects it unregisters at exit time.
> >
> > So let's see what changes are needed to make the approach workable.  We
> > will have to maintain a count of objects whose release methods haven't
> > been called yet.  The count has to be incremented every time an object is
> > unregistered (or registered, it doesn't matter which) and decremented
> > _after_ the release method returns -- meaning somewhere in the driver
> > core.  When the count goes to zero, the exit routine is then allowed to
> > terminate.
> >
> > Hmmm, this is beginning to sound like a module-wide refcount which serves
> > to block mod->exit().  In fact, it sounds almost identical to what
> > Cornelia wrote, except that the refcount refers only to devices rather
> > than arbitrary kobjects (and except that the blockage just before
> > mod->exit returns instead of just after).  You can see where I'm
> > leading...
>
> The goal of immediate-disconnect is to remove such lingering reference
> counts so that device_unregister() or driver detach puts the last
> reference count.
>
> You tell a higher layer that a device is going away, on return from the
> function, that layer isn't gonna access the device anymore.  ie. On
> return from the unregistration function, the upper layer shouldn't have
> any reference to the device.  If you unregister from all layers a device
> is registered to, you are left with only 1 reference which you put with
> device_unregister().  After all are converted, reference count doesn't
> mean much.  struct device isn't a reference counted object anymore.
>
> I don't think this is gonna be too difficult to do.  I think I can
> convert block layer and IDE/SCSI drivers without too much problem.
> Dunno much about other layers tho.

I am still do not understand why this is needed. Would it not be
simplier just to use a reference to struct device instead of embedding
it in a larger structure if their lifetimes are different and one does
not have a subsystem that takes care of releasing logic.


Pretty much drivers have 2 options:

struct my_device {
        void *private_data;
        struct device dev;
};

In this case ->release must live in a subsystem code; individual
drivers kfree(my_dev->private) and do any additional cleanup after
calling device_unregister(&my_dev->dev);

Second option:

struct my_device {
        type member1;
        type member2;

       struct device *dev;
};

dev is coming from _device_create(). Driver core takes care of
releasing dev structure; driver does cleanup of my_device.

With current sysfs orphaning attributes upon removal request there is
no issue of accessing driver-private data through references obtained
via ether embedded or referenced dev structure so everything is fine.

-- 
Dmitry
