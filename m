Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYK1KT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYK1KT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYK1KTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:19:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47812 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYK1KTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:19:46 -0500
Date: Fri, 28 Nov 2008 10:19:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v10][PATCH 08/13] Dump open file descriptors
Message-ID: <20081128101919.GO28946@ZenIV.linux.org.uk>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu> <1227747884-14150-9-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227747884-14150-9-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 08:04:39PM -0500, Oren Laadan wrote:
> +int cr_scan_fds(struct files_struct *files, int **fdtable)
> +{
> +	struct fdtable *fdt;
> +	int *fds;
> +	int i, n = 0;
> +	int tot = CR_DEFAULT_FDTABLE;
> +
> +	fds = kmalloc(tot * sizeof(*fds), GFP_KERNEL);
> +	if (!fds)
> +		return -ENOMEM;
> +
> +	/*
> +	 * We assume that the target task is frozen (or that we checkpoint
> +	 * ourselves), so we can safely proceed after krealloc() from where
> +	 * we left off; in the worst cases restart will fail.
> +	 */

Task may be frozen, but it may share the table with any number of other
tasks...

> +	spin_lock(&files->file_lock);
> +	rcu_read_lock();
> +	fdt = files_fdtable(files);
> +	for (i = 0; i < fdt->max_fds; i++) {
> +		if (!fcheck_files(files, i))
> +			continue;
> +		if (n == tot) {
> +			/*
> +			 * fcheck_files() is safe with drop/re-acquire
> +			 * of the lock, because it tests:  fd < max_fds
> +			 */
> +			spin_unlock(&files->file_lock);
> +			rcu_read_unlock();
> +			tot *= 2;	/* won't overflow: kmalloc will fail */
> +			fds = krealloc(fds, tot * sizeof(*fds), GFP_KERNEL);
> +			if (!fds)
> +				return -ENOMEM;
> +			rcu_read_lock();
> +			spin_lock(&files->file_lock);
> +		}
> +		fds[n++] = i;
> +	}
> +	rcu_read_unlock();
> +	spin_unlock(&files->file_lock);
> +
> +	*fdtable = fds;
> +	return n;
> +}

> +	switch (inode->i_mode & S_IFMT) {
> +	case S_IFREG:
> +		fd_type = CR_FD_FILE;
> +		break;
> +	case S_IFDIR:
> +		fd_type = CR_FD_DIR;
> +		break;
> +	case S_IFLNK:
> +		fd_type = CR_FD_LINK;

Opened symlinks?  May I have whatever you'd been smoking, please?
