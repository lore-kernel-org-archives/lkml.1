Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbYLARsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbYLARsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYLARrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:47:53 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48274 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYLARrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:47:52 -0500
Subject: Re: [RFC v10][PATCH 08/13] Dump open file descriptors
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081128101919.GO28946@ZenIV.linux.org.uk>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
	 <1227747884-14150-9-git-send-email-orenl@cs.columbia.edu>
	 <20081128101919.GO28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 09:47:25 -0800
Message-Id: <1228153645.2971.36.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 10:19 +0000, Al Viro wrote:
> On Wed, Nov 26, 2008 at 08:04:39PM -0500, Oren Laadan wrote:
> > +int cr_scan_fds(struct files_struct *files, int **fdtable)
> > +{
> > +	struct fdtable *fdt;
> > +	int *fds;
> > +	int i, n = 0;
> > +	int tot = CR_DEFAULT_FDTABLE;
> > +
> > +	fds = kmalloc(tot * sizeof(*fds), GFP_KERNEL);
> > +	if (!fds)
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * We assume that the target task is frozen (or that we checkpoint
> > +	 * ourselves), so we can safely proceed after krealloc() from where
> > +	 * we left off; in the worst cases restart will fail.
> > +	 */
> 
> Task may be frozen, but it may share the table with any number of other
> tasks...

First of all, thanks for looking at this, Al.  

I think Oren's assumption here is that all tasks possibly sharing the
table would be frozen.  I don't think that's a good assumption,
either. :)

This would be a lot safer and bulletproof if we size the allocation
ahead of time, take all the locks, then retry if the size has changed.

I think that will just plain work of we do this:

> > +	spin_lock(&files->file_lock);
> > +	rcu_read_lock();
> > +	fdt = files_fdtable(files);
> > +	for (i = 0; i < fdt->max_fds; i++) {
> > +		if (!fcheck_files(files, i))
> > +			continue;
> > +		if (n == tot) {
> > +			/*
> > +			 * fcheck_files() is safe with drop/re-acquire
> > +			 * of the lock, because it tests:  fd < max_fds
> > +			 */
> > +			spin_unlock(&files->file_lock);
> > +			rcu_read_unlock();
> > +			tot *= 2;	/* won't overflow: kmalloc will fail */

			  free(fds);
			  goto first_kmalloc_in_this_function;

> > +		}
> > +		fds[n++] = i;
> > +	}
> > +	rcu_read_unlock();
> > +	spin_unlock(&files->file_lock);
> > +
> > +	*fdtable = fds;
> > +	return n;
> > +}

Right?

> > +	switch (inode->i_mode & S_IFMT) {
> > +	case S_IFREG:
> > +		fd_type = CR_FD_FILE;
> > +		break;
> > +	case S_IFDIR:
> > +		fd_type = CR_FD_DIR;
> > +		break;
> > +	case S_IFLNK:
> > +		fd_type = CR_FD_LINK;
> 
> Opened symlinks?  May I have whatever you'd been smoking, please?

Ugh, that certainly doesn't have any place here.  I do wonder if Oren
had some use for that in the fully put together code, but it can
certainly go for now.

I'll send patches for these shortly.

-- Dave

