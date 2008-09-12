Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbYILWIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbYILWIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYILWIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:08:12 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42030 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809AbYILWIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:08:11 -0400
Date: Fri, 12 Sep 2008 17:08:02 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: unprivileged mounts git tree
Message-ID: <20080912220802.GA23230@us.ibm.com>
References: <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu> <20080904132804.GA14709@us.ibm.com> <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu> <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu> <20080905153134.GA18367@us.ibm.com> <E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu> <m11vzrge86.fsf@frodo.ebiederm.org> <E1KdnOb-00068L-Eq@pomaz-ex.szeredi.hu> <20080911152033.GA29318@us.ibm.com> <m13ak6ecoi.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13ak6ecoi.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > Quoting Miklos Szeredi (miklos@szeredi.hu):
> >> On Thu, 11 Sep 2008, ebiederm@xmission.com (Eric W. Biederman)
> >> > There is a weird corner case I'm trying to wrap my head around.
> >> > unlink and rmdir do not work on dentries that are mount points
> >> > in another mount namespace.
> >> > 
> >> > Which is at least needed for the moment so we don't leak mounts.
> >> > 
> >> > Once we have unprivileged mounts does that introduce a DOS attack?
> >> 
> >> Hmm, yes.  That's a tough one...
> >> 
> >> I think if the dentry has only user mounts, unlink should go ahead and
> >> on success dissolve any mounts on the dentry.  Does that sound
> >> workable?
> >> 
> >> Thanks,
> >> Miklos
> >
> > Is it really a problem?  The admin can always go ahead and kill the
> > user, which already takes care of any mounts in private namespaces,
> > which I think is Eric's primary concern.  IT also takes care of that
> > user's processes pinning files under the mounts.  So now the admin can
> > umount all the user's mounts in the init namespace (using a script
> > parsing /proc/self/mountinfo if need be), and delete the files.
> >
> > Doesn't really seem like a problem.
> >
> > Or am I missing Eric's real concern?
> 
> Assume /user is the base unprivileged mount point.
> 
> echo dummy > /tmp/1234
> mount --bind /etc /user/etc
> mount --bind /tmp/1234 /user/etc/passwd

Ok, but this is all done as root.  Kind of a silly thing for root to
do :)

So in order for me as an unprivileged user to pin a dentry by mounting
over it, I have to have write permission to the dentry to begin with
as well as the dentry being under a user=hallyn mount.

> Now you can't create /etc/passwd.new and rename it to /etc/passwd.
> Stopping adduser from working.
> 
> As Miklos said this can apply to any file or any directory, so it can
> be a DOS against any other user on the system.

Except I need to own the mount as well as the dentry.  So after
root does

	mmount --bind -o user=hallyn /home/hallyn /home/hallyn
	mmount --bind -o user=hallyn /home/serge /home/serge

if user serge (uid 501) tries to

	mmount --bind /etc /home/hallyn/etc
	mmount --bind /etc /home/serge/etc

permission for the first will be denied because serge does not
have write perms to /home/hallyn/etc, and permission for the second
will be denied because only hallyn may mount under /home/serge.

If root properly did

	mmount --bind -o user=hallyn /home/hallyn /home/hallyn
	mmount --bind -o user=serge /home/serge /home/serge

and then hallyn does

	mmount --bind /etc /home/hallyn/etc

and serge does

	mmount --bind /home/hallyn/etc /home/serge/etc

then hallyn can still ummount /home/hallyn/etc.

And we've decided that users cannot (for now) do shared mounts.
So I'm still not sure where there is the potential for danger?

> It is also contrary to classic unix and linux semantics as open files
> don't otherwise prevent unlink, rename or, rmdir from happening. So
> applications are not going to be ready for it.
> 
> At a practical level I recently replace chroot with mount namespaces
> to simplify handling of mounts and ouch!  When a process goes crazy
> and doesn't exit when you expect and then you try and delete the
> directory it is a pain.
> 
> Eric
