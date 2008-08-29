Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYH2WnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYH2WnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbYH2Wm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:42:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636AbYH2Wm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:42:56 -0400
Date: Fri, 29 Aug 2008 15:42:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aaron Straus <aaron@merfinllc.com>
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, tytso@mit.edu,
       stable@kernel.org
Subject: Re: drivers/char/random.c line 728 BUG
Message-Id: <20080829154215.970fd4c1.akpm@linux-foundation.org>
In-Reply-To: <20080829223155.GM31108@merfinllc.com>
References: <20080826225918.GC5452@merfinllc.com>
	<20080828225924.GD6432@merfinllc.com>
	<20080829124807.54293904.akpm@linux-foundation.org>
	<20080829223155.GM31108@merfinllc.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 15:31:55 -0700
Aaron Straus <aaron@merfinllc.com> wrote:

> > -	if (r == &input_pool &&
> > -	    r->entropy_count >= random_read_wakeup_thresh) {
> > +	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
> >  		wake_up_interruptible(&random_read_wait);
> >  		kill_fasync(&fasync, SIGIO, POLL_IN);
> >  	}
> > -
> > +	r->entropy_count = entropy_count;
> 
> Here you set the entropy_count in the pool *after* waking up the reader.
> I was a little worried the reader would find the entropy_count unchanged
> and go back to sleep.
> 

Probably it doesn't matter because of the coverage of the lock but yes,
let's do the assignment first.

--- a/drivers/char/random.c~drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug-fix-fix
+++ a/drivers/char/random.c
@@ -535,13 +535,13 @@ static void credit_entropy_bits(struct e
 		entropy_count = 0;
 	} else if (entropy_count > r->poolinfo->POOLBITS)
 		entropy_count = r->poolinfo->POOLBITS;
+	r->entropy_count = entropy_count;
 
 	/* should we wake readers? */
 	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
 		wake_up_interruptible(&random_read_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
 	}
-	r->entropy_count = entropy_count;
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
_

