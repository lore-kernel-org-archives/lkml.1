Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993Ab0AJEmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0AJEmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 23:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144Ab0AJEmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 23:42:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51930 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0AJEml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 23:42:41 -0500
Date: Sun, 10 Jan 2010 04:42:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeff Layton <jlayton@redhat.com>, Jamie Lokier <jamie@shareable.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
	and file bind mounts (try #5)
Message-ID: <20100110044226.GA19799@ZenIV.linux.org.uk>
References: <m1my2cdhi3.fsf@fess.ebiederm.org> <20091123173616.75c3f600@tlielax.poochiereds.net> <20091123224948.GB5598@shareable.org> <20091123181545.05ad004d@tlielax.poochiereds.net> <20091216123143.GA15784@ZenIV.linux.org.uk> <20091220195903.GG23917@elf.ucw.cz> <20091220210404.GN18217@ZenIV.linux.org.uk> <20091220210619.GK23917@elf.ucw.cz> <20091220212340.GO18217@ZenIV.linux.org.uk> <20100101154027.GK3944@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100101154027.GK3944@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 01, 2010 at 04:40:27PM +0100, Pavel Machek wrote:
> > Access rights belong to file, not to a pathname (and there's no such thing
> > as _the_ pathname of a file).
> > 
> > I'd buy that as a minor QoI issue; as a security one - no way.
> 
> Ok, so you see it as a (QoI) problem, but not too major. Good; I hope
> it gets fixed one day.

Actually, I'm not even sure that it *is* worse than what we'd get after
such change.  Note that it's not just about trying to reopen a file
currently opened r/o for write; there's the opposite case.  We'd break
scripts that try to read /dev/stderr and expect to be called with stderr
redirected to caller-writable file.  With redirects done with 2> and not
2<>.  Sure, it's a lousy practice.  And scripts in question are not
well-written in general.  Downright unmaintainable, in fact.  Written
by sysadmin that had left the job five years ago and can't be located,
even if he could be bribed into touching That Shite(tm) ever again.

We have far lousier kinds of behaviour we can't fix for compatibility
reasons.  O_CREAT on dangling symlinks, for one.  We tried to switch to
sane variant (from the current "create file wherever that symlink points
to") and had to revert due to userland crap that actually relied on that
insanity.
