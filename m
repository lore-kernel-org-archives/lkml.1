Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbYHZTQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbYHZTQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbYHZTQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:16:25 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57836 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbYHZTQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:16:24 -0400
Date: Tue, 26 Aug 2008 14:16:23 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       SELinux <selinux@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: Re: [PATCH 1/1] selinux: add support for installing a dummy policy
Message-ID: <20080826191623.GA1956@us.ibm.com>
References: <20080822193413.GA8401@us.ibm.com> <alpine.LRH.1.10.0808230852320.24779@tundra.namei.org> <20080823023812.GA30915@us.ibm.com> <1219666201.2721.29.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219666201.2721.29.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> 
> On Fri, 2008-08-22 at 21:38 -0500, Serge E. Hallyn wrote:
> > --- /dev/null
> > +++ b/scripts/selinux/install_policy.sh
> > @@ -0,0 +1,44 @@
> > +#!/bin/sh
> > +if [ `id -u` -ne 0 ]; then
> > +	echo "$0: must be root to install the selinux policy"
> > +	exit 1
> > +fi
> > +SF=`which setfiles`
> > +if [ $? -eq 1 ]; then
> > +	if [ -f /usr/sbin/setfiles ]; then
> > +		SF="/usr/sbin/setfiles"
> 
> /sbin/setfiles on modern Fedora releases.

Thanks for reviewing, Stephen.

Changed this to /sbin.

> > +	else
> > +		echo "no selinux tools installed: setfiles"
> > +		exit 1
> > +	fi
> > +fi
> > +
> > +cd mdp
> > +
> > +CP=`which checkpolicy`
> > +./mdp policy.conf file_contexts
> > +$CP -o policy.`checkpolicy -V | awk '{print $1}'` policy.conf
> 
> Save version to a variable and reuse below.
> 
> > +
> > +mkdir -p /etc/selinux/dummy/policy
> > +mkdir -p /etc/selinux/dummy/contexts/files
> > +
> > +cp file_contexts /etc/selinux/dummy/contexts/files
> > +cp dbus_contexts /etc/selinux/dummy/contexts
> > +cp policy.`checkpolicy -V | awk '{print $1}'` /etc/selinux/dummy/policy
> > +FC_FILE=/etc/selinux/dummy/contexts/files/file_contexts
> > +
> > +cd /etc/selinux/dummy/contexts/files
> > +$SF file_contexts /
> > +
> > +mounts=`cat /proc/$$/mounts | egrep "ext2|ext3|xfs|jfs" | awk '{ print $2 '}`
> 
> ext4, ext4dev, gfs2 too.
> See /sbin/fixfiles for an example.  Or run it.

I'm testing a version which uses fixfiles, but it complains about
the fact that selinux is not loaded.  Using setfiles seemed
more robust.  So I guess I'll go back to that for now.  Someone
else can always update it later.

> > +for line in $mounts; do
> > +	$SF file_contexts $line
> > +done
> 
> You can pass them all to setfiles at once; it takes a list of mount
> points after the file_contexts file. Or run fixfiles instead as it does
> much the same.
> 
> However, I don't believe this step will work if you are doing this on an
> existing SELinux-enabled system - the kernel will check the contexts
> upon setxattr against the active policy and reject them, and you haven't
> loaded the new policy yet.  Also, this is a "destructive" operation,
> i.e. if they were running SELinux before, they are hereby clobbering all
> their file labels.  Possibly you should bail out if selinuxenabled
> (utility that can be used as a boolean in shell conditionals).
> if /usr/sbin/selinuxenabled; then
> 	echo"SELinux already enabled with a policy loaded; exiting."
> 	exit 1
> fi

Done in my new version (which I'll send out once I re-create
it using setfiles again), along with most of your other
suggestions.

> > +
> > +dodev=`cat /proc/$$/mounts | grep "/dev "`
> > +if [ "eq$dodev" != "eq" ]; then
> > +	mount --move /dev /mnt
> > +	$SF file_contexts /dev
> > +	mount --move /mnt /dev
> > +fi
> 
> Not sure what you are doing here.  If /dev is udev-managed, then it will

This (like the whole file) came from David, but nevertheless it's
something I've had to do many times to get a system booted.  Maybe the
new fedora initrd way of enabling selinux changes that, but it would
still be needed for older distros.

> handle labeling at boot.  But it still shows up as a tmpfs mount
> in /proc/self/mounts.
> 
> Where do you set up /etc/selinux/config to refer to this dummy policy so
> it will get loaded at boot?

I was going to just explain how to do it in the documentation, but went
ahead and modified install_policy.sh to do it.

New version coming soon.

thanks,
-serge
