Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZIQB4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZIQB4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 21:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZIQB4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 21:56:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58090 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbZIQB4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 21:56:51 -0400
Date: Thu, 17 Sep 2009 11:56:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: linux-next: manual merge of the ext4 tree with Linus tree
Message-Id: <20090917115653.2e3b6b49.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Theodore,

Today's linux-next merge of the ext4 tree got a conflict in
include/trace/events/ext4.h between commit
1fe06ad89255c211fe100d7f690d10b161398df8 ("writeback: get rid of
wbc->for_writepages") from Linus tree and commits
b3107b75b479ff8f0a8aba9cdb38ec13284ce7eb ("ext4: Fix spelling typo in the
trace format for trace_ext4_da_writepages()") from the ext4 tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/trace/events/ext4.h
index 8d433c4e,3d26f9d..0000000
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@@ -243,14 -247,50 +246,49 @@@ TRACE_EVENT(ext4_da_writepages
  		__entry->range_cyclic	= wbc->range_cyclic;
  	),
  
- 	TP_printk("dev %s ino %lu nr_t_write %ld pages_skipped %ld range_start %llu range_end %llu nonblocking %d for_kupdate %d for_reclaim %d range_cyclic %d",
- 		  jbd2_dev_to_name(__entry->dev), __entry->ino, __entry->nr_to_write,
 -	TP_printk("dev %s ino %lu nr_to_write %ld pages_skipped %ld range_start %llu range_end %llu nonblocking %d for_kupdate %d for_reclaim %d for_writepages %d range_cyclic %d",
++	TP_printk("dev %s ino %lu nr_to_write %ld pages_skipped %ld range_start %llu range_end %llu nonblocking %d for_kupdate %d for_reclaim %d range_cyclic %d",
+ 		  jbd2_dev_to_name(__entry->dev),
+ 		  (unsigned long) __entry->ino, __entry->nr_to_write,
  		  __entry->pages_skipped, __entry->range_start,
  		  __entry->range_end, __entry->nonblocking,
  		  __entry->for_kupdate, __entry->for_reclaim,
 -		  __entry->for_writepages, __entry->range_cyclic)
 +		  __entry->range_cyclic)
  );
  
+ TRACE_EVENT(ext4_da_write_pages,
+ 	TP_PROTO(struct inode *inode, struct mpage_da_data *mpd),
+ 
+ 	TP_ARGS(inode, mpd),
+ 
+ 	TP_STRUCT__entry(
+ 		__field(	dev_t,	dev			)
+ 		__field(	ino_t,	ino			)
+ 		__field(	__u64,	b_blocknr		)
+ 		__field(	__u32,	b_size			)
+ 		__field(	__u32,	b_state			)
+ 		__field(	unsigned long,	first_page	)
+ 		__field(	int,	io_done			)
+ 		__field(	int,	pages_written		)
+ 	),
+ 
+ 	TP_fast_assign(
+ 		__entry->dev		= inode->i_sb->s_dev;
+ 		__entry->ino		= inode->i_ino;
+ 		__entry->b_blocknr	= mpd->b_blocknr;
+ 		__entry->b_size		= mpd->b_size;
+ 		__entry->b_state	= mpd->b_state;
+ 		__entry->first_page	= mpd->first_page;
+ 		__entry->io_done	= mpd->io_done;
+ 		__entry->pages_written	= mpd->pages_written;
+ 	),
+ 
+ 	TP_printk("dev %s ino %lu b_blocknr %llu b_size %u b_state 0x%04x first_page %lu io_done %d pages_written %d",
+ 		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
+ 		  __entry->b_blocknr, __entry->b_size,
+ 		  __entry->b_state, __entry->first_page,
+ 		  __entry->io_done, __entry->pages_written)
+ );
+ 
  TRACE_EVENT(ext4_da_writepages_result,
  	TP_PROTO(struct inode *inode, struct writeback_control *wbc,
  			int ret, int pages_written),
