Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZAMXCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZAMXCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZAMXCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:02:44 -0500
Received: from matrixpower.ru ([195.178.208.66]:59163 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZAMXCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:02:43 -0500
Date: Wed, 14 Jan 2009 02:02:40 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Theodore Tso <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113230240.GA30192@ioremap.net>
References: <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net> <20090113224941.GA14730@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113224941.GA14730@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 05:49:41PM -0500, Theodore Tso (tytso@mit.edu) wrote:
> > User does not work with the some magically calculated scores, he just
> > starts the processes and knows only their names. User can specify pid,
> > but in the case of short-living connections it is not possible. Changing
> > parent oom score opens a huge possibility to kill it, while in case of
> > some application server (or database) it should never be killed, and
> > only some of its clients (which work for the users and not for the
> > calculating backend for example) have to be killed.
> 
> The standard way this gets handled for resource limits is very simple:
> 
> 1)  parent forks the child process
> 2)  in the child process we set up resource limits, adjust oom
> 3)  exec the child's program.
> 
> As Alan has already pointed out to you:
> 
>    (echo XXXX > /proc/self/oom_adj ; exec /usr/bin/program)

Yes, I saw that in archive, but did not receive myself, so did not
answer. This works in the above simple case, but if we dig a little bit
into the case when there are children, parent has to live and not all
children should be considered equal by the oom-killer, things change
dramatially. And we can not change the sources. Well, in particaular my
case we can, but it is not about the single system :)

> There are two problems; one is whether or not the OOM protection is
> inherited or not, and how one sets OOM protection --- and I think you
> will find a huge resistance to using names as a way of expressing
> policy.

Yup, this whole thread shows this resistance quite good :)

> The second problem is that oom_adj scoring is a hueristic which is
> hard for system administrators to understand --- and these are
> separable problems.  Don't try to conflate them, and try using the
> fact that a random score echo'ed into /proc/pid/oom_adj is hard to
> tune as a justification for using process executable names.

I tried, and although I do agree on the fact that it can be used to turn
oom-killer on or off, but not for the tuning. But even this does not
really work in the case showed, when we can not change the application,
and having a main goal to save the parent and kill only some subset of
the short-living children. So we can not really adjust parent oom-score
and get the same in the children, since this will put parent and
important children at risk.

> If you want to argue that using containers is too hard, and there out
> to be a simpler tuning parameter where (for the sake of argument) all
> processes are given a number from 0 to 10, where 5 is the default, and
> higher numbers will be picked unconditionally over lower numbers, and
> the existing OOM score is used to distinguish between two process with
> the same OOM protection, that's fine.

> How we set that OOM protection class, whether it is via setrlimit() or
> echoing into a magic /proc/pid/oom_protection file, and whether it
> inherits across fork and exec calls, are a separate question.

Let's put containers out of the picture. While it may or may not work,
they are definitely not an issue in the given systems. Having simpler
tunables would be great, but we can not change them, since it is
already existing abi, documentation could be extended though, I can
cook up a patch tomorrow if no one else will do this.

-- 
	Evgeniy Polyakov
