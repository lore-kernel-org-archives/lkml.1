Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbXHaNMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbXHaNMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbXHaNM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:12:29 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:42471 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755664AbXHaNM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:12:28 -0400
Date: Fri, 31 Aug 2007 15:12:26 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jakob Oestergaard <jakob@unthought.net>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
Message-ID: <20070831131226.GA24084@janus>
References: <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188535485.6626.85.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org> <1188536658.6626.98.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org> <20070831074028.GR21979@unthought.net> <alpine.LFD.0.999.0708310055010.25853@woody.linux-foundation.org> <1188562298.6649.39.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188562298.6649.39.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 08:11:38AM -0400, Trond Myklebust wrote:
> On Fri, 2007-08-31 at 01:07 -0700, Linus Torvalds wrote:
> > 
> 
> > If you want new behaviour, you add a new flag saying you want new 
> > behaviour. You don't just start behaving differently from what you've 
> > always done before (and what *other* UNIXes do, for that matter).
> > 
> > Besides, even *if* it was a matter of somebody doing a mount with "rw", 
> > when the previous mount was "ro", returning EBUSY is still the wrong thing 
> > to do! If the user asks for a new mount that is read-write, he should just 
> > get it - ie we should not re-use the old client handles, and we should do 
> > what Solaris apparently does, namely to just make it a totally different 
> > mount.
> > 
> > In other words, it should (as I already mentioned once) have used 
> > "nosharecache" by default, which makes it all work.
> > 
> > Then, people who want to re-use the caches (which in turn may mean that 
> > everything needs to have the same flags), THOSE PEOPLE, who want the NEW 
> > SEMANTICS (errors and all) should then use a "sharecache" flag.
> 
> That would be a major change in existing semantics. The default has been
> "sharecache" ever since Al Viro introduced the "sget()" function some 6
> or 7 years ago. The problem was that we never advertised the fact that
> the kernel was overriding your mount options, and so sysadmins were
> (rightly IMO) complaining that they should _know_ when the client does
> this.
> 
> The list of known problems with a "nosharecache" default is nasty too:
>         
>         - file and directory attribute and data caching breaks.
>         Applications will see stale data in cases where they otherwise
>         would not expect it.
>         
>         - the existing dcache and icache issues when a file is renamed
>         or deleted on the server are now extended to also include the
>         case where the rename or deletion occurs on an alias in another
>         directory on the client itself. In particular, sillyrename will
>         break.
>         
>         - file locking breaks (the server knows that the client holds
>         locks on one file, whereas the client thinks it holds locks on
>         several).
>         
>         - the NFSv4 delegation model breaks: the client will be using
>         OPEN when it could use cached opens. More importantly, when
>         performing an operation that requires it to return the
>         delegation on the aliased file, it won't know until the server
>         sends it a callback.
> 
> ...and of course, the amount of unnecessary traffic to the server
> increases. I'm not aware of any sane way of dealing with those issues,
> and I doubt Solaris has a solution for them either.

All of this won't happen when server foo exports /bar and a client
mounts /bar/x and /bar/y separately: there must be a shared subtree or
hard-links between files within them, right?

An obvious (but disruptive) server side workaround is to export the
subtrees with different fsid= but that would give the same list of
problems as above, right?

IMHO I'd only consider returning EBUSY when trying to mount _exactly_
the same directory with different flags, not for arbitrary subtrees. The
client should preferably not be bothered with server side disk
partitioning (at least not beyond the obvious such as df output).

-- 
Frank
