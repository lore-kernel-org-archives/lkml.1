Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYCNGoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYCNGoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 02:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYCNGoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 02:44:12 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36437 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750935AbYCNGoL (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 02:44:11 -0400
Date: Fri, 14 Mar 2008 17:43:50 +1100
From: David Chinner <dgc@sgi.com>
To: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, dgc@sgi.com
Subject: Re: [PATCH][BUGFIX][RFC] fix soft lock up at NFS mount by making limitation of dentry_unused
Message-ID: <20080314064350.GU95344431@sgi.com>
References: <20080306055416.GF155407@sgi.com> <47CF9A1F.50300@np.css.fujitsu.com> <20080308171911.E365.KOSAKI.MOTOHIRO@jp.fujitsu.com> <47DA09F0.2030506@np.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DA09F0.2030506@np.css.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 02:15:28PM +0900, Kentaro Makita wrote:
> Hi David
> On Thu, 6 Mar 2008 16:54:16 +1100  David Chinner wrote:
> >> No, we need a smarter free list structure. There have been several attempts
> >> at this in the past. Two that I can recall off the top of my head:
> >>
> >> 	- per node unused LRUs
> >> 	- per superblock unusued LRUs
> >> I guess we need to revisit this again, because limiting the size of
> >> the cache like this is not an option.
> I 'm interesting in your patch. I 'll test two patches above if there
> is newer version based on latest kernel.
> 
> >> Try something that relies on leaving the working set on the unused
> >> list, like NFS server benchmarks that have a working set of tens of
> >> million of files....
> >>
> I tested following, and I found no regressions except one case.
>  - kernbench-0.24 on local ext3 and nfs
>  - dbench-3.04 on local ext3 and nfs
>  - IOzone-3.291 on local ext3 and nfs
> -Basic file operations (create/delete/list/copy/move) on local ext3 and nfs

None of those really demonstrate the potential effects of your
proposed change. Even 1 million file sequential create and delete
will not stress it. It won't be until you need to hold that
million dentries in memory to prevent disk lookups while an
application generates significant memory pressure that you will
notice the difference. Without the dentries pinning the inodes,
they'll get reclaimed and need to be fetched from disk again....

FWIW - in trying to understand this a little more, I just checked my
idle test box just after boot and realised something:

$ cat /proc/sys/fs/dentry-state
12723   8709    45      0       0       0
$

That means 12723 allocated dentrys, 8709 unused. That means ~4000 in use.

If the limiting test you are using is:

       if (dentry_stat.nr_dentry > nr_in_use * dentry_unused_ratio / 100)
               prune_dcache(dentry_stat.nr_unused * 5 / 100 , NULL);

We need to have (4000 * 10000) / 100) = 400,000 allocated unused, cached
dentries before they get pruned back. i.e. the working set of dentries I
can currently have is 400,000.

I've got 24GB RAM on this box, and often I want to cache 10,000,000 inodes.
Under this algorithm, I'll need to pin 100,000 dentries to allow the cache to
grow this large or tweak a knob. Therein lies the problem....

Effetively, the dentry_unused_ratio is saying that for every node in
the dentry tree, we allow (dentry_unused_ratio / 100) cached leaves
distributed throughout the tree. At dentry_unused_ratio = 10,000
that gives us 100 leaves per node in the tree.

i.e. if your directory heirachy is deep, then you can cache lots and
lots of inodes because you pin lots of dentries as nodes in the
tree.  But If you have a flat directory structure, there will be
relatively few nodes pinned and you can't cache as many inodes.

IOWs, the size limiting aspect of this algorithm is biased in
exactly the wrong direction. It grows without bound on filesystem
traversal (and hence fails to prevent the condition you want to avoid)
yet prevents caching lots of file dentries if you have a shallow
directory structure (can affect normal application performance).

To prevent the first, you need to tweak the knob in one direction,
and to prevent the second, you need to tweak the knob in the
other direction. We try to avoid adding knobs that require ppl
to tweak them all the time to get optimal performance.

I think we're better off trying to fix the traversal issue....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
