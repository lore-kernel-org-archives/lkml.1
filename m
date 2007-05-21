Return-Path: <linux-kernel-owner+w=401wt.eu-S1762345AbXEUKYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762345AbXEUKYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761610AbXEUKYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:24:14 -0400
Received: from verein.lst.de ([213.95.11.210]:43616 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758325AbXEUKYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:24:12 -0400
Date: Mon, 21 May 2007 12:23:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Chinner <dgc@sgi.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] Re: 2.6.22-rc1-mm1
Message-ID: <20070521102321.GA2632@lst.de>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B304C.5040104@googlemail.com> <20070516094133.bec04e65.akpm@linux-foundation.org> <20070517020600.GS85884050@sgi.com> <20070517084135.GA8510@lst.de> <464CB577.5080106@googlemail.com> <20070518021114.GV86004887@sgi.com> <20070521101141.GX86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521101141.GX86004887@sgi.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 08:11:42PM +1000, David Chinner wrote:
> Christoph - this is an interaction with xfs_buf_associate_memory();
> I'm not sure what it is doing is at all safe now that it never gets
> passed kmem_alloc()d memory - it works for the log recovery case
> because we use it in pairs - once to shorten the buffer and then once
> to put it back the way it was.
> 
> But that doesn't work for the log buffers (we never return them to their
> original state) and the log wrap case looks to work mostly by accident
> now (and could posibly lead to double freeing pages)....
> 
> It seems that what we really need with the new code is a xfs_buf_clone()
> operation followed by trimming the range to what the secondary I/O needs
> to span. This would work for the log buffer case as well. Your thoughts?

xfs_buf_associate_memory is a mess.  My original plan was to get rid of
it, but I kept that out to keep that patchset small and easily reviable,
but it seems like that was a mistake.  My plan is the following:

 - xlog_bread and thus the whole buffer I/O path grows an iooffset
   paramater that specifies at which offset into the buffer we start
   the actual I/O.  That gets rid of all the xfs_buf_associate_memory
   memory uses in the log recovery code
 - add a buffer clone operation as suggested by you above, and use
   the offset in xlog_sync aswell.

until then you patch below looks fine.
   
