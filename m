Return-Path: <linux-kernel-owner+w=401wt.eu-S1758445AbXKASfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445AbXKASfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXKASfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:35:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52221 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbXKASfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:35:40 -0400
Subject: Re: per-bdi-throttling: synchronous writepage doesn't work
	correctly
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <1193937408.27652.326.camel@twins>
References: <E1IndEw-00046x-00@dorka.pomaz.szeredi.hu>
	 <1193935886.27652.313.camel@twins>
	 <E1IndPT-00047e-00@dorka.pomaz.szeredi.hu>
	 <1193936949.27652.321.camel@twins>  <1193937408.27652.326.camel@twins>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 19:35:32 +0100
Message-Id: <1193942132.27652.331.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 18:16 +0100, Peter Zijlstra wrote:
> On Thu, 2007-11-01 at 18:09 +0100, Peter Zijlstra wrote:
> > On Thu, 2007-11-01 at 18:00 +0100, Miklos Szeredi wrote:
> > > > > Hi,
> > > > > 
> > > > > It looks like bdi_thresh will always be zero if filesystem does
> > > > > synchronous writepage, resulting in very poor write performance.
> > > > > 
> > > > > Hostfs (UML) is one such example, but there might be others.
> > > > > 
> > > > > The only solution I can think of is to add a set_page_writeback();
> > > > > end_page_writeback() pair (or some reduced variant, that only does
> > > > > the proportions magic).  But that means auditing quite a few
> > > > > filesystems...
> > > > 
> > > > Ouch...
> > > > 
> > > > I take it there is no other function that is shared between all these
> > > > writeout paths which we could stick a bdi_writeout_inc(bdi) in?
> > > 
> > > No, and you can't detect it from the callers either I think.
> > 
> > The page not having PG_writeback set on return is a hint, but not fool
> > proof, it could be the device is just blazing fast.
> > 
> > I guess there is nothing to it but for me to grep writepage and manually
> > look at all hits...
> 
>   writepage: called by the VM to write a dirty page to backing store.
>       This may happen for data integrity reasons (i.e. 'sync'), or
>       to free up memory (flush).  The difference can be seen in
>       wbc->sync_mode.
>       The PG_Dirty flag has been cleared and PageLocked is true.
>       writepage should start writeout, should set PG_Writeback,
>       and should make sure the page is unlocked, either synchronously
>       or asynchronously when the write operation completes.
> 
>       If wbc->sync_mode is WB_SYNC_NONE, ->writepage doesn't have to
>       try too hard if there are problems, and may choose to write out
>       other pages from the mapping if that is easier (e.g. due to
>       internal dependencies).  If it chooses not to start writeout, it
>       should return AOP_WRITEPAGE_ACTIVATE so that the VM will not keep
>       calling ->writepage on that page.
> 
>       See the file "Locking" for more details.
> 
> 
> The "should set PG_Writeback" bit threw me off I guess.

Hmm, set_page_writeback() is also the one clearing the radix tree dirty
tag. So if that is not called, we get in a bit of a mess, no?

Which makes me think hostfs is buggy.

