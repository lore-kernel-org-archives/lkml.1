Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZB1BeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZB1BeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZB1Bd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:33:56 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33942 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbZB1Bd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:33:56 -0500
Date: Fri, 27 Feb 2009 17:33:02 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org
Subject: Re: [RFC][PATCH 4/8] file c/r: expose functions to query fs support
Message-ID: <20090228013302.GC19872@us.ibm.com>
References: <20090227203425.F3B51176@kernel> <20090227203429.6963AFC4@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227203429.6963AFC4@kernel>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen [dave@linux.vnet.ibm.com] wrote:
| 
| This pair of functions will check to see whether a given
| 'struct file' can be checkpointed.  If it can't be, the
| "explain" function can also give a description why.
| 
| Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
| ---
| 
|  linux-2.6.git-dave/checkpoint/ckpt_file.c     |   46 ++++++++++++++++++++++++++
|  linux-2.6.git-dave/include/linux/checkpoint.h |   18 ++++++++++
|  2 files changed, 64 insertions(+)
| 
| diff -puN checkpoint/ckpt_file.c~cr-explain-unckpt-file checkpoint/ckpt_file.c
| --- linux-2.6.git/checkpoint/ckpt_file.c~cr-explain-unckpt-file	2009-02-27 12:07:38.000000000 -0800
| +++ linux-2.6.git-dave/checkpoint/ckpt_file.c	2009-02-27 12:07:38.000000000 -0800
| @@ -72,6 +72,52 @@ int cr_scan_fds(struct files_struct *fil
|  	return n;
|  }
| 
| +int fs_is_cr_able(struct file_system_type *fs_type)

Too many variations in naming ? "*cr_able(), *supported(), *checkpointable()'
all for a boolean result.

How about calling this cr_fs_checkpointable() ?

| +{
| +	if (fs_type->fs_flags & FS_CHECKPOINTABLE)
| +		return 1;
| +	/*
| +	 * We assume that all block-based filesystems that
| +	 * need devices work.  This covers all of the
| +	 * "important" fs's by default like ext*.  If this
| +	 * assumption becomes untrue, we may need a
| +	 * NOT_CHECKPOINTABLE flag in the future
| +	 */
| +	if (fs_type->fs_flags & FS_REQUIRES_DEV)
| +		return 1;
| +	return 0;
| +}
| +
| +int cr_explain_file(struct file *file, char *explain, int left)
| +{
| +	struct inode *inode = file->f_dentry->d_inode;
| +	struct file_system_type *fs_type = inode->i_sb->s_type;
| +
| +	if (!fs_is_cr_able(fs_type))
| +		return snprintf(explain, left,
| +				" (%s does not support checkpoint)",
| +				fs_type->name);
| +
| +	if (special_file(inode->i_mode))
| +		return snprintf(explain, left, " (special file)");
| +
| +	return 0;
| +}
| +
| +int cr_file_supported(struct file *file)

and this cr_file_checkpointable() ?

Sukadev
