Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbXK1MXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbXK1MXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbXK1MXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:23:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:58034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbXK1MXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:23:15 -0500
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
From: Kay Sievers <kay.sievers@vrfy.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com>
References: <20071127230252.GB10038@kroah.com>
	 <20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 13:23:02 +0100
Message-Id: <1196252582.3242.28.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18l53RJHMkNDpDHrCiiOfcU7wpLM+PsKQWujX2
 C6l8RAG1EXcJkAyIh0CYwYIlSsuF+q8IbAeFRAfz6rR6r+0QJb
 iFa8gjNby6T53fOn0TPDkYrQzmc2oXH
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 12:45 +0100, Cornelia Huck wrote:
> On Tue, 27 Nov 2007 15:02:52 -0800, Greg KH <greg@kroah.com> wrote:

> > A kset serves these functions:
> > 
> >  - It serves as a bag containing a group of objects. A kset can be used by
> >    the kernel to track "all block devices" or "all PCI device drivers."
> > 
> >  - A kset is also a subdirectory in sysfs, where the associated kobjects
> >    with the kset can show up.  
> 
> Perhaps better wording:
> 
> A kset is also represented via a subdirectory in sysfs, under which the
> kobjects associated with the kset can show up.

This draws a misleading picture. A member of a kset shows up where the
"parent" pointer points to. Like /sys/block is a kset, the kset contains
disks and partitions, but partitions do not live at the kset, and tons
of other kset directories where this is the case.

"If the kobject belonging to a kset has no parent kobject set, it will
be added to the kset's directory. Not all members of a kset do
necessarily live in the kset directory. If an explicit parent kobject is
assigned before the kobject is added, the kobject is registered with the
kset, but added below the parent kobject."

> > Every kset contains a kobject which can be
> >    set up to be the parent of other kobjects; in this way the device model
> >    hierarchy is constructed.
> > 
> >  - Ksets can support the "hotplugging" of kobjects and influence how
> >    uevent events are reported to user space.
> > 
> >  - A kset can provide a set of default attributes that all kobjects that
> >    belong to it automatically inherit and have created whenever a kobject
> >    is registered belonging to the kset.
> 
> Hm, the default attributes are provided by the ktype?

Yeah, it's the type, not the set.

> > In object-oriented terms, "kset" is the top-level container class; ksets
> > contain their own kobject, but that kobject is managed by the kset code and
> > should not be manipulated by any other user.
> > 
> > A kset keeps its children in a standard kernel linked list.  Kobjects point
> > back to their containing kset via their kset field. In almost all cases,
> > the contained kobjects also have a pointer to the kset (or, strictly, its
> > embedded kobject) in their parent field.

It's by far not "almost all cases". Can we please drop that? It's very
common that kobjects are a member of a kset but have a different parent.

> > The uevent function will be called when the uevent is about to be sent to
> > userspace to allow more environment variables to be added to the uevent.
> 
> It may be helpful to mention which uevents are by default created by
> the kobject core (KOBJ_ADD, KOBJ_DEL, KOBJ_MOVE).

I think, we should remove all these default events from the kobject
core. We will not be able to manage the timing issues and "raw" kobject
users should request the events on their own, when they are finished
adding stuff to the kobject. I see currently no way to solve the
"attributes created after the event" problem. The new
*_create_and_register functions do not allow default attributes to be
created, which will just lead to serious trouble when someone wants to
use udev to set defaults and such things. We may just want to require an
explicit call to send the event?

Thanks,
Kay

