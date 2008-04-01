Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbYDAWHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbYDAWHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYDAWHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:07:25 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36420 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYDAWHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:07:24 -0400
Date: Tue, 1 Apr 2008 17:07:22 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       daniel@hozac.com, lizf@cn.fujitsu.com,
       Pavel Emelyanov <xemul@openvz.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/1] cgroups: implement device whitelist (v6)
Message-ID: <20080401220722.GA6317@sergelap.austin.ibm.com>
References: <20080326180543.GA27709@sergelap.austin.ibm.com> <20080329081839.GA4423@ucw.cz> <20080331140053.GA9909@sergelap.austin.ibm.com> <20080401123218.GE12129@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401123218.GE12129@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Machek (pavel@ucw.cz):
> On Mon 2008-03-31 09:00:53, Serge E. Hallyn wrote:
> > Quoting Pavel Machek (pavel@ucw.cz):
> > > On Wed 2008-03-26 13:05:43, Serge E. Hallyn wrote:
> > > > (This is identical to the version I sent on Mar 19 in response to
> > > > the comments by Daniel Hokka Zakrisson, which are the last
> > > > comments I've gotten.)
> > > > 
> > > > Implement a cgroup to track and enforce open and mknod restrictions on device
> > > > files.  A device cgroup associates a device access whitelist with each
> > > > cgroup.  A whitelist entry has 4 fields.  'type' is a (all), c (char), or
> > > > b (block).  'all' means it applies to all types and all major and minor
> > > > numbers.  Major and minor are either an integer or * for all.
> > > > Access is a composition of r (read), w (write), and m (mknod).
> > > > 
> > > > The root device cgroup starts with rwm to 'all'.  A child devcg gets
> > > > a copy of the parent.  Admins can then remove devices from the
> > > > whitelist or add new entries.  A child cgroup can never receive a
> > > > device access which is denied its parent.  However when a device
> > > > access is removed from a parent it will not also be removed from the
> > > > child(ren).
> > > > 
> > > > An entry is added using devices.allow, and removed using
> > > > devices.deny.  For instance
> > > > 
> > > > 	echo 'c 1:3 mr' > /cgroups/1/devices.allow
> > > > 
> > > > allows cgroup 1 to read and mknod the device usually known as
> > > > /dev/null.  Doing
> > > > 
> > > > 	echo a > /cgroups/1/devices.deny
> > > 
> > > Can't you use selinux or something?
> > 
> > No.  At the moment SELinux can't authorize based on type/major:minor.  I
> > would like to add that support later on, but even when I do, folks such
> > as the openvz folks do not want to rely on any security modules.
> 
> Yep, it looks like openvz folks do not want to rely on any security
> modules, do not want to fix their userland, and do not have a taste
> when implementing new features.
> 
> IMO that means openvz folks should be kept off mainline.
> 
> Implementing SELinux extension that can authorize based on
> type/major:minor seems like a way to go to me....

If we go with the decision that properly isolated containers will
always require an LSM then I can go with that.  But IMO such a
decision needs agreement by all the players.  So far it seems there
is only calls from one objector.

Eric, I don't recall - was it your opinion that an LSM was an ok
short-term solution, or that it was in fact an ok long-term solution?

> > > > --- a/include/linux/cgroup_subsys.h
> > > > +++ b/include/linux/cgroup_subsys.h
> > > > @@ -42,3 +42,9 @@ SUBSYS(mem_cgroup)
> > > >  #endif
> > > >  
> > > >  /* */
> > > > +
> > > > +#ifdef CONFIG_CGROUP_DEVICE
> > > > +SUBSYS(devices)
> > > > +#endif
> > > > +
> > > > +/* */
> > > 
> > > I don't know what this is, but it does not look like C...
> > 
> > Huh?
> 
> Empty comments as separators? What does magical SUBSYS macro do?
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
