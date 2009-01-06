Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbZAFSMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbZAFSMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZAFSM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:12:29 -0500
Received: from THUNK.ORG ([69.25.196.29]:44009 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbZAFSM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:12:28 -0500
Date: Tue, 6 Jan 2009 13:12:24 -0500
From: Theodore Tso <tytso@mit.edu>
To: David Miller <davem@davemloft.net>
Cc: jbeulich@novell.com, sam@ravnborg.org, linux-kernel@vger.kernel.org,
       ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090106181224.GC10903@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>, jbeulich@novell.com,
	sam@ravnborg.org, linux-kernel@vger.kernel.org,
	ccache@lists.samba.org
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <20090106.082619.170966508.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106.082619.170966508.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 08:26:19AM -0800, David Miller wrote:
> From: "Theodore Ts'o" <tytso@mit.edu>
> Date: Tue, 06 Jan 2009 10:15:26 -0500
> 
> I think the problem might be that the assembler source always
> "changes" because a different date or timestamp string is put in there
> by gcc every time the assembler source is built.

I'm not sure that's the problem, actually. Running "ccache -s" doesn't
show any additional cache misses *or* hits.  Instead the only
statistic which gets bumped is the "called for link" counter.  So I
suspect it's because ccache doesn't attempt to cache "gcc -S" or "gcc
-c foo.s" operations.  So it might be the case that a change to ccache
to cache compile-to-assemble and assemble-to-object code
transformation would help, but then we would still end up calling
ccache twice, and double the number of things that would be cached in
the ccache directories, not to mention doubling the number of calls to
remote hosts of distcc is involved.

So a full, long-term solution that gets back all of the efficiency
wins of ccache and distcc probably requires somehow passing a script
or program to ccache and distcc which does all of the steps which
kbuild needs to do to transform a kernel .c file to a kernel .o file,
which seems to involve interposing multiple steps between the foo.c to
foo.s and foo.s and foo.o steps, as well as post-processing on the
resulting .o file using objcopy.  If we can somehow get ccache to
cache all of that work, and distribute all of the steps of going from
foo.c to foo.o to other machines when distcc is involved, that would
be really cool.  I suspect this is not trivial to do, however....

   	  	   	   	       - Ted

