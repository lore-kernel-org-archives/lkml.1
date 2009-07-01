Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZGAF4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZGAF4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZGAFz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:55:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53677 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZGAFz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:55:56 -0400
Date: Wed, 1 Jul 2009 07:52:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/3] exec: Allow do_coredump to wait for user space
	pipe readers to complete (v4)
Message-ID: <20090701055151.GB26877@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090630173836.GA15612@hmsreliant.think-freely.org> <20090630174634.GD15612@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630174634.GD15612@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30, Neil Horman wrote:
>
>  void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  {
>  	struct core_state core_state;
>  	char corename[CORENAME_MAX_SIZE + 1];
>  	struct mm_struct *mm = current->mm;
>  	struct linux_binfmt * binfmt;
> -	struct inode * inode;
> -	struct file * file;
> +	struct inode * inode = NULL;
> +	struct file * file = NULL;

why this change?

> @@ -1824,6 +1860,17 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  			       corename);
>   			goto fail_dropcount;
>   		}
> +
> +		/*
> +		 * This lets us wait on a pipe after we close the writing
> +		 * end.  The extra reader count prevents the pipe_inode_info
> +		 * from getting freed.

but it can't be freed until we close file?

> This extra count is reclaimed in
> +		 * wait_for_dump_helpers
> +		 */
> +		pipe = file->f_path.dentry->d_inode->i_pipe;
> +		pipe_lock(pipe);
> +		pipe->readers++;
> +		pipe_unlock(pipe);

why should we inc ->readers in advance?

> +	wait_for_dump_helpers(file);

why do we call it unconditionally and then check ISFIFO? We only need to wait
when ispipe = T, and in that case we know that this file is pipe.

IOW, could you explain why the (much simpler) patch I sent doesn't work ?


Hmm. And in fact that pipe->readers++ above doesn't look right. What if
the core_patter task exits? Since we incremented ->readers we can't notice
the fact there are no readers, and f_op->write() will hang forever.

Oleg.

