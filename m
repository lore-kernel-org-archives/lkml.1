Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbZCFWzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbZCFWzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZCFWzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:55:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40087 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZCFWzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:55:37 -0500
Date: Fri, 6 Mar 2009 22:55:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Walter <stevenrwalter@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: cache aliasing in dup_mmap
Message-ID: <20090306225525.GB3212@n2100.arm.linux.org.uk>
References: <e06498070903061426o5875ad13hc6328aa0d3f08ed7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e06498070903061426o5875ad13hc6328aa0d3f08ed7@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 05:26:24PM -0500, Steven Walter wrote:
> I've been tracking down an instance of userspace data corruption, and I
> believe I have found a window during fork where data can be lost.  The
> corruption is occurring on an ARMv5 system with VIVT caches.  Here's the
> scenario in question.  Thread A is forking, Thread B is running in
> userspace:

With VIVT caches, you're missing a few things here:

> Thread A: flush_cache_mm (dup_mmap)

-- cache written back and invalidated

> Thread B: writes to a page in the above mm

-- cache written back and invalidated

> Thread A: pte_wrprotect the above page (copy_one_pte)

-- cache written back and invalidated

> Thread B: writes to the same page again
> 
> During thread B's second write, he'll take a fault and enter the do_wp_page
> case.  We'll end up calling copy_page, which notably uses the kernel virtual
> addresses for the old and new pages.  This means that the new page does not
> necessarily have the data from the first write.

Given the additional flushing I've mentioned above, where could the
problem be?
