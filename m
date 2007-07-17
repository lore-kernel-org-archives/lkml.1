Return-Path: <linux-kernel-owner+w=401wt.eu-S1762807AbXGQTdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762807AbXGQTdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763908AbXGQTdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:33:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:58977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935800AbXGQTdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:33:21 -0400
Date: Tue, 17 Jul 2007 21:33:08 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070717193308.GD25301@v2.random>
References: <20070706222651.GG5777@v2.random> <1183764801.10287.233.camel@localhost> <20070706235228.GL5777@v2.random> <20070717174737.GM6909@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717174737.GM6909@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 10:47:37AM -0700, William Lee Irwin III wrote:
> You may rest assured that it's technically feasible. It's been done.
> The larger obstacles to all this are nontechnical.

Back then there was no variable order page size proposal, no slub,
generally nothing of that kind.

I think these days it worth to get it working again and solve the
technical obstacles once more time. Then we should plug into it a
pagecache logic to handle small files. That means if the soft page
size is 64k, we should kmalloc 32k of pagecache if the file is < 64k
but >= 32k, or kmalloc 16k if the file is < 32k but >= 16k, etc...

Down to 32bytes if we memcpy the 32bytes away to a 64k page, and we
disable the logic the moment somebody attempts to mmap the "kmalloced"
pagecache (which I think it's a lot simpler than trying to mmap a
kmalloced 4k naturally aligned object into userland). I wouldn't call
it tail packing, it's more a fine-granular pagecache with the already
available kmalloc granularities. That will maximize pagecache
utilization with read syscall for hg/git compared to current 2.6.22
plus memory will be allocated faster in 64k chunks etc... Ideally it
should be possible to disable the finer-granular-kmalloc-pagecache on
the big irons with lots of memory and only working with big files.
