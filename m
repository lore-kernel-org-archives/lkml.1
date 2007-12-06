Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbXLFReh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbXLFReh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXLFRe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:34:29 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48084 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbXLFRe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:34:28 -0500
Date: Thu, 6 Dec 2007 10:34:26 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Liam Howlett <howlett@gmail.com>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Subject: Re: NFS Killable tasks request comments on patch
Message-ID: <20071206173426.GC15868@parisc-linux.org>
References: <20071204212543.GA6907@solidsnake>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204212543.GA6907@solidsnake>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 04:25:43PM -0500, Liam Howlett wrote:
> This patch removes the rpc sigmask code and changes the
> out_of_line_wait_on_bit and wait_on_bit calls in the sched.c file to
> use TASK_KILLABLE.  The result of this patch is the ability to kill
> commands issued to a dead NFS mount by the normal ctrl+c method.  I am

I've done a more thorough review of Liam's work and come up with a few
more fixes (which I'll publish later today), but more importantly, a
list of questions for the NFS/RPC people:

1. __nfs_revalidate_inode - with an error return from nfs_wait_on_inode(),
   shouldn't we go to out_nowait()?

2. nfs4_set_lock_task_retry - shouldn't we honour the fatal signal, and,
   say, set the timeout to MAXTIMEOUT?

3. Can we make nfs use rpc_wait_bit_killable()?  I think there's two places
   that exact function is duplicated.

4. Can we remove the 'action' parameter from
   __rpc_wait_for_completion_task()?  It's always NULL.

5. Should xprt_rdma_free be using wait_event_killable?
   Ditto rpcrdma_ep_connect and rpcrdma_ep_disconnect

I think we're going to find a lot of places where attention hasn't been
paid to the 'intr' case.  It's always been a wart, so I'm unsurprised it
doesn't get much testing.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
