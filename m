Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZBJDh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZBJDh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 22:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZBJDhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 22:37:50 -0500
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:31183 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbZBJDht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:37:49 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Feb 2009 22:37:49 EST
X-IronPort-AV: E=Sophos;i="4.38,183,1233532800"; 
   d="scan'208";a="36528932"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Propagate CRAMFS uncompression errors
Date: Mon, 9 Feb 2009 22:28:15 -0500
Message-ID: <FF038EB85946AA46B18DFEE6E6F8A289950C30@xmb-rtp-218.amer.cisco.com>
In-Reply-To: <20090209151630.4d87ad13.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Propagate CRAMFS uncompression errors
Thread-Index: AcmLDHXY+0u/CWjMTeSDGiBBtoGX9AAItmDg
References: <FF038EB85946AA46B18DFEE6E6F8A2899507E0@xmb-rtp-218.amer.cisco.com> <20090209151630.4d87ad13.akpm@linux-foundation.org>
From: "David VomLehn (dvomlehn)" <dvomlehn@cisco.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Feb 2009 03:28:16.0660 (UTC) FILETIME=[9CC43D40:01C98B2F]
Authentication-Results: rtp-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/rtpdkim2001 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> Sent: Monday, February 09, 2009 3:17 PM
> Subject: Re: [PATCH] Propagate CRAMFS uncompression errors
> 
> "David VomLehn (dvomlehn)" <dvomlehn@cisco.com> wrote:
> 
> > If cramfs_uncompress_block detects an error uncompressing it will
> > return a zero value. This patch checks the return value and 
> propagates
> > the error back up to the block layer.
> > 
> > Signed-off-by: David VomLehn <dvomlehn@cisco.com>
> > ---
> >  fs/cramfs/inode.c |   10 +++++++++-
> >  1 files changed, 9 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> > index a07338d..6ff8a5e 100644
> > --- a/fs/cramfs/inode.c
> > +++ b/fs/cramfs/inode.c
> > @@ -493,7 +493,15 @@ static int cramfs_readpage(struct file *file,
> > struct page * page)
> 
> Your email client is wordwrapping the patches.

Sorry. I sent it to myself first, and didn't have a problem. I hate
email programs.

> >  	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE -
> > bytes_filled);
> >  	kunmap(page);
> >  	flush_dcache_page(page);
> > -	SetPageUptodate(page);
> > +
> > +	if (bytes_filled == 0) {
> > +		ClearPageUptodate(page);
> > +		SetPageError(page);
> > +	}
> > +
> > +	else
> > +		SetPageUptodate(page);
> > +
> >  	unlock_page(page);
> >  	return 0;
> 
> A more typical code layout would be
> 
> 	if (bytes_filled == 0) {
> 		ClearPageUptodate(page);
> 		SetPageError(page);
> 	} else
> 		SetPageUptodate(page);
> 
> or (better, IMO):
> 
> 	if (bytes_filled == 0) {
> 		ClearPageUptodate(page);
> 		SetPageError(page);
> 	} else {
> 		SetPageUptodate(page);
> 	}
> 
> 
> This patch will incorrectly cause the driver to report an IO error if
> the (page->index < maxblock) test returns false.  For example, a
> pread() which is wholly outside the end-of-file should return 
> zero, not
> -EIO.
> 
> cramfs_readpage() handles this case very strangely, although not
> obviously buggily.  Probably this function never even gets 
> called for a
> read wholly outside i_size.
> 
> How does this version look to you?
> 
> --- a/fs/cramfs/inode.c~propagate-cramfs-uncompression-errors
> +++ a/fs/cramfs/inode.c
> @@ -488,12 +488,19 @@ static int cramfs_readpage(struct file *
>  				 compr_len);
>  			mutex_unlock(&read_mutex);
>  		}
> -	} else
> -		pgdata = kmap(page);
> -	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - 
> bytes_filled);
> -	kunmap(page);
> -	flush_dcache_page(page);
> -	SetPageUptodate(page);
> +
> +		if (bytes_filled == 0) {
> +			/* Decompression error */
> +			ClearPageUptodate(page);
> +			SetPageError(page);
> +		} else {
> +			memset(pgdata + bytes_filled, 0,
> +					PAGE_CACHE_SIZE - bytes_filled);
> +			flush_dcache_page(page);
> +			SetPageUptodate(page);
> +		}
> +		kunmap(page);
> +	}
>  	unlock_page(page);
>  	return 0;
>  }

Better, thanks!
