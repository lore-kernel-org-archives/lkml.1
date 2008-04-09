Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbYDIRFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbYDIRFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYDIRFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:05:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:25387 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYDIRFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:05:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xfUb560zXjW3Imi+myDn1UAEzD7Q6UySREmS2u8Kkpp6lAihHwkKJFOrqDIA9C7GIEzAYDjL5R7IRbNsNboIbDIjzjo98Nrb1/wTi/48kLDXeHCFutQjRRlkH4yT1c8JkfgtmRZKxB0WsNYQEJfYX4QSzc+GIbdQrf05mUpDx7o=
Message-ID: <6101e8c40804091005k27e6f510h4385b6f709b6b5ed@mail.gmail.com>
Date: Wed, 9 Apr 2008 19:05:28 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [patch] fix infinite loop in generic_file_splice_read()
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JjcgO-0004q2-VJ@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
References: <E1JjcgO-0004q2-VJ@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m39H4mEB006204

Helló Miklós!
ez a patch szükséges a 2.6.22.y kernelhez? (2.6.22.y-ba elsõ ránézésrehunk nélkül hozzáadható)vagy várjam meg, amig bekerül a mainline kernelbe?
On 4/9/08, Miklos Szeredi <miklos@szeredi.hu> wrote:> generic_file_splice_read() goes into an infinite loop if it races with> truncation.  I've found this with fsx-linux on NFS over fuse.>> Perhaps the whole while() loop is bogus, but I can't tell from a> cursory glance at __generic_file_splice_read() if it will return zero> only on EOF, or it can do that for other reasons as well.  In the> latter case the loop is obviously needed.>> This simplistic patch fixes the issue for me.>> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>> --->  fs/splice.c |   19 ++++++++++--------->  1 file changed, 10 insertions(+), 9 deletions(-)>> Index: linux/fs/splice.c> ===================================================================> --- linux.orig/fs/splice.c	2008-04-02 13:34:58.000000000 +0200> +++ linux/fs/splice.c	2008-04-09 17:35:06.000000000 +0200> @@ -481,19 +481,20 @@ ssize_t generic_file_splice_read(struct>  {>  	ssize_t spliced;>  	int ret;> -	loff_t isize, left;> -> -	isize = i_size_read(in->f_mapping->host);> -	if (unlikely(*ppos >= isize))> -		return 0;> -> -	left = isize - *ppos;> -	if (unlikely(left < len))> -		len = left;>>  	ret = 0;>  	spliced = 0;>  	while (len && !spliced) {> +		loff_t isize, left;> +> +		isize = i_size_read(in->f_mapping->host);> +		if (unlikely(*ppos >= isize))> +			return 0;> +> +		left = isize - *ppos;> +		if (unlikely(left < len))> +			len = left;> +>  		ret = __generic_file_splice_read(in, ppos, pipe, len, flags);>>  		if (ret < 0)> --> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at  http://vger.kernel.org/majordomo-info.html> Please read the FAQ at  http://www.tux.org/lkml/>

-- Thanks,Oliverÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
