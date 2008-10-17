Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbYJQR1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbYJQR1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbYJQR1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:27:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56149 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbYJQR1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:27:22 -0400
Date: Fri, 17 Oct 2008 13:27:14 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Steve French" <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
Subject: Re: [linux-cifs-client] Re: unlink behavior when file is open by
 other process
Message-ID: <20081017132714.111e33f9@tleilax.poochiereds.net>
In-Reply-To: <524f69650810170824x4f9ff975qb03d687c8d3557ff@mail.gmail.com>
References: <524f69650810170809u2df1a309o2f357dc8489c06c6@mail.gmail.com>
	<524f69650810170824x4f9ff975qb03d687c8d3557ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 10:24:29 -0500
"Steve French" <smfrench@gmail.com> wrote:

> On Fri, Oct 17, 2008 at 10:09 AM, Steve French <smfrench@gmail.com> wrote:
> > Even when a file is open by another process, posix allows the file to
> > be deleted (the file is removed from the namespace and eventually the
> > data is removed from disk).   Unfortunately due to problems in some
> > NAS filers/servers this can be hard to implement, and I am not sure
> > what the "best" behavior is in that case.    Currently when unlink
> > fails with the cifs network status codes equivalent to ETXTBUSY, cifs
> > retries unlink by first renaming the file (ala nfs's "silly rename")
> > by file handle and then marking the file attribute as "delete on
> > close" (which will cause the server to unlink the file when the last
> > opener closes the file).   This is similar to the behavior required by
> > posix (although, like in nfs, the silly renamed file is temporarily
> > visible in the namespace, can't be reopened by anyone else).
> >
> > Jeff Layton included a behavior change within a patch to fix another
> > problem with NTCreateX flags
> > (http://git.samba.org/?p=jlayton/cifs.git;a=commitdiff;h=f0c39587b7111deb13e56e5a521c5f3d8278cf5e)
> > that I just merged that will break this (delete of open files) to at
> > least one popular filer because that filer does not support rename by
> > handle (rename of open file is one of the SMB transact2 levels, and
> > one that most servers support).   His patch would give up in
> > cifs_unlink if we can't "silly-rename" the file.   I have mixed
> > feelings about this since with current code we can delete the file
> > (mark the file delete on close) but we can't rename it (we could hide
> > it in the namespace but it obviously can't be completely transparent
> > because you can't create a file of the same name).
> >
> > Is it better to fail unlink if the file can't be removed from the
> > namespace immediately or better to allow unlink (but then some
> > applications will get an access denied on open if they try to create a
> > file of the same name before the original opener closes the file)?
> 
> The two particular examples:
> 1) An application that does:
>              open, unlink, close, create
> used to always work but now would fail unless the server/filer has
> rename-by-handle support
> 
> 2) An application that does:
>             open, unlink, create
> used to fail (with access denied on create) when the server did not have
> rename-by-handle support but now (with Jeff's patch sideeffect) will
> fail on unlink.
> 
> 

My argument is that the primary function of unlink() is to remove a
filename from the filesystem. If we return success from such a call
without actually having freed up that filename, then that's a bug. It's
unfortunate that some servers don't support the calls we need to make
this work all the time.

We can't however make assumptions about what applications want. We
could, in principle, fix up the situation where a server does
open->unlink->create by truncating the old file and pretending that
it's a new one. An application may be unlinking the file for some other
reason -- what if it wants to create a directory there?

All we can reasonably do is try to have each syscall give us the
expected end result or an error if it can't be done.

Down any other path lies madness ;)

-- 
Jeff Layton <jlayton@redhat.com>
