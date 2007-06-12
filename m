Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbXFLPp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbXFLPp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbXFLPpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:45:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51767 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbXFLPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:45:13 -0400
Date: Tue, 12 Jun 2007 10:34:31 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Andreas Gruenbacher <agruen@suse.de>,
       Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Message-ID: <20070612153431.GB14397@sergelap.austin.ibm.com>
References: <20070514110607.549397248@suse.de> <200706110110.35553.agruen@suse.de> <1181572416.8805.73.camel@moss-spartans.epoch.ncsc.mil> <200706111755.33162.agruen@suse.de> <20070611190222.GB18276@sergelap.austin.ibm.com> <1181653234.17547.89.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181653234.17547.89.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> On Mon, 2007-06-11 at 14:02 -0500, Serge E. Hallyn wrote:
> > Quoting Andreas Gruenbacher (agruen@suse.de):
> > > On Monday 11 June 2007 16:33, Stephen Smalley wrote:
> > > > On Mon, 2007-06-11 at 01:10 +0200, Andreas Gruenbacher wrote:
> > > > > On Wednesday 06 June 2007 15:09, Stephen Smalley wrote:
> > > > > > On Mon, 2007-06-04 at 16:30 +0200, Andreas Gruenbacher wrote:
> > > > > > > On Monday 04 June 2007 15:12, Pavel Machek wrote:
> > > > > > > > How will kernel work with very long paths? I'd suspect some
> > > > > > > > problems, if path is 1MB long and I attempt to print it in /proc
> > > > > > > > somewhere.
> > > > > > >
> > > > > > > Pathnames are only used for informational purposes in the kernel,
> > > > > > > except in AppArmor of course.
> > > > > >
> > > > > > I don't mean this as a flame, but isn't the above statement the very
> > > > > > crux of this discussion?
> > > > >
> > > > > I think the question at the core of it all is, shall a pathname based
> > > > > security mechanism be allowed. I was under the impression that this
> > > > > question had already been answered affirmatively. If the answer here was
> > 
> > That was the decision at ksummit last year, yes.
> > 
> > > > > no, then we could stop the entire discussion right there.
> > > >
> > > > There is a difference between using the pathname at the kernel/userland
> > > > interface as part of configuring a security mechanism and using it as
> > > > the basis for the runtime checking itself.
> > > 
> > > Yes, there is a difference. When I say pathname based security mechanism, I 
> > > literally mean a pathname based security mechanism, meaning the pathnames 
> > > determine the outcome o the decision. This includes designs that are based on 
> > > different abstractions internally, but the bahavior observable from 
> > > user-space must be the same (or else, it's a different model).
> > > 
> > > Unfortunately, translating pathnames to labels destroys this fundamental 
> > > abstraction. We explained why this is so in the following postings:
> > > 
> > > 	http://lkml.org/lkml/2007/6/9/94
> > > 	http://lkml.org/lkml/2007/6/10/141
> > > 
> > > > Further, there is a difference between generating and matching full
> > > > pathnames on each access vs. caching information in the parent dentry and
> > > > making decisions based on that cached information and the last
> > > > component-name.
> > > 
> > > Wait, you are mixing two issues here: access checks on existing files, and the 
> > > creation of new files. For AppArmor as it stands today the two are the same, 
> > > but when looking at emulating AppArmor using labels, they are not. Let's look 
> > > at things one at a time.
> > > 
> > > Generating and matching full pathnames on each access takes time, no question 
> > > about that. (In fact we are not checking on each access but only when 
> > > pathnames are involved, such as on open. Filehandle based operations do not 
> > > require access checks, but that's not a very important difference at this 
> > > level of discussion.) That's a quantitative statement though, not a 
> > > qualitative one: retrieving xattrs and checking labels also takes time; 
> > > additional checks are never for free. We find that doing the pathname checks 
> > > is easily fast enough. You may disagree, but then you don't have to use 
> > > AppArmor, and we are not standing in your way.
> > > 
> > > As far as new files are concerned, basing decisions on the parent dentry and 
> > > component name requires that you know where in the filesystem hierarchy this 
> > > dentry is located: with bind mounts, the same dentry shows up in multiple 
> > > locations in a process's namespace, corresponding to different pathnames. In 
> > > other words, to make the right decision, the dentry alone is not enough; it 
> > > takes a <dentry, vfsmount> pair. So there we are again.
> > > 
> > > >From the point on where you have a <dentry, vfsmount> pair of objects, you can 
> > > do two things: you can compute the full pathname and base your decision on 
> > > that, or you can do some caching to hopefully cut some of that work short 
> > > frequently enough to set off the additional cost. The difference between the 
> > > two approaches is quantitative -- if there is a difference in results, then 
> > > that's obviously a bug. I believe that caching could speed up things 
> > > measurably, but up to this point, neither I nor anybody else had the time to 
> > > look into it, and so we are not doing it -- not yet, any perhaps never at 
> > > all. It may be counter to your intuition, but doing those checks is not a big 
> > > issue.
> > 
> > My approach in DTE, which used pathnames to assign TE labels in the
> > kernel, was to use a 'shadow tree' to the vfsmnt+dentry tree, filled out
> > at policy load time to the depth of the deepest policy rule.  For the
> > behavior I was after, bind mounts were handled by storing pointers from
> > the new mount to the original, but the behavior AA wants would be
> > different.  Namespace clones are easily handled this way by copying the
> > cached pointers to the shadow tree.  And it was pretty fast.
> > 
> > When I talked about this with Tony last year, the biggest shortcoming to
> > use this for AA was the wildcards.  For instance, if there is a rule for
> > /var/log/HOSTS/*/messages, then when /var/log/HOSTS/sergelap/ is
> > created, a new rule would have to be created on the fly to tag
> > /var/log/HOSTS/sergelap/messages if it is created.  How to represent
> > that when only /var/log or /var/log/HOSTS exists at policy load time
> > would be, well, a fun problem to solve actually  :)
> 
> If we added support for named type transitions to SELinux, as proposed
> earlier by Kyle Moffett during this discussion, wouldn't that address
> that issue without needing a DTE-like approach?  The concept is to add

Haven't read his message, but based on what you laid out here sure, that
sounds good.  It still, like my dte approach, might have some trouble
with the wildcard/regex rules AA allows.  And while it might perfectly
reproduce my original DTE behavior, I don't think it does what AA wants
on bind mounts.  (Whether what AA wants for bind mounts makes sense I'm
still not convinced, especially with user mounts coming soon (or already
here?), but I'm staying out of that discussion for now)

> the last component name as a further input to the labeling decision for
> new files, in addition to the existing use of the creating process'
> label, the parent directory label, and the kind of file.  Then, you
> could have something like:
> type_transition <domain> var_log_hosts_t:file "messages" messages_t;
> 
> The last component name is already available, so that doesn't require
> any changes to LSM, and it would be a straightforward extension of
> SELinux to support the above - it doesn't change the model at all, just
> adds a further input to the new file labeling logic.

And eliminates the need for restorecond?

thanks,
-serge
