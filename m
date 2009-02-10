Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbZBJFLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbZBJFLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 00:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbZBJFLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 00:11:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667AbZBJFLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 00:11:41 -0500
Date: Mon, 9 Feb 2009 21:10:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dvomlehn@cisco.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Propagate CRAMFS uncompression errors
Message-Id: <20090209211049.eef3c126.akpm@linux-foundation.org>
In-Reply-To: <1234238761.17414.2.camel@cuplxvomd02.corp.sa.net>
References: <FF038EB85946AA46B18DFEE6E6F8A2899507E0@xmb-rtp-218.amer.cisco.com>
	<20090209151630.4d87ad13.akpm@linux-foundation.org>
	<FF038EB85946AA46B18DFEE6E6F8A289950C30@xmb-rtp-218.amer.cisco.com>
	<20090209194825.e052e07a.akpm@linux-foundation.org>
	<1234238761.17414.2.camel@cuplxvomd02.corp.sa.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Feb 2009 20:06:01 -0800 David VomLehn <dvomlehn@cisco.com> wrote:

> 
> On Mon, 2009-02-09 at 19:48 -0800, Andrew Morton wrote:
> ...
> > 
> > umm...
> > 
> > Nope, it's still not right.  We'll treat this case:
> > 
> > 		if (compr_len == 0)
> > 			; /* hole */
> > 
> > as an IO error.  grr.
> > 
> > --- a/fs/cramfs/inode.c~cramfs-propagate-uncompression-errors
> > +++ a/fs/cramfs/inode.c
> > @@ -477,7 +477,7 @@ static int cramfs_readpage(struct file *
> >  		mutex_unlock(&read_mutex);
> >  		pgdata = kmap(page);
> >  		if (compr_len == 0)
> > -			; /* hole */
> > +			goto out; /* hole */
> >  		else if (compr_len > (PAGE_CACHE_SIZE << 1))
> >  			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
> >  		else {
> > @@ -488,12 +488,20 @@ static int cramfs_readpage(struct file *
> >  				 compr_len);
> >  			mutex_unlock(&read_mutex);
> >  		}
> > -	} else
> > -		pgdata = kmap(page);
> > -	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - bytes_filled);
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
> > +out:
> >  	unlock_page(page);
> >  	return 0;
> >  }
> 
> Is that actually an error. The comment in the code is, uh, a bit terse,
> but I took it to mean that there was a deliberate hole, just like holes
> in files that should read as all zeroes. But even if it's actually an
> error, we still need to kunmap the page

Yes, we need to unmap the page.

It's better to perform those checks before mapping it.

--- a/fs/cramfs/inode.c~cramfs-propagate-uncompression-errors
+++ a/fs/cramfs/inode.c
@@ -475,25 +475,32 @@ static int cramfs_readpage(struct file *
 			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4, 4);
 		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4) - start_offset);
 		mutex_unlock(&read_mutex);
-		pgdata = kmap(page);
 		if (compr_len == 0)
-			; /* hole */
-		else if (compr_len > (PAGE_CACHE_SIZE << 1))
-			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
-		else {
-			mutex_lock(&read_mutex);
-			bytes_filled = cramfs_uncompress_block(pgdata,
-				 PAGE_CACHE_SIZE,
-				 cramfs_read(sb, start_offset, compr_len),
-				 compr_len);
-			mutex_unlock(&read_mutex);
+			goto out; /* hole */
+		if (compr_len > (PAGE_CACHE_SIZE << 1)) {
+			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n",
+					compr_len);
+			goto out;
 		}
-	} else
 		pgdata = kmap(page);
-	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - bytes_filled);
-	kunmap(page);
-	flush_dcache_page(page);
-	SetPageUptodate(page);
+		mutex_lock(&read_mutex);
+		bytes_filled = cramfs_uncompress_block(pgdata, PAGE_CACHE_SIZE,
+			 cramfs_read(sb, start_offset, compr_len), compr_len);
+		mutex_unlock(&read_mutex);
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

But if address_space_operations.readpage() encounters a hole, it is
supposed to return zeroes to userspace (see, for example,
block_read_full_page()'s !buffer_mapped() handling).

Sigh.  That code needs more thought than I am apparently able to give it :(
