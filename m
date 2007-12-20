Return-Path: <linux-kernel-owner+w=401wt.eu-S1762256AbXLTVxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbXLTVxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762396AbXLTVwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:52:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58528 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762364AbXLTVwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:52:42 -0500
Date: Thu, 20 Dec 2007 13:48:58 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
Message-ID: <20071220214858.GA6217@kroah.com>
References: <20071220003031.GA15129@kroah.com> <Pine.LNX.4.44L0.0712192237140.15674-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0712192237140.15674-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 11:26:19PM -0500, Alan Stern wrote:
> On Wed, 19 Dec 2007, Greg KH wrote:
> >  - A ktype is the type of object that embeds a kobject. Every structure
> >    that embeds a kobject needs a corresponding ktype.  The ktype controls
> 
> I think the wording here is a little misleading.  It might be better to
> say: "For every kind of structure with an embedded kobject, there
> should be a corresponding ktype object.  In each structure of that kind
> the embedded kobject should contain a pointer to that ktype."
> 
> Even that isn't great.  Maybe somebody can suggest something better.

See the version I just suggested to Randy for this paragraph.  It's all
I can come up with right now too :)

> > 
> > It is rare for kernel code to create a standalone kobject; with one major
> 
> The ';' should be a ','.

fixed.

> > If you have a struct uio_mem structure, finding its embedded kobject is
> > just a matter of using the kobj structure.  Code that works with kobjects
> 
> "using the kobj member."

fixed.

> > The ktype is required for a kobject to be created properly, as every kobject
> > must have an associated kobj_type.  Among other things, kobject_init() sets
> > the kobject's reference count to one.  After calling kobject_init(), to
> 
> Setting the reference count to one is explained below, so the sentence
> can be omitted here.

Ok, dropped.

> > register the kobject with sysfs, the function kobject_add() must be called:
> > 
> >     int kobject_add(struct kobject *kobj, struct kobject *parent, const char *fmt, ...);
> > 
> > This sets up the parent of the kobject, and the name for the kobject
> > properly.  If the kobject is to be associated with a specific kset, that
> > assignment must be done before calling kobject_add().  If a kset is
> 
> "kobj->kset must be assigned" instead of "that assignment must be done"

fixed, thanks.

> > associated with a kobject, then the parent for the kobject can be set to
> > NULL in the call to kobject_add() and then the kobject will be placed under
> > the kset itself.
> 
> "and then the kobject's parent will be set to the kset itself."

changed, thanks.

> > Uevents
> > 
> > After a kobject has been registered with the kobject core, it needs to be
> > announced to the world that it has been created.  This can be done with
> 
> "you need to announce"

changed.

> > If all that you are wanting to use a kobject for is to provide a reference
> > counter for your structure, please use the struct kref instead, a kobject
> 
> The second ',' in the line above should be a ';'.

I always never know when to use a ';', thanks.

> > This structure is used to describe a particular type of kobject (or, more
> > correctly, of containing object). Every kobject needs to have an associated
> > kobj_type structure; a pointer to that structure can be placed in the
> > kobject's ktype field at initialization time, or (more likely) it can be
> > defined by the kobject's containing kset.
> 
> "a pointer to that structure must be specified when you call
> kobject_init() or kobject_init_and_add()."

Thanks, that was a big miss.

> >  - A kset is also a subdirectory in sysfs, where the associated kobjects
> >    with the kset can show up.  Every kset contains a kobject which can be
> >    set up to be the parent of other kobjects; in this way the device model
> >    hierarchy is constructed.
> 
> "the top-level directories of the sysfs hierarchy are constructed in 
> this way."

thanks.

> >  - Ksets can support the "hotplugging" of kobjects and influence how
> >    uevent events are reported to user space.
> > 
> > In object-oriented terms, "kset" is the top-level container class; ksets
> > contain their own kobject, but that kobject is managed by the kset code and
> > should not be manipulated by any other user.
> 
> Don't you want to include the definition of struct kset here?

Not really, you never touch the "raw" kset, you only use functions to
create it.  There's nothing in the structure for someone to mess with.

> > A kset keeps its children in a standard kernel linked list.  Kobjects point
> > back to their containing kset via their kset field. In almost all cases,
> > the contained kobjects also have a pointer to the kset (or, strictly, its
> > embedded kobject) in their parent field.
> 
> "In almost all cases, the kobjects belonging to a kset have that kset 
> (or, strictly, its embedded kobject) as their parent."

changed, thanks.

> > If the kobject belonging to a kset has no parent kobject set, it will be
> > added to the kset's directory.  Not all members of a kset do necessarily
> > live in the kset directory.  If an explicit parent kobject is assigned
> > before the kobject is added, the kobject is registered with the kset, but
> > added below the parent kobject.
> 
> This paragraph is unnecessary since it is already explained in the
> section about kobject_add().

good catch.

> > In the future, the kobject_unregister() call will be going away to help
> > clean up the kobject api.
> 
> Will there be a kobject_del_and_put() routine, to complement 
> kobject_init_and_add()?

Nope, all you need is 'kobject_put()'  I've already added that change to
the tree, turned out it was already all implemented, all I had to do was
the search-and-replace, thanks to Kay :)

thanks for the review.

greg k-h
