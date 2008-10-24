Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYJXPS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYJXPS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYJXPSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:18:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153AbYJXPSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:18:47 -0400
Date: Fri, 24 Oct 2008 08:17:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alistair John Strachan <alistair@devzero.co.uk>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc1
In-Reply-To: <200810241352.45745.alistair@devzero.co.uk>
Message-ID: <alpine.LFD.2.00.0810240801540.3287@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <200810241224.38541.alistair@devzero.co.uk> <200810241345.04966.rjw@sisk.pl> <200810241352.45745.alistair@devzero.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Oct 2008, Alistair John Strachan wrote:
> 
> git reset --hard v2.6.27 ; git clean -d -f
> git status ("Nothing to commit")

The problem is ignored files.

Yes, git claims everything is clean, but that's because it has been told 
to ignore certain files, and because it has been told to ignore them, it 
will not remove them (without the -x flag) in "git clean", nor will it 
mention them in "git status".

And yes, one of the ignored file patterns is

	include/asm-*/asm-offsets.h

which means that your "git clean -df" didn't *really* clean everything 
from the old include/asm-x86, and because it didn't clean it all it also 
wouldn't be able to remove the old stale directory - since it wasn't 
empty.

You can use "git clean -dfx" to force git to remove ignored files too. And 
"make distclean" should have done it too.

Now, _another_ part (and arguably the really core reason) of this problem 
is that our Makefile rules for the asm include directory is weak and 
unreliable in the presense of already-existing unexpected entries.

And it has caused problems before. For example, if you somehow made the 
symlink not be a symlink at all (by using "cp -LR" for example), or a 
symlink pointing to another architecture (changing architecture builds in 
the same tree without doing a "make clean" in between), you historically 
got really odd results.

In fact, it's broken in subtle way before to the point where we now have a 
special "check-symlink" target internally that checks that the symlink is 
correctly set up.

Of course, it didn't check that you had some old stuff in include/asm-x86, 
it only checks for the _traditional_ problems we've had. Not some new odd 
one.

		Linus
