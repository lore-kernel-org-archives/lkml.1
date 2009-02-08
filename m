Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZBHWQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZBHWQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZBHWQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:16:32 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:62165 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368AbZBHWQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:16:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAObojkl5LClx/2dsb2JhbADMVYQaBg
X-IronPort-AV: E=Sophos;i="4.37,401,1231075800"; 
   d="scan'208";a="285836570"
Date: Mon, 9 Feb 2009 09:16:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-xfs <linux-xfs@oss.sgi.com>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
Message-ID: <20090208221625.GB8830@disturbed>
Mail-Followup-To: Alessandro Bono <alessandro.bono@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@oss.sgi.com>
References: <1234011974.7435.11.camel@champagne.cantina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234011974.7435.11.camel@champagne.cantina>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 02:06:13PM +0100, Alessandro Bono wrote:
> Hi all
> 
> This time I hit kernel bug without any particular operation, normal
> browsing, mail, news, etc
> tell me if you need info asap because I want to reformat this machine
> and switch back to ext3.
>
> xfs seems really unstable in this particular
> machine and after this crash I lose again configuration file of opened
> program at crash time

That's not XFS's fault - that's a broken application that does not
safely overwrite files and hence you lose data on crash.

> Feb  7 12:43:12 champagne kernel: [ 5828.167041] ------------[ cut
> here ]------------
> Feb  7 12:43:12 champagne kernel: [ 5828.167048] kernel BUG at
> fs/buffer.c:470!

I can't remember seeing that problem before.

> Call Trace:
>  [<ffffffff8022806f>] ?  need_resched+0x1e/0x28
>  [<ffffffff8030be35>] ?  __up_write+0x12/0x45
>  [<ffffffffa01c2269>] ?  xfs_destroy_ioend+0x23/0x71 [xfs]
>  [<ffffffffa01c23db>] ?  xfs_end_bio_delalloc+0x0/0x19 [xfs]
>  [<ffffffffa01c23db>] ?  xfs_end_bio_delalloc+0x0/0x19 [xfs]
>  [<ffffffff80242d5e>] ?  run_workqueue+0x79/0xfe
>  [<ffffffff80242ed3>] ?  worker_thread+0xf0/0x102
>  [<ffffffff802461cd>] ?  autoremove_wake_function+0x0/0x2e
>  [<ffffffff80242de3>] ?  worker_thread+0x0/0x102
>  [<ffffffff80245ea2>] ?  kthread+0x47/0x73
>  [<ffffffff80231bfa>] ?  schedule_tail+0x27/0x60
>  [<ffffffff8020c3f9>] ?  child_rip+0xa/0x11
>  [<ffffffff80245e5b>] ?  kthread+0x0/0x73
>  [<ffffffff8020c3ef>] ?  child_rip+0x0/0x11

Standard delayed allocation IO completion trace. No idea what
could have caused it. Perhaps a memory error? 

Can you send the output of xfs_info on that filesystem, and
perhaps run an xfs_repair -n  on it to see if there are any
undetected errors on disk?

Also, I note that you are using ext4 on some disks. Does this
problem show up if you don't use ext4 at all? (We have had problems
in the past with one filesystem not leaving bufferheads in the
correct state and the system crashing when a different type of
filesystem got them reallocated).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
