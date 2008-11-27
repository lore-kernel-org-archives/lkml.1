Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbYK0RAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbYK0RAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYK0Q7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:59:45 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:46005 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbYK0Q7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:59:44 -0500
Date: Thu, 27 Nov 2008 09:59:27 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, julia@diku.dk,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix mmap2 error handling
Message-ID: <20081127165926.GM25548@parisc-linux.org>
References: <20081127151238.13728.34704.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127151238.13728.34704.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 03:12:38PM +0000, David Howells wrote:
> Fix the error handling in sys_mmap2().  Currently, if the pgoff check fails,
> fput() might have to be called (which it isn't), so do the pgoff check first,
> before fget() is called.

*sigh*.

My reaction was "Why do we have sys_mmap2 in every architecture?"  So I
started looking.  Oh dear, oh dear oh dear.

FRV:
        /* As with sparc32, make sure the shift for mmap2 is constant
           (12), no matter what PAGE_SIZE we have.... */
ia64:
Just uses PAGE_SIZE (currently supported values: 4k, 8k, 16k and 64k).

So what is poor userspace to do?  Check which architecture it's on and
figure out what PAGE_SIZE to use for mmap2 based on that?


How about we introduce a sys_mmap6() in common code which takes 'off'
in multiples of 4k.  Then FRV and other sane architectures can replace
their sys_mmap2 entries in their syscall tables with sys_mmap6.  ia64 has
to keep its insane sys_mmap2 entry, but it can add a sys_mmap6 entry too.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
