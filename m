Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbXL2QSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbXL2QSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 11:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbXL2QS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 11:18:27 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:39261 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbXL2QS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 11:18:26 -0500
Date: Sat, 29 Dec 2007 08:18:25 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: David Newall <david@davidnewall.com>
cc: Mark Lord <lkml@rtr.ca>, Al Viro <viro@ftp.linux.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
In-Reply-To: <47760578.2090305@davidnewall.com>
Message-ID: <alpine.DEB.0.999999.0712290754230.5207@twinlark.arctic.org>
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca> <4768973C.8020909@davidnewall.com> <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org>
 <47760578.2090305@davidnewall.com>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2007, David Newall wrote:

> dean gaudet wrote:
> > On Wed, 19 Dec 2007, David Newall wrote:
> >   
> > > Mark Lord wrote:
> > >     
> > > > But.. pity there's no mount flag override for smaller systems,
> > > > where bind mounts might be more useful with link(2) actually working.
> > > >       
> > > I don't see it.  You always can make hard link on the underlying
> > > filesystem.
> > > If you need to make it on the bound mount, that is, if you can't locate
> > > the
> > > underlying filesystem to make the hard link, you can use a symbolic link.
> > >     
> > 
> > i run into it on a system where /home is a bind mount of /var/home ... i did
> > this because:
> > 
> > - i prefer /home to be nosuid,nodev (multi-user system)
> >   
> 
> Whatever security /home has, /var/home is the one that restricts because users
> can still access their files that way.

yep.  and /var is nosuid,nodev as well.

> > - i prefer /home to not be on same fs as /
> > - the system has only one raid1 array, and i can't stand having two
> > writable filesystems competing on the same set of spindles (i like to
> >   imagine that one fs competing for the spindles can potentially result
> >   in better seek patterns)
> > ...
> > - i didn't want to try to balance disk space between /var and /home
> > - i didn't want to use a volume mgr just to handle disk space balance...
> >   
> 
> Pffuff.  That's what volume managers are for!  You do have (at least) two
> independent spindles in your RAID1 array, which give you less need to worry
> about head-stack contention.

this system is write intensive and writes go to all spindles, so you're
assertion is wrong.  a quick look at iostat shows the system has averaged
50/50 reads/writes over 34 days.  that means 50% of the IO is going to
both spindles.

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               1.96     2.24   33.65   33.16   755.50   465.45    36.55     0.56    8.43   5.98  39.96

> You probably want different mount restrictions
> on /home than /var, so you really must use separate filesystems.

not sure why you think i want different restrictions... i'm running fine
with nosuid,nodev for /var.

the main worry i have is some user maliciously hardlinks everything
under /var/log somewhere else and slowly fills up the file system with
old rotated logs.  the users otherwise have quotas so they can't fill
things up on their own.  i could probably set up XFS quota trees (aka
"projects") but haven't gone to this effort yet.


> LVM is your friend.

i disagree.  but this is getting into personal taste -- i find volume
managers to be an unnecessary layer of complexity.  given i need quotas for
the users anyhow i don't see why i should both manage my disk space via
quotas and via an extra block layer.


> 
> But with regards to bind mounts and hard links:  If you want to be able to
> hard-link /home/me/log to /var/tmp/my-log, then I see nothing to prevent
> hard-linking /var/home/me/log to /var/tmp/my-log.

you probably missed the point where i said that i was surprised i couldn't
hardlink across the bind mount and actually wanted it to work.

-dean
