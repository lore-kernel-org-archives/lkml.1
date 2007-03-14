Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbXCNRBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbXCNRBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXCNRBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:01:46 -0400
Received: from mail.alkar.net ([195.248.191.95]:59073 "EHLO mail.alkar.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbXCNRBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:01:45 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2007 13:01:45 EDT
From: "Vladimir V. Saveliev" <vs@namesys.com>
To: "Nate Diller" <nate.diller@gmail.com>
Subject: Re: [BUG] reiser4: page lock recursion in reiser4_write_extent
Date: Wed, 14 Mar 2007 19:30:46 +0300
User-Agent: KMail/1.8.2
Cc: reiserfs-dev@namesys.com, "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <5c49b0ed0703132240h2087eb12xb44652bf0d235521@mail.gmail.com>
In-Reply-To: <5c49b0ed0703132240h2087eb12xb44652bf0d235521@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703141930.46868.vs@namesys.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Wednesday 14 March 2007 08:40, Nate Diller wrote:
> This little code snippet seems to have a page_lock recursion, in
> addition to overall looking particularly fragile to me.  It seems to
> be handling the case where a page needs to be brought uptodate because
> a partial page write is being done.  The page gets locked as many as 3
> times, each checking PageUptodate, however the two failure cases here
> go BUG() instead of returning an error.  I'm starting to think that
> somehow the whole suspect branch just never gets taken, because
> otherwise I would expect to see bug reports related to -EIO, -ENOMEM,
> etc causing this to barf.
> 
> either way, it seems there's a lock recursion if another thread races
> to bring @page uptodate while we're waiting on the first lock_page()
> call.
> 
> ---
> 
>                 page = jnode_page(jnodes[i]);
>                 if (page_offset(page) < inode->i_size &&
>                     !PageUptodate(page) && to_page != PAGE_CACHE_SIZE) {
>                         /*
>                          * the above is not optimal for partial write to last
>                          * page of file when file size is not at boundary of
>                          * page
>                          */
> takes the lock
>                         lock_page(page);
> raced with readpage?
>                         if (!PageUptodate(page)) {
> readpage drops lock
>                                 result = readpage_unix_file(NULL, page);
>                                 BUG_ON(result != 0);
> -ENOMEM?
>                                 /* wait for read completion */
>                                 lock_page(page);
>                                 BUG_ON(!PageUptodate(page));
> -EIO?
>                                 unlock_page(page);
>                         } else
> still have the lock here
>                                 result = 0;
>                 }
> 
>                 BUG_ON(get_current_context()->trans->atom != NULL);
>                 fault_in_pages_readable(buf, to_page);
>                 BUG_ON(get_current_context()->trans->atom != NULL);
> 
> BOOM!!!
>                 lock_page(page);
>                 if (!PageUptodate(page) && to_page != PAGE_CACHE_SIZE) {

you are right, I will make a patch.
