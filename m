Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYLLUMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYLLUMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYLLUMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:12:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53354 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYLLUMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:12:23 -0500
Date: Fri, 12 Dec 2008 21:24:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: andi@firstfloor.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm 1/5] nilfs2: fix problems of memory allocation in ioctl
Message-ID: <20081212202411.GK25779@one.firstfloor.org>
References: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <871vwdcxo1.fsf@basil.nowhere.org> <20081213.034808.104867584.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081213.034808.104867584.ryusuke@osrg.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> By the way, is there any recommended way to exchange such a large
> amount of data items between user space and kernel space?
> 
> In the current interface, each data item is copied twice: one is to
> the allocated memory from user space (via copy_from_user), and another

For such large copies it is better to use multiple smaller (e.g. 4K) 
copy user, that gives better real time preempt latencies. Each cfu has a 
cond_resched(), but only one, not multiple times in the inner loop.

> is to on-memory structures or to buffers/pages from the allocated
> memory.

It depends how performance critical it is.

One way for example is to grab the user pages using get_user_pages()
and then reference those pages directly using kmap().
But you would be at the mercy of the user process not modifying in 
parallel then. Normally it is safer to work from copies in kernel
space to avoid races. As long as it doesn't happen too often a few
copies are also usually not a problem. I wouldn't worry about them
unless you see them prominently in profiler logs.

-Andi


-- 
ak@linux.intel.com
