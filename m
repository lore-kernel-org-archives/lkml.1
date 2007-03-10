Return-Path: <linux-kernel-owner+w=401wt.eu-S2993157AbXCJBXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993157AbXCJBXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993156AbXCJBXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:23:03 -0500
Received: from kanga.kvack.org ([66.96.29.28]:58367 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993157AbXCJBXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:23:02 -0500
Date: Fri, 9 Mar 2007 20:22:44 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] dio: invalidate clean pages before dio write
Message-ID: <20070310012244.GP6209@kvack.org>
References: <20070309223557.29256.4572.sendpatchset@tetsuo.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309223557.29256.4572.sendpatchset@tetsuo.zabbo.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 02:35:57PM -0800, Zach Brown wrote:
> +	if (rw == WRITE && mapping->nrpages) {
> +		int err = invalidate_inode_pages2_range(mapping,
> +					      offset >> PAGE_CACHE_SHIFT, end);
> +		if (err && retval >= 0)
> +			retval = err;
> +	}

I don't think reporting the error is the correct thing to do in the presense 
of the write having completed.  It's a race that the caller can do nothing 
about and is arguably a kernel bug, so I'd rather do something like:

		if (err) {
			if (!retval)
				retval = err;
			else
				printk_ratelimited(KERN_DEBUG
					"dio sucks and hit the race %ld %ld\n",
					retval, err);
		}

Aside from that, I much prefer this approach to fix the problem than going 
around and changing semantics.  Feel free to add my Signed-off-by.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
