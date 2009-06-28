Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZF2BpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZF2BpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZF2BpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:45:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47746 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbZF2Bo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:44:59 -0400
Date: Mon, 29 Jun 2009 00:24:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v3)
Message-ID: <20090628222455.GA21475@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090629003514.GC2479@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629003514.GC2479@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, Neil Horman wrote:
>
> Allow for the kernel to wait for a core_pattern process to complete

(please change the subject to match)

> One of the things core_pattern processes might do is interrogate the status of a
> crashing process via its /proc/pid directory.  To ensure that that directory is
> not removed prematurely, we wait for the process to exit prior to cleaning it
> up.
>
> Since the addition of this feature makes it possible to block the reaping of a
> crashed process (if the collecting process never exits), Also introduce a new
> sysctl: core_pipe_limit.

Perhaps this sysctl should be added in a separate patch? This patch mixes
differents things imho.

But in fact I don't really understand why do we need the new sysctl. Yes,
if the collecting process never exits, the coredumping thread can't be reaped.
But this process runs as root, it can do other bad things. And let's suppose
it just does nothing, say sleeps forever, and do not read the data from pipe.
In that case, regardless of any sysctls, ->core_dump() never finishes too.

> +fail_dropcount:
> +	if (dump_count) {
> +		while (core_pipe_limit && inode->i_pipe->readers)
> +			pipe_wait(inode->i_pipe);

No, no, this is racy and wrong.

First, it is possible that it exits between ->readers != 0 check and
pipe_wait(), we will sleep forever.

Also, pipe_wait() should be called under pipe_lock(), I guess lockdep
should complain if you test your patch ;)

I'd suggest you to make a simple helper,

	static inline void xxx(struct file *file)
	{
		struct pipe_inode_info *pipe = file->...;

		wait_event(pipe->wait, pipe->readers == 0);
	}

I believe we don't need pipe_lock().

Oleg.

