Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbZGCKTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbZGCKTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZGCKTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:19:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52814 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZGCKS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:18:59 -0400
Date: Fri, 3 Jul 2009 12:16:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com, andi@firstfloor.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 3/3] exec: Allow do_coredump to wait for user space
	pipe readers to complete (v7)
Message-ID: <20090703101606.GB5764@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090702225714.GA11447@hmsreliant.think-freely.org> <20090702230131.GD11447@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702230131.GD11447@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Neil Horman wrote:
>
> +static void wait_for_dump_helpers(struct file *file)
> +{
> +	struct pipe_inode_info *pipe;
> +
> +	pipe = file->f_path.dentry->d_inode->i_pipe;
> +
> +	pipe_lock(pipe);
> +	pipe->readers++;
> +	pipe->writers--;
> +
> +	while ((pipe->readers > 1) && (!fatal_signal_pending(current))) {
> +		wake_up_interruptible_sync(&pipe->wait);
> +		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
> +		pipe_wait(pipe);
> +	}

The kernel can hang on UP machine.

Suppose that rt task starts the coredump and then recieves a non-fatal
signal before core_pattern app closes stdin.

In that case this "while()" above becomes a busy-wait loop which never
stops.

Neil, please use signal_pending() as I said. Yes, this means wait_for_
will abort if we recieve a non-fatal signal. But as I said we have other
problems with signals here, when we fix them wait_for_dump_helpers()
will be fixed automatically.

Oleg.

