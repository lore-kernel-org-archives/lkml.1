Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbXFLNOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbXFLNOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbXFLNOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:14:06 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:53763 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755540AbXFLNOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:14:04 -0400
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200706111755.33162.agruen@suse.de>
References: <20070514110607.549397248@suse.de>
	 <200706110110.35553.agruen@suse.de>
	 <1181572416.8805.73.camel@moss-spartans.epoch.ncsc.mil>
	 <200706111755.33162.agruen@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 12 Jun 2007 09:13:58 -0400
Message-Id: <1181654038.17547.104.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-11 at 17:55 +0200, Andreas Gruenbacher wrote:
> On Monday 11 June 2007 16:33, Stephen Smalley wrote:
> > On Mon, 2007-06-11 at 01:10 +0200, Andreas Gruenbacher wrote:
> > > On Wednesday 06 June 2007 15:09, Stephen Smalley wrote:
> > > > On Mon, 2007-06-04 at 16:30 +0200, Andreas Gruenbacher wrote:
> > > > > On Monday 04 June 2007 15:12, Pavel Machek wrote:
> > > > > > How will kernel work with very long paths? I'd suspect some
> > > > > > problems, if path is 1MB long and I attempt to print it in /proc
> > > > > > somewhere.
> > > > >
> > > > > Pathnames are only used for informational purposes in the kernel,
> > > > > except in AppArmor of course.
> > > >
> > > > I don't mean this as a flame, but isn't the above statement the very
> > > > crux of this discussion?
> > >
> > > I think the question at the core of it all is, shall a pathname based
> > > security mechanism be allowed. I was under the impression that this
> > > question had already been answered affirmatively. If the answer here was
> > > no, then we could stop the entire discussion right there.
> >
> > There is a difference between using the pathname at the kernel/userland
> > interface as part of configuring a security mechanism and using it as
> > the basis for the runtime checking itself.
> 
> Yes, there is a difference. When I say pathname based security mechanism, I 
> literally mean a pathname based security mechanism, meaning the pathnames 
> determine the outcome o the decision. This includes designs that are based on 
> different abstractions internally, but the bahavior observable from 
> user-space must be the same (or else, it's a different model).
> 
> Unfortunately, translating pathnames to labels destroys this fundamental 
> abstraction. We explained why this is so in the following postings:
> 
> 	http://lkml.org/lkml/2007/6/9/94
> 	http://lkml.org/lkml/2007/6/10/141

I don't really see the specific reasons explained in the first posting;
the second one has a list of problems, but I'd question their validity:
- New files:  Adding the last component name as a further input to the
logic for determining the label of a new file would address many of the
concerns here.
- Renaming:  Do you honestly believe that renaming a file or directory
tree should automatically change its protection without explicit action
by the user/admin?  I don't, naturally, and Linux DAC certainly doesn't
work that way.  I view the change-protections-on-rename behavior of AA
as a flaw, not something to be emulated.
- New Policies:  So there may be more work to be done up front in the
label-based approach when developing policies.  Isn't that where you
want to front load the work?  Versus doing it at runtime?  Do you expect
users to be rewriting their policies constantly on their production
systems?
- File systems that do not support labels:  I'm a bit surprised that you
would advocate this given your experience in developing EA and ACL
support for local filesystems and NFS.  The pathname-based approach in
NFS seems even scarier than in the local case - the clients may have
different views of the namespace than one another or the server and the
potential for inconsistent views of the tree (particularly as it is
being modified) during access checks is only greater in the NFS case,
right?  It may be more expedient to implement, but is it the right
technical approach?

But possibly the larger question here is whether your abstraction is
fundamentally broken/leaky.  Even with your "native" implementation in
AA, you concede that there are cases where it breaks down, right?  e.g.
as the path returned by d_path may in fact differ from the path that was
looked up, as the tree can change between time-of-lookup and
time-of-path-generation?

> [cut here for lack of time right now -- will take another look later]

I'm hoping you'll ultimately respond to the questions I have raised (a
couple times now) about why this fundamentally differs from audit and/or
inotify, which take pathnames as part of configuring the mechanism but
do not generate them and match them on each access.

> 
> > > Without the vfsmounts propagated down you won't know the pathnames.
> > > Whether or not a different problem can be solved without the vfsmounts is
> > > not really relevant.
> >
> > Well, that presumes that your mechanism has to generate full pathnames
> > on each access check.  But even if so, you could be doing your checking
> > in the higher level code then where you have a vfsmount available.
> 
> The LSM hooks are pretty high-level, meant for being able to plug in different 
> access checks. That's the right level of abstraction. We just need the 
> vfsmounts passed down as well. That's what the bulk of common code patches 
> are there for.

Well, if you succeed in that, does that mean that the read-only bind
mount folks should go back to that approach?  Just looking for a little
bit of consistency among different efforts...

-- 
Stephen Smalley
National Security Agency

