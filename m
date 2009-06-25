Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZFYRsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZFYRsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZFYRrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:47:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZFYRrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:47:52 -0400
Date: Thu, 25 Jun 2009 13:47:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/11] vfs: Add better VFS support for page_mkwrite
	when blocksize < pagesize
Message-ID: <20090625174754.GA21957@infradead.org>
References: <1245088797-29533-1-git-send-email-jack@suse.cz> <1245088797-29533-3-git-send-email-jack@suse.cz> <20090625161753.GB30755@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625161753.GB30755@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 06:17:53PM +0200, Nick Piggin wrote:
> Basically the problems is that i_op->truncate a) cannot return an error
> (which is causing problems missing -EIO today anyway), and b) is called
> after i_size update which makes it not possible to error-out without
> races anyway, and c) does not get the old i_size so you can't unmap the
> last partial page with it.
> 
> My patch is basically moving ->truncate call into setattr, and have
> the filesystem call vmtruncate. I've jt to clean up loose ends.

We absolutely need to get rid of ->truncate.  Due to the above issues
XFS already does the majority of the truncate work from setattr, and it
works pretty well.  The only problem is the generic aops calling
vmtruncate directly.

