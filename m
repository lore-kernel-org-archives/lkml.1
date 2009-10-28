Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZJ1TpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZJ1TpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 15:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZJ1TpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 15:45:02 -0400
Received: from mail2.shareable.org ([80.68.89.115]:59469 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbZJ1TpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 15:45:01 -0400
Date: Wed, 28 Oct 2009 19:44:51 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: symlinks with permissions
Message-ID: <20091028194451.GC17475@shareable.org>
References: <20091025062953.GC1391@ucw.cz> <20091026163157.GB7233@duck.suse.cz> <20091026165729.GF23564@us.ibm.com> <20091026173629.GB16861@fieldses.org> <20091026174631.GD7233@duck.suse.cz> <1256579869.8576.7.camel@heimdal.trondhjem.org> <20091025093604.GA1501@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org> <20091028081653.GA18290@elf.ucw.cz> <4AE87292.20802@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE87292.20802@schaufler-ca.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> Pavel Machek wrote:
> > The actual permissions of the file are not ignored, but permissions of
> > the containing directory _are_. If there's 666 file in 700 directory,
> > you can reopen it read-write, in violation of directory's 700
> > permissions.
> > 									Pavel
> 
> There is no security violation here. Consider the case where
> the file is unlinked after it is opened. What directory permissions
> would matter in that case?

That's an even worse security violation.

If you have a file opened read-only which is unlinked (and there's no
other file descriptors to it), it is impossible to modify the file
except through this quirk of /proc/NN/fd.  In traditional unix, it is
impossible to modify full stop.  Even root can't write to it.

Paths are in this discussion as an *example* of something that cannot
be done except through /proc/NN/fd.  Paths are not the issue.

As you've noticed, the same security hole occurs for files which have
been unlinked and don't have any path.

The real issue is gaining more access to an open file than you had before.

> Or what about the case where the file
> has a link count of 2, say /a/foo and /b/ish are hard links. If
> /a is 777 and /b is 700 what would your position be regarding
> the file descriptor obtained by opening /b/ish?

It depends on the flag passed to open() when the file descriptor is
obtained.  That's where the pseudo-symlink permission comes from,
which is what Pavel is getting it.

> The path name is an ethereal convenience and once traversed has no
> bearing on the security state of the object.

That's right.  The security state should depend _only_ on the
file open mode, that is O_RDONLY/WRONLY/RDWR/APPEND.

That is more or less what Pavel is saying too, because the
pseudo-symlink permission is calculated from the file open mode
(except for O_APPEND, which is why it shouldn't be done using the
pseudo-symlink permission).  Ignore the path aspect, it's just a distraction.

-- Jamie
