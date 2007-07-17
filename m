Return-Path: <linux-kernel-owner+w=401wt.eu-S936598AbXGQVFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936598AbXGQVFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936901AbXGQVEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:04:33 -0400
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:55299 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936876AbXGQVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:04:31 -0400
Date: Tue, 17 Jul 2007 23:05:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs root link count broken in 2.6.22-git5
Message-ID: <20070717230530.64d9a896@hyperion.delvare>
In-Reply-To: <20070717183652.GG9702@suse.de>
References: <20070715124232.4e371bf9@hyperion.delvare>
	<20070717034844.GB11602@suse.de>
	<20070717131255.71b7e72e@hyperion.delvare>
	<20070717183652.GG9702@suse.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 11:36:52 -0700, Greg KH wrote:
> On Tue, Jul 17, 2007 at 01:12:55PM +0200, Jean Delvare wrote:
> > On Mon, 16 Jul 2007 20:48:44 -0700, Greg KH wrote:
> > > On Sun, Jul 15, 2007 at 12:42:32PM +0200, Jean Delvare wrote:
> > > > I'm running 2.6.22-git5 and noticed that the link count of the sysfs
> > > > root is broken:
> > > > 
> > > > $ ls -ld /sys
> > > > drwxr-xr-x 2 root root 0 Jul 15 12:27 /sys
> > > > 
> > > > sysfs is mounted, the link count should be 11, and is with kernel
> > > > 2.6.22.1. find(1) complains about the bad link count.
> > > 
> > > I suggest updating your version of find(1), I get no such complaint
> > > with:
> > > 	$ find --version
> > > 	GNU find version 4.3.8
> > > 	Built using GNU gnulib version 2007-05-26
> > > 	Features enabled: D_TYPE O_NOFOLLOW(enabled) LEAF_OPTIMISATION FTS() CBO(level=0)
> > > 
> > > What are you using?
> > 
> > $ find --version
> > GNU find version 4.2.28
> > Features enabled: D_TYPE O_NOFOLLOW(enabled) LEAF_OPTIMISATION
> > 
> > This is the standard version in openSuse 10.2. But how does it matter?
> 
> Well, some people feel that that message from find is not something that
> should be bothering users all the time.  Hence it was fixed in newer
> versions.

My understanding is that find uses the link count to speed up the
search. So even if I admit that printing an error message when it
detects that the count is wrong might confuse or annoy end-users, this
is still a valuable for us developers that we got things wrong. I seem
to remember that it helped us detect bugs in procfs and sysfs several
times already.

> > sysfs is broken, not find(1). Don't you see the sysfs root link count
> > at 2 as I do? This needs to be fixed.
> 
> I'm not disagreeing with that, but other than find, what is the downside
> of this not being correct?  And what should it be?

This breaks libsensors. libsensors uses libsysfs, and libsysfs is not
very smart in that it will initialize successfully even if sysfs is not
mounted. So I added tests after the initialization, to make sure that
sysfs is really there. These tests are:
* The mount point exists.
* The mount point is really mounted.

The code looks like:

       if (sysfs_get_mnt_path(sensors_sysfs_mount, NAME_MAX)
         || stat(sensors_sysfs_mount, &statbuf) < 0
         || statbuf.st_nlink <= 2)      /* Empty directory */
                return 0;		/* Failure */

This works OK with 2.6.22.1, but the last test fails with the current
git kernel even when sysfs is mounted.

You may object that this is not the right way to make sure that sysfs
is mounted, but I don't want to rewrite half of sysfs_get_mnt_path() in
libsensors when a simple stat should does the job.

Thanks,
-- 
Jean Delvare
