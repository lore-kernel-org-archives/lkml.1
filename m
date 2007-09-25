Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbXIYWud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbXIYWud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbXIYWu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:50:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36075 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbXIYWuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:50:25 -0400
Date: Tue, 25 Sep 2007 15:50:05 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 4/4] sysfs: implement new features
Message-ID: <20070925225005.GB26099@kroah.com>
References: <11902770971822-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11902770971822-git-send-email-htejun@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 05:31:37PM +0900, Tejun Heo wrote:
> Hello, all.
> 
> This is the fourth patchset of four sysfs update patchset series[1]
> and to be applied on top of the third patchset[2].
> 
> This patchset implements the following new features.
> 
> * Notify pollers on file deactivation.

This looks nice.

> * Name-formatting for symlinks.  e.g. symlink pointing to
>   /dira/dirb/leaf can be named as "symlink:%1-%0" and it will show up
>   as "symlink:dirb-leaf".  This only applies when new interface is
>   used.

Is this really necessary?  It looks like we are adding a "special" type
of parser here that no one uses.

> * Autoremoval of symlinks when target is removed.  This only applies
>   when new interface is used.

Nice.

> * Autorenaming of symlinks according to the name format string when
>   target or one of its ancestors is renamed or moved.  This only
>   applies when new interface is used.

Nice.

> * Plugged operations.  Sysfs users can plug top node and build subtree
>   gradually without revealing the process to userland.  When subtree
>   is fully constructed, the top node can be unplugged and userland
>   will see completely built subtree appearing at once.  If subtree
>   creation fails in the process, the whole subtree can be removed by
>   simply removing the top node.  There won't be any userland
>   noticeable event.  This is to be combined with uevent_suppress
>   mechanism of driver model.

Hm, but why?  Can't we do this today with the attribute groups?

> * Batch error handling.  A plugged node accumulates any error
>   condition occurring below it and can return the first error when
>   asked.  Also, all interface functions accepth ERR_PTR() value as
>   sysfs_dirent parameter.  This means that constructs like the
>   following can be used to replace the current group interface.
> 
>   <<-- code -->>
>   group = sysfs_add_dir(parent, "group_name", 0777 | SYSFS_PLUGGED, NULL);
>   sysfs_add_file(group, "file0", 0777, file0_ops, file0_data);
>   sysfs_add_file(group, "file1", 0777, file1_ops, file1_data);
>   ...
>   sysfs_add_file(group, "fileN", 0777, fileN_ops, fileN_data);
>   rc = sysfs_check_batch_error(group);
>   if (rc) {
> 	sysfs_remove(group);
> 	return rc;
>   }
>   sysfs_unplug(group);
>   return 0;
>   <<-- end of code -->>
> 
>   The above will create a subdirectory "group_name" which contains N
>   files and show them atomically to userland or remove them without
>   letting userland notice if any failure happens.  This will simplify
>   sysfs users quite a bit (not only for groups, other stuff too).

I'm still not sold on why this is needed.  It looks like a lot of extra
work for something that we are already handling.

thanks,

greg k-h
