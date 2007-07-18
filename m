Return-Path: <linux-kernel-owner+w=401wt.eu-S1759929AbXGRVWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbXGRVWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbXGRVV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:21:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:5443 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbXGRVVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kFGHUJSdtP3Spt/6pHxR+JsEV8AUimCjxkDgvFly4zZBNikVLJ3xRfiDlsHY9XoKktgffFUYfVHnJRr9gZfTaUIwFylEfb34TrZOD43nd8LP7g3xtCW8yYY6e8cRh7uN6YaZjP+OW2Y7Af/bKtPwwynMlNsjmpyfaDPhGn/tJjo=
Message-ID: <6101e8c40707181421l6166c319l8648341b855904b7@mail.gmail.com>
Date: Wed, 18 Jul 2007 23:21:54 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: sysfs root link count broken in 2.6.22-git5
Cc: "Greg KH" <gregkh@suse.de>, "Tejun Heo" <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070718220652.15ad2c4b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070715124232.4e371bf9@hyperion.delvare>
	 <20070717034844.GB11602@suse.de>
	 <20070717131255.71b7e72e@hyperion.delvare>
	 <20070717183652.GG9702@suse.de>
	 <20070717230530.64d9a896@hyperion.delvare>
	 <20070718033828.GA8582@suse.de>
	 <20070718220652.15ad2c4b@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Greg,
>
> On Tue, 17 Jul 2007 20:38:28 -0700, Greg KH wrote:
> > On Tue, Jul 17, 2007 at 11:05:30PM +0200, Jean Delvare wrote:
> > > This breaks libsensors. libsensors uses libsysfs, and libsysfs is not
> > > very smart in that it will initialize successfully even if sysfs is not
> > > mounted.
> >
> > libsysfs isn't smart at all, and isn't even supported anymore.  I'd
> > really suggest droping it entirely, it isn't worth it.
>
> Agreed, except that I do not have the time for this right now. I want
> to get lm-sensors-3.0.0 ready for a release candidate first. What
> really matters for this is to get the API ready. Implementation details
> will come later.
>
> > > So I added tests after the initialization, to make sure that
> > > sysfs is really there. These tests are:
> > > * The mount point exists.
> > > * The mount point is really mounted.
> >
> > Do you know of a 2.6 based distro that does not mount sysfs at /sys?  We
> > took that check out a long time ago in udev and no one has complained :)
>
> I don't know of any 2.6-based distro not mounting sysfs at /sys, but I
> know of 2.4-based distros not mounting sysfs at all ;) libsensors
> supports both 2.4 and 2.6 kernels, so being able to tell whether sysfs
> is mounted or not, matters.

debian has mounted the sysfs

/etc/rcS.d/S02mountkernfs.sh:

#
	# Mount sysfs on /sys
	#
	# Only mount sysfs if it is supported (kernel >= 2.6)
	if grep -E -qs "sysfs\$" /proc/filesystems
	then
		domount sysfs "" /sys sysfs -onodev,noexec,nosuid
	fi

	# Mount /var/run and /var/lock as tmpfs if enabled
	if [ yes = "$RAMRUN" ] ; then
		RUN_OPT=
		[ "${RUN_SIZE:=$TMPFS_SIZE}" ] && RUN_OPT=",size=$RUN_SIZE"
		domount tmpfs "" /var/run varrun -omode=0755,nosuid$RUN_OPT
		touch /var/run/.ramfs
	fi
	if [ yes = "$RAMLOCK" ] ; then
		LOCK_OPT=
		[ "${LOCK_SIZE:=$TMPFS_SIZE}" ] && LOCK_OPT=",size=$LOCK_SIZE"
		domount tmpfs "" /var/lock varlock -omode=1777,nodev,noexec,nosuid$LOCK_OPT
		touch /var/lock/.ramfs
	fi


>
> > > The code looks like:
> > >
> > >        if (sysfs_get_mnt_path(sensors_sysfs_mount, NAME_MAX)
> > >          || stat(sensors_sysfs_mount, &statbuf) < 0
> > >          || statbuf.st_nlink <= 2)      /* Empty directory */
> > >                 return 0;           /* Failure */
> > >
> > > This works OK with 2.6.22.1, but the last test fails with the current
> > > git kernel even when sysfs is mounted.
> >
> > Yeah, but is checking the number of hard links in the directory a safe
> > way to always verify that it isn't empty?
>
> I think so, yes. To the best of my knowledge, it has worked on all
> Unix-like systems for decades. There are other ways, but this is by far
> the less expensive.
>
> >                                            Isn't there some glibc
> > function that can detect the mount point of a filesystem or directory?
> > Something in glibc parses /proc/mounts for something, I can't remember
> > what it is right now though, sorry.
>
> Maybe getmntent(3)? Sure I could use this, but how expensive compared
> to a single stat(2).
>
> > Again, I recommend dropping libsysfs, it's gone from some distros
> > already :)
>
> Really? I'm curious how such distributions support libsensors and the
> other tools which still rely on libsysfs. If they have already
> converted libsensors for me, that would be good news :)
>
> > And yes, the bug should be fixed, I agree.  Thanks for letting us know.
>
> Tejun already fixed it, that was quick :)
>
> --
> Jean Delvare
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
