Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbZJGNsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbZJGNsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbZJGNsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:48:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbZJGNsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:48:10 -0400
Message-ID: <4ACC9BE2.5070409@redhat.com>
Date: Wed, 07 Oct 2009 09:47:14 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/45] some writeback experiments
References: <20091007073818.318088777@intel.com>
In-Reply-To: <20091007073818.318088777@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> Hi all,
> 
> Here is a collection of writeback patches on
> 
> - larger writeback chunk sizes
> - single per-bdi flush thread (killing the foreground throttling writeouts)
> - lumpy pageout
> - sync livelock prevention
> - writeback scheduling
> - random fixes
> 
> Sorry for posting a too big series - there are many direct or implicit
> dependencies, and one patch lead to another before I can stop..
> 
> The lumpy pageout and nr_segments support is not complete and do not
> cover all filesystems for now. It may be better to first convert some of
> the ->writepages to the generic routines to avoid duplicate work.
> 
> I managed to address many issues in past week, however there are still known
> problems. Hints from filesystem developers are highly appreciated. Thanks!
> 
> The estimated writeback bandwidth is about 1/2 the real throughput
> for ext2/3/4 and btrfs; noticeable bigger than real throughput for NFS; and
> cannot be estimated at all for XFS.  Very interesting..
> 
> NFS writeback is very bumpy. The page numbers and network throughput "freeze"
> together from time to time:
> 

Yes.  It appears that the problem is that too many pages get dirtied
and the network/server get overwhelmed by the NFS client attempting
to write out all of the pages as quickly as it possibly can.

I think that it would be better if we could better match the
number of pages which can be dirty at any given point with the
bandwidth available through the network and the server file
system and storage.

One approach that I have pondered is immediately queuing an
asynchronous request when enough pages are dirtied to be able
to completely fill an over the wire transfer.  This sort of
seems like a per-file bdi, which doesn't seem quite like the
right approach to me.  What would y'all think about that?

		ps


> # vmmon -d 1 nr_writeback nr_dirty nr_unstable      # (per 1-second samples)
>      nr_writeback         nr_dirty      nr_unstable
>             11227            41463            38044
>             11227            41463            38044
>             11227            41463            38044
>             11227            41463            38044
>             11045            53987             6490
>             11033            53120             8145
>             11195            52143            10886
>             11211            52144            10913
>             11211            52144            10913
>             11211            52144            10913
> 
> btrfs seems to maintain a private pool of writeback pages, which can go out of
> control:
> 
>      nr_writeback         nr_dirty
>            261075              132
>            252891              195
>            244795              187
>            236851              187
>            228830              187
>            221040              218
>            212674              237
>            204981              237
> 
> XFS has very interesting "bumpy writeback" behavior: it tends to wait
> collect enough pages and then write the whole world.
> 
>      nr_writeback         nr_dirty
>             80781                0
>             37117            37703
>             37117            43933
>             81044                6
>             81050                0
>             43943            10199
>             43930            36355
>             43930            36355
>             80293                0
>             80285                0
>             80285                0
> 
> Thanks,
> Fengguang
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

