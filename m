Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbYJaUbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbYJaUbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 16:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYJaUbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 16:31:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbYJaUbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 16:31:24 -0400
Date: Fri, 31 Oct 2008 16:31:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: do_sync() and XFSQA test 182 failures....
Message-ID: <20081031203123.GA11514@infradead.org>
References: <20081030085020.GP17077@disturbed> <20081030224625.GA18690@infradead.org> <20081031001249.GM4985@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031001249.GM4985@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 11:12:49AM +1100, Dave Chinner wrote:
> Right - that's exactly where we should be going with this, I think.
> I'd suggest two callouts, perhaps: ->sync_data and ->sync_metadata.
> The freeze code can then still operate in two stages, and we can
> also use then for separating data and inode writeback in pdflush....
> 
> FWIW, I mentioned doing this sort of thing here:
> 
> http://xfs.org/index.php/Improving_inode_Caching#Avoiding_the_Generic_pdflush_Code
> 
> I think I'll look at redoing do_sync() to provide a custom sync
> method before trying to fix XFS....

And you weren't the first to thing of this.  Reiser4 for example
has bad a patch forever to turn sync_sb_inodes into a filesystem method,
and I think something similar is what we want.  When talking about
syncing we basically want a few things:

 - sync out data, either async (from pdflush) or sync
   (from sync, freeze, remount ro or unmount)
 - sync out metadata (from pdflush), either async or sync
   (from sync, freeze, remount ro or unmount)

and then we want pdflush / sync / etc call into it.  If we are doing
this correctly this would also avoid having our own xfssyncd.

And as we found out it's not just sync that gets it wrong, it's also
fsync (which isn't part of the above picture as it's per-inode) that
gets this utterly wrong, as well as all kinds of syncs, not just the
unmount one.  Combine this with the other data integrity issues Nick
found in write_cache_pages I come to the conclusion that this whole area
needs some profound audit and re-architecture urgently.


