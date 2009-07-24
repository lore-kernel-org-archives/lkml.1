Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbZGXQwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbZGXQwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZGXQwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:52:40 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44469 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZGXQwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:52:37 -0400
Date: Fri, 24 Jul 2009 09:52:37 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/19] ceph: address space operations
In-Reply-To: <20090724065603.GA2045@basil.fritz.box>
Message-ID: <Pine.LNX.4.64.0907240857420.14156@cobra.newdream.net>
References: <1248292313-31326-4-git-send-email-sage@newdream.net>
 <1248292313-31326-5-git-send-email-sage@newdream.net>
 <1248292313-31326-6-git-send-email-sage@newdream.net>
 <1248292313-31326-7-git-send-email-sage@newdream.net>
 <1248292313-31326-8-git-send-email-sage@newdream.net>
 <1248292313-31326-9-git-send-email-sage@newdream.net> <874ot33ddd.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0907231122070.2930@cobra.newdream.net>
 <1248374834.6139.13.camel@heimdal.trondhjem.org>
 <Pine.LNX.4.64.0907231642590.2930@cobra.newdream.net> <20090724065603.GA2045@basil.fritz.box>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009, Andi Kleen wrote:
> > The part I don't understand is what actually happens to pages after the 
> > error flag set.  They're still uptodate, but no longer dirty?  And can be 
> > overwritten/redirtied?  There's also an error flag on the address_space.  
> > Are there any guidelines as far as which should be used?
> 
> Ideally both. The Page error flag prevents the data from being
> consumed and the address space error flag makes sure errors are 
> getting reported on fsync()/close() etc.  Also AS error is useful when
> you don't have a clear page to assign the error to, e.g. if you
> get an error indication that's not tied to a read operation.
> 
> BTW the upcoming hwpoison code can set such errors asynchronously
> under you.

I looked through the various callers, and these look correct:

readpages -- return error code.  Doesn't matter, we'll get a call to 
->readpage later.

writepages (async) -- return error code if we fail during request setup, 
or call mapping_set_error() on completion.  If 
wait_on_page_writeback_range() is any indication, that's correct.


These I'm unsure about:

readpage -- currently calls SetPageError(page) _and_ returns error code.  
I don't see any page error checks outside the writeout paths, so a simple 
return value looks sufficient for a synchronous read.  OTOH 
mpage_end_io_read() and end_buffer_async_read() both do SetPageError() for 
async readpage (although I don't see where that is checked).

writepage -- SetPageError(page) _and_ return error code.  I see that 
wait_on_page_writeback_range() and write_one_page() check the page error 
after wait_on_page_writeback(), so that looks correct for an async 
writepage.  My writepage() is currently synchronous (i.e. does 
wait_on_page_writeback itself), so worry the page error bit is 
superfluous?  I should make it async, regardless.  Also, 
mpage_end_io_write() sets both PageError and AS_EIO on the mapping, so an 
async writepage should also set the mapping bit in the async case.


I'm guessing on the (??) items, but this at least looks consistent (as far 
as the sync vs async implementations go):

readpage (sync) -- return error and SetPageError (??)
readpage (async) -- SetPageError
readpages -- doesn't matter
writepage (sync) -- return error and SetPageError (__writepage() sets 
	mapping error)   (??)
writepage (async) -- SetPageError AND mapping_set_error
writepages (sync) -- return error AND mapping_set_error (??)
writepages (async) -- mapping_set_error

Does that sound right?  If so, I can update 
Documentation/filesystems/vfs.txt appropriately.

Thanks-
sage

