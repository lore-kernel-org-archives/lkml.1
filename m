Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbXBJBuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbXBJBuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXBJBuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:50:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59756 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbXBJBuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:50:22 -0500
Date: Fri, 9 Feb 2007 17:50:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] ext2: use perform_write aop
Message-Id: <20070209175017.c8a8c500.akpm@linux-foundation.org>
In-Reply-To: <20070210013407.GB14349@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site>
	<20070208105508.26443.7806.sendpatchset@linux.site>
	<20070209111455.67a69783.akpm@linux-foundation.org>
	<20070209114539.8bd15ee0.akpm@linux-foundation.org>
	<20070210013407.GB14349@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007 02:34:07 +0100
Nick Piggin <npiggin@suse.de> wrote:

> On Fri, Feb 09, 2007 at 11:45:39AM -0800, Andrew Morton wrote:
> > On Fri, 9 Feb 2007 11:14:55 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > If so, that might be preventable by leaving the buffer nonuptodate.
> > 
> > oh, OK, it was buffer_new(), so zeroes are the right thing for a reader to
> > see.
> > 
> > But if it wasn't buffer_new() then the appropriate thing for the reader to
> > see is what's on the disk.  But __block_prepare_write() won't read a buffer
> > which is fully-inside the write area from disk.
> > 
> > And that's seemingly OK, because if a reader gets in there after the short
> > copy, that reader will see the non-uptodate buffer and will populate it
> > from disk.
> > 
> > But doing that will overwrite the data which the write() caller managed to
> > copy into the page before it took a fault.  And that's not OK because
> > block_perform_write() does iovec_iterator_advance(i, copied) in this case
> > and hence will not rerun the copy after acquiring the page lock?
> 
> Hmm, yeah. This can be handled by not advancing partially into a !uptodate
> buffer.

Think so, yeah.

Overall, the implementation you have there seems reasonable to me. 
Basically it's passing the responsibility for preventing the deadlock and
the exposure-of-zeroes problem down into the filesystem itself, where we
have visibility of the state of the various subsections of the page and can
take appropriate actions in response to that.

It's got conceptually harder to follow as a result, which is a shame.  But
still no magic bullet is on offer.

I pity the poor schmuck who has to write ext3_journalled_perform_write(),
ext3_ordered_perform_write(), ext3_writeback_perform_write(),
ext3_writeback_nobh_perform_write() and all that other stuff.  But I think
we need to do that pretty soon to validate the whole approach.  Also xfs
and reiser3.

NTFS will be interesting from the can-this-be-made-to-work POV.

Is NFS vulnerable to the deadlock?  It looks to be.  Shudder.

We'd need to find a way of communicating all this to the poor old
fs maintainers.

