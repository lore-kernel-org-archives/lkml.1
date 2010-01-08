Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893Ab0AHQ2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0AHQ2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 11:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699Ab0AHQ2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 11:28:01 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:51245 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0AHQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 11:28:01 -0500
Date: Fri, 8 Jan 2010 17:27:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sections mismatch detection
Message-ID: <20100108162759.GA16334@merkur.ravnborg.org>
References: <1262772683.4263.147.camel@localhost> <20100106104823.GA30439@merkur.ravnborg.org> <4B44762C.1090605@suse.cz> <20100107150339.b66fadc5.rdunlap@xenotime.net> <20100108054144.GA15827@merkur.ravnborg.org> <4B4730C0.6000601@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4730C0.6000601@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 02:18:56PM +0100, Michal Marek wrote:
> Sam Ravnborg napsal(a):
> >> I would prefer to see (logically) the same section mismatch not be
> >> reported multiple times, even though they are in different binary
> >> files.  This would reduce the noise level quite a bit IMO.
> > 
> > That would be nice but is not trivially doable.
> > We need to discover when there is a section mismatch
> > resulting from for example a function in kernel/*
> > calling a function in arch/$ARCH/kernel so we
> > need to execute the check on multiple levels
> > i order to catch the bugs as early as possible.
> > 
> > The easy 'fix' would be to execute the check only
> > on vmlinux.o (default behaviour) but the added
> > checks with the option enabled allows us to
> > be much more precise in reporting where
> > the section mismatch originate from.
> 
> But we could remember the (caller,callee) pairs and only emit the first
> warning. Or am I missing something?

The warnings comes from individual calls to mdpost.
When we enable CONFIG_DEBUG_SECTION.. then we will
use modpost to analyse for section mismatches each time we link.

This allows us to emit warnings when we have much better chance
to tell in what .o file we saw the mismatch.
But the downside as Randy also highlight is that the same warning
will be displayed several times as we see it for each linking step.

The nomal way to do section mismatch checks is to only do it
on vmlinux.o and thus we get only one warning per mismatch but 
we are much less precise in where it comes from.


Now we could save (caller, callee) from each warning and read
in these and then only emit new warnings.
But it suddenly became non-trivial to do.

And we really want to do the check on several levels.
Think of for example ext4.
Within fs/ext4/ there may be no problems.
But when linkend with the rest of the fs/ subsystem
we may see issues, which is why we need to do the checks on
both level (when we have the config flag enabled).

	Sam
