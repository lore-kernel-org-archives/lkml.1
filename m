Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZKXAew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZKXAew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZKXAev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:34:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbZKXAeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:34:50 -0500
Date: Mon, 23 Nov 2009 19:34:26 -0500
From: Jeff Layton <jlayton@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
 and file bind mounts (try #5)
Message-ID: <20091123193426.55f1530a@tlielax.poochiereds.net>
In-Reply-To: <m1ljhwbyr3.fsf@fess.ebiederm.org>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
	<m1my2cdhi3.fsf@fess.ebiederm.org>
	<20091123173616.75c3f600@tlielax.poochiereds.net>
	<20091123224948.GB5598@shareable.org>
	<20091123181545.05ad004d@tlielax.poochiereds.net>
	<m1ljhwbyr3.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 15:35:44 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Jeff Layton <jlayton@redhat.com> writes:
> 
> > On Mon, 23 Nov 2009 22:49:48 +0000
> > Jamie Lokier <jamie@shareable.org> wrote:
> >
> >> Jeff Layton wrote:
> >> > > check_path_accessible seems pretty horrible.   If a process is running
> >> > > inside of a subdirectory it doesn't have permissions to access, say
> >> > > a chroot, /proc/self/fd/XXX becomes completely unusable.
> >> > > 
> >> > 
> >> > Hmm...I have this in there:
> >> > 
> >> > +		/* are we at global root or root of namespace? */
> >> > +		if ((tdentry == root.dentry && vfsmnt == root.mnt) ||
> >> > +		    vfsmnt->mnt_parent == vfsmnt)
> >> > +			break;
> >> > 
> >> > ...In the case of a chroot, wouldn't "current->fs->root" point to the
> >> > root of the process' namespace? Or am I misunderstanding what
> >> > current->fs actually represents?
> >> 
> >> A process can run inside a subdirectory it doesn't have permissions to
> >> access without that being a chroot.
> >> 
> >
> > Certainly.
> >
> >> It can also run inside a subdirectory that isn't accessible from it's
> >> root, if that's how it was started - as well as having other
> >> descriptors pointing to things outside its root.
> >> 
> >
> > Yes.
> >
> >> It can also be passed file descriptors from outside it's root while
> >> it's running.
> >> 
> >
> > Yep.
> >
> >> Really, I think the /proc/PID/fd/N check should restrict the open to
> >> the O_* limitations that were used to open fd N before, and not have
> >> any connection to actual paths at the time of this check.
> >> 
> >
> > The big question with all of this is: Should a task have the ability
> > to follow a /proc/pid symlink to a path that it wouldn't ordinarily be
> > able to resolve with a path lookup. The concensus that I got from the
> > bugtraq discussion was that it should not, and this patch is an attempt
> > to prevent that.
> >
> > I take it from you and Eric's comments that you disagree? If so, what's
> > your rationale for allowing a task to resolve this symlink when it
> > wouldn't ordinarily be able to do so if it were a "normal" symlink?
> 
> For myself I start with the simple fact that the code has worked the
> way it currently does since around linux 0.99.  We have to be very
> careful if we change this to avoid breaking existing applications.
> 
> So if we change the existing behaviour it must be done in such a way
> that legitimate applications do not break.
> 

I certainly don't want to break existing apps. That said, applications
that are depending on /proc/pid symlinks to allow them to bypass
directory permissions or access files that aren't in their namespace
would seem to be unsafe, no?

I think all we can reasonably do is try to clearly lay out how these
symlinks are intended to work. I think it's logical that the result of
following these links should be more or less the same as if you were to
resolve the results of the readlink.

Is there some reason that we should expect them to provide anything
more? Do you have apps in mind that you think will break with this
change? If you think this is unreasonable, perhaps you could suggest an
alternative?

If this approach is reasonable, there is one thing I think that I'm
pretty sure will need to be fixed. It'll need to detect when the file
lies outside of its namespace altogether. I'm not quite sure how to
do that yet. I've not done much work with multiple namespaces, so I
could certainly use some guidance here.

-- 
Jeff Layton <jlayton@redhat.com>
