Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbYAPINg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbYAPINg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYAPIN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:13:27 -0500
Received: from relay2.sgi.com ([192.48.171.30]:48167 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753585AbYAPIN0 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:13:26 -0500
Date: Wed, 16 Jan 2008 19:13:07 +1100
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, Michael Rubin <mrubin@google.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] writeback: requeue_io() on redirtied inode
Message-ID: <20080116081307.GX155407@sgi.com>
References: <20080115123637.518924046@mail.ustc.edu.cn> <20080115124801.430525129@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115124801.430525129@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 08:36:46PM +0800, Fengguang Wu wrote:
> Redirtied inodes could be seen in really fast writes.
> They should really be synced as soon as possible.
> 
> redirty_tail() could delay the inode for up to 30s.
> Kill the delay by using requeue_io() instead.

That's actually bad for anything that does delayed allocation
or updates state on data I/o completion.

e.g. XFS when writing past EOF doing delalloc dirties the inode
during writeout (allocation) and then updates the file size on data
I/o completion hence dirtying the inode again.

With this change, writing the last pages out would result
in hitting this code and causing the inode to be flushed very
soon after the data write. Then, after the inode write is issued,
we get data I/o completion which dirties the inode again,
resulting in needing to write the inode again to clean it.
i.e. it introduces a potential new and useless inode write
I/O.

Also, the immediate inode write may be useless for XFS because the
inode may be pinned in memory due to async transactions
still in flight (e.g. from delalloc) so we've got two
situations where flushing the inode immediately is suboptimal.

Hence I don't think this is an optimisation that should be made
in the generic writeback code.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
