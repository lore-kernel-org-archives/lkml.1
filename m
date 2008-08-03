Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYHCBoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYHCBoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 21:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYHCBoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 21:44:11 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41198 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbYHCBoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 21:44:10 -0400
Date: Sat, 2 Aug 2008 19:44:09 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Simon Horman <horms@verge.net.au>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tony Luck <tony.luck@intel.com>, Keith Owens <kaos@ocs.com.au>
Subject: Re: [patch] IA64: suppress return value of down_trylock() in salinfo_work_to_do()
Message-ID: <20080803014408.GC26461@parisc-linux.org>
References: <20080803000654.GA30659@verge.net.au> <20080803013159.GB26461@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080803013159.GB26461@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 07:32:00PM -0600, Matthew Wilcox wrote:
> I can't say that I think this is a good idea.  Has anyone looked at what
> it would take to actually track this?  For example, could we ever have
> the situation where:

Looking at this a bit more deeply, it seems to be a simple abuse of a
semaphore.

It's used both to exclude other tasks in salinfo_event_read() and as a
wake queue from interrupt context.  I think what we want is something
more like this:

	spin_lock(&data_saved_lock);
	if (!worktodo) {
		if (O_NONBLOCK)
			spin_unlock()
			return;
		else
			add to wait queue
			spin_unlock()
			schedule()
			spin_lock()
	}

Then we can just use wake_up() from interrupt context.

Thoughts?  I don't have any idea how to generate salinfo events, so I
wouldn't be able to test.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
