Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbZCJNaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbZCJNaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZCJNam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:30:42 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:54862 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZCJNam (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:30:42 -0400
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2009 09:30:41 EDT
Date: Tue, 10 Mar 2009 09:19:08 -0400
From: Woody Suwalski <woodys@xandros.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <49B668CC.4090901@xandros.com>
In-Reply-To: <alpine.LRH.2.00.0903101149500.25436@vixen.sonytel.be>
References: <49AF30EC.8010205@lougher.demon.co.uk>
References: <200903092239.13078.s.L-H@gmx.de>
References: <49B5CCB7.5030404@lougher.demon.co.uk>
References: <alpine.LRH.2.00.0903101149500.25436@vixen.sonytel.be>
Subject: Re: [GIT PULL] Squashfs fixes for 2.6.29?
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Tue, 10 Mar 2009, Phillip Lougher wrote:
>   
>> Stefan Lippers-Hollmann wrote:
>>     
>>> This patch seems to break squashfs for me on i386 and amd64. 
>>> Test environment is a squashed filesystem image (live CD image, but also
>>> tested manually with a loop mounted iso9660 and loop mounted squashfs;
>>> kernel 2.6.29-rc7-git2). The squashfs image has been created with
>>> squashfs-tools CVS[1] as of today (latest commit 2009-03-03).
>>>
>>>       
>> Can you send me a filesystem (or link to one) which exhibits this?  Zlib is
>> obviously showing unexpected behaviour...
>>     
>
> I see the same thing here. I'll send you a test file system by private email.
>
> The patch below fixes it. It seems zlib sometimes does need an additional
> loop ;-)
>
> Note that I expect it may now loop forever in case of file system corruption.
>
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>
> diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
> index 321728f..46358dd 100644
> --- a/fs/squashfs/block.c
> +++ b/fs/squashfs/block.c
> @@ -184,15 +184,7 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
>  				offset = 0;
>  			}
>  
> -			if (msblk->stream.avail_out == 0) {
> -				if (page == pages) {
> -					ERROR("zlib_inflate tried to "
> -						"decompress too much data, "
> -						"expected %d bytes.  Zlib "
> -						"data probably corrupt\n",
> -						srclength);
> -					goto release_mutex;
> -				}
> +			if (msblk->stream.avail_out == 0 && page < pages) {
>  				msblk->stream.next_out = buffer[page++];
>  				msblk->stream.avail_out = PAGE_CACHE_SIZE;
>  			}
>
> With kind regards,
>
> Geert Uytterhoeven
> Software Architect
>
>   
Same here. I have experimentally commented out the "goto release_mutex" 
and I see that the error message is printed once or twice during boot.
(and we are banging on it heavily - no real file system problems seen).
In my case squash4 is a 600M+ all the system partition to be aufs'd with 
a read-write portion.
Leaving the patch as it is renders the system unbootable - weird errors 
resulting from aborted reads....

Woody

-- 
Woody Suwalski, Xandros, Ottawa, Canada, 1-613-842-3498 x414

