Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZBJEG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZBJEG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 23:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZBJEGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 23:06:20 -0500
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:39148 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZBJEGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 23:06:19 -0500
X-IronPort-AV: E=Sophos;i="4.38,183,1233532800"; 
   d="scan'208";a="36493944"
Subject: Re: [PATCH] Propagate CRAMFS uncompression errors
From: David VomLehn <dvomlehn@cisco.com>
Reply-To: dvomlehn@cisco.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090209194825.e052e07a.akpm@linux-foundation.org>
References: <FF038EB85946AA46B18DFEE6E6F8A2899507E0@xmb-rtp-218.amer.cisco.com>
	 <20090209151630.4d87ad13.akpm@linux-foundation.org>
	 <FF038EB85946AA46B18DFEE6E6F8A289950C30@xmb-rtp-218.amer.cisco.com>
	 <20090209194825.e052e07a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 20:06:01 -0800
Message-Id: <1234238761.17414.2.camel@cuplxvomd02.corp.sa.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8)
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Feb 2009 04:06:15.0900 (UTC) FILETIME=[EB4CA9C0:01C98B34]
X-ST-MF-Message-Resent: 2/9/2009 23:06
Authentication-Results: rtp-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/rtpdkim1001 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-02-09 at 19:48 -0800, Andrew Morton wrote:
...
> 
> umm...
> 
> Nope, it's still not right.  We'll treat this case:
> 
> 		if (compr_len == 0)
> 			; /* hole */
> 
> as an IO error.  grr.
> 
> --- a/fs/cramfs/inode.c~cramfs-propagate-uncompression-errors
> +++ a/fs/cramfs/inode.c
> @@ -477,7 +477,7 @@ static int cramfs_readpage(struct file *
>  		mutex_unlock(&read_mutex);
>  		pgdata = kmap(page);
>  		if (compr_len == 0)
> -			; /* hole */
> +			goto out; /* hole */
>  		else if (compr_len > (PAGE_CACHE_SIZE << 1))
>  			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
>  		else {
> @@ -488,12 +488,20 @@ static int cramfs_readpage(struct file *
>  				 compr_len);
>  			mutex_unlock(&read_mutex);
>  		}
> -	} else
> -		pgdata = kmap(page);
> -	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - bytes_filled);
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
> +out:
>  	unlock_page(page);
>  	return 0;
>  }

Is that actually an error. The comment in the code is, uh, a bit terse,
but I took it to mean that there was a deliberate hole, just like holes
in files that should read as all zeroes. But even if it's actually an
error, we still need to kunmap the page
-- 
David VomLehn, dvomlehn@cisco.com




     - - - - -                              Cisco                            - - - - -         
This e-mail and any attachments may contain information which is confidential, 
proprietary, privileged or otherwise protected by law. The information is solely 
intended for the named addressee (or a person responsible for delivering it to 
the addressee). If you are not the intended recipient of this message, you are 
not authorized to read, print, retain, copy or disseminate this message or any 
part of it. If you have received this e-mail in error, please notify the sender 
immediately by return e-mail and delete it from your computer.

