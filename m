Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZAMWuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZAMWuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZAMWtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:49:51 -0500
Received: from THUNK.ORG ([69.25.196.29]:34028 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZAMWtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:49:49 -0500
Date: Tue, 13 Jan 2009 17:49:41 -0500
From: Theodore Tso <tytso@mit.edu>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Rientjes <rientjes@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113224941.GA14730@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Evgeniy Polyakov <zbr@ioremap.net>,
	David Rientjes <rientjes@google.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113214627.GC27227@ioremap.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 12:46:27AM +0300, Evgeniy Polyakov wrote:
> User does not work with the some magically calculated scores, he just
> starts the processes and knows only their names. User can specify pid,
> but in the case of short-living connections it is not possible. Changing
> parent oom score opens a huge possibility to kill it, while in case of
> some application server (or database) it should never be killed, and
> only some of its clients (which work for the users and not for the
> calculating backend for example) have to be killed.

The standard way this gets handled for resource limits is very simple:

1)  parent forks the child process
2)  in the child process we set up resource limits, adjust oom
3)  exec the child's program.

As Alan has already pointed out to you:

   (echo XXXX > /proc/self/oom_adj ; exec /usr/bin/program)

There are two problems; one is whether or not the OOM protection is
inherited or not, and how one sets OOM protection --- and I think you
will find a huge resistance to using names as a way of expressing
policy.

The second problem is that oom_adj scoring is a hueristic which is
hard for system administrators to understand --- and these are
separable problems.  Don't try to conflate them, and try using the
fact that a random score echo'ed into /proc/pid/oom_adj is hard to
tune as a justification for using process executable names.

If you want to argue that using containers is too hard, and there out
to be a simpler tuning parameter where (for the sake of argument) all
processes are given a number from 0 to 10, where 5 is the default, and
higher numbers will be picked unconditionally over lower numbers, and
the existing OOM score is used to distinguish between two process with
the same OOM protection, that's fine.

How we set that OOM protection class, whether it is via setrlimit() or
echoing into a magic /proc/pid/oom_protection file, and whether it
inherits across fork and exec calls, are a separate question.

	 	     	      	     	   - Ted
