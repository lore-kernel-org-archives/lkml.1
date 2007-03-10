Return-Path: <linux-kernel-owner+w=401wt.eu-S1030334AbXCJJZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030334AbXCJJZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030321AbXCJJZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:25:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42418 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030250AbXCJJZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:25:43 -0500
Date: Sat, 10 Mar 2007 09:25:41 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] fs: introduce perform_write aop
Message-ID: <20070310092541.GA22182@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mark Fasheh <mark.fasheh@oracle.com>, Nick Piggin <npiggin@suse.de>,
	Linux Filesystems <linux-fsdevel@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105458.26443.41479.sendpatchset@linux.site> <20070309103913.GA4503@infradead.org> <20070309233301.GC18555@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309233301.GC18555@ca-server1.us.oracle.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 03:33:01PM -0800, Mark Fasheh wrote:
> ->kernel_write() as opposed to genericizing ->perform_write() would be fine
> with me. Just so long as we get rid of ->prepare_write and ->commit_write in
> that other kernel code doesn't call them directly. That interface just
> doesn't work for Ocfs2.

It doesn't work for any filesystem that needs slightly fancy locking.
That and the reason that's an interface that doesn't fit into our
layering is why I want to get rid of it.  Note that fops->kernel_write
might in fact use ->perform_write with an actor as Nick suggested.
I'm not quite sure how it'll look like - I'd rather take care of the
buffered write path first and then handle this issue once the first
changes have stabilized.

> Right now I've got Ocfs2 implementing it's own lowest-level buffered write
> code - think generic_file_buffered_write() replacement for Ocfs2. With some
> duplicated code above that layer. What's nice is that I can abstract away
> the "copy data into some target pages" bits such that the majority of that
> code is re-usable for ocfs2's splice write operation. I'm not sure we could
> have that low a level of abstraction for anyhing above individual the file
> system though which also has to deal with non-kernel writes though. That's
> where a ->kernel_write() might come in handy.

Why do you need your own low level buffered write functionality?  As in
past times when filesystems want to come up I'd like to have a very
good exaplanation on why you think it's needed and whether we shouldn't
improve the generic buffered write code instead.  This codepath is so nasty
that any duplication will be a maintaince horror.

