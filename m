Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbYCFDPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbYCFDPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 22:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759672AbYCFDPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 22:15:34 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35361 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbYCFDPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 22:15:33 -0500
Date: Wed, 5 Mar 2008 21:15:25 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/9] Devices accessibility control group (v4)
Message-ID: <20080306031525.GA9070@sergelap.austin.ibm.com>
References: <47CED717.60406@openvz.org> <20080306015513.GA5359@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306015513.GA5359@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (greg@kroah.com):
> On Wed, Mar 05, 2008 at 08:23:35PM +0300, Pavel Emelyanov wrote:
> > Changes from v3:
> > * Ported on 2.6.25-rc3-mm1;
> > * Re-splitted into smaller pieces;
> > * Added more comments to tricky places.
> > 
> > This controller allows to tune the devices accessibility by tasks,
> > i.e. grant full access for /dev/null, /dev/zero etc, grant read-only
> > access to IDE devices and completely hide SCSI disks.
> 
>  From within the kernel itself?  The kernel should not be keeping track
> of the mode of devices, that's what the filesystem holding /dev is for.
> Those modes change all the time depending on the device plugged in, and
> the user using the "console".  Why should the kernel need to worry about
> any of this?

These are distinct from the permissions on device files.  No matter what
the permissions on the device files, a task in a devcg cgroup which
isn't allowed write to chardev 4:64 will not be able to write to
/dev/ttyS0.

The purpose is to prevent a root task from granting itself access to
certain devices.  Without this, the only option currently is to take
CAP_MKNOD out of the capability bounding set for a container and make
sure that /dev is set up right (and enforce nodev for mounts).  In
itself that doesn't sound so bad and it was my preference at first, but
the argument is that things like udev should be able to run in a
container, and will object about not being able to create devices.

> > Tasks still can call mknod to create device files, regardless of
> > whether the particular device is visible or accessible, but they
> > may not be able to open it later.
> > 
> > This one hides under CONFIG_CGROUP_DEVS option.
> > 
> > To play with it - run a standard procedure:
> > 
> >  # mount -t container none /cont/devs -o devices
> >  # mkdir /cont/devs/0
> >  # echo -n $$ > /cont/devs/0/tasks
> 
> What is /cont/ for?

cgroups used to be called containers, so 'cont' is presumably shorthand
for container.

> > and tune device permissions.
> 
> How is this done?
> 
> Why would the kernel care about this stuff?

Because there is no way for userspace to restrict a root process in a
container from accessing whatever devices it wants.

> confused,
> 
> greg k-h

thanks,
-serge
