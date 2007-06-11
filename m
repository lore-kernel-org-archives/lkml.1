Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbXFKOeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbXFKOeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 10:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXFKOds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 10:33:48 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:40571 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752398AbXFKOdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 10:33:45 -0400
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200706110110.35553.agruen@suse.de>
References: <20070514110607.549397248@suse.de>
	 <200706041630.49316.agruen@suse.de>
	 <1181135397.3699.53.camel@moss-spartans.epoch.ncsc.mil>
	 <200706110110.35553.agruen@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 11 Jun 2007 10:33:36 -0400
Message-Id: <1181572416.8805.73.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-11 at 01:10 +0200, Andreas Gruenbacher wrote:
> On Wednesday 06 June 2007 15:09, Stephen Smalley wrote:
> > On Mon, 2007-06-04 at 16:30 +0200, Andreas Gruenbacher wrote:
> > > On Monday 04 June 2007 15:12, Pavel Machek wrote:
> > > > How will kernel work with very long paths? I'd suspect some problems,
> > > > if path is 1MB long and I attempt to print it in /proc
> > > > somewhere.
> > > 
> > > Pathnames are only used for informational purposes in the kernel, except 
> > > in AppArmor of course.
> > 
> > I don't mean this as a flame, but isn't the above statement the very
> > crux of this discussion?
> 
> I think the question at the core of it all is, shall a pathname based security 
> mechanism be allowed. I was under the impression that this question had 
> already been answered affirmatively. If the answer here was no, then we could 
> stop the entire discussion right there.

There is a difference between using the pathname at the kernel/userland
interface as part of configuring a security mechanism and using it as
the basis for the runtime checking itself.  Further, there is a
difference between generating and matching full pathnames on each access
vs. caching information in the parent dentry and making decisions based
on that cached information and the last component-name.  The only
question I saw being answered was the abstract one of "can a pathname
play a role in the security mechanism" not "should the kernel be
regenerating a full path on each open and glob matching it against a
list of file globs."

> > Why should AppArmor be different from the rest of the kernel in its usage of
> > pathnames (basis for decisions vs. informational reporting to userspace)? 
> > And if it is ok for AppArmor to generate and use pathnames as its basis of
> > decisions on each open, then is it also ok for audit, inotify, and others to
> > use them in the same manner?
> 
> Audit and inotify don't make any decisions based on pathnames, or on SELinux 
> labels for that matter, they only report. That being said, sure those parts 
> of the kernel that report pathnames should report them correctly -- I guess 
> there is no disagreement about that.

>From a userland perspective, audit and inotify allow you to specify
watches on pathnames, and those watches trigger actions by the audit and
inotify subsystems when those files are accessed.  The kernel mechanism
however is inode-based, not pathname-based; the pathname is merely
looked up when the watch is added and mapped to an inode.  That's my
point - why should AA be different?  Would you really recommend that
audit or inotify call d_path() on each open and glob match the result
against a list of audit or inotify watches?  BTW, audit does allow
filters on SELinux labels these days.

> > Another question:  it seems like the read-only bind mount folks gave up
> > on propagating the vfsmounts down and switched to a rather different
> > approach (checking near the entry points, using mount writer counters).
> > So similarly, what makes AppArmor fundamentally different that it
> > wouldn't take a similar approach to what they are doing vs. propagating
> > the vfsmounts down?
> 
> Without the vfsmounts propagated down you won't know the pathnames. Whether 
> or not a different problem can be solved without the vfsmounts is not really 
> relevant.

Well, that presumes that your mechanism has to generate full pathnames
on each access check.  But even if so, you could be doing your checking
in the higher level code then where you have a vfsmount available.

-- 
Stephen Smalley
National Security Agency

