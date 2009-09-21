Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbZIUVji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbZIUVji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 17:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZIUVji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 17:39:38 -0400
Received: from mail2.shareable.org ([80.68.89.115]:50814 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZIUVjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 17:39:37 -0400
Date: Mon, 21 Sep 2009 22:39:34 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Ulrich Drepper <drepper@redhat.com>, James Youngman <jay@gnu.org>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org
Subject: fchdir, EACCESS and when to check (was: [PATCH] VFS: document what MAY_ACCESS means)
Message-ID: <20090921213934.GD14700@shareable.org>
References: <20090921012933.2631.85495.stgit@paris.rdu.redhat.com> <20090921081047.GA20006@shareable.org> <1253536193.17222.21.camel@heimdal.trondhjem.org> <20090921185336.GA5633@shareable.org> <1253564285.17222.120.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253564285.17222.120.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> > I suspect having fchdir() fail in this admittedly obscure case is more
> > likely to cause problems than the RPC permission check, due to
> > surprise and no obvious error recovery strategy in an application
> > where fchdir is used in some subroutine to temporarily switch
> > directory and then return to the caller, which doesn't expect the
> > current directory might be changed by the call.  I suspect when that
> > happens, most applications will either terminate abruptly or behave
> > wrongly later.  It's just a guess though....
> 
> Oh, I see what you're getting at.
> 
> So, looking at the code for fchdir(), it would appear that the
> permission check there is being made by the VFS, not NFS. I suspect that
> is because it is mandated by POSIX.
> Indeed, looking at the spec for fchdir(), it would appear that you _do_
> need valid permissions. See
> 
>    http://www.opengroup.org/onlinepubs/009695399/functions/fchdir.html
> 
> which states that the function returns EACCES if the process doesn't
> have search permissions.

Sadly I think you're right.  The check is performed locally, too.
It's not an NFS quirk (unlike, say, read permissions), and local
concurrency can trip it up.

Well well well.

http://www.mail-archive.com/bug-gnulib@gnu.org/msg12513.html

    "using only fchdir does have the advantage that we know that
    restoring the current directory can't fail.  (It can fail IIRC on
    SunOS, but I think we don't support the affected versions any
    more)."

That doesn't look convincing any more.

[Have added James Youngman who wrote that, to Cc]

Let's look around:

http://www.opengroup.org/onlinepubs/9699919799/functions/openat.html

    "the file to be opened is determined relative to the directory
    associated with the file descriptor fd instead of the current
    working directory. If the file descriptor was opened without
    O_SEARCH, the function shall check whether directory searches are
    permitted using the current permissions of the directory
    underlying the file descriptor. If the file descriptor was opened
    with O_SEARCH, the function shall not perform the check."

Also,
http://www.opengroup.org/austin/docs/austin_383.txt

That's not about fchdir(), but it's a general property of directories
opened with O_SEARCH when used with *at() functions.

fchdir() doesn't apply the "shall not perform the check" rule.  It's
only used for *at() lookups.  Given the existence of any rule which
allows search permission to be checked at open() time and not checked
later, it looks like it might be quite useful for fchdir() to have the
same property, so you'd know you can always return to a directory if you
successfully opened it before.

I've added Ulrich Drepper to the Cc list in case he cares to say
something about fchdir(), since he seems to have introduced O_SEARCH
to SUS.

Ulrich, do you think fchdir should fail even if you successfully
opened a directory with O_SEARCH (if that is eventually implemented in
Linux ;-), when the permissions have been changed after the descriptor
is opened, even though all the *at() functions can successfully search
using the descriptor?

-- Jamie
