Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYAQEXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYAQEXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 23:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYAQEXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 23:23:20 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37330 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751471AbYAQEXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 23:23:18 -0500
Message-ID: <400543799.23158@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 17 Jan 2008 12:22:38 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, Michael Rubin <mrubin@google.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] writeback: requeue_io() on redirtied inode
References: <20080115123637.518924046@mail.ustc.edu.cn> <20080115124801.430525129@mail.ustc.edu.cn> <20080116081307.GX155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116081307.GX155407@sgi.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JFMH1-0001xA-L1@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 07:13:07PM +1100, David Chinner wrote:
> On Tue, Jan 15, 2008 at 08:36:46PM +0800, Fengguang Wu wrote:
> > Redirtied inodes could be seen in really fast writes.
> > They should really be synced as soon as possible.
> > 
> > redirty_tail() could delay the inode for up to 30s.
> > Kill the delay by using requeue_io() instead.
> 
> That's actually bad for anything that does delayed allocation
> or updates state on data I/o completion.
> 
> e.g. XFS when writing past EOF doing delalloc dirties the inode
> during writeout (allocation) and then updates the file size on data
> I/o completion hence dirtying the inode again.
> 
> With this change, writing the last pages out would result
> in hitting this code and causing the inode to be flushed very
> soon after the data write. Then, after the inode write is issued,
> we get data I/o completion which dirties the inode again,
> resulting in needing to write the inode again to clean it.
> i.e. it introduces a potential new and useless inode write
> I/O.
> 
> Also, the immediate inode write may be useless for XFS because the
> inode may be pinned in memory due to async transactions
> still in flight (e.g. from delalloc) so we've got two
> situations where flushing the inode immediately is suboptimal.
> 
> Hence I don't think this is an optimisation that should be made
> in the generic writeback code.

Thanks for the explanation.
I can confirm that many requeue_io() happened for the same XFS inode:
[  158.794562] requeue_io 328: inode 5243009 size 34647 at 03:03(hda3)
[  158.794827] mm/page-writeback.c 668 wb_kupdate: pdflush(183) 14209 global 486 10 0 wc _M tw 1013 sk 0
[  158.795293] requeue_io 328: inode 5243009 size 34647 at 03:03(hda3)
[  158.795313] mm/page-writeback.c 668 wb_kupdate: pdflush(183) 14198 global 486 10 0 wc _M tw 1024 sk 0
...
[  170.713900] requeue_io 328: inode 5243009 size 34647 at 03:03(hda3)
[  170.713925] mm/page-writeback.c 668 wb_kupdate: pdflush(183) 14198 global 1875 0 0 wc _M tw 1024 sk 0
[  170.813584] mm/page-writeback.c 668 wb_kupdate: pdflush(183) 14198 global 2855 0 0 wc __ tw 1024 sk 0

