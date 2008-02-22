Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbYBVN6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbYBVN6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763103AbYBVN56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:57:58 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54053 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762599AbYBVN55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:57:57 -0500
From: Chris Mason <chris.mason@oracle.com>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/37] Permit filesystem local caching
Date: Fri, 22 Feb 2008 08:52:26 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Daniel Phillips <phillips@phunq.net>, Trond.Myklebust@netapp.com,
       chuck.lever@oracle.com, casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <28196.1203605703@redhat.com> <20080220160557.4715.66608.stgit@warthog.procyon.org.uk> <17916.1203636833@redhat.com>
In-Reply-To: <17916.1203636833@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802220852.26584.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2008, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> > > Have you got before/after benchmark results?
> >
> > See attached.
>
> Attached here are results using BTRFS (patched so that it'll work at all)
> rather than Ext3 on the client on the partition backing the cache.

Thanks for trying this, of course I'll ask you to try again with the latest 
v0.13 code, it has a number of optimizations especially for CPU usage.

>
> Note that I didn't bother redoing the tests that didn't involve a cache as
> the choice of filesystem backing the cache should have no bearing on the
> result.
>
> Generally, completely cold caches shouldn't show much variation as all the
> writing can be done completely asynchronously, provided the client doesn't
> fill its RAM.
>
> The interesting case is where the disk cache is warm, but the pagecache is
> cold (ie: just after a reboot after filling the caches).  Here, for the two
> big files case, BTRFS appears quite a bit better than Ext3, showing a 21%
> reduction in time for the smaller case and a 13% reduction for the larger
> case.

I'm afraid I don't have a good handle on the filesystem operations that result 
from this workload.  Are we reading from the FS to fill the NFS page cache?

>
> For the many small/medium files case, BTRFS performed significantly better
> (15% reduction in time) in the case where the caches were completely cold.
> I'm not sure why, though - perhaps because it doesn't execute a
> write_begin() stage during the write_one_page() call and thus doesn't go
> allocating disk blocks to back the data, but instead allocates them later.

If your write_one_page call does parts of btrfs_file_write, you'll get delayed 
allocation for anything bigger than 8k by default.  <= 8k will get packed 
into the btree leaves.

>
> More surprising is that BTRFS performed significantly worse (15% increase
> in time) in the case where the cache on disk was fully populated and then
> the machine had been rebooted to clear the pagecaches.

Which FS operations are included here?  Finding all the files or just an 
unmount?  Btrfs defrags metadata in the background, and unmount has to wait 
for that defrag to finish.

Thanks again,
Chris
