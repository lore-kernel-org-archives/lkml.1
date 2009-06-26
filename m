Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZFZImc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZFZImc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZFZImY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:42:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbZFZImX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:42:23 -0400
Date: Fri, 26 Jun 2009 10:42:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/11] vfs: Add better VFS support for page_mkwrite when blocksize < pagesize
Message-ID: <20090626084225.GA12201@wotan.suse.de>
References: <1245088797-29533-1-git-send-email-jack@suse.cz> <1245088797-29533-3-git-send-email-jack@suse.cz> <20090625161753.GB30755@wotan.suse.de> <20090625174754.GA21957@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625174754.GA21957@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 01:47:55PM -0400, Christoph Hellwig wrote:
> On Thu, Jun 25, 2009 at 06:17:53PM +0200, Nick Piggin wrote:
> > Basically the problems is that i_op->truncate a) cannot return an error
> > (which is causing problems missing -EIO today anyway), and b) is called
> > after i_size update which makes it not possible to error-out without
> > races anyway, and c) does not get the old i_size so you can't unmap the
> > last partial page with it.
> > 
> > My patch is basically moving ->truncate call into setattr, and have
> > the filesystem call vmtruncate. I've jt to clean up loose ends.
> 
> We absolutely need to get rid of ->truncate.  Due to the above issues
> XFS already does the majority of the truncate work from setattr, and it
> works pretty well.

Yes well we could get rid of ->truncate and have filesystems do it
themselves in setattr, but I figure that moving truncate into
generic setattr is helpful (makes conversions a bit easier too).
Did you see my patch? What do you think of that basic approach?


>  The only problem is the generic aops calling
> vmtruncate directly.

What should be done is require that filesystems trim blocks past
i_size in case of any errors. I actually need to fix up a few
existing bugs in this area too, so I'll look at this..

