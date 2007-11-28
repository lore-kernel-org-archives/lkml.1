Return-Path: <linux-kernel-owner+w=401wt.eu-S1761018AbXK1LqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbXK1LqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 06:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbXK1LqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 06:46:14 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:37343 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401AbXK1LqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:46:12 -0500
Date: Wed, 28 Nov 2007 12:45:45 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071127230252.GB10038@kroah.com>
References: <20071127230252.GB10038@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 15:02:52 -0800,
Greg KH <greg@kroah.com> wrote:

> 
> ksets
> 
> A kset is merely a collection of kobjects that want to be associated with
> each other.  There is no restriction that they be of the same ktype, but be
> very careful if they are not.
> 
> A kset serves these functions:
> 
>  - It serves as a bag containing a group of objects. A kset can be used by
>    the kernel to track "all block devices" or "all PCI device drivers."
> 
>  - A kset is also a subdirectory in sysfs, where the associated kobjects
>    with the kset can show up.  

Perhaps better wording:

A kset is also represented via a subdirectory in sysfs, under which the
kobjects associated with the kset can show up.

> Every kset contains a kobject which can be
>    set up to be the parent of other kobjects; in this way the device model
>    hierarchy is constructed.
> 
>  - Ksets can support the "hotplugging" of kobjects and influence how
>    uevent events are reported to user space.
> 
>  - A kset can provide a set of default attributes that all kobjects that
>    belong to it automatically inherit and have created whenever a kobject
>    is registered belonging to the kset.

Hm, the default attributes are provided by the ktype?

> 
> In object-oriented terms, "kset" is the top-level container class; ksets
> contain their own kobject, but that kobject is managed by the kset code and
> should not be manipulated by any other user.
> 
> A kset keeps its children in a standard kernel linked list.  Kobjects point
> back to their containing kset via their kset field. In almost all cases,
> the contained kobjects also have a pointer to the kset (or, strictly, its
> embedded kobject) in their parent field.
> 
> As a kset contains a kobject within it, it should always be dynamically
> created and never declared statically or on the stack.  To create a new
> kset use:
>   struct kset *kset_create_and_register(char *name,
> 					struct kset_uevent_ops *u,
> 					struct kobject *parent);
> 
> When you are finished with the kset, call:
>   void kset_unregister(struct kset *kset);
> to destroy it.

Maybe also mention kset_get()/kset_put() here? kset_unregister() will
only destroy the kset if the caller holds the last reference to it.

> 
> An example of using a kset can be seen in the
> samples/kobject/kset-example.c file in the kernel tree.
> 
> If a kset wishes to control the uevent operations of the kobjects
> associated with it, it can use the struct kset_uevent_ops to handle it:
> 
> struct kset_uevent_ops {
>         int (*filter)(struct kset *kset, struct kobject *kobj);
>         const char *(*name)(struct kset *kset, struct kobject *kobj);
>         int (*uevent)(struct kset *kset, struct kobject *kobj,
>                       struct kobj_uevent_env *env);
> };
> 
> 
> The filter function allows a kset to prevent a uevent from being emitted to
> userspace for a specific kobject.  If the function returns 0, the uevent
> will not be emitted.
> 
> The name function will be called to override the default name of the kset
> that the uevent sends to userspace.  By default, the name will be the same
> as the kset itself, but this function, if present, can override that name.
> 
> The uevent function will be called when the uevent is about to be sent to
> userspace to allow more environment variables to be added to the uevent.

It may be helpful to mention which uevents are by default created by
the kobject core (KOBJ_ADD, KOBJ_DEL, KOBJ_MOVE).

> 
> One might ask how, exactly, a kobject is added to a kset, given that no
> functions which perform that function have been presented. The answer is
> that this task is handled by kobject_add(). When a kobject is passed to
> kobject_add(), its kset member should point to the kset to which the
> kobject will belong. kobject_add() will handle the rest. There is currently
> no other way to add a kobject to a kset without directly messing with the
> list pointers.
> 
> 
> Kobject initialization again
> 
> Now that we have covered all of that stuff, we can talk in detail about how
> a kobject should be prepared for its existence in the kernel. Here are all
> of the struct kobject fields which must be initialized somehow:
> 
>  - k_name - the name of the object. This fields should always be
>    initialized with kobject_set_name(), or specified in the original call
>    to kobject_create_and_register().
> 
>  - refcount is the kobject's reference count; it is initialized by kobject_init()

There is no field called "refcount"; the embedded struct kref kref is
initialized by kobject_init().

> 
>  - parent is the kobject's parent in whatever hierarchy it belongs to. It
>    can be set explicitly by the creator. If parent is NULL when
>    kobject_add() is called, it will be set to the kobject of the containing
>    kset.
> 
>  - kset is a pointer to the kset which will contain this kobject; it should
>    be set prior to calling kobject_init().
> 
>  - ktype is the type of the kobject; it should be set prior to calling
>    kobject_init().
> 
> Often, much of the initialization of a kobject is handled by the layer that
> manages the containing kset.  See the sample/kobject/kset-example.c for how
> this is usually handled.

Do we also want to mention kobject_rename() and kobject_move(), or are
those functions so esoteric that most people don't want to know about
them?
