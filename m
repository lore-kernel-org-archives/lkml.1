Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYFRTsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYFRTsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 15:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYFRTsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 15:48:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58877 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYFRTsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 15:48:37 -0400
Date: Wed, 18 Jun 2008 15:48:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       zach.brown@oracle.com, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: invalidate async directio writes
Message-ID: <20080618194823.GA7237@infradead.org>
References: <x49ej6uy5qo.fsf@segfault.boston.devel.redhat.com> <20080618182223.GA14851@infradead.org> <x49abhiy1bb.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49abhiy1bb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 03:45:28PM -0400, Jeff Moyer wrote:
> > Can we please move all these aio_complete calls to user context?  Having
> > AIO contexts completing from irq context is a major pain for complex
> > filesystems like XFS.
> 
> Can you help me understand why this is a pain?  I'm having trouble
> making the connection.

With your patch we complete aio dio write request in user context, which
is great for filesystems that need to do more complex activity in the
completion handler, e.g. XFS for the unwritten extent conversion.  But
only doing this for the write case is only very partially useful, we
should be doing this for the read case, too.

See fs/xfs/linux-2.6/xfs_aops.c:xfs_end_io_direct() for what I mean.
