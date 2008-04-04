Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbYDDB1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbYDDB1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbYDDB1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:27:44 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40619 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752831AbYDDB1n (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:27:43 -0400
Date: Fri, 4 Apr 2008 11:27:35 +1000
From: David Chinner <dgc@sgi.com>
To: Jan Kara <jack@suse.cz>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: BUG: ext3 hang in transaction commit
Message-ID: <20080404012735.GA103491721@sgi.com>
References: <20080326231612.GC103491721@sgi.com> <20080403100742.GA16314@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403100742.GA16314@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 12:07:42PM +0200, Jan Kara wrote:
>   Hi,
> 
> > ia32 XFS QA machine, ext3 root on a raw partition. 2.6.25-rc3.
> > 
> > kjournald hung journal_commit_transaction():
> > 
> > Stack traceback for pid 2046
> > 0xf6e0b350     2046        2  0    0   D  0xf6e0b550  kjournald
> > esp        eip        Function (args)
> > 0xf68d5e70 0xc04c20b2 schedule+0x51e
> > 0xf68d5ec0 0xc04c2394 io_schedule+0x1d
> > 0xf68d5ecc 0xc0179b64 sync_buffer+0x33 (invalid)
> > 0xf68d5ed4 0xc04c2570 __wait_on_bit+0x36 (0xc2000b78, 0xf68d5f00, 0xc0179b31, 0x2)
> > 0xf68d5ef0 0xc04c25ef out_of_line_wait_on_bit+0x58 (0xde89bc18, 0x2, 0xc0179b31, 0x2)
> > 0xf68d5f2c 0xc0179adf __wait_on_buffer+0x19
> > 0xf68d5f38 0xc01cecba journal_commit_transaction+0x40b (0xf6d94a00)
> > 0xf68d5fa0 0xc01d180a kjournald+0xa4 (0xf6d94a00)
> > 0xf68d5fd4 0xc01301f1 kthread+0x3b (invalid)
> 
>   I suppose this is wait_on_buffer() in line 444 in fs/jbd/commit.c, isn't it?

No idea. I haven't looked at the code....

> > We're waiting on the last page/buffer in the file, and it doesn't appear
> > to be under writeback....
>   We wait for write of ordered-data to finish. Which seems to never
> happen. Page isn't under writeback, but that just means we submitted the
> buffer from the commit code (that doesn't change the page state).
>   Anyway, the cause is that either due to some bug IO never finished and

Yes, I certainly beleive that is possible. We see it often enough with
XFS....

> so buffer never got unlocked, or we somewhere locked the buffer and
> forgot to unlock it (but I've checked all the relevant places and think
> they are correct). The traces of all the processes seem harmless - I see
> no place trace where we are holding a buffer lock.
>   If you happen to hit this again, please let me know and I'll look into
> it further...

Will do.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
