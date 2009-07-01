Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbZGAQKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbZGAQKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZGAQJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:09:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34011 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbZGAQJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:09:38 -0400
Date: Wed, 1 Jul 2009 18:06:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, akpm@linux-foundation.org, earl_chew@agilent.com
Subject: Re: [PATCH 3/3] exec: Allow do_coredump to wait for user space
	pipe readers to complete (v5)
Message-ID: <20090701160610.GA32012@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090701152640.GD29601@hmsreliant.think-freely.org> <20090701153757.GG29601@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701153757.GG29601@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil, the changelog is not right,

On 07/01, Neil Horman wrote:
>
> We basically add ourselves as an additional
> reader (to prevent cleanup of the pipe), write the dump in ->core_dump(),

This is not what we do. We do not and must not inc readers before
->core_dump(). We only do this in wait_for_dump_helpers().

> note that we add ourselves as a reader before writing the
> file.  this closes the race in the window between the time we write the dump and
> the time we start checking for the user space process to be done with the pipe.

again, this doesn't match the patch.

> +static void wait_for_dump_helpers(struct file *file)
> +{
> +	struct pipe_inode_info *pipe;
> + 
> +	pipe = file->f_path.dentry->d_inode->i_pipe;
> + 
> +	pipe_lock(pipe);
> +	pipe->readers++;
> +	pipe->writers--;
> +	while (pipe->readers > 1) {
> +		wake_up_interruptible_sync(&pipe->wait);
> +		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
> +		pipe_wait(pipe);
> +	}
> + 
> +	/*
> +	 * This reclaims the additional readers count we took in
> +	 * do_coredump
> +	 */

now the comment is wrong.

Can't understand why do you change readers/writers unconditianally,
we shouldn't have the false wakeups since ->writers == 0, but OK.

Oleg.

