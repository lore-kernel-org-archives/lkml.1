Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbXIIUD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbXIIUD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXIIUDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:03:21 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34410 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbXIIUDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:03:21 -0400
Date: Sun, 9 Sep 2007 07:59:02 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: regarding sysfs/kobject separation
Message-ID: <20070909145902.GA9194@kroah.com>
References: <46DABD6A.2030708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DABD6A.2030708@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 10:40:58PM +0900, Tejun Heo wrote:
> Hello, just a note to tell you guys what's going on.
> 
> It's taking more time than I expected but it's near completion.  I'm
> testing things now.  After that, they need to be split and documented.
> It'll be a BIG change and due to other things including moronic military
> reserve training, I'll probably be able to post it after next week.
> Sorry about the delay but I think the result will be pretty good in the end.
> 
> * Suicidal nodes don't need special treatment.  If a file tries to
> commit suicide, sysfs will detect the condition and deactivate and drain
> the node except for the suiciding reference.
> 
> * much more compact and flexible interface based on sysfs_dirent instead
> of kobject.

Why?  What would use this kind of interface?  Why would you want to
create things in sysfs without a kobject?

> * Backward compatibility is fully maintained.  All kobject based
> interface is reimplemented in terms of the new interface.

This is a source level for the sysfs functions compatibility, right?  Or
is this the userspace view of sysfs?  If the later one, why would that
have changed?

> * Plugged creation and batched error handling.  Sysfs directories can be
> 'plugged' on creation such that it can be made visible atomically after
> all its subtrees are constructed.  Also, the user doesn't have to check
> for failure at every step.  For example, the user can do the following.
> 
> 	dir = sysfs_add_dir(parent, "my_dir", SYSFS_PLUGGED | 0777);
> 	sysfs_add_file(dir, ...);
> 	...
> 	dir2 = sysfs_add_dir(dir, ...);
> 	sysfs_add_link(dir, "link-to-dir2", dir2);
> 	...
> 	if (sysfs_check_batch_error(dir) == 0)
> 		sysfs_unplug(dir);
> 	else
> 		sysfs_remove(dir);
> 
> And all the nodes under and including @dir will show up atomically if
> all operations succeeded or removed without ever bothering userland.

Is this really needed?  We work on kobjects and attributes today, and we
can easily add and remove groups of attributes just fine.

> * Automatic symlink handling.  Symlink names can be formatted with the
> name of its target.  e.g. if the symlink name is specified as
> "link-%1:%0" and points to "devices/mybus0/mydev0", its name becomes
> "link-mybus0-mydev0" && the symlink will be automatically renamed when
> the target node or one of its ancestor is moved or renamed.  The symlink
> is also plugged and removed together with its target.  So, once created,
> the user doesn't have to care about the symlink.  sysfs will take care
> of it.

This might be nice, it would take code out of kobject_move(), right?

> * I think most of the changes wouldn't hinder implementation of tagged
> nodes.  In fact, most of the new rename logic which handles symlink
> rename together is taken from tagged node implementation, so with some
> luck it should be easier to support tagged nodes.
> 
> *** Future plans.
> 
> * Move uevent support over to sysfs and bridging the current users.
> This makes sense because sysfs hierarchy is all that userland can see
> and sysfs users which don't use kobject also needs uevent support.

What sysfs users without kobjects?  Why?

> * Convert device model (drivers/base/*) over to the new sysfs_dirent
> based interface and make device/driver <-> sysfs association flexible.
> Automatic sysfs association is a good thing.  In most cases, it makes
> sense and makes drivers simpler but it also needs to be flexible such
> that drivers with special needs can override how the device and driver
> are represented to userland.  I think such flexibility can be achieved
> without too much problem now that sysfs and kobject are separated.

Hm, I'll have to wait to see the code to understand what you mean by
this one :)

thanks for all your work on sysfs so far, it is much nicer than it used
to be.

greg k-h
