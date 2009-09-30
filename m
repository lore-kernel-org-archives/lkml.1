Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZI3WhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZI3WhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZI3WhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:37:14 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38240 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZI3WhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:37:12 -0400
Date: Wed, 30 Sep 2009 17:37:10 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, stable@kernel.org
Subject: Re: [PATCH] ima: ecryptfs fix imbalance message
Message-ID: <20090930223710.GA12622@boomer>
References: <1254258535-18894-1-git-send-email-zohar@linux.vnet.ibm.com> <4AC3AC33.1020907@linux.vnet.ibm.com> <1254340821.3544.12.camel@dyn9002018117.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254340821.3544.12.camel@dyn9002018117.watson.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Sep 30, 2009 at 04:00:21PM -0400, Mimi Zohar (zohar@linux.vnet.ibm.com) was quoted:
> On Wed, 2009-09-30 at 14:06 -0500, Tyler Hicks wrote:
> > On 09/29/2009 04:08 PM, Mimi Zohar wrote:
> > > The underlying files are measured. Update the counters to get rid of
> > > the ecryptfs imbalance message. (http://bugzilla.redhat.com/519737)
> > > 
> > > Reported-by: Sachin Garg <ascii79@gmail.com>
> > > Cc: stable@kernel.org
> > > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > > ---
> > >  fs/ecryptfs/main.c |    4 +++-
> > >  1 files changed, 3 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> > > index 9f0aa98..177e61e 100644
> > > --- a/fs/ecryptfs/main.c
> > > +++ b/fs/ecryptfs/main.c
> > > @@ -35,6 +35,7 @@
> > >  #include <linux/key.h>
> > >  #include <linux/parser.h>
> > >  #include <linux/fs_stack.h>
> > > +#include <linux/ima.h>
> > >  #include "ecryptfs_kernel.h"
> > > 
> > >  /**
> > > @@ -135,7 +136,8 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
> > >  			       "rc = [%d]\n", lower_dentry, lower_mnt, rc);
> > >  			rc = PTR_ERR(inode_info->lower_file);
> > >  			inode_info->lower_file = NULL;
> > > -		}
> > > +		} else
> > > +			ima_counts_get(inode_info->lower_file);
> > >  	}
> > >  	mutex_unlock(&inode_info->lower_file_mutex);
> > >  	return rc;
> > 
> > Hi Mimi - I can't think of why we would want to measure the underlying
> > files.  The file contents are encrypted with a randomly generated key
> > and there is eCryptfs metadata stored in the first 8K of the underlying
> > file.  If you have two eCryptfs mounts, using the same key, and copy the
> > same file into both mount points, you'll end up with two entirely
> > different underlying files.
> > 
> > Taking a closer look at IMA is still on my TODO list, so I could be
> > missing something obvious.  The upper (decrypted) file is being
> > measured, right?
> > 
> > For performance and the reason mentioned above, it seems like the proper
> > fix is to only measure the upper file.  What do you think?
> > 
> > Tyler
> 
> Yes, the terminology 'underlying files are measured' was incorrect. It
> is measuring the decrypted files.
> 

Thanks to some offline help from you, I enabled IMA and verified that
only the upper file is being measured.  However, this patch causes a
lockdep warning when reading a file from an eCryptfs mount as root.  I
haven't had a chance to look into it yet, but here's what I'm seeing:

kernel: =======================================================
kernel: [ INFO: possible circular locking dependency detected ]
kernel: 2.6.32-rc2 #11
kernel: -------------------------------------------------------
kernel: cat/1392 is trying to acquire lock:
kernel: (&inode_info->lower_file_mutex){+.+.+.}, at: [<ffffffffa00bb622>] ecryptfs_read_lower+0x34/0xa0 [ecryptfs]
kernel:
kernel: but task is already holding lock:
kernel: (&crypt_stat->cs_mutex){+.+.+.}, at: [<ffffffffa00b83ac>] ecryptfs_open+0x15d/0x219 [ecryptfs]
kernel:
kernel: which lock already depends on the new lock.
kernel:
kernel:
kernel: the existing dependency chain (in reverse order) is:
kernel:
kernel: -> #2 (&crypt_stat->cs_mutex){+.+.+.}:
kernel:       [<ffffffff8106dad6>] __lock_acquire+0xb50/0xcf9
kernel:       [<ffffffff8106dd5b>] lock_acquire+0xdc/0x102
kernel:       [<ffffffff8133a606>] __mutex_lock_common+0x4b/0x350
kernel:       [<ffffffff8133a9cf>] mutex_lock_nested+0x3e/0x43
kernel:       [<ffffffffa00b82f3>] ecryptfs_open+0xa4/0x219 [ecryptfs]
kernel:       [<ffffffff810da552>] __dentry_open+0x1e7/0x35a
kernel:       [<ffffffff810da74c>] dentry_open+0x87/0x8e
kernel:       [<ffffffff811988d4>] ima_path_check+0x150/0x1f7
kernel:       [<ffffffff810e607f>] may_open+0xe5/0x21b
kernel:       [<ffffffff810e68e1>] do_filp_open+0x4eb/0x9b0
kernel:       [<ffffffff810da273>] do_sys_open+0x63/0x10f
kernel:       [<ffffffff810da352>] sys_open+0x20/0x22
kernel:       [<ffffffff8100bb42>] system_call_fastpath+0x16/0x1b
kernel:
kernel: -> #1 (&iint->mutex){+.+.+.}:
kernel:       [<ffffffff8106dad6>] __lock_acquire+0xb50/0xcf9
kernel:       [<ffffffff8106dd5b>] lock_acquire+0xdc/0x102
kernel:       [<ffffffff8133a606>] __mutex_lock_common+0x4b/0x350
kernel:       [<ffffffff8133a9cf>] mutex_lock_nested+0x3e/0x43
kernel:       [<ffffffff81198644>] ima_counts_get+0x54/0xa0
kernel:       [<ffffffffa00ba20f>] ecryptfs_init_persistent_file+0xa9/0xc3 [ecryptfs]
kernel:       [<ffffffffa00b9c92>] ecryptfs_lookup_and_interpose_lower+0x1c3/0x299 [ecryptfs]
kernel:       [<ffffffffa00b9f13>] ecryptfs_lookup+0x1ab/0x1d8 [ecryptfs]
kernel:       [<ffffffff810e4217>] do_lookup+0xd1/0x167
kernel:       [<ffffffff810e4cc5>] __link_path_walk+0x591/0x6c2
kernel:       [<ffffffff810e4f96>] path_walk+0x4c/0x8f
kernel:       [<ffffffff810e534b>] do_path_lookup+0x2a/0x8b
kernel:       [<ffffffff810e64d7>] do_filp_open+0xe1/0x9b0
kernel:       [<ffffffff810da273>] do_sys_open+0x63/0x10f
kernel:       [<ffffffff810da352>] sys_open+0x20/0x22
kernel:       [<ffffffff8100bb42>] system_call_fastpath+0x16/0x1b
kernel:
kernel: -> #0 (&inode_info->lower_file_mutex){+.+.+.}:
kernel:       [<ffffffff8106d980>] __lock_acquire+0x9fa/0xcf9
kernel:       [<ffffffff8106dd5b>] lock_acquire+0xdc/0x102
kernel:       [<ffffffff8133a606>] __mutex_lock_common+0x4b/0x350
kernel:       [<ffffffff8133a9cf>] mutex_lock_nested+0x3e/0x43
kernel:       [<ffffffffa00bb622>] ecryptfs_read_lower+0x34/0xa0 [ecryptfs]
kernel:       [<ffffffffa00bcc31>] ecryptfs_read_metadata+0x8d/0x14e [ecryptfs]
kernel:       [<ffffffffa00b83c6>] ecryptfs_open+0x177/0x219 [ecryptfs]
kernel:       [<ffffffff810da552>] __dentry_open+0x1e7/0x35a
kernel:       [<ffffffff810da74c>] dentry_open+0x87/0x8e
kernel:       [<ffffffff811988d4>] ima_path_check+0x150/0x1f7
kernel:       [<ffffffff810e607f>] may_open+0xe5/0x21b
kernel:       [<ffffffff810e68e1>] do_filp_open+0x4eb/0x9b0
kernel:       [<ffffffff810da273>] do_sys_open+0x63/0x10f
kernel:       [<ffffffff810da352>] sys_open+0x20/0x22
kernel:       [<ffffffff8100bb42>] system_call_fastpath+0x16/0x1b
kernel:
kernel: other info that might help us debug this:
kernel:
kernel: 2 locks held by cat/1392:
kernel: #0:  (&iint->mutex){+.+.+.}, at: [<ffffffff811987f3>] ima_path_check+0x6f/0x1f7
kernel: #1:  (&crypt_stat->cs_mutex){+.+.+.}, at: [<ffffffffa00b83ac>] ecryptfs_open+0x15d/0x219 [ecryptfs]
kernel:
kernel: stack backtrace:
kernel: Pid: 1392, comm: cat Not tainted 2.6.32-rc2 #11
kernel: Call Trace:
kernel: [<ffffffff8106cb64>] print_circular_bug+0xa8/0xb6
kernel: [<ffffffff8106d980>] __lock_acquire+0x9fa/0xcf9
kernel: [<ffffffff81075b54>] ? __module_text_address+0x12/0x58
kernel: [<ffffffff8106dd5b>] lock_acquire+0xdc/0x102
kernel: [<ffffffffa00bb622>] ? ecryptfs_read_lower+0x34/0xa0 [ecryptfs]
kernel: [<ffffffff8106e62c>] ? check_usage_backwards+0x4c/0x80
kernel: [<ffffffffa00bb622>] ? ecryptfs_read_lower+0x34/0xa0 [ecryptfs]
kernel: [<ffffffff8133a606>] __mutex_lock_common+0x4b/0x350
kernel: [<ffffffffa00bb622>] ? ecryptfs_read_lower+0x34/0xa0 [ecryptfs]
kernel: [<ffffffff8106bf4c>] ? mark_lock+0x27/0x21e
kernel: [<ffffffff8106c0f8>] ? mark_lock+0x1d3/0x21e
kernel: [<ffffffff8106c195>] ? mark_held_locks+0x52/0x70
kernel: [<ffffffff8133a9cf>] mutex_lock_nested+0x3e/0x43
kernel: [<ffffffffa00bb622>] ecryptfs_read_lower+0x34/0xa0 [ecryptfs]
kernel: [<ffffffffa00bcc31>] ecryptfs_read_metadata+0x8d/0x14e [ecryptfs]
kernel: [<ffffffffa00b83c6>] ecryptfs_open+0x177/0x219 [ecryptfs]
kernel: [<ffffffffa00b824f>] ? ecryptfs_open+0x0/0x219 [ecryptfs]
kernel: [<ffffffff810da552>] __dentry_open+0x1e7/0x35a
kernel: [<ffffffff810da74c>] dentry_open+0x87/0x8e
kernel: [<ffffffff811988d4>] ima_path_check+0x150/0x1f7
kernel: [<ffffffff81186016>] ? selinux_inode_permission+0x40/0x45
kernel: [<ffffffff810e607f>] may_open+0xe5/0x21b
kernel: [<ffffffff810e68e1>] do_filp_open+0x4eb/0x9b0
kernel: [<ffffffff810f074c>] ? alloc_fd+0x3b/0x128
kernel: [<ffffffff811c5377>] ? _raw_spin_unlock+0x8f/0x98
kernel: [<ffffffff8133bad8>] ? _spin_unlock+0x2b/0x30
kernel: [<ffffffff810f0827>] ? alloc_fd+0x116/0x128
kernel: [<ffffffff810da273>] do_sys_open+0x63/0x10f
kernel: [<ffffffff810da352>] sys_open+0x20/0x22
kernel: [<ffffffff8100bb42>] system_call_fastpath+0x16/0x1b

Tyler
