Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbZBXWjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbZBXWjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761115AbZBXWjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:39:19 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:51527 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760894AbZBXWjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:39:18 -0500
Subject: Re: next-20090220: XFS, IMA: BUG: sleeping function called from
	invalid  context at mm/slub.c:1613
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <20090220122242.b36a778f.akpm@linux-foundation.org>
References: <a4423d670902200300n1d1bfdeeg6daca4b32989c9d3@mail.gmail.com>
	 <20090220122242.b36a778f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 17:39:14 -0500
Message-Id: <1235515154.2953.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 12:22 -0800, Andrew Morton wrote:

> But to fix this bug, xfs needs to stop calling inode_init_always()
> under read_lock().  Because inode_alloc_security() also can sleep (see
> new_inode_smack()).

Yes, even without IMA enabled, with SELINUX, PREEMPT, and DEBUG_PREEMPT
enabled, I'm seeing the problem:

Feb 24 17:37:52 iicu10 kernel: BUG: sleeping function called from invalid context at mm/slub.c:1613
Feb 24 17:37:52 iicu10 kernel: in_atomic(): 1, irqs_disabled(): 0, pid: 3209, name: vi
Feb 24 17:37:52 iicu10 kernel: Pid: 3209, comm: vi Tainted: P           2.6.29-rc6-next-20090224 #5
Feb 24 17:37:52 iicu10 kernel: Call Trace:
Feb 24 17:37:52 iicu10 kernel: [<ffffffff8103d2c1>] __might_sleep+0x120/0x122
Feb 24 17:37:52 iicu10 kernel: [<ffffffff810c9a96>] kmem_cache_alloc+0x32/0xd1
Feb 24 17:37:52 iicu10 kernel: [<ffffffff811563ca>] selinux_inode_alloc_security+0x39/0x90
Feb 24 17:37:52 iicu10 kernel: [<ffffffff8114ef12>] security_inode_alloc+0x1c/0x1e
Feb 24 17:37:52 iicu10 kernel: [<ffffffff810e15b3>] inode_init_always+0xc3/0x1dc
Feb 24 17:37:52 iicu10 kernel: [<ffffffffa0031a34>] xfs_iget+0x14e/0x49e [xfs]
Feb 24 17:37:52 iicu10 kernel: [<ffffffffa00462c2>] xfs_trans_iget+0xa6/0xd4 [xfs]
Feb 24 17:37:52 iicu10 kernel: [<ffffffffa003463c>] xfs_ialloc+0x96/0x517 [xfs]
Feb 24 17:37:52 iicu10 kernel: [<ffffffff8118b5e2>] ? _raw_spin_lock+0x6c/0x112
Feb 24 17:37:52 iicu10 kernel: [<ffffffff8118b5e2>] ? _raw_spin_lock+0x6c/0x112
Feb 24 17:37:52 iicu10 kernel: [<ffffffffa0046bb1>] xfs_dir_ialloc+0x73/0x26a [x

Mimi Zohar

