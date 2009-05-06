Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZEFEpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZEFEpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbZEFEpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:45:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:56904 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750770AbZEFEpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:45:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+FSxczghOF/1ad7tHm3Kg+6VhZqB4xpDHcWn0FUl
	3hkV/NOLw7ne1u
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@ZenIV.linux.org.uk, knobi@knobisoft.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uk
In-Reply-To: <20090505154911.e0309a4f.akpm@linux-foundation.org>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com>
	 <20090428182837.62c51f26.akpm@linux-foundation.org>
	 <1240977096.5478.3.camel@marge.simson.net>
	 <20090429011755.c141c599.akpm@linux-foundation.org>
	 <20090429120827.GI8633@ZenIV.linux.org.uk>
	 <1241014725.15095.19.camel@marge.simson.net>
	 <20090505154911.e0309a4f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 06 May 2009 06:45:40 +0200
Message-Id: <1241585140.5196.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 15:49 -0700, Andrew Morton wrote:
> On Wed, 29 Apr 2009 16:18:45 +0200
> Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Wed, 2009-04-29 at 13:08 +0100, Al Viro wrote:
> > > On Wed, Apr 29, 2009 at 01:17:55AM -0700, Andrew Morton wrote:
> > > 
> > > > > > > Questions remains: was this intentional? It breaks existing userspace and should therefore be considered a regression - right? On the other hand, it will never be a problem for RHEL-4/5 kernels, unless the change in 2.6.29 gets backported. Any ideas?
> > > > > > 
> > > > > > afaik that was unintentional and was probably a mistake.
> > > > > > 
> > > > > > I wonder how we did that.
> > > > > 
> > > > > <paste>
> > > > > > [hotplug]# grep sysfs /proc/mounts
> > > > > > none /sys sysfs rw,relatime 0 0
> > > > > > /sys /sys sysfs rw,relatime 0 0
> > > > > 
> > > > > ___(I wonder how the heck that is accomplished)
> > > > 
> > > > Beats me.  I'm not seeing likely changes in fs/proc/base.c or around
> > > > show_mountinfo().  Maybe sysfs broke in an ingenious way.  (hopefully
> > > > cc's viro).
> > > 
> > > Er...  Somebody mounting sysfs twice?  From some init script and from
> > > /etc/fstab, perhaps?  That definitely looks like two mount(2) had to
> > > have been done to cause that...
> > 
> > Yeah, but how does one go about doing that?
> > 
> > Using mount -f, I can convince mount to succeed, but I still have only
> > one entry in /proc/mounts, despite what my mount binary imagines.
> > 
> > marge:..sys/vm # grep sysfs /proc/mounts
> > sysfs /sys sysfs rw,relatime 0 0
> > 
> > marge:..sys/vm # mount|grep sysfs
> > sysfs on /sys type sysfs (rw)
> > sys on /sys type sysfs (rw)
> > /sys on /sys type sysfs (rw)
> > 
> 
> So /proc/mounts is OK and /etc/mtab is wrong?
> 
> Obvious next step is to strace `mount -f', see what's happening around
> sys_mount(), please.

Well, there is no syscall with -f.

I was trying various mount options to see if I could find a way to
create bogons that could confuse scripts.  I could create bogons
in /etc/mtab with -f, or bogons in /proc/mounts by using --move.  I
could re-create the exact reported data with a combination of mount -n
and mount --move.  I could not get a double /proc/mounts entry without
--move, and that seems unlikely to appear in boot scripts.  So I still
wonder how the heck it was accomplished.

I also now wonder why you can --move mounts on top of one another, but
beck with it, ignorance conserves braincells I may some day need :)

	-Mike

