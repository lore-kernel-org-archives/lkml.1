Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbXFPAbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbXFPAbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbXFPAbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:31:38 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58372 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbXFPAbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:31:36 -0400
Date: Fri, 15 Jun 2007 17:31:32 -0700
From: Greg KH <greg@kroah.com>
To: david@lang.hm
Cc: Crispin Cowan <crispin@novell.com>, Pavel Machek <pavel@ucw.cz>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
Message-ID: <20070616003132.GB30127@kroah.com>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070615234925.GB15056@kroah.com> <Pine.LNX.4.64.0706151656170.12349@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706151656170.12349@asgard.lang.hm>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 05:01:25PM -0700, david@lang.hm wrote:
>  On Fri, 15 Jun 2007, Greg KH wrote:
> 
> > On Fri, Jun 15, 2007 at 04:30:44PM -0700, Crispin Cowan wrote:
> >> Greg KH wrote:
> >>> On Fri, Jun 15, 2007 at 10:06:23PM +0200, Pavel Machek wrote:
> >>>> Only case where attacker _can't_ be keeping file descriptors is newly
> >>>> created files in recently moved tree. But as you already create files
> >>>> with restrictive permissions, that's okay.
> >>>>
> >>>> Yes, you may get some -EPERM during the tree move, but AA has that
> >>>> problem already, see that "when madly moving trees we sometimes
> >>>> construct path file never ever had".
> >>>>
> >>> Exactly.
> >>>
> >> You are remembering old behavior. The current AppArmor generates only
> >> correct and consistent paths. If a process has an open file descriptor
> >> to such a file, they will retain access to it, as we described here:
> >> http://forgeftp.novell.com//apparmor/LKML_Submission-May_07/techdoc.pdf
> >>
> >> Under the restorecon-alike proposal, you have a HUGE open race. This
> >> post http://bugs.centos.org/view.php?id=1981 describes restorecon
> >> running for 30 minutes relabeling a file system. That is so far from
> >> acceptable that it is silly.
> >
> > Ok, so we fix it.  Seriously, it shouldn't be that hard.  If that's the
> > only problem we have here, it isn't an issue.
> 
>  how do you 'fix' the laws of physics?
> 
>  the problem is that with a directory that contains lots of files below it 
>  you have to access all the files metadata to change the labels on it. it can 
>  take significant amounts of time to walk the entire three and change every 
>  file.

Agreed, but you can do this in ways that are faster than others :)

> >>> I can't think of a "real world" use of moving directory trees around
> >>> that this would come up in as a problem.
> >> Consider this case: We've been developing a new web site for a month,
> >> and testing it on the server by putting it in a different virtual
> >> domain. We want to go live at some particular instant by doing an mv of
> >> the content into our public HTML directory. We simultaneously want to
> >> take the old web site down and archive it by moving it somewhere else.
> >>
> >> Under the restorecon proposal, the web site would be horribly broken
> >> until restorecon finishes, as various random pages are or are not
> >> accessible to Apache.
> >
> > Usually you don't do that by doing a 'mv' otherwise you are almost
> > guaranteed stale and mixed up content for some period of time, not to
> > mention the issues surrounding paths that might be messed up.
> 
>  on the contrary, useing 'mv' is by far the cleanest way to do this.
> 
>  mv htdocs htdocs.old;mv htdocs.new htdocs
> 
>  this makes two atomic changes to the filesystem, but can generate thousands 
>  to millions of permission changes as a result.

I agree, and yet, somehow, SELinux today handles this just fine, right?
:)

Let's worry about speed issues later on when a working implementation is
produced, I'm still looking for the logical reason a system like this
can not work properly based on the expected AA interface to users.

thanks,

greg k-h
