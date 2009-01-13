Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbZAMNgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbZAMNgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757240AbZAMNf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:35:58 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:58554 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227AbZAMNf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:35:58 -0500
Date: Tue, 13 Jan 2009 16:35:55 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Rientjes <rientjes@google.com>, Bill Davidsen <davidsen@tmr.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113133555.GA28107@ioremap.net>
References: <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <20090113131937.GB17664@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113131937.GB17664@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 08:19:37AM -0500, Theodore Tso (tytso@mit.edu) wrote:
> Instead of trying to specify which process should be protected from
> the OOM killer by name, how about something which is inherited from
> the parent process?  After all, if having the child not get killed due
> to OOM is important, the child won't even have a chance to run if the
> parent gets killed off.  And in fact, we have something that fits that
> bill fairly well; getrlimit()/setrlimit().  Why not define a new
> resource limit which specifies a relative immunity to the oom_killer?
> 
> Most of the infrastructure to support that will already be in place
> (i.e., shell support, PAM support in /etc/securitylimits.conf); all
> that would need to be done is to teach a few userspace
> programs/libraries about the new resource limit.
> 
> This would be a much cleaner approach, I would think.

It will be similar to oom_adj parameter (although I did not find where
it is inherited from the parent), but with the different updating
interface. I do not think it will be anyhow easier to solve the problem,
since it is not directly in the parent/child hierarchy, since there are
cases when we do want to kill children (this phrase just screams for the
addition: and eat them), but only some processes which are not really
the most significant.

Existing oom score adjustment mechanism works for this cases, but it is
by itself is not convenient to be used. Even its documentation does not
say how it is used :) It is not just simple add/remove, but score
multiplication or division by the two in the power of the oom_adj value.
Plus really no one knows how scores are calculated except those who read
the mm/kill.c before going to sleep.

So effectively oom_adj only works as enable/disable switch, and since no
one knows how to tune it, it is better to do not touch at all. And get
ssh killed. I believe if it is ever used then only to disable oom at
all, which is wrong, since task still may be killed but after some
others. My patch adds a simple priority for that based on the name of
the process, which are known to the administrators who maintain given
system.

-- 
	Evgeniy Polyakov
