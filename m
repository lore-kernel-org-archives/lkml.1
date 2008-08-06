Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbYHFWlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbYHFWlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYHFWk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:40:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42127 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753161AbYHFWkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:40:55 -0400
Date: Wed, 6 Aug 2008 18:40:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, <ospite@studenti.unina.it>,
       Matthew Wilcox <matthew@wil.cx>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: BUG in VFS or block layer
In-Reply-To: <20080806142805.9db6f52f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0808061838340.2145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Andrew Morton wrote:

> What the VFS will do is
> 
> - lock the page
> 
> - put the page into a BIO and send it down to the block layer
> 
> - later, wait for IO completion.  It does this by running
>   lock_page[_killable](), which will waiting for the page to come unlocked.
> 
>   The page comes unlocked via the device driver, usually within the
>   IO completion interrupt.
> 
> 
> A common cause of userspace lockups during IO errors is that the driver
> layer screwed up and didn't run the completion callback.
> 
> Now, according to the above trace, the above code sequence _did_ work
> OK.  Or at least, it ran to completion.  It was later, when we tried to
> truncate a file that we stumbled across a permanently-locked page.
> 
> So it would appear that the VFS read() code successfully completed, but
> left locked pages behind it, which caused the truncate to hang.

...

> One possible problem is here:
> 
> readpage:
> 		/* Start the actual read. The read will unlock the page. */
> 		error = mapping->a_ops->readpage(filp, page);
> 
> 		if (unlikely(error)) {
> 			if (error == AOP_TRUNCATED_PAGE) {
> 				page_cache_release(page);
> 				goto find_page;
> 			}
> 			goto readpage_error;
> 		}
> 
> the VFS layer assumes that if ->readpage() returned a synchronous error
> then the page was already unlocked within ->readpage().  Usually this
> means that the driver layer had to run the BIO completion callback to
> do that unlocking.  It is possible that the USB code forgot to do this.
> This would explain what you're seeing.
> 
> So...  would you be able to verify that the USB, layer is correctly
> calling bio->bi_end_io() for the offending requests?

The USB layer doesn't handle that; the SCSI layer takes care of it.  
Possibly the I/O error confuses the code in and around 
scsi_end_request().  I'll have to do some testing to find out.

Alan Stern

