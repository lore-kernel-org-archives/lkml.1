Return-Path: <linux-kernel-owner+w=401wt.eu-S1761555AbXEOEsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555AbXEOEsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 00:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXEOEsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 00:48:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029AbXEOEs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 00:48:29 -0400
From: Neil Brown <neilb@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 15 May 2007 14:48:04 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17993.15236.442636.502640@notabene.brown>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: Re: [PATCH 00/15] per device dirty throttling -v6
In-Reply-To: message from Peter Zijlstra on Thursday May 10
References: <20070510100839.621199408@chello.nl>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 10, a.p.zijlstra@chello.nl wrote:
> The latest version of the per device dirty throttling patches.
> 
> I put in quite a few comments, and added an patch to do per task dirty
> throttling as well, for RFCs sake :-)
> 
> I haven't yet come around to do anything but integrety testing on this code
> base, ie. it built a kernel. I hope to do more tests shorty if time permits...
> 
> Perhaps the people on bugzilla.kernel.org #7372 might be willing to help out
> there.
> 
> Oh, patches are against 2.6.21-mm2
> 
> -- 

Patch 12 has:
  +#include <linux/proportions.h>

But that file isn't added until patch 14.

Splitting the "proportions" stuff out into lib/ is a good idea.
You have left some remnants of it's origin though, which mentions of
   BDI
   pages
   total page writeback

The "proportions" library always uses a percpu counter, which is
perfect of the per-bdi counter, but seems wrong when you use the same
code for per-task throttling.  Have a percpu counter in struct task
seems very wasteful.  You don't need to lock the access to this
counter as it is only ever access as current-> so a simple "long"
(or "long long") would do.  The global "vm_dirties" still needs to be
percpu....  I'm not sure what best to do about this.

   
The per-task throttling is interesting.
You reduce the point where a task has to throttle by up to half, based
on the fraction of recently dirtied pages that the task is responsible
for.
So if there is one writer, it now gets only half the space that it
used to.  That is probably OK, we can just increase the space
available...
If there are two equally eager writers, they can both use up to the
75% mark, so they probably each get 37%, which is reasonable.
If there is one fast an one slow writer where the slow writer is
generating dirty pages well below the writeout rate of the device, the
fast writer will throttle at around 50% and the slow writer will never
block.  That is nice.

If you have two writers A and B writing aggressively to two devices X
and Y with different speeds, say X twice the speed of Y, then in the
steady state, X gets 2/3 of the space and Y gets 1/3.
A will dirty twice the pages that B dirties so A will get to use
1 - (2/3)/2 == 2/3 of that space or 4/9, and B will get to use 1 - (1/3)/2 ==
5/6 of that space or 5/18.  Did I get that right?
So they will each reduce the space available to the other, even though
they aren't really competing.   That might not be a problem, but it is
interesting... 

It seems that the 'one half' is fairly arbitrary.  It could equally
well be 3/4.  That would simply mean there is less differentiation
between the more and less aggressive writer.  I would probably lean
towards a higher number like 3/4.  It should still give reasonable
differentiation without cutting max amount of dirty memory in half for
the common 1-writer case.

A couple of years ago Andrea Arcangeli wrote a patch that did per-task
throttling, which it is worth comparing with.
  http://lwn.net/Articles/152277/

It takes each task separately, measure rate-of-dirtying over a fixed
time period, and throttle when that rate would put the system over the
limit soon.  Thus slower dirtiers throttle later.

Having to configure the fixed number (the period) is always awkward,
and I think your floating average is better suited for the task.
I doubt if Andrea's patch still applies so a direct comparison might
be awkward, but it might not hurt to read through it if you haven't
already. 

NeilBrown
