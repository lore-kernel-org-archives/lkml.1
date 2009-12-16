Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZLPMcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZLPMcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 07:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZLPMcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 07:32:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43854 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbZLPMcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 07:32:04 -0500
Date: Wed, 16 Dec 2009 12:31:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Layton <jlayton@redhat.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, miklos@szeredi.hu
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
	and file bind mounts (try #5)
Message-ID: <20091216123143.GA15784@ZenIV.linux.org.uk>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com> <m1my2cdhi3.fsf@fess.ebiederm.org> <20091123173616.75c3f600@tlielax.poochiereds.net> <20091123224948.GB5598@shareable.org> <20091123181545.05ad004d@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123181545.05ad004d@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 06:15:45PM -0500, Jeff Layton wrote:

> The big question with all of this is: Should a task have the ability
> to follow a /proc/pid symlink to a path that it wouldn't ordinarily be
> able to resolve with a path lookup. The concensus that I got from the
> bugtraq discussion was that it should not, and this patch is an attempt
> to prevent that.
> 
> I take it from you and Eric's comments that you disagree? If so, what's
> your rationale for allowing a task to resolve this symlink when it
> wouldn't ordinarily be able to do so if it were a "normal" symlink?

WTF not?  It's convenient and doesn't lose any real security.  If your
code relies on inaccessibility of <path> since some component of that
path is inaccessible, you are *already* fscked.  Consider e.g. fchdir()
and its implications - if you have an opened descriptor for parent,
having no exec permissions on grandparent won't stop you at all.  Already.
On all Unices, regardless of openat(), etc.

And that's aside of being able to see the same object at some other pathname.
Which is also possible in a lot of ways.  IOW, any code relying on that class
of assumptions is very likely to be widely b0rken, even if you leave aside the
long-standing behaviour of Linux.

I might buy the argument about restricting reopening with wider permissions,
but
	a) we still are looking at possible userland breakage of the worst
kind - random scripts passing /dev/fd/42 as command line arguments to
random programs.  Once in a while.  With error checking being... not quite
sufficient.
	b) it's not just open - we have at least chmod/chown/truncate to
deal with.

Prohibiting *all* access is a complete non-starter - things like
cmp foo /dev/stdin || ....
would bloody better work and nobody cares whether you have redirect
from something out of your reach at the moment.
