Return-Path: <linux-kernel-owner+w=401wt.eu-S935907AbXGRUFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935907AbXGRUFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbXGRUFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:05:46 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:57508 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754613AbXGRUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:05:45 -0400
Date: Wed, 18 Jul 2007 22:06:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs root link count broken in 2.6.22-git5
Message-ID: <20070718220652.15ad2c4b@hyperion.delvare>
In-Reply-To: <20070718033828.GA8582@suse.de>
References: <20070715124232.4e371bf9@hyperion.delvare>
	<20070717034844.GB11602@suse.de>
	<20070717131255.71b7e72e@hyperion.delvare>
	<20070717183652.GG9702@suse.de>
	<20070717230530.64d9a896@hyperion.delvare>
	<20070718033828.GA8582@suse.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, 17 Jul 2007 20:38:28 -0700, Greg KH wrote:
> On Tue, Jul 17, 2007 at 11:05:30PM +0200, Jean Delvare wrote:
> > This breaks libsensors. libsensors uses libsysfs, and libsysfs is not
> > very smart in that it will initialize successfully even if sysfs is not
> > mounted.
> 
> libsysfs isn't smart at all, and isn't even supported anymore.  I'd
> really suggest droping it entirely, it isn't worth it.

Agreed, except that I do not have the time for this right now. I want
to get lm-sensors-3.0.0 ready for a release candidate first. What
really matters for this is to get the API ready. Implementation details
will come later.

> > So I added tests after the initialization, to make sure that
> > sysfs is really there. These tests are:
> > * The mount point exists.
> > * The mount point is really mounted.
> 
> Do you know of a 2.6 based distro that does not mount sysfs at /sys?  We
> took that check out a long time ago in udev and no one has complained :)

I don't know of any 2.6-based distro not mounting sysfs at /sys, but I
know of 2.4-based distros not mounting sysfs at all ;) libsensors
supports both 2.4 and 2.6 kernels, so being able to tell whether sysfs
is mounted or not, matters.

> > The code looks like:
> > 
> >        if (sysfs_get_mnt_path(sensors_sysfs_mount, NAME_MAX)
> >          || stat(sensors_sysfs_mount, &statbuf) < 0
> >          || statbuf.st_nlink <= 2)      /* Empty directory */
> >                 return 0;		/* Failure */
> > 
> > This works OK with 2.6.22.1, but the last test fails with the current
> > git kernel even when sysfs is mounted.
> 
> Yeah, but is checking the number of hard links in the directory a safe
> way to always verify that it isn't empty?

I think so, yes. To the best of my knowledge, it has worked on all
Unix-like systems for decades. There are other ways, but this is by far
the less expensive.

>                                            Isn't there some glibc
> function that can detect the mount point of a filesystem or directory?
> Something in glibc parses /proc/mounts for something, I can't remember
> what it is right now though, sorry.

Maybe getmntent(3)? Sure I could use this, but how expensive compared
to a single stat(2).

> Again, I recommend dropping libsysfs, it's gone from some distros
> already :)

Really? I'm curious how such distributions support libsensors and the
other tools which still rely on libsysfs. If they have already
converted libsensors for me, that would be good news :)

> And yes, the bug should be fixed, I agree.  Thanks for letting us know.

Tejun already fixed it, that was quick :)

-- 
Jean Delvare
