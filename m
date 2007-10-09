Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbXJIW6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbXJIW6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 18:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbXJIW6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 18:58:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57631 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbXJIW6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 18:58:38 -0400
Date: Tue, 9 Oct 2007 15:26:38 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Tejun Heo <htejun@gmail.com>, ebiederm@xmission.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver
	model
Message-ID: <20071009222638.GD21228@kroah.com>
References: <11902755392688-git-send-email-htejun@gmail.com> <20070925221736.GA3566@kroah.com> <46FB956B.8000205@gmail.com> <20071005061812.GA16914@kroah.com> <4705EF30.8010002@gmail.com> <20071009112901.6d4fa19d@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009112901.6d4fa19d@gondolin>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 11:29:01AM +0200, Cornelia Huck wrote:
> On Fri, 05 Oct 2007 17:00:48 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
> > I think this definitely needs more discussion, so here we go...
> 
> I agree, so I'll give my 0.02 ? here...
> > 
> > Greg KH wrote:
> > >> 1. What is a kobject?
> > [--snip--]
> > >> The functionality served by kobject can be broken down into the
> > >> following two.
> > >>
> > >> F-a. To serve as an entity both subsystems can share lifespan
> > >> management.  ie. both subsystems reference count on kobject.
> > >>
> > >> F-b. To serve as an entity both subsystems can base their internal
> > >> representation on.  (base object in OO term).
> > > 
> > > Yes, those are two functions, I can agree with.
> 
> I think that's the heart of the question: We first need to agree what
> use the different components should have.
> 
> (a) The driver model
> 
> The driver model serves as a unified layer for all devices managed by
> the kernel, organized in trees, and the drivers handling them. This
> includes busses, matching of devices and drivers, attributes and so on.
> Userspace expects to see these devices, drivers, busses and attributes
> by looking under /sys/devices/. /sys/class/ and /sys/bus/ provide
> additional views on this data.
> 
> (b) kobjects, ktypes, ksets
> 
> kobjects provide a mechanism to arrange kernel objects into a tree-like
> structure. ktypes and ksets are mechanisms to further order these
> objects. Changes in the kobject hierarchy are communicated to userspace
> via uevents.
> 
> The driver core is implemented using this infrastructure.
> 
> (c) krefs
> 
> krefs provide a generic reference counting mechanism.
> 
> The kobject infrastructure uses krefs for its reference counting needs.
> 
> (d) sysfs
> 
> sysfs is a virtual filesystem. It exports information on kernel objects
> to user space. (IMO, that's the key: sysfs is userspace representation.)

Ok, I agree with all of the above :)

> That said, it is logical that kobjects are made visible to userspace
> via sysfs. If someone is trying to make things show up in sysfs and has
> to jump through hoops to cook up kobjects, they're probably using the
> wrong infrastructure.

I agree.

> There are two big problems with the tight coupling of sysfs and kobjects:
> 
> - lifetime rules; but this fortunately hugely improved with the
> previous patches :)

Yes, I think that's pretty much fixed now.

> - relaying implementation details to userspace so that they cannot be
> easily changed. We would need to allow kobjects not showing up in sysfs
> and making symlinks a sysfs facility not relying on kobjects to help
> there.

Huh?  Why would you want a kobject to not show up in sysfs?

And yes, I agree we could use some more "automatic" help in regards to
symlinks in sysfs when we change kobjects around.  That would make
things simpler for the kobject core.

> > [--snip--]
> > >> 3. Where does that leave kobject?
> > >>
> > >> If you combine #1 and #2, both functionalities become questionable.
> > >>
> > >> F-a. sysfs no longer plays role in lifespan management of driver model
> > >> object.  This functionality is exactly what's killed by #2.
> > > 
> > > Yes, but a kobject is still needed internally for the lifespan
> > > management.
> > 
> > Yes, exactly - "internally" to the driver model (or drivers which ride
> > along).  To sysfs, it has no function other than being an opaque token.
> 
> But krefs are used for kobject reference counting, or am I
> misunderstanding here?
> 
> > 
> > [--snip--]
> > >> IMHO, both L-a and L-b contribute only to obfuscation of the driver
> > >> model and sysfs.
> > > 
> > > No.  I think you are missing a number of things that kobjects provide
> > > and allow:
> > > 	- a structurual heirachy of devices.  Combine kobjects with
> > > 	  ksets and ktypes, and you have a very powerful system to
> > > 	  categorize objects and their representation to each other.
> > 
> > Yes, which only needs to be used _inside_ the driver model
> > implementation proper.
> 
> There are use cases outside of the driver model prober where you may
> want to use kobject for hierarchy.

agreed.

> > > 	- a consistant and easy interface to userspace through
> > > 	  uevents/hotplug of the creation and removal of these objects.
> > > 	  This keeps the different parts of the kernel that need this
> > > 	  interface from having to create it every time on their own.
> > 
> > Things can be much easier than now.  Also, the above paragraph is
> > inconsistent with the rest of your argument or am I misunderstanding
> > what you mean by the above paragraph?
> 
> I see uevents as a notifier for changes in the kobject hierarchy, so
> they belong to that layer. However, the layering between kobjects and
> sysfs (path names etc.) could probably be made cleaner.

also agreed.

> > > 	- a way to easily create and export attributes in sysfs
> > > 	  automatically.
> > 
> > This is and should be the function of the driver model not kobjects.
> 
> I agree, attributes should belong to the driver model.
> 
> > Removing kobject from the interface doesn't change anything about this.
> 
> Hm. Currently you have a file<->attribute correlation. This would
> change if you allow non-attribute files.

I don't want to have non-attribute files, that's my main point here.

> > > 	- a way to provide working reference counting for a variety of
> > > 	  different objects.
> > 
> > To me, this just feels wrong and does more harm than it helps.  I really
> > think we shouldn't have multi-role flash light at the core of our driver
> > model (inside driver model proper, no problem, but not as exported
> > interface).
> 
> And I still think that this is the purpose of krefs :)

Ok, yes, at the very base level, it is, you are correct :)

> > > All of those are still needed for the kernel.
> > 
> > For #1 and #3, I agree if you limit the scope to driver model proper but
> > I am not arguing kobject and all its friends should be abolished.  I'm
> > arguing that there is no reason to export it as API because it doesn't
> > add any value exported.
> 
> I see the value for those code paths that want to provide a hierarchy
> of kernel objects outside the driver model proper.

Yes.

> > >> The rest isn't great in number and, much more importantly, many of those
> > >> suffer from the current interface which is painful to use independently.
> > >>  For example, kernel/module.c does all the kobject dances including
> > >> defining a subsystem just to ignore everything else and use it as an
> > >> opaque token to sysfs (kset_find_obj doesn't count, a generic map or
> > >> sysfs with sysfs_dirent interface can do that just as well).
> > > 
> > > I will not deny that the current use of kobjects/ksets/ktypes (subsystem
> > > is now gone) is difficult and extreemly painful.  I am currently working
> > > to fix this issue.  But don't think that the reason this is hard to use
> > > means that it should be abolished alltogether.
> > > 
> > > Rather, it means that this interface to using kobjects needs to be fixed
> > > and made easier, not circumvented.
> 
> Yes, an easier-to-use interface to the kobject stuff would be helpful
> for everyone :)
> 
> > The thing is that functionality-wise, kobject and its friends don't
> > serve anything anymore outside of driver model implementation proper
> > (I'll talk about uevent later) and thus there is no reason to use it
> > outside of driver model implementation anymore in the long term.
> 
> I disagree. A hierarchy of kernel objects has uses beyond the driver
> model.

i agree.

thanks,

greg k-h
