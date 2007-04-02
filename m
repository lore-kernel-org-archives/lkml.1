Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXDBJdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXDBJdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965297AbXDBJdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:33:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:42892 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965289AbXDBJdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:33:22 -0400
Date: Mon, 2 Apr 2007 02:33:24 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, hugh@veritas.com,
       cornelia.huck@de.ibm.com, dmitry.torokhov@gmail.com, oneukum@suse.de,
       maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Message-ID: <20070402093324.GA21857@suse.de>
References: <460CDBA6.5030608@gmail.com> <1175257751.3760.19.camel@mulgrave.il.steeleye.com> <460D12B8.6050101@gmail.com> <1175278774.3760.44.camel@mulgrave.il.steeleye.com> <20070401195943.GA29627@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070401195943.GA29627@htj.dyndns.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 04:59:43AM +0900, Tejun Heo wrote:
> 
> Dependencies between sysfs/kobject objects are clearer now and I think
> I got the locking and referencing correct.  This patch immediately
> fixes 'sysfs attr grabbing the wrong kobject and module' problem -
> sysfs and module lifetimes are unrelated now.  We can drop
> half-working attr->owner.
> 
> * A sysfs node no longer hold reference to its kobject.  It just
>   attaches itself to the kobject on creation and detaches on deletion.
> 
> * For a dir node, sysfs_dirent no longer directly points to kobject.
>   It points to sysfs_dir which contains pointer to kobject and a rwsem
>   to protect it.
> 
> * An open file doesn't hold a reference to kobject.  It holds a
>   reference to sysfs_dirent.  kobject pointer is verified and
>   show/store are performed with rwsem read-locked.  Deletion
>   disconnects the sysfs from its kobject while the rwsem is
>   write-locked.  This mechanism replaces buffer orphaning and kobject
>   validation during open.

Ah, very nice.

> * attr ops is determined on sysfs node creation not on open.  This is
>   a step toward making kobject opaque in sysfs.
> 
> * bin files are handled similarly but mmap makes the open file hold
>   reference to the kobject till it's closed.  Any better ideas?

This is probably needed, and might be acceptable, and I think we can
live with it as there is only a very small number of sysfs files that
fall into this category.

> * symlink is reimplemented in terms of sysfs_dirents instead of
>   kobjects.  sysfs_dirent->s_parent is added and each sysfs_dirent
>   holds reference to its parent.  Currently walking up the tree
>   requires read locking and unlocking sysfs_dir at each level.  This
>   can be removed if name is added to sysfs_dirent.
> 
> * As kobject can be disconnected anytime and sysfs code still needs to
>   look follow dentry link in kobject, kobject->dentry is protected by
>   dcache_lock.  Once kobject becomes opaque to sysfs, this hack can go
>   away.  All in all, making kobject completely opaque in sysfs isn't
>   too far away after this patch although it would require mass code
>   update.

What would need to be updated after this?

> What do you think about this approach?  If it's acceptable, I'll test
> further and split the patch into logical steps to get it reviewed
> better.

At first glance, I think it looks fine, but Maneesh is the one who
understands this code better than anyone, so I would like to get his
opinion on it.

I think you should start splitting it all up into steps, which will help
us review it a whole lot easier, as overall, I think this is a very
worthy goal.

thanks so much for doing this work,

greg k-h
