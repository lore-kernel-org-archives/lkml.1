Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXIJLwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXIJLwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 07:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbXIJLwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 07:52:03 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:55740 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbXIJLwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 07:52:01 -0400
Date: Mon, 10 Sep 2007 13:51:59 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Greg K-H <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: regarding sysfs/kobject separation
Message-ID: <20070910135159.133224eb@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46DABD6A.2030708@gmail.com>
References: <46DABD6A.2030708@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Sep 2007 22:40:58 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> * Suicidal nodes don't need special treatment.  If a file tries to
> commit suicide, sysfs will detect the condition and deactivate and drain
> the node except for the suiciding reference.

Excellent. This is so easy to overlook.

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

Hm. This sounds like two different things:

- Eliminate the need to check after each operation. Might be a matter
of taste; personally, I prefer checking and unwinding on error.

- Atomic creation/deletion of a bunch of sysfs nodes. This sounds
like something really worthwile to have.

> 
> * Automatic symlink handling.  Symlink names can be formatted with the
> name of its target.  e.g. if the symlink name is specified as
> "link-%1:%0" and points to "devices/mybus0/mydev0", its name becomes
> "link-mybus0-mydev0" && the symlink will be automatically renamed when
> the target node or one of its ancestor is moved or renamed.  The symlink
> is also plugged and removed together with its target.  So, once created,
> the user doesn't have to care about the symlink.  sysfs will take care
> of it.

Really nice. The need to delete/create symlinks on moving/renaming is
currently a headache inducer.

> * Move uevent support over to sysfs and bridging the current users.
> This makes sense because sysfs hierarchy is all that userland can see
> and sysfs users which don't use kobject also needs uevent support.

Makes sense.

> 
> * Convert device model (drivers/base/*) over to the new sysfs_dirent
> based interface and make device/driver <-> sysfs association flexible.
> Automatic sysfs association is a good thing.  In most cases, it makes
> sense and makes drivers simpler but it also needs to be flexible such
> that drivers with special needs can override how the device and driver
> are represented to userland.  I think such flexibility can be achieved
> without too much problem now that sysfs and kobject are separated.

Yes, if we can change internal implementation details without upsetting
userspace a lot is gained. As long as the default behaviour remains
easy to implement.
