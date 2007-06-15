Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbXFOUHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbXFOUHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXFOUH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:07:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59192 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753416AbXFOUH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:07:28 -0400
Date: Fri, 15 Jun 2007 22:06:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Crispin Cowan <crispin@novell.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070615200623.GA2616@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615165054.GA11345@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

And before you scream "races", take a look. It does not actually add
them:

> > > I agree that the in-kernel implementation could use different abstractions 
> > > than user-space, provided that the underlying implementation details can be 
> > > hidden well enough. The key phrase here is "if possible", and in fact "if 
> > > possible" is much too strong: very many things in software are possible, 
> > > including user-space drives and a stable kernel module ABI. Some things make 
> > > sense; others are genuinely bad ideas while still possible.
> > >   
> > In particular, to layer AppArmor on top of SELinux, the following
> > problems must be addressed:
> > 
> >     * New files: when a file is created, it is labeled according to the
> >       type of the creating process and the type of the parent directory.
> >       Applications can also use libselinux to use application logic to
> >       relabel the file, but that is not 'mandatory' policy, and fails in
> >       cases like cp and mv. AppArmor lets you create a policy that e..g
> >       says "/home/*/.plan r" to permit fingerd to read everyone's .plan
> >       file, should it ever exist, and you cannot emulate that with SELinux.
> 
> A daemon using inotify can "instantly"[1] detect this and label the file
> properly if it shows up.

Or just create the files with restrictive labels by default. That way
you "fail closed".

> >     * Renamed Files: Renaming a file changes the policy with respect to
> >       that file in AA. To emulate this in SELinux, you would have to
> >       have a way to instantly re-label the file upon rename.
> 
> Same daemon can do the re-label.

...and no, race there is not important. Attacker may have opened the
file under old name and is keeping open file descriptor. So this does
not add a new race relative to AA.

> >     * Renamed Directory trees: The above problem is compounded with
> >       directory trees. Changing the name at the top of a large, bushy
> >       tree can require instant relabeling of millions of files.
> 
> Same daemon can do this.  And yes, it might take a ammount of time, but
> the times that this happens in "real-life" on a "production" server is
> quite small, if at all.

And now, if you move a tree, there will be old labels for a while. But
this does not matter, because attacker could be keeping file
descriptors.

Only case where attacker _can't_ be keeping file descriptors is newly
created files in recently moved tree. But as you already create files
with restrictive permissions, that's okay.

Yes, you may get some -EPERM during the tree move, but AA has that
problem already, see that "when madly moving trees we sometimes
construct path file never ever had".

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
