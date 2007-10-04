Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbXJDAmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbXJDAmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 20:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbXJDAmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 20:42:32 -0400
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:37173 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752001AbXJDAmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 20:42:31 -0400
X-YMail-OSG: R_Xkfc8VM1nr.OAzW.Qix9JTvwEuFubAhG9fUoPnummzmWfrEFfqUgAcYRMWVtUB_b.HANcf_A--
X-RocketYMMF: rancidfat
Date: Wed, 3 Oct 2007 17:42:30 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory Access Control Kernel
To: Al Viro <viro@ftp.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, paul.moore@hp.com
In-Reply-To: <20071003225036.GN8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <49869.10776.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Al Viro <viro@ftp.linux.org.uk> wrote:

> On Wed, Oct 03, 2007 at 03:23:15PM -0700, Casey Schaufler wrote:
> > 1. Create /moldy at "_"
> > 2. For each label you care about
> >    2a. Create /moldy/<label>
> >    2b. Set the label of /moldy/<label> to <label>
> > 3. ln -s /smack/tmp /tmp
> 
> > 1. Create /moldy at "_"
> > 2. For each label you care about
> >    2a. Create /moldy/<label>
> >    2b. Set the label of /moldy/<label> to <label>
> > 3. ln -s /smack/tmp.link /tmp
>   4. mount --bind /moldy /smack/tmp
> or add
> /moldy /smack/tmp none bind,rw 0 2
> to /etc/fstab (same effect as (4))
> 
> Compare with your variant; the difference is in one argument of ln(1) and
> one additional line in rc script or /etc/fstab.  Sorry, but I don't buy
> the "extra setup complexity" argument at all.

What I'm confused about is how that results in a process labeled "foo"
getting a different /tmp from a process labeled "bar".

I guess I'll have to review your first post.

> > It's the content of a symlink, and that can be just about anything
> > and is not required to point to anything, which is one reason why
> > I made that choice. If you don't have a /tmp, or can't write to the
> > /tmp that exists, or have a /tmp that's a dangling symlink under
> > any circumstances you may have an issue. That's true regardless of
> > the presence or absense of /smack. All of the traditional mechanisms
> > for dealing with /tmp in a chrooted or namespaced environment remain.
> 
> It's not about symlink pointing to /smack/<something>; it's about the place
> where /smack/<something> itself points to.  And _that_ can bloody well be
> different in different chroots.

Which is completely OK with me.

> Look, if you allow to change where it goes, you certainly allow different
> prefices on different boxen; moreover, admin can change it freely according
> to his layout on given box.  OTOH, you _can't_ have it different in different
> chroots and changing it in one will affect all of them.  See why that's a
> problem?

Yes, I can see that could be an unexpected behavior.

> > It's in a symlink on the filesystem, and it doesn't have to be an
> > absolute pathname, although since it's a symlink and the semantics
> > for a symlink allow that be be absolute, relative, or dangling I
> > don't see any reason to restrict it from being absolute.
> 
> Fixed-contents symlink (with or without variable tail - it's irrelevant
> here) is a bloody wrong tool for that kind of fs for the reasons described
> above.

I do not understand where the concept of Fixed-contents symlink
comes from. Yes, "tmp" is initialized to "/moldy/", but that can
be changed by writing to /smack/links. Please help me understand
the what you mean by fixed-contents symlinks. 

> And if you go for "prefix should point to location on the same fs"
> you can trivially configure the rest in userland (one line describing a
> binding), leaving the kernel-side stuff with something like "userland
> can ask for a pair of symlink and directory, having symlink resolve
> to directory + <label>" instead of your "userland can ask for a symlink
> resolving to <prefix> + <label>".  And _that_ is chroot-neutral - you don't
> need to do any extra work...
>  
> > Could allowing multiple distinct mounts and symlink assignments
> > of /smackfs address those issues?
> 
> ... like that one.  Leave it to normal userland mechanisms; it's a matter
> of a single line in whatever script you are using to set chroot up and it
> involves _way_ fewer caveats.
> 
> That said, Alan's point still stands - if you don't get processes changing
> context back and forth, you don't need anything at all - we already have
> all we need for that kind of setups (and no, selinux is not involved ;-).


Casey Schaufler
casey@schaufler-ca.com
