Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZB1C6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZB1C6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZB1C6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:58:38 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41578 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbZB1C6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:58:37 -0500
Date: Fri, 27 Feb 2009 18:57:43 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
Message-ID: <20090228025743.GA22451@us.ibm.com>
References: <20090227203425.F3B51176@kernel> <20090227203435.98735E54@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227203435.98735E54@kernel>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen [dave@linux.vnet.ibm.com] wrote:
| 
| Introduce a files_struct counter to indicate whether a particular
| file_struct has ever contained a file which can not be
| checkpointed.  This flag is a one-way trip; once it is set, it may
| not be unset.
| 
| We assume at allocation that a new files_struct is clean and may
| be checkpointed.  However, as soon as it has had its files filled
| from its parent's, we check it for real in __scan_files_for_cr().
| At that point, we mark it if it contained any uncheckpointable
| files.

Hmm. Why not just copy ->may_checkpoint setting from parent (or old)
files_struct ? If parent is not checkpointable, then child won't be
and vice-versa - no ?

| 
| We also check each 'struct file' when it is installed in a fd
| slot.  This way, if anyone open()s or managed to dup() an
| unsuppored file, we can catch it.
| 
| Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
| ---
| 
|  linux-2.6.git-dave/fs/file.c                  |   19 +++++++++++++++++++
|  linux-2.6.git-dave/fs/open.c                  |    5 +++++
|  linux-2.6.git-dave/include/linux/checkpoint.h |   14 ++++++++++++++
|  linux-2.6.git-dave/include/linux/fdtable.h    |    3 +++
|  4 files changed, 41 insertions(+)
| 
| diff -puN fs/file.c~track-files_struct-checkpointability fs/file.c
| --- linux-2.6.git/fs/file.c~track-files_struct-checkpointability	2009-02-27 12:07:41.000000000 -0800
| +++ linux-2.6.git-dave/fs/file.c	2009-02-27 12:07:41.000000000 -0800
| @@ -15,6 +15,7 @@
|  #include <linux/file.h>
|  #include <linux/fdtable.h>
|  #include <linux/bitops.h>
| +#include <linux/checkpoint.h>
|  #include <linux/interrupt.h>
|  #include <linux/spinlock.h>
|  #include <linux/rcupdate.h>
| @@ -285,6 +286,20 @@ static int count_open_files(struct fdtab
|  	return i;
|  }
| 
| +static void __scan_files_for_cr(struct files_struct *files)
| +{
| +	int i;
| +
| +	for (i = 0; i < files->fdtab.max_fds; i++) {
| +		struct file *f = fcheck_files(files, i);
| +		if (!f)
| +			continue;
| +		if (cr_file_supported(f))
| +			continue;
| +		files_deny_checkpointing(files);
| +	}
| +}
| +

A version of __scan_files_for_cr() for CONFIG_CHECKPOINT_RESTART=n or...

|  /*
|   * Allocate a new files structure and copy contents from the
|   * passed in files structure.
| @@ -303,6 +318,9 @@ struct files_struct *dup_fd(struct files
|  		goto out;
| 
|  	atomic_set(&newf->count, 1);
| +#ifdef CONFIG_CHECKPOINT_RESTART
| +	newf->may_checkpoint = 1;
| +#endif
| 
|  	spin_lock_init(&newf->file_lock);
|  	newf->next_fd = 0;
| @@ -396,6 +414,7 @@ struct files_struct *dup_fd(struct files
| 
|  	rcu_assign_pointer(newf->fdt, new_fdt);
| 
| +	__scan_files_for_cr(newf);

... #ifdef CONFIG_CHECKPOINT_RESTART here ?

Sukadev
