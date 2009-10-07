Return-Path: <linux-kernel-owner+w=401wt.eu-S934153AbZJGINu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153AbZJGINu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933264AbZJGIBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:35820 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086AbZJGIBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971246"
Message-Id: <20091007073818.318088777@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/45] some writeback experiments
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a collection of writeback patches on

- larger writeback chunk sizes
- single per-bdi flush thread (killing the foreground throttling writeouts)
- lumpy pageout
- sync livelock prevention
- writeback scheduling
- random fixes

Sorry for posting a too big series - there are many direct or implicit
dependencies, and one patch lead to another before I can stop..

The lumpy pageout and nr_segments support is not complete and do not
cover all filesystems for now. It may be better to first convert some of
the ->writepages to the generic routines to avoid duplicate work.

I managed to address many issues in past week, however there are still known
problems. Hints from filesystem developers are highly appreciated. Thanks!

The estimated writeback bandwidth is about 1/2 the real throughput
for ext2/3/4 and btrfs; noticeable bigger than real throughput for NFS; and
cannot be estimated at all for XFS.  Very interesting..

NFS writeback is very bumpy. The page numbers and network throughput "freeze"
together from time to time:

# vmmon -d 1 nr_writeback nr_dirty nr_unstable      # (per 1-second samples)
     nr_writeback         nr_dirty      nr_unstable
            11227            41463            38044
            11227            41463            38044
            11227            41463            38044
            11227            41463            38044
            11045            53987             6490
            11033            53120             8145
            11195            52143            10886
            11211            52144            10913
            11211            52144            10913
            11211            52144            10913

btrfs seems to maintain a private pool of writeback pages, which can go out of
control:

     nr_writeback         nr_dirty
           261075              132
           252891              195
           244795              187
           236851              187
           228830              187
           221040              218
           212674              237
           204981              237

XFS has very interesting "bumpy writeback" behavior: it tends to wait
collect enough pages and then write the whole world.

     nr_writeback         nr_dirty
            80781                0
            37117            37703
            37117            43933
            81044                6
            81050                0
            43943            10199
            43930            36355
            43930            36355
            80293                0
            80285                0
            80285                0

Thanks,
Fengguang

