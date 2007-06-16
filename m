Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbXFPAET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbXFPAET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXFPAEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:04:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35989 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756898AbXFPAEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:04:04 -0400
Date: Sat, 16 Jun 2007 02:02:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Crispin Cowan <crispin@novell.com>
Cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070616000251.GG2616@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46732124.80509@novell.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Only case where attacker _can't_ be keeping file descriptors is newly
> >> created files in recently moved tree. But as you already create files
> >> with restrictive permissions, that's okay.
> >>
> >> Yes, you may get some -EPERM during the tree move, but AA has that
> >> problem already, see that "when madly moving trees we sometimes
> >> construct path file never ever had".
> >>     
> > Exactly.
> >   
> You are remembering old behavior. The current AppArmor generates only
> correct and consistent paths. If a process has an open file descriptor
> to such a file, they will retain access to it, as we described here:

Ok, so what I described was actually secure. Good.

> Under the restorecon-alike proposal, you have a HUGE open race. This
> post http://bugs.centos.org/view.php?id=1981 describes restorecon
> running for 30 minutes relabeling a file system. That is so far from
> acceptable that it is silly.

30 minutes during installation does not seem "silly" to me.

And that race does not make it insecure, because of the open file
descriptors. Good.

> Of course, this depends on the system in question, but restorecon will
> necessarily need to traverse whatever portions of the filesystem that
> have changed, which can be quite a long time indeed. Any race condition
> measured in minutes is a very serious issue.

You seem to imply it is security related, it is not. I can have open
files for hours or days.

> > I can't think of a "real world" use of moving directory trees around
> > that this would come up in as a problem.
> Consider this case: We've been developing a new web site for a month,
> and testing it on the server by putting it in a different virtual
> domain. We want to go live at some particular instant by doing an mv of
> the content into our public HTML directory. We simultaneously want to
> take the old web site down and archive it by moving it somewhere
> else.

And you do that exactly how, without the race? I do not think ve have
three_way_rename(name1, name2, name3) system call.

Notice that

1) mv can take minutes already if you move cross filesystem.

2) this is easily avoided by mv-ing somewhere with "same" permissons,
then doing quick moves when daemon is done.

> You could get restorecon to do this automatically by using inotify. But
> to make it as general and transparent as AA is now, you would have to
> run inotify on every directory in the system, with consequences for
> kernel memory and performance.

So you run inotify everywhere. IIRC beagle does it already.

> > Can anyone else see a problem with this that I'm just being foolish and
> > missing?
> >   
> It is not foolish. The label idea is so attractive that last September
> from discussions with Arjan we actually thought it was the preferred
> implementation. However, what we've been saying over and over again is
> that we *tried* this, and it *doesn't* work at the implementation level.
> There is no good answer, restorecon is an ugly kludge, and so this
> seductive approach turns out to be a dead end.

Talking about dead ends... "just put path-based security module into
kernel" recently got pretty strong "NACK" from Christoph Hellwig (see
TOMOYO Linux thread), and I believe there was similar comment from Al
Viro in past. That seems to me as dead-endy as it gets. "mv takes 30
minutes" is road slightly covered with bushes... compared to that.

So we can either forget about AA completely, or take a way Christoph
did not "NACK". restorecond is such a way, and with inotify it should
be acceptable. find does _not_ take that long, not even for git trees.

pavel@amd:/data/l/linux$ time find . > /dev/null
0.04user 0.37system 11.50 (0m11.504s) elapsed 3.56%CPU

(If you wanted to be super-nice, you could introduce rename() helper
into glibc, that would do re-labeling synchronously, and only return
when it is done. All the nice applications call glibc anyway, and all
the exploits can't take advantage of it, because it is secure
already.).

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
