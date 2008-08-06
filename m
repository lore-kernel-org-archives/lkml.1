Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbYHFW4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbYHFW4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYHFW43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:56:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbYHFW42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:56:28 -0400
Date: Wed, 6 Aug 2008 15:55:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, ospite@studenti.unina.it, matthew@wil.cx,
       nickpiggin@yahoo.com.au
Subject: Re: BUG in VFS or block layer
Message-Id: <20080806155547.619f13f8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0808061838340.2145-100000@iolanthe.rowland.org>
References: <20080806142805.9db6f52f.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0808061838340.2145-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 18:40:54 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 6 Aug 2008, Andrew Morton wrote:
> 
> > What the VFS will do is
> > 
> > - lock the page
> > 
> > - put the page into a BIO and send it down to the block layer
> > 
> > - later, wait for IO completion.  It does this by running
> >   lock_page[_killable](), which will waiting for the page to come unlocked.
> > 
> >   The page comes unlocked via the device driver, usually within the
> >   IO completion interrupt.
> > 
> > 
> > A common cause of userspace lockups during IO errors is that the driver
> > layer screwed up and didn't run the completion callback.
> > 
> > Now, according to the above trace, the above code sequence _did_ work
> > OK.  Or at least, it ran to completion.  It was later, when we tried to
> > truncate a file that we stumbled across a permanently-locked page.
> > 
> > So it would appear that the VFS read() code successfully completed, but
> > left locked pages behind it, which caused the truncate to hang.
> 
> ...
> 
> > One possible problem is here:
> > 
> > readpage:
> > 		/* Start the actual read. The read will unlock the page. */
> > 		error = mapping->a_ops->readpage(filp, page);
> > 
> > 		if (unlikely(error)) {
> > 			if (error == AOP_TRUNCATED_PAGE) {
> > 				page_cache_release(page);
> > 				goto find_page;
> > 			}
> > 			goto readpage_error;
> > 		}
> > 
> > the VFS layer assumes that if ->readpage() returned a synchronous error
> > then the page was already unlocked within ->readpage().  Usually this
> > means that the driver layer had to run the BIO completion callback to
> > do that unlocking.  It is possible that the USB code forgot to do this.
> > This would explain what you're seeing.
> > 
> > So...  would you be able to verify that the USB, layer is correctly
> > calling bio->bi_end_io() for the offending requests?
> 
> The USB layer doesn't handle that; the SCSI layer takes care of it.  
> Possibly the I/O error confuses the code in and around 
> scsi_end_request().  I'll have to do some testing to find out.
> 

Well...  looking at your patch to
drivers/usb/gadget/file_storage.c:do_read(), it appears that
do_scsi_command() just drops do_read()'s error code on the floor rather
than returning it to the scsi layer?

