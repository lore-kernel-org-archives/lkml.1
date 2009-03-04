Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZCDXmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZCDXmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbZCDXls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:41:48 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46315 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbZCDXlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:41:47 -0500
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org
In-Reply-To: <20090228025743.GA22451@us.ibm.com>
References: <20090227203425.F3B51176@kernel>
	 <20090227203435.98735E54@kernel>  <20090228025743.GA22451@us.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 15:41:41 -0800
Message-Id: <1236210101.22399.55.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 18:57 -0800, Sukadev Bhattiprolu wrote: 
> Dave Hansen [dave@linux.vnet.ibm.com] wrote:
> | 
> | Introduce a files_struct counter to indicate whether a particular
> | file_struct has ever contained a file which can not be
> | checkpointed.  This flag is a one-way trip; once it is set, it may
> | not be unset.
> | 
> | We assume at allocation that a new files_struct is clean and may
> | be checkpointed.  However, as soon as it has had its files filled
> | from its parent's, we check it for real in __scan_files_for_cr().
> | At that point, we mark it if it contained any uncheckpointable
> | files.
> 
> Hmm. Why not just copy ->may_checkpoint setting from parent (or old)
> files_struct ? If parent is not checkpointable, then child won't be
> and vice-versa - no ?

Because init does things that are uncheckpointable.  If we purely
inherit, we'll never be able to checkpoint.

> | +static void __scan_files_for_cr(struct files_struct *files)
> | +{
> | +	int i;
> | +
> | +	for (i = 0; i < files->fdtab.max_fds; i++) {
> | +		struct file *f = fcheck_files(files, i);
> | +		if (!f)
> | +			continue;
> | +		if (cr_file_supported(f))
> | +			continue;
> | +		files_deny_checkpointing(files);
> | +	}
> | +}
> | +
> 
> A version of __scan_files_for_cr() for CONFIG_CHECKPOINT_RESTART=n or...
> 
> |  /*
> |   * Allocate a new files structure and copy contents from the
> |   * passed in files structure.
> | @@ -303,6 +318,9 @@ struct files_struct *dup_fd(struct files
> |  		goto out;
> | 
> |  	atomic_set(&newf->count, 1);
> | +#ifdef CONFIG_CHECKPOINT_RESTART
> | +	newf->may_checkpoint = 1;
> | +#endif
> | 
> |  	spin_lock_init(&newf->file_lock);
> |  	newf->next_fd = 0;
> | @@ -396,6 +414,7 @@ struct files_struct *dup_fd(struct files
> | 
> |  	rcu_assign_pointer(newf->fdt, new_fdt);
> | 
> | +	__scan_files_for_cr(newf);
> 
> ... #ifdef CONFIG_CHECKPOINT_RESTART here ?

gcc isn't quite smart enough to figure out that this is a noop.  Please
see my new set for a new compiler helper to solve this problem.

-- Dave

