Return-Path: <linux-kernel-owner+w=401wt.eu-S1030952AbXDPUSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030952AbXDPUSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030953AbXDPUSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:18:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:54887 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030952AbXDPUSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l8hm3KQubNn2TyKCVNKi4iuWybn7ZW952/yeoHttmOYHZooQo/+yiDfnSNEjh9DZH0KRIr5TgfLYFDJYWrM1rxJ0xq6KL6yQ1uSjmjiCF8i+mhUktjGH4knTeU6TsAQGTSiPn1ny5/IxeyOVbB2dUeYXi9cHFDGFNUkgJ/wbcsY=
Message-ID: <d120d5000704161318t7bbc8ab9t3a23145dcc44e7dd@mail.gmail.com>
Date: Mon, 16 Apr 2007 16:18:50 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Tejun Heo" <htejun@gmail.com>, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <20070416195229.GA16074@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d120d5000704161130j7ae89a1eyef89e015f0a3e97f@mail.gmail.com>
	 <Pine.LNX.4.44L0.0704161530160.2685-100000@iolanthe.rowland.org>
	 <d120d5000704161247v1ce98cc2v9ba53d91b166f935@mail.gmail.com>
	 <20070416195229.GA16074@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Greg KH <greg@kroah.com> wrote:
> On Mon, Apr 16, 2007 at 03:47:13PM -0400, Dmitry Torokhov wrote:
> > On 4/16/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> > >On Mon, 16 Apr 2007, Dmitry Torokhov wrote:
> > >
> > >> On 4/16/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > >> > Hi,
> > >> >
> > >> > based on the discussion in "How should an exit routine wait for
> > >> > release() callbacks?", I've cooked up some patches that make module
> > >> > unload wait until the last reference for a kobject has been dropped.
> > >> > This should plug the "release function in already deleted module" race;
> > >> > however, if the last kobject_put() from the module containing the
> > >> > release function is not in the module's exit function, there's still a
> > >> > small window (not sure if and how to plug this).
> > >>
> > >> Unfortunately all this "wait for refcount in module's exit" schemas
> > >> lead to the following deadlock:
> > >>
> > >>         rmmod my_module < /path/to/some/file/incrementing/my/refcount
> > >
> > >(Note that this problem will be a lot harder to provoke once Tejun's
> > >changes to sysfs are in place.  But it will still be possible, unless we
> > >make similar changes to all the other filesystems as well.)
> > >
> > >There are three possible approaches to this problem:
> > >
> > >    1. Ignore it, as we do now.  If someone actually tries running your
> > >       example above, an oops will result when the kobject's release
> > >       method is called after my_module has been unloaded from memory.
> > >
> > >    2. Do what Cornelia suggested, and allow the example to deadlock.
> > >
> > >    3. Change the module code so that rmmod can return _before_ the
> > >       module is actually unloaded from memory (but after the module's
> > >       exit routine has completed).  This will lead to more problems.
> > >       For example, what if someone tries to modprobe my_module back
> > >       again before it has finished unloading?
> > >
> > >My feeling is that either a deadlock or more complications with modprobe
> > >would be preferable to an oops.  Your opinion may differ.
> > >
> >
> > What about 4:
> >
> >     When registering an [k]object increment refcount of module that
> > provides ->release() function.
> >
> > That would normally require ->release function to be placed on
> > subsystem level to allow unloading individual devices.
>
> But that would also mean that a lot of modules that want to be able to
> be released whenever they want to today, not be allowed to (network
> drivers, etc.)
>

No, only the core module has to stay. For example, every time you
register an input device you pin input.ko as it is the module that
provides ->release() method for input devices. You can freely unload
psmouse, or hid or your favorite joystick but input has to stay until
last reference to the input device is dropped. serio and gameport work
the same way.

I think the requirement that one is not able to unload a core
subsystem module untill all users are dropped off is ok - you can't
unload it anyway until you unload all drivers that reference its
exported functions and once you unload all the drivers data objects
will drop off pretty quickly.

-- 
Dmitry
