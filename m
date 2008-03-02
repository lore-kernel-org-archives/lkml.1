Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbYCBVXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbYCBVXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbYCBVX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:23:28 -0500
Received: from styx.suse.cz ([82.119.242.94]:48324 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756885AbYCBVX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:23:27 -0500
Date: Sun, 2 Mar 2008 22:23:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Olsa <olsajiri@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Nadia Derbey <Nadia.Derbey@bull.net>,
       peifferp@gmail.com
Subject: Re: [BUG] soft lockup detected with ipcs
In-Reply-To: <20080302120236.61e0ec74.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803022214190.15209@jikos.suse.cz>
References: <47C7E280.4010805@gmail.com> <Pine.LNX.4.64.0802291241080.7699@twin.jikos.cz>
 <47CAE7D5.5040907@gmail.com> <20080302120236.61e0ec74.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008, Jiri Olsa wrote:

> I got more logs via netconsole, first I ran ipcs it segfaulted next run
> the system freezed.

Did you run ipcs without any arguments? If so, it should only call 
shmctl(SHM_INFO) and shmctl(SHM_STAT), so the only two spinlocks involved 
should be either shmem_inode_info->lock in shm_get_stat() or 
kern_ipc_perm->out_lock in ipc_lock().

Could you please try what is the output with the attached patch below, so 
that we know which spinlock buggers?

Also, could you please provide strace of the first (segfaulting) 
invocation of ipcs?

On Sun, 2 Mar 2008, Andrew Morton wrote:

> > [  144.699366] BUG: unable to handle kernel paging request at virtual address 6b6b6c2b
[ ... ]
> Looks like you got a use-after free when lockdep was playing with a 
> spinlock which is taken in sys_shmctl() or one of its inlined callees.

BTW any idea where does the '2b' come from? (it's single-bit flip).

-- 
Jiri Kosina
SUSE Labs
