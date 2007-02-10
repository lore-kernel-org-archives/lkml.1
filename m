Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXBJBeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXBJBeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbXBJBeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:34:10 -0500
Received: from ns1.suse.de ([195.135.220.2]:49869 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbXBJBeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:34:09 -0500
Date: Sat, 10 Feb 2007 02:34:07 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] ext2: use perform_write aop
Message-ID: <20070210013407.GB14349@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105508.26443.7806.sendpatchset@linux.site> <20070209111455.67a69783.akpm@linux-foundation.org> <20070209114539.8bd15ee0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209114539.8bd15ee0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 11:45:39AM -0800, Andrew Morton wrote:
> On Fri, 9 Feb 2007 11:14:55 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > If so, that might be preventable by leaving the buffer nonuptodate.
> 
> oh, OK, it was buffer_new(), so zeroes are the right thing for a reader to
> see.
> 
> But if it wasn't buffer_new() then the appropriate thing for the reader to
> see is what's on the disk.  But __block_prepare_write() won't read a buffer
> which is fully-inside the write area from disk.
> 
> And that's seemingly OK, because if a reader gets in there after the short
> copy, that reader will see the non-uptodate buffer and will populate it
> from disk.
> 
> But doing that will overwrite the data which the write() caller managed to
> copy into the page before it took a fault.  And that's not OK because
> block_perform_write() does iovec_iterator_advance(i, copied) in this case
> and hence will not rerun the copy after acquiring the page lock?

Hmm, yeah. This can be handled by not advancing partially into a !uptodate
buffer.
