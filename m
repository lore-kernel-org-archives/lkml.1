Return-Path: <linux-kernel-owner+w=401wt.eu-S933270AbXBFVh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbXBFVh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbXBFVh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:37:58 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:11043 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933270AbXBFVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:37:57 -0500
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Message-ID: <45C8F5E0.5030500@amd.com>
Date: Tue, 06 Feb 2007 22:40:48 +0100
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070206)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] x86-64 ext2/ext3 datestamp problem
References: <45C8F419.5040103@amd.com>
In-Reply-To: <45C8F419.5040103@amd.com>
X-OriginalArrivalTime: 06 Feb 2007 21:37:43.0862 (UTC)
 FILETIME=[09097560:01C74A37]
X-WSS-ID: 69D62AA02KW7199190-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>

Markus Rechberger wrote:
> Hi,
>
> there is an issue with ext2/ext3 date stamps, if someone creates a file
> with a timestamp between 1902 and 1970(epoch 0) it will overflow and
> result in a higher date than 2038.
>
> $ touch --date "1905-01-01" test
> $ ls -lah test
> -rw-r--r-- 1 root root 0 Jan  1  1905 test (this is a cached value here)
> (remount the partition/clear the cache)
> $ ls -lah test
> -rw-r--r-- 1 root root 0 Feb  6  2041 test
>
> 10000101101111001100011001110000 .. -2051226000 (1905)
> 10000101101111001100011001110000 .. 2243741296 (2041)
>
> this was tested against linus git tree
>
> Markus
>
>   
> ------------------------------------------------------------------------
>
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index dd4e14c..9fa1bd6 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1079,9 +1079,9 @@ void ext2_read_inode (struct inode * inode)
>  	}
>  	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
>  	inode->i_size = le32_to_cpu(raw_inode->i_size);
> -	inode->i_atime.tv_sec = le32_to_cpu(raw_inode->i_atime);
> -	inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
> -	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
> +	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
> +	inode->i_ctime.tv_sec = (signed)le32_to_cpu(raw_inode->i_ctime);
> +	inode->i_mtime.tv_sec = (signed)le32_to_cpu(raw_inode->i_mtime);
>  	inode->i_atime.tv_nsec = inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec = 0;
>  	ei->i_dtime = le32_to_cpu(raw_inode->i_dtime);
>  	/* We now have enough fields to check if the inode was active or not.
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index beaf25f..5d171c0 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -2673,9 +2673,9 @@ void ext3_read_inode(struct inode * inode)
>  	}
>  	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
>  	inode->i_size = le32_to_cpu(raw_inode->i_size);
> -	inode->i_atime.tv_sec = le32_to_cpu(raw_inode->i_atime);
> -	inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
> -	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
> +	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
> +	inode->i_ctime.tv_sec = (signed)le32_to_cpu(raw_inode->i_ctime);
> +	inode->i_mtime.tv_sec = (signed)le32_to_cpu(raw_inode->i_mtime);
>  	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = inode->i_mtime.tv_nsec = 0;
>  
>  	ei->i_state = 0;
>   


-- 
Markus Rechberger
Operating System Research Center
AMD Saxony LLC & Co. KG



