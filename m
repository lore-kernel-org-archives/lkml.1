Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbZDUWgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbZDUWgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZDUWgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:36:06 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:32139 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbZDUWgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:36:05 -0400
Subject: Re: [GIT PULL] Btrfs changes for 2.6.30-rc
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1240320545.4869.22.camel@think.oraclecorp.com>
References: <1240320545.4869.22.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 13:02:47 -0400
Message-Id: <1240333367.4869.77.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.49EE4A0A.00DC:SCFMA922111,ss=1,fgs=0
X-QuarantineReason: Unscannable attachment
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 09:29 -0400, Chris Mason wrote:
> Hello everyone,
> 
> The master branch of:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
> 
> Has some fixes for oopsen and a cluster of bugs inside of one of the
> btree readahead functions.
> 
> I also jumped on the fsync latency train for btrfs and switched over to
> WRITE_SYNC for the writes I was going to wait on.
> 
> This is a bigger change in btrfs because I had to add a high priority
> list to the async helper threads, but it had a big impact on performance
> overall.  Before, the writes we were waiting on would get stuck behind
> the less critical writes in the async helper threads, and now they pop
> out much faster.
> 
> Average fsync latencies concurrent with a streaming writer went down
> from ~5 seconds (with longer peaks) to < 1 second.
> 

Jens Axboe hit a bug in fallocate, I've pushed that fix out today as
well.  Updated shortlog/diffstat:


Chris Mason (5):
      Btrfs: use WRITE_SYNC for synchronous writes
      Btrfs: add a priority queue to the async thread helpers
      Btrfs: fix oops on page->mapping->host during writepage
      Btrfs: use the right node in reada_for_balance
      Btrfs: fix btrfs fallocate oops and deadlock

 fs/btrfs/async-thread.c |   60 ++++++++++++++++++-----
 fs/btrfs/async-thread.h |    2
 fs/btrfs/ctree.c        |   17 ++++--
 fs/btrfs/disk-io.c      |    9 ++-
 fs/btrfs/extent_io.c    |   86 ++++++++++++++++++++++++---------
 fs/btrfs/file.c         |    6 +-
 fs/btrfs/inode.c        |   36 ++++++++++---
 fs/btrfs/ordered-data.c |    2
 fs/btrfs/volumes.c      |  124 +++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h      |   13 ++++-

-chris


