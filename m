Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbYAXXJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbYAXXJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYAXXJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:09:45 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:47145 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbYAXXJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:09:43 -0500
Date: Fri, 25 Jan 2008 01:08:09 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andreas Dilger <adilger@sun.com>,
       Valdis.Kletnieks@vt.edu, David Chinner <dgc@sgi.com>,
       Valerie Henson <val@vahconsulting.com>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@clusterfs.com>,
       Ric Wheeler <ric@emc.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Message-ID: <20080124230809.GA29120@does.not.exist>
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <9Mo9w-7Ws-23@gated-at.bofh.it> <9OdWm-7uN-25@gated-at.bofh.it> <9Oi9A-5EJ-3@gated-at.bofh.it> <9OiMg-6IC-1@gated-at.bofh.it> <9OlqL-2xG-3@gated-at.bofh.it> <9Orda-3ub-45@gated-at.bofh.it> <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 06:32:15PM +0100, Bodo Eggert wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> >> I'd tried to advocate SIGDANGER some years ago as well, but none of
> >> the kernel maintainers were interested.  It definitely makes sense
> >> to have some sort of mechanism like this.  At the time I first brought
> >> it up it was in conjunction with Netscape using too much cache on some
> >> system, but it would be just as useful for all kinds of other memory-
> >> hungry applications.
> > 
> > There is an early thread for a /proc file which you can add to your
> > poll() set and it will wake people when memory is low. Very elegant and
> > if async support is added it will also give you the signal variant for
> > free.
> 
> IMO you'll need a userspace daemon. The kernel does only know about the
> amount of memory available / recommended for a system (or container),
> while the user knows which program's cache is most precious today.
> 
> (Off cause the userspace daemon will in turn need the /proc file.)
> 
> I think a single, system-wide signal is the second-to worst solution: All
> applications (or the wrong one, if you select one) would free their caches
> and start to crawl, and either stay in this state or slowly increase their
> caches again until they get signaled again. And the signal would either
> come too early or too late. The userspace daemon could collect the weighted
> demand of memory from all applications and tell them how much to use.

I don't think that's something that would require finetuning on a
per-application basis - the kernel should tell all applications once to
reduce memory consumption and write a fat warning to the logs (which
will on well-maintained systems be mailed to the admin).

Your "and tell them how much to use" wouldn't work for most applications 
- e.g. I've worked the last weeks with a computer with 512 MB RAM and no 
Swap, which means usually only 200 MB of free RAM. I've gotten quite 
used to git aborting with "fatal: Out of memory, malloc failed" when 
200 MB weren't enough for git, and I don't think there is any reasonable 
way for git to reduce the memory usage while continuing to run.

In practice, there is a small number of programs that are both the
common memory hogs and should be able to reduce their memory consumption
by 10% or 20% without big problems when requested (e.g. Java VMs,
Firefox and databases come into my mind).

And from a performance point of view letting applications voluntarily 
free some memory is better even than starting to swap.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

