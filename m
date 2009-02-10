Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZBJDsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZBJDsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 22:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZBJDsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 22:48:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbZBJDsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:48:30 -0500
Date: Mon, 9 Feb 2009 19:48:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David VomLehn (dvomlehn)" <dvomlehn@cisco.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Propagate CRAMFS uncompression errors
Message-Id: <20090209194825.e052e07a.akpm@linux-foundation.org>
In-Reply-To: <FF038EB85946AA46B18DFEE6E6F8A289950C30@xmb-rtp-218.amer.cisco.com>
References: <FF038EB85946AA46B18DFEE6E6F8A2899507E0@xmb-rtp-218.amer.cisco.com>
	<20090209151630.4d87ad13.akpm@linux-foundation.org>
	<FF038EB85946AA46B18DFEE6E6F8A289950C30@xmb-rtp-218.amer.cisco.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 22:28:15 -0500 "David VomLehn (dvomlehn)" <dvomlehn@cisco.com> wrote:

> 
> > From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> > Sent: Monday, February 09, 2009 3:17 PM
> > Subject: Re: [PATCH] Propagate CRAMFS uncompression errors
> > 
> > "David VomLehn (dvomlehn)" <dvomlehn@cisco.com> wrote:
> > 
> > > If cramfs_uncompress_block detects an error uncompressing it will
> > > return a zero value. This patch checks the return value and 
> > propagates
> > > the error back up to the block layer.
> > > 
> > > Signed-off-by: David VomLehn <dvomlehn@cisco.com>
> > > ---
> > >  fs/cramfs/inode.c |   10 +++++++++-
> > >  1 files changed, 9 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> > > index a07338d..6ff8a5e 100644
> > > --- a/fs/cramfs/inode.c
> > > +++ b/fs/cramfs/inode.c
> > > @@ -493,7 +493,15 @@ static int cramfs_readpage(struct file *file,
> > > struct page * page)
> > 
> > Your email client is wordwrapping the patches.
> 
> Sorry. I sent it to myself first, and didn't have a problem. I hate
> email programs.
> 
> > >  	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE -
> > > bytes_filled);
> > >  	kunmap(page);
> > >  	flush_dcache_page(page);
> > > -	SetPageUptodate(page);
> > > +
> > > +	if (bytes_filled == 0) {
> > > +		ClearPageUptodate(page);
> > > +		SetPageError(page);
> > > +	}
> > > +
> > > +	else
> > > +		SetPageUptodate(page);
> > > +
> > >  	unlock_page(page);
> > >  	return 0;
> > 
> > A more typical code layout would be
> > 
> > 	if (bytes_filled == 0) {
> > 		ClearPageUptodate(page);
> > 		SetPageError(page);
> > 	} else
> > 		SetPageUptodate(page);
> > 
> > or (better, IMO):
> > 
> > 	if (bytes_filled == 0) {
> > 		ClearPageUptodate(page);
> > 		SetPageError(page);
> > 	} else {
> > 		SetPageUptodate(page);
> > 	}
> > 
> > 
> > This patch will incorrectly cause the driver to report an IO error if
> > the (page->index < maxblock) test returns false.  For example, a
> > pread() which is wholly outside the end-of-file should return 
> > zero, not
> > -EIO.
> > 
> > cramfs_readpage() handles this case very strangely, although not
> > obviously buggily.  Probably this function never even gets 
> > called for a
> > read wholly outside i_size.
> > 
> > How does this version look to you?
> > 
> > --- a/fs/cramfs/inode.c~propagate-cramfs-uncompression-errors
> > +++ a/fs/cramfs/inode.c
> > @@ -488,12 +488,19 @@ static int cramfs_readpage(struct file *
> >  				 compr_len);
> >  			mutex_unlock(&read_mutex);
> >  		}
> > -	} else
> > -		pgdata = kmap(page);
> > -	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - 
> > bytes_filled);
> > -	kunmap(page);
> > -	flush_dcache_page(page);
> > -	SetPageUptodate(page);
> > +
> > +		if (bytes_filled == 0) {
> > +			/* Decompression error */
> > +			ClearPageUptodate(page);
> > +			SetPageError(page);
> > +		} else {
> > +			memset(pgdata + bytes_filled, 0,
> > +					PAGE_CACHE_SIZE - bytes_filled);
> > +			flush_dcache_page(page);
> > +			SetPageUptodate(page);
> > +		}
> > +		kunmap(page);
> > +	}
> >  	unlock_page(page);
> >  	return 0;
> >  }
> 
> Better, thanks!

umm...

Nope, it's still not right.  We'll treat this case:

		if (compr_len == 0)
			; /* hole */

as an IO error.  grr.

--- a/fs/cramfs/inode.c~cramfs-propagate-uncompression-errors
+++ a/fs/cramfs/inode.c
@@ -477,7 +477,7 @@ static int cramfs_readpage(struct file *
 		mutex_unlock(&read_mutex);
 		pgdata = kmap(page);
 		if (compr_len == 0)
-			; /* hole */
+			goto out; /* hole */
 		else if (compr_len > (PAGE_CACHE_SIZE << 1))
 			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
 		else {
@@ -488,12 +488,20 @@ static int cramfs_readpage(struct file *
 				 compr_len);
 			mutex_unlock(&read_mutex);
 		}
-	} else
-		pgdata = kmap(page);
-	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - bytes_filled);
-	kunmap(page);
-	flush_dcache_page(page);
-	SetPageUptodate(page);
+
+		if (bytes_filled == 0) {
+			/* Decompression error */
+			ClearPageUptodate(page);
+			SetPageError(page);
+		} else {
+			memset(pgdata + bytes_filled, 0,
+					PAGE_CACHE_SIZE - bytes_filled);
+			flush_dcache_page(page);
+			SetPageUptodate(page);
+		}
+		kunmap(page);
+	}
+out:
 	unlock_page(page);
 	return 0;
 }
_

