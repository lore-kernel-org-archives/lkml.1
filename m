Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYINB5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYINB5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 21:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYINB5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 21:57:33 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54791 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbYINB5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 21:57:31 -0400
Date: Sat, 13 Sep 2008 20:56:46 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: unprivileged mounts git tree
Message-ID: <20080914015646.GC18604@us.ibm.com>
References: <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu> <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu> <20080905153134.GA18367@us.ibm.com> <E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu> <m11vzrge86.fsf@frodo.ebiederm.org> <E1KdnOb-00068L-Eq@pomaz-ex.szeredi.hu> <20080911152033.GA29318@us.ibm.com> <m13ak6ecoi.fsf@frodo.ebiederm.org> <20080912220802.GA23230@us.ibm.com> <m1tzck68od.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tzck68od.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> 
> > Ok, but this is all done as root.  Kind of a silly thing for root to
> > do :)
> 
> There are less silly examples like setting up a chroot type
> environment contained in a mount namespace and having a kernel oops
> and then not being able to delete all of your files.

I wasn't saying that I believe I can win an argument by knocking down
one example :)

In fact I'm not trying to win an argument.  Because I'm quite sure you
and Miklos are right, and I just need to figure out what I'm missing.

> > So in order for me as an unprivileged user to pin a dentry by mounting
> > over it, I have to have write permission to the dentry to begin with
> > as well as the dentry being under a user=hallyn mount.
> 
> That second condition is interesting requiring write permission of the
> dentry.  I thought we had obviated the need for that when we added
> ownership to the mounts themselves.  In this case at least it shouldn't
> it be write permission on the directory containing the dentry.

Oh no, it seems I'm wrong, that's not a condition.  Just tested it.

> >> Now you can't create /etc/passwd.new and rename it to /etc/passwd.
> >> Stopping adduser from working.
> >> 
> >> As Miklos said this can apply to any file or any directory, so it can
> >> be a DOS against any other user on the system.
> >
> > Except I need to own the mount as well as the dentry.  So after
> > root does
> >
> > 	mmount --bind -o user=hallyn /home/hallyn /home/hallyn
> > 	mmount --bind -o user=hallyn /home/serge /home/serge
> >
> > if user serge (uid 501) tries to
> >
> > 	mmount --bind /etc /home/hallyn/etc
> > 	mmount --bind /etc /home/serge/etc
> >
> > permission for the first will be denied because serge does not
> > have write perms to /home/hallyn/etc, and permission for the second
> > will be denied because only hallyn may mount under /home/serge.
> >
> > If root properly did
> >
> > 	mmount --bind -o user=hallyn /home/hallyn /home/hallyn
> > 	mmount --bind -o user=serge /home/serge /home/serge
> >
> > and then hallyn does
> >
> > 	mmount --bind /etc /home/hallyn/etc
> >
> > and serge does
> >
> > 	mmount --bind /home/hallyn/etc /home/serge/etc
> >
> > then hallyn can still ummount /home/hallyn/etc.
> >
> > And we've decided that users cannot (for now) do shared mounts.
> > So I'm still not sure where there is the potential for danger?
> 
> Ok.  Let's pick on something a little more interesting.
> 
> root does:
> 	mmount --bind -o user=hallyn /home/hallyn /home/hallyn
> hallyn does:
> 	mount --bind /tmp /home/hallyn/tmp
>         touch dummy
> 	mount --bind dummy /home/hallyn/tmp/some_shared_file_I_have_write_access_to.
> 
> Which allows me to transform write permissions into the ability to
> deny someone else the ability to delete a file.

Yup, that's an interesting example.

Still an admin *can* work around that, if he can sufficiently parse
/proc/self/mountinfo to know to umount
/home/hallyn/tmp/some_shared_file_I_have_write_access_to.

Is that sufficient?  Probably not?

> This seems to mess up things like revoke.

Hey, do we have revoke now?  :)

> At a practical level it is a real annoyance, regardless of the security
> implications.
> 
> As a point of comparison plan9 does not have that restriction.

Why doesn't it have that restriction?  Does it always allow you to rm a
mounted-over file?

-serge
