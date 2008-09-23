Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbYIWKii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbYIWKii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 06:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYIWKib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 06:38:31 -0400
Received: from relay.gothnet.se ([82.193.160.251]:8548 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750959AbYIWKia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 06:38:30 -0400
X-Greylist: delayed 996 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2008 06:38:29 EDT
Message-ID: <48D8C326.80909@tungstengraphics.com>
Date: Tue, 23 Sep 2008 12:21:26 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: keith.packard@intel.com, eric@anholt.net, hugh@veritas.com,
       hch@infradead.org, airlied@linux.ie, jbarnes@virtuousgeek.org,
       dri-devel@lists.sourceforge.net,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm: pageable memory allocator (for DRM-GEM?)
References: <20080923091017.GB29718@wotan.suse.de>
In-Reply-To: <20080923091017.GB29718@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Hi,
>
> So I promised I would look at this again, because I (and others) have some
> issues with exporting shmem_file_setup for DRM-GEM to go off and do things
> with.
>
> The rationale for using shmem seems to be that pageable "objects" are needed,
> and they can't be created by userspace because that would be ugly for some
> reason, and/or they are required before userland is running.
>
> I particularly don't like the idea of exposing these vfs objects to random
> drivers because they're likely to get things wrong or become out of synch
> or unreviewed if things change. I suggested a simple pageable object allocator
> that could live in mm and hide the exact details of how shmem / pagecache
> works. So I've coded that up quickly.
>
> Upon actually looking at how "GEM" makes use of its shmem_file_setup filp, I
> see something strange... it seems that userspace actually gets some kind of
> descriptor, a descriptor to an object backed by this shmem file (let's call it
> a "file descriptor"). Anyway, it turns out that userspace sometimes needs to
> pread, pwrite, and mmap these objects, but unfortunately it has no direct way
> to do that, due to not having open(2)ed the files directly. So what GEM does
> is to add some ioctls which take the "file descriptor" things, and derives
> the shmem file from them, and then calls into the vfs to perform the operation.
>
> If my cursory reading is correct, then my allocator won't work so well as a
> drop in replacement because one isn't allowed to know about the filp behind
> the pageable object. It would also indicate some serious crack smoking by
> anyone who thinks open(2), pread(2), mmap(2), etc is ugly in comparison...
>
> So please, nobody who worked on that code is allowed to use ugly as an
> argument. Technical arguments are fine, so let's try to cover them.
>
>   
Nick,
 From my point of view, this is exactly what's needed, although there 
might be some different opinions among the
DRM developers. A question:

Sometimes it's desirable to indicate that a page / object is "cleaned", 
which would mean data has moved and is backed by device memory. In that 
case one could either free the object or indicate to it that it can 
release it's pages. Is freeing / recreating such an object an expensive 
operation? Would it, in that case, be possible to add an object / page 
"cleaned" function?

/Thomas
 








