Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbXFPA37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbXFPA37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbXFPA3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:29:49 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44126 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbXFPA3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:29:48 -0400
Date: Fri, 15 Jun 2007 17:29:45 -0700
From: Greg KH <greg@kroah.com>
To: Crispin Cowan <crispin@novell.com>, Pavel Machek <pavel@ucw.cz>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
Message-ID: <20070616002945.GA30127@kroah.com>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070615234925.GB15056@kroah.com> <20070616001810.GP3564@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070616001810.GP3564@suse.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 05:18:10PM -0700, Seth Arnold wrote:
> On Fri, Jun 15, 2007 at 04:49:25PM -0700, Greg KH wrote:
> > > We have built a label-based AA prototype. It fails because there is no
> > > reasonable way to address the tree renaming problem.
> > 
> > How does inotify not work here?  You are notified that the tree is
> > moved, your daemon goes through and relabels things as needed.  In the
> > meantime, before the re-label happens, you might have the wrong label on
> > things, but "somehow" SELinux already handles this, so I think you
> > should be fine.
> 
> SELinux does not relabel files when containing directories move, so it
> is not a problem they've chosen to face.
> 
> How well does inotify handle running attached to every directory on a
> typical Linux system?

Look at SLED and Beagle (taking the indexing logic out of the equation.)
It runs good enough that a major Linux vendor is willing to stake its
reputation on it :)

> > > Under the restorecon-alike proposal, you have a HUGE open race. This
> > > post http://bugs.centos.org/view.php?id=1981 describes restorecon
> > > running for 30 minutes relabeling a file system. That is so far from
> > > acceptable that it is silly.
> > 
> > Ok, so we fix it.  Seriously, it shouldn't be that hard.  If that's the
> > only problem we have here, it isn't an issue.
> 
> Restorecon traverses the filesystem from a specific down. In order to
> apply to an entire system (as would be necessary to try to emulate
> AppArmor's model using SELinux), restorecon would need to run on vast
> portions of the filesystem often. (mv ~/public_html ~/archived; or tar
> zxvf linux-*.tar.gz, etc.)
> 
> I'm not sure we need to run restorecon every time rename(2) is called.

Ok, so we optimize it.  Putting speed issues aside right now as a "mere"
implementation details, I'm looking for logical reasons the AA model
will not work in this type of system.

> > > Of course, this depends on the system in question, but restorecon will
> > > necessarily need to traverse whatever portions of the filesystem that
> > > have changed, which can be quite a long time indeed. Any race condition
> > > measured in minutes is a very serious issue.
> > 
> > Agreed, so we fix that.  There are ways to speed those kinds of things
> > up quite a bit, and I imagine since the default SELinux behavior doesn't
> > use restorecon in this kind of use-case, no one has spent the time to do
> > the work.
> 
> The time for restorecon is probably best imagined as a kind of 'du' that
> also updates extended attributes as it does its work. It'd be very
> difficult to improve on this.

Is that a bet?  :)

> > What "kernel memory and performance" issues are there?  Your SLED
> > machine already has inotify running on every directory in the system
> > today, and you don't seem to have noticed that :)
> 
> I beg to differ. :)

The Beagle index backend is known to slow things down at times, yes, but
is that the fault of the inotify watches, or the use of mono and a
big-ass database on the system at the same time?

In the original inotify development, the issue was not inotify at all,
unless you have some newer numbers in this regard?

And Crispin mentioned that you all already implemented this.  Do you
have the code around so that we can take a look at it?

thanks,

greg k-h
