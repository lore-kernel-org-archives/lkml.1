Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYCGGIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYCGGIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYCGGIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:08:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32909 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYCGGII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:08:08 -0500
Date: Thu, 6 Mar 2008 20:58:12 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH 0/9] Devices accessibility control group (v4)
Message-ID: <20080307045812.GC913@kroah.com>
References: <47CED717.60406@openvz.org> <20080306015513.GA5359@kroah.com> <20080306031525.GA9070@sergelap.austin.ibm.com> <20080306043427.GA15498@kroah.com> <47CFAD06.7020501@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CFAD06.7020501@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 11:36:22AM +0300, Pavel Emelyanov wrote:
> Greg KH wrote:
> > On Wed, Mar 05, 2008 at 09:15:25PM -0600, Serge E. Hallyn wrote:
> >> Quoting Greg KH (greg@kroah.com):
> >>> On Wed, Mar 05, 2008 at 08:23:35PM +0300, Pavel Emelyanov wrote:
> >>>> Changes from v3:
> >>>> * Ported on 2.6.25-rc3-mm1;
> >>>> * Re-splitted into smaller pieces;
> >>>> * Added more comments to tricky places.
> >>>>
> >>>> This controller allows to tune the devices accessibility by tasks,
> >>>> i.e. grant full access for /dev/null, /dev/zero etc, grant read-only
> >>>> access to IDE devices and completely hide SCSI disks.
> >>>  From within the kernel itself?  The kernel should not be keeping track
> >>> of the mode of devices, that's what the filesystem holding /dev is for.
> >>> Those modes change all the time depending on the device plugged in, and
> >>> the user using the "console".  Why should the kernel need to worry about
> >>> any of this?
> >> These are distinct from the permissions on device files.  No matter what
> >> the permissions on the device files, a task in a devcg cgroup which
> >> isn't allowed write to chardev 4:64 will not be able to write to
> >> /dev/ttyS0.
> > 
> > Then why not do that from userspace with a different /dev, or with a
> > LSM?
> 
> Different dev is not suitable, since task may still call mknod to
> create device it needs and use it. This is not about comfortable
> use, this is about security.

LSM can control mknod quite well.  And it is _all_ about security, don't
try to add "security" to some other portion of the kernel that it not
expecting it :)

> LSM approach was proposed, but that required some API to configure
> the permissions.

Much like the API you already created to configure the permissions...

> This API done via control groups, so there were no
> difference between this approach and that. Except for this one doesn't
> create one more level of filtering at the top of kobject lookup and
> thus is simpler and faster.

How can it be "faster"?  There is no speed problems here.

Please use LSM for this, that is what it is explicitly there for.

> >> The purpose is to prevent a root task from granting itself access to
> >> certain devices.  Without this, the only option currently is to take
> >> CAP_MKNOD out of the capability bounding set for a container and make
> >> sure that /dev is set up right (and enforce nodev for mounts).  In
> >> itself that doesn't sound so bad and it was my preference at first,
> > 
> > that would be my preference as well.
> 
> That approach relies on a proper user space setup inside a container, 
> but this creates security holes, since container user may ignore all
> these "requirements".

Ok then, use LSM to enforce those requirements, again, that is what it
is there for.

> >> but the argument is that things like udev should be able to run in a
> >> container, and will object about not being able to create devices.
> > 
> > No reason you can't modify udev to do something like this.  At the
> 
> Sure we _can_ modify udev, but the problem is that users of virtualisation
> solutions often (very often) use old software (e.g. set up some out-dated
> distribution inside a container), so trick with modified udev simply won't
> work in many cases.

So the kernel's job is to enforce policy that an old userspace can not
seem to get straight?  That bit of logic doesn't go over so well...

Andrew, please drop these patches from your tree, this all should be
done with a simple LSM interface, which would be much smaller and much
less intrusive than this patchset.

thanks,

greg k-h
