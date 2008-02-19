Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbYBSIUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbYBSIUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbYBSIUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:20:34 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33915 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751309AbYBSIUd (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:20:33 -0500
Date: Tue, 19 Feb 2008 19:20:11 +1100
From: David Chinner <dgc@sgi.com>
To: Linda Walsh <xfs@tlinx.org>
Cc: =?iso-8859-1?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: xfsaild causing 30+ wakeups/s on an idle system since 2.6.25-rcX
Message-ID: <20080219082011.GD155407@sgi.com>
References: <47B863A9.5070206@gmail.com> <47BA131A.5080908@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BA131A.5080908@tlinx.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 03:22:02PM -0800, Linda Walsh wrote:
> Not to look excessively dumb, but what's xfsaild?

AIL = Active Item List

It is a sorted list all the logged metadata objects that have not
yet been written back to disk.  The xfsaild is responsible for tail
pushing the log.  i.e.  writing back objects in the AIL in the most
efficient manner possible.

Why a thread? Because allowing parallelism in tail pushing is a
scalability problem and moving this to it's own thread completely
isolates it from parallelism. Tail pushing only requires a small
amount of CPU time, but it requires a global scope spinlock.
Isolating the pushing to a single CPU means the spinlock is not
contended across every CPU in the machine.

How much did it improve scalability? on a 2048p machine with an
MPI job that did a synchronised close of 12,000 files (6 per CPU),
the close time went from ~5400s without the thread to 9s with the
xfsaild. That's only about 600x faster. ;)

> xfs seems to be sprouting daemons at a more rapid pace
> these days...xfsbufd, xfssyncd, xfsdatad, xfslogd, xfs_mru_cache, and
> now xfsaild?

Why not? Got to make use of all those cores machines have these
days. ;)

Fundamentally, threads are cheap and simple. We'll keep adding
threads where it makes sense as long as it improves performance and
scalability.

> Are there any design docs (scribbles?) saying what these do and why
> they were added so I can just go read 'em myself?  I'm sure they
> were added for good reason...just am curious more than anything.

'git log' is your friend. The commits that introduce the new threads
explain why they are necessary. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
