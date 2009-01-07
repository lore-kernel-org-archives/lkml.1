Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZAGEdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZAGEdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZAGEdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:33:35 -0500
Received: from thunk.org ([69.25.196.29]:52099 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbZAGEde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:33:34 -0500
Date: Tue, 6 Jan 2009 23:33:29 -0500
From: Theodore Tso <tytso@mit.edu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090107043329.GA13267@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Sam Ravnborg <sam@ravnborg.org>, Jan Beulich <jbeulich@novell.com>,
	linux-kernel@vger.kernel.org, ccache@lists.samba.org
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <20090106220950.GA23838@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106220950.GA23838@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 11:09:50PM +0100, Sam Ravnborg wrote:
> Hi Ted.
> 
> How about this simple patch.
> 
> It basically starts all over again with the C file if the
> file did not export any symbols (typical case).

I tried the patch.  It does cause ccache to be functional again, at
least as far as causing the "cache hit" stats to get bumped.  However,
the ccache "called for link" stats is still going up (which is I guess
how ccache misleadingly categorizes "cc -S" requests to compile to
assembly).  However, it doesn't actually save time; quite the reverse,
it makes things worse.  Doing a 32-bit compile, I tried compiling a
kernel where after each compile, I remove the ext4 object files via
"/bin/rm ../ext4-32/fs/ext4/*.o".  Without the patch, these were the
results after getting the cache warm, running the compile three tims,
and taking the average:

real 36.238 // user 44.143 // sys 11.375

Applying the patch, it actually took longer to recompile fs/ext4/*.o
and relink vmlinuz: (again average of three compiles)

real 38.401 // user 46.438 // sys 11.838

That's because ccache has to do the ccache -E and then calculate the
checksum to look up the results of the cache.  Before the patch, we
are doing this:

    preprocessor, compile, check for exported sysmbols, assemble

after the patch, we are doing this:

      preprocessor, compile, check for exported symbols, then (in
      ccache), preprocessor, locate the cached object file, write
      cached objectfile.

What this experiment shows is that even with a completely warm cache,
it's faster to run the assembler than to run ccache and have it re-run
the preprocessor and look up the cached object file.  In fact, it's
quite a bit faster.

So basically, in order to make things work well with ccache, we really
need to avoid redoing the compile unconditionally.  If the goal is
just to check to see if there were any exported symbols, we would be
better off doing a grep for EXPORT_SYMBOL.

In contrast, with 2.6.28, the numbers for just compiling fs/ext4/*.o
and relinking vmlinuz is.

real 28.836 // user 30.949 // sys 10.562

Note that the bulk of this time is doing the kbuild setup and
relinking vmlinuz.  The amount of time to do setup and relink is
18.677 / 21.639 / 8.253.  So if you subtract that out, and simply
compare the time to compile fs/ext4/*.o, what you get is:

2.6.28:     	    	     real 10.159 user  9.310 sys 2.309
2.6.28-git7:	      	     real 17.561 user 22.503 sys 3.122
2.6.28-git7 w/your patch     real 19.724 user 24.799 sys 3.585


Bottom line, I suspect if we want to make builds fast, we really need
to cache the full kbuild pipeline.  I hope you find these measurements
useful.

       	     	       	       	     	 - Ted

