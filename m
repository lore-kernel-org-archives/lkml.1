Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbZI0RKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbZI0RKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 13:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZI0RKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 13:10:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751976AbZI0RKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 13:10:41 -0400
Date: Sun, 27 Sep 2009 10:10:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       jack@suse.cz
Subject: Re: [PATCH] bdi_sync_writeback should WB_SYNC_NONE first
Message-Id: <20090927101035.e8712819.akpm@linux-foundation.org>
In-Reply-To: <20090927165513.GC23126@kernel.dk>
References: <20090925141014.GB15853@think>
	<20090927013458.53e43459.akpm@linux-foundation.org>
	<20090927164431.GB23126@kernel.dk>
	<20090927095202.717fdf64.akpm@linux-foundation.org>
	<20090927165513.GC23126@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009 18:55:14 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> > I wasn't referring to this patch actually.  The code as it stands in
> > Linus's tree right now attempts to write back up to 2^63 pages...  
> 
> I agree, it could make the fs sync take a looong time. This is not a new
> issue, though.

It _should_ be a new issue.  The old code would estimate the number of
dirty pages up-front and would then add a +50% fudge factor, so if we
started the sync with 1GB dirty memory, we write back a max of 1.5GB.

However that might have got broken.

void sync_inodes_sb(struct super_block *sb, int wait)
{
	struct writeback_control wbc = {
		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_NONE,
		.range_start	= 0,
		.range_end	= LLONG_MAX,
	};

	if (!wait) {
		unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
		unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);

		wbc.nr_to_write = nr_dirty + nr_unstable +
			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
	} else
		wbc.nr_to_write = LONG_MAX; /* doesn't actually matter */

	sync_sb_inodes(sb, &wbc);
}

a) the +50% isn't there in 2.6.31

b) the wait=true case appears to be vulnerable to livelock in 2.6.31.

whodidthat

38f21977663126fef53f5585e7f1653d8ebe55c4 did that back in January.
