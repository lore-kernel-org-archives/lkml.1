Return-Path: <linux-kernel-owner+w=401wt.eu-S932797AbZKXL0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbZKXL0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932687AbZKXL0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:26:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932654AbZKXL0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:26:45 -0500
Date: Tue, 24 Nov 2009 06:26:21 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
 and file bind mounts (try #5)
Message-ID: <20091124062621.744beddb@tlielax.poochiereds.net>
In-Reply-To: <20091124012027.GA14645@shareable.org>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
	<m1my2cdhi3.fsf@fess.ebiederm.org>
	<20091123173616.75c3f600@tlielax.poochiereds.net>
	<20091123224948.GB5598@shareable.org>
	<20091123181545.05ad004d@tlielax.poochiereds.net>
	<m1ljhwbyr3.fsf@fess.ebiederm.org>
	<20091123193426.55f1530a@tlielax.poochiereds.net>
	<20091124012027.GA14645@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 01:20:27 +0000
Jamie Lokier <jamie@shareable.org> wrote:

> Jeff Layton wrote:
> > I certainly don't want to break existing apps. That said, applications
> > that are depending on /proc/pid symlinks to allow them to bypass
> > directory permissions or access files that aren't in their namespace
> > would seem to be unsafe, no?
> 
> I think we can mostly agree on that :-)
> 
> > I think all we can reasonably do is try to clearly lay out how these
> > symlinks are intended to work. I think it's logical that the result of
> > following these links should be more or less the same as if you were to
> > resolve the results of the readlink.
> > 
> > Is there some reason that we should expect them to provide anything
> > more? Do you have apps in mind that you think will break with this
> > change?
> 
> Anything which compiled with and uses the openat(), mkdirat()
> etc. emulation in gnulib (formerly known as libiberty), and anything
> using the same technique.
> 
> You know, GNU coreutils and other obscure things :-)
> 
> Of course there are real system calls for that, now, but there are
> still compiled programs that don't know about the real system calls.
> 
> The same technique (traversing /proc/self/fd/N) is used on Solaris, by
> the way.  It's probably worth keeping a modicum of compatibility with
> whatever Solaris does.
> 

Oof...ok. I didn't realize that these symlinks were relied on in such a
fashion. I guess that means that there is a need to have them continue
to have special semantics beyond what a symlink would ordinarily have.

> > If you think this is unreasonable, perhaps you could suggest an
> > alternative?
> 
> I have, two mails up - did you read it? - and in the previous threads
> which resulted in the bugtraq.
> 
> Please tell me why that approach does not work, thanks.
> 

I did read it, sorry I didn't comment on it before...

My immediate thought was that that approach only affects open calls. If
the containing directory weren't executable by the process it wouldn't
be able to (for instance) stat the file were these symlinks more
ordinary. Of course, the process could always do an fstat on the fd so
I don't suppose there's any harm in allowing it.

Since it's clear that these symlinks do need to have special semantics,
perhaps the approach you suggest would be the best thing. I'll have to
think about it a bit more.

> > If this approach is reasonable, there is one thing I think that I'm
> > pretty sure will need to be fixed.
> 
> It's not reasonable for /proc/self/fd/N because that has historically
> been a way to follow a directory (like openat) or dup() an open file
> without sharing the seek offset, which is useful for multithreaded
> code.
> 
> Same goes for /proc/self/exe: That has historically been a way to read
> your own executable, e.g. for self-extracting executables, executables
> with additional data glued on.  That breaks if the executable at the
> link target is not yourself.
> 
> But just to prove we've been over this before and never came to a
> consensus or conclusion:
> 
> http://lkml.org/lkml/2008/3/23/3
> 
> (the whole thread is worth a read, but Denys Vlasenko's remarks are
> especially relevant).
> 
> And for those who remember 2.0 :-)
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/9609.2/0371.html
> 

Thanks for the links. Those help clarify where you and Eric are coming
from. I'll need to rethink this.

Thank you (and Eric) for the comments so far.

Cheers,
-- 
Jeff Layton <jlayton@redhat.com>
