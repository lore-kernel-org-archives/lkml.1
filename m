Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYAOMvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYAOMvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbYAOMsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:32 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:48018 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754988AbYAOMsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:08 -0500
Message-ID: <400401292.24795@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:37 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/13] writeback bug fixes and simplifications take 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This patchset mainly polishes the writeback queuing policies.
The main goals are:

(1) small files should not be starved by big dirty files
(2) sync as fast as possible for not-blocked inodes/pages
    - don't leave them out; no congestion_wait() in between them
(3) avoid busy iowait for blocked inodes
    - retry them in the next go of s_io(maybe at the next wakeup of pdflush)

The role of the queues:

s_dirty:   park for dirtied_when expiration
s_io:      park for io submission
s_more_io: for big dirty inodes, they will be retried in this run of pdflush
           (it ensures fairness between small/large files)
s_more_io_wait: for blocked inodes, they will be picked up in next run of s_io


This patchset is in better shape, but still not ready for merge.
It begins with:

	[PATCH 01/13] writeback: revert 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b      
	[PATCH 02/13] writeback: clear PAGECACHE_TAG_DIRTY for truncated page in block_write_full_page()

Introduces more_io/more_io_wait based policies:

	[PATCH 03/13] writeback: introduce writeback_control.more_io                  
	[PATCH 04/13] writeback: introduce super_block.s_more_io_wait                 
	[PATCH 05/13] writeback: merge duplicate code into writeback_some_pages()     
	[PATCH 06/13] writeback: defer writeback on not-all-pages-written             
	[PATCH 07/13] writeback: defer writeback on locked inode                      
	[PATCH 08/13] writeback: defer writeback on locked buffers                    
	[PATCH 09/13] writeback: requeue_io() on redirtied inode                      

And finishes with some code cleanups:

	[PATCH 10/13] writeback: introduce queue_dirty()                              
	[PATCH 11/13] writeback: queue_dirty() on memory-backed bdi                   
	[PATCH 12/13] writeback: remove redirty_tail()                                
	[PATCH 13/13] writeback: cleanup __sync_single_inode()                        

Diffstat:

 fs/buffer.c         |    2 
 fs/fs-writeback.c   |  121 +++++++++++++++---------------------------
 fs/super.c          |    1 
 include/linux/fs.h  |    1 
 mm/page-writeback.c |   46 +++++++--------
 5 files changed, 72 insertions(+), 99 deletions(-)

Regards,
Fengguang Wu
-- 
