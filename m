Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbXF3KV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbXF3KV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 06:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbXF3KVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 06:21:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51516 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbXF3KVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 06:21:15 -0400
Date: Sat, 30 Jun 2007 11:21:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com,
       xfs@oss.sgi.com
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070630102111.GB23568@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
	suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com
References: <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626103247.GA19870@amitarora.in.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 04:02:47PM +0530, Amit K. Arora wrote:
> > Can you clarify - what is the current behaviour when ENOSPC (or some other
> > error) is hit?  Does it keep the current fallocate() or does it free it?
> 
> Currently it is left on the file system implementation. In ext4, we do
> not undo preallocation if some error (say, ENOSPC) is hit. Hence it may
> end up with partial (pre)allocation. This is inline with dd and
> posix_fallocate, which also do not free the partially allocated space.

I can't find anything in the specification of posix_fallocate
(http://www.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html)
that tells what should happen to allocate blocks on error.

But common sense would be to not leak disk space on failure of this
syscall, and this definitively should not be left up to the filesystem,
either we always leak it or always free it, and I'd strongly favour
the latter variant.

> > For FA_ZERO_SPACE - I'd think this would (IMHO) be the default - we
> > don't want to expose uninitialized disk blocks to userspace.  I'm not
> > sure if this makes sense at all.
> 
> I don't think we need to make it default - atleast for filesystems which
> have a mechanism to distinguish preallocated blocks from "regular" ones.
> In ext4, for example, we will have a way to mark uninitialized extents.
> All the preallocated blocks will be part of these uninitialized extents.
> And any read on these extents will treat them as a hole, returning
> zeroes to user land. Thus any existing data on uninitialized blocks will
> not be exposed to the userspace.

This is the xfs unwritten extent behaviour.  But anyway, the important bit
is uninitialized blocks should never ever leak to userspace, so there is
not need for the flag.
