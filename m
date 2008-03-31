Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbYCaOBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbYCaOBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYCaOBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:01:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53989 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbYCaOBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:01:23 -0400
Date: Mon, 31 Mar 2008 09:00:53 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       daniel@hozac.com, lizf@cn.fujitsu.com,
       Pavel Emelyanov <xemul@openvz.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/1] cgroups: implement device whitelist (v6)
Message-ID: <20080331140053.GA9909@sergelap.austin.ibm.com>
References: <20080326180543.GA27709@sergelap.austin.ibm.com> <20080329081839.GA4423@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080329081839.GA4423@ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Machek (pavel@ucw.cz):
> On Wed 2008-03-26 13:05:43, Serge E. Hallyn wrote:
> > (This is identical to the version I sent on Mar 19 in response to
> > the comments by Daniel Hokka Zakrisson, which are the last
> > comments I've gotten.)
> > 
> > Implement a cgroup to track and enforce open and mknod restrictions on device
> > files.  A device cgroup associates a device access whitelist with each
> > cgroup.  A whitelist entry has 4 fields.  'type' is a (all), c (char), or
> > b (block).  'all' means it applies to all types and all major and minor
> > numbers.  Major and minor are either an integer or * for all.
> > Access is a composition of r (read), w (write), and m (mknod).
> > 
> > The root device cgroup starts with rwm to 'all'.  A child devcg gets
> > a copy of the parent.  Admins can then remove devices from the
> > whitelist or add new entries.  A child cgroup can never receive a
> > device access which is denied its parent.  However when a device
> > access is removed from a parent it will not also be removed from the
> > child(ren).
> > 
> > An entry is added using devices.allow, and removed using
> > devices.deny.  For instance
> > 
> > 	echo 'c 1:3 mr' > /cgroups/1/devices.allow
> > 
> > allows cgroup 1 to read and mknod the device usually known as
> > /dev/null.  Doing
> > 
> > 	echo a > /cgroups/1/devices.deny
> 
> Can't you use selinux or something?

No.  At the moment SELinux can't authorize based on type/major:minor.  I
would like to add that support later on, but even when I do, folks such
as the openvz folks do not want to rely on any security modules.

> Or just fix the userland as this is for old-udev compatibility, only?

Until the part of Miklos' user mounts patches go in which enforces MNT_NODEV
on mounts made by someone who is !capable(CAP_MKNOD), using capability bounding
sets is completely inadequate.

> The interface is ugly...

What's ugly about it?  How could we clean it up?

> > diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> > index 1ddebfc..e287745 100644
> > --- a/include/linux/cgroup_subsys.h
> > +++ b/include/linux/cgroup_subsys.h
> > @@ -42,3 +42,9 @@ SUBSYS(mem_cgroup)
> >  #endif
> >  
> >  /* */
> > +
> > +#ifdef CONFIG_CGROUP_DEVICE
> > +SUBSYS(devices)
> > +#endif
> > +
> > +/* */
> 
> I don't know what this is, but it does not look like C...

Huh?

-serge
