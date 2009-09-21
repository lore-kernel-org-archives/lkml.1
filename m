Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZIUSxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZIUSxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZIUSxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:53:43 -0400
Received: from mail2.shareable.org ([80.68.89.115]:41476 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbZIUSxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:53:43 -0400
Date: Mon, 21 Sep 2009 19:53:36 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org
Subject: Re: [PATCH] VFS: document what MAY_ACCESS means
Message-ID: <20090921185336.GA5633@shareable.org>
References: <20090921012933.2631.85495.stgit@paris.rdu.redhat.com> <20090921081047.GA20006@shareable.org> <1253536193.17222.21.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253536193.17222.21.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Mon, 2009-09-21 at 09:10 +0100, Jamie Lokier wrote
> > (Btw, side issue: I was very surprised to find fchdir() to an open
> > directory can fail on NFS due to change of permissions, so the pattern
> > dir = open("."); chdir("foo"); fchdir(dir) can fail to restore the
> > current directory).
> 
> Welcome to the world of stateless server-enforced security. Unlike the
> POSIX model, a NFS server doesn't have the ability to track what
> permissions have already been checked using a file descriptor. It
> therefore needs to check permissions on each RPC operation you perform
> using the credential you present then and there.

No, no, it's not that.

It's allowed to have the current directory be a directory you can't
access any more.  You find out you've lost permission, as you say,
later when you _do_ something with the directory.  In other words when
you do a lookup or readdir from the directory.

Putting it another way, this will _never_ error due to another process
messing with the permissions of the original directory after subdir is
opened:

    dir=open(".");
    dir2=open("/elsewhere");
    fstatat(dir2, "something_elsewhere");

But this can fail, leaving you in a different directory:

    dir=open(".");
    dir2=open("/elsewhere");
    fchdir(dir2);
    stat("something_elsewhere");
    fchdir(dir);

I find that surprising.  Imho, both codes are intended to have the
same behaviour.

Is there something in POSIX which says fchdir() must verify you still
have execute permission in the directory you are switching to at the
time you call fchdir()?

I suspect having fchdir() fail in this admittedly obscure case is more
likely to cause problems than the RPC permission check, due to
surprise and no obvious error recovery strategy in an application
where fchdir is used in some subroutine to temporarily switch
directory and then return to the caller, which doesn't expect the
current directory might be changed by the call.  I suspect when that
happens, most applications will either terminate abruptly or behave
wrongly later.  It's just a guess though....

-- Jamie
