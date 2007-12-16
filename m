Return-Path: <linux-kernel-owner+w=401wt.eu-S935127AbXLPRg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127AbXLPRg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 12:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934417AbXLPRgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 12:36:20 -0500
Received: from waste.org ([66.93.16.53]:46414 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbXLPRgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 12:36:19 -0500
Date: Sun, 16 Dec 2007 11:34:17 -0600
From: Matt Mackall <mpm@selenic.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [RANDOM] Move two variables to read_mostly section to save memory
Message-ID: <20071216173416.GW19691@waste.org>
References: <47650FBD.2060209@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47650FBD.2060209@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 12:45:01PM +0100, Eric Dumazet wrote:
> While examining vmlinux namelist on i686, I noticed :
> 
> c0581300 D random_table
> c0581480 d input_pool
> c0581580 d random_read_wakeup_thresh
> c0581584 d random_write_wakeup_thresh
> c0581600 d blocking_pool
> 
> That means that the two integers random_read_wakeup_thresh and 
> random_write_wakeup_thresh use a full cache entry (128 bytes).

But why did that happen?

Probably because of this:

        spinlock_t lock ____cacheline_aligned_in_smp;

in struct entropy_store.

And that comes from here:

http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=47b54fbff358a1d5ee4738cec8a53a08bead72e4;hp=ce334bb8f0f084112dcfe96214cacfa0afba7e10

So we could save more memory by just dropping that alignment.

The trick is to improve the scalability without it. Currently, for
every 10 bytes read, we hash the whole output pool and do three
feedback cycles, each grabbing the lock briefly and releasing it. We
also need to grab the lock every 128 bytes to do some accounting. So
we do 40 locks every 128 output bytes! Also, the output pool itself
gets bounced back and forth like mad too.

I'm actually in the middle of redoing some patches that will reduce
this to one lock per 10 bytes, or 14 locks per 128 bytes. 

But we can't do much better than that without some fairly serious
restructuring. Like switching to SHA-512, which would take us to one
lock for every 32 output bytes, or 5 locks per 128 bytes with accounting.

We could also switch to per-cpu output pools for /dev/urandom, which
would add 128 bytes of data per CPU, but would eliminate the lock
contention and the pool cacheline bouncing. Is it worth the added
complexity? Probably not.

-- 
Mathematics is the supreme nostalgia of our time.
