Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbXGLLO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbXGLLO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 07:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762074AbXGLLOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 07:14:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:43548 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761939AbXGLLOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 07:14:51 -0400
Date: Thu, 12 Jul 2007 13:14:36 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070712111436.GG28613@v2.random>
References: <20070706222651.GG5777@v2.random> <20070708232031.GF12413810@sgi.com> <20070710101148.GJ1482@v2.random> <20070712001256.GI31489@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712001256.GI31489@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 10:12:56AM +1000, David Chinner wrote:
> I need really large filesystems that contain both small and large files to
> work more efficiently on small boxes where we can't throw endless amounts of
> RAM and CPUs at the problem.  Hence things like 64k page size are just not an
> option because of the wastage that it entails.

I didn't know you were allocating 4k pages for the small files and 64k
for the large ones in the same fs. That sounds quite a bit
overkill. So it seems all you really need is to reduce the length of
the sg list?  Otherwise you could do the above fine without order > 0
+ pte changes and memcpy in the defrag code. Given the amount of cpu
you throw at the problem of deciding 4k or 64k pages and the defrag,
and all complexity involved to handle mixed page-cache-sized per
inode, I doubt the cpu saving of the order page size matters much to
you. Probably the main thing you can measure is your storage subsystem
being too slow if the DMA isn't physically contiguous, hence the need
for those larger pages when you do I/O on the big files.

I still think you should run those systems with PAGE_SIZE 64k even if
it'll waste you more memory on the small files.
