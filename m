Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbXJYCh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbXJYCh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbXJYChP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:37:15 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:58101 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753123AbXJYChM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:37:12 -0400
Message-ID: <393279833.15570@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 25 Oct 2007 10:37:08 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, chris.mason@oracle.com, jeffm@suse.com,
       maximlevitsky@gmail.com, peterz@infradead.org, stable@kernel.org,
       lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: +
	reiserfs-dont-drop-pg_dirty-when-releasing-sub-page-sized-dirty-file
	.patch added to -mm tree
References: <200710242307.l9ON7btk017173@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710242307.l9ON7btk017173@imap1.linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1Iksaq-0006pr-Hv@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 04:07:37PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      reiserfs: don't drop PG_dirty when releasing sub-page-sized dirty file
> has been added to the -mm tree.  Its filename is
>      reiserfs-dont-drop-pg_dirty-when-releasing-sub-page-sized-dirty-file.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: reiserfs: don't drop PG_dirty when releasing sub-page-sized dirty file
> From: Fengguang Wu <wfg@mail.ustc.edu.cn>
> 
> This is not a new problem in 2.6.23-git17.  2.6.22/2.6.23 is buggy in the
> same way.
> 
> Reiserfs could accumulate dirty sub-page-size files until umount time. 
> They cannot be synced to disk by pdflush routines or explicit `sync'
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Sorry it's not that horrible. The *data* will still be written to disk.
Only the inodes will be stuck in I_DIRTY_PAGES state, and the pages
stuck in PAGECACHE_TAG_DIRTY state.

> commands.  Only `umount' can do the trick.
> 
> The direct cause is: the dirty page's PG_dirty is wrongly _cleared_.
> Call trace:
> 	 [<ffffffff8027e920>] cancel_dirty_page+0xd0/0xf0
> 	 [<ffffffff8816d470>] :reiserfs:reiserfs_cut_from_item+0x660/0x710
> 	 [<ffffffff8816d791>] :reiserfs:reiserfs_do_truncate+0x271/0x530
> 	 [<ffffffff8815872d>] :reiserfs:reiserfs_truncate_file+0xfd/0x3b0
> 	 [<ffffffff8815d3d0>] :reiserfs:reiserfs_file_release+0x1e0/0x340
> 	 [<ffffffff802a187c>] __fput+0xcc/0x1b0
> 	 [<ffffffff802a1ba6>] fput+0x16/0x20
> 	 [<ffffffff8029e676>] filp_close+0x56/0x90
> 	 [<ffffffff8029fe0d>] sys_close+0xad/0x110
> 	 [<ffffffff8020c41e>] system_call+0x7e/0x83
> 
> Fix the bug by removing the cancel_dirty_page() call. Tests show that
> it causes no bad behaviors on various write sizes.

