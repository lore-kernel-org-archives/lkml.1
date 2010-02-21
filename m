Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab0BUDCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 22:02:41 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:14744 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab0BUDCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 22:02:39 -0500
Date: Sat, 20 Feb 2010 19:02:38 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Chris Frost <chris@frostnet.net>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Benny Halevy <bhalevy@panasas.com>, Andrew@firstfloor.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Steve VanDeBogart <vandebo-lkml@nerdbox.net>,
       linux-fsdevel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] fs: add fincore(2) (mincore(2) for file descriptors)
Message-ID: <20100221030238.GA26511@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216181312.GA9700@frostnet.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 10:13:12AM -0800, Chris Frost wrote:
> Add the fincore() system call. fincore() is mincore() for file descriptors.
> 
> The functionality of fincore() can be emulated with an mmap(), mincore(),
> and munmap(), but this emulation requires more system calls and requires
> page table modifications. fincore() can provide a significant performance
> improvement for non-sequential in-core queries.

In addition to being expensive, mmap/mincore/munmap perturb the VM's
eviction algorithm -- a page is less likely to be evicted if it's
mmapped when being considered for eviction.

I frequently see this happen when using mincore(1) from
http://bitbucket.org/radii/mincore/ -- "watch mincore -v *.big" while
*.big are being sequentially read results in a significant number of
pages remaining in-core, whereas if I only run mincore after the
sequential read is complete, the large files will be nearly-completely
out of core (except for the tail of the last file, of course).

It's very interesting to watch
% watch --interval=.5 mincore -v *

while an IO-intensive process is happening, such as mke2fs on a
filesystem image.

So, I support the addition of fincore(2) and would use it if it were
merged.

-andy
