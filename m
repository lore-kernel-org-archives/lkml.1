Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbYFBFk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbYFBFk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYFBFkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:40:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:42838 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbYFBFkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VPhwUi2FwS8+cg1ltwCjs1UpERdmEfqaGMErvZTZgUmvB549+Q8aak2JRtW5Q10I4X
         tvH8YcZ1CbT2SxA1xm6eS8PR9ZI5pwQlGG2KlscI4PGM0+VEoMYXkNxPMicqPn0V6KHF
         0MMucjK8jCDA8NsD99u+Eo5u7cVyMEdrGW7m4=
Date: Mon, 2 Jun 2008 09:35:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org
Subject: Re: [patch -v2 01/23] sunrpc: use simple_read_from_buffer
Message-ID: <20080602053552.GA6592@martell.zuzino.mipt.ru>
References: <20080601231329.223608711@gmail.com> <20080601231451.529328123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080601231451.529328123@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 08:13:30AM +0900, akinobu.mita@gmail.com wrote:
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---
>  net/sunrpc/cache.c |   15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> Index: 2.6-git/net/sunrpc/cache.c
> ===================================================================
> --- 2.6-git.orig/net/sunrpc/cache.c
> +++ 2.6-git/net/sunrpc/cache.c
> @@ -1271,20 +1271,11 @@ static ssize_t read_flush(struct file *f
>  {
>  	struct cache_detail *cd = PDE(file->f_path.dentry->d_inode)->data;
>  	char tbuf[20];
> -	unsigned long p = *ppos;
>  	size_t len;
>  
> -	sprintf(tbuf, "%lu\n", cd->flush_time);
> -	len = strlen(tbuf);
> -	if (p >= len)
> -		return 0;
> -	len -= p;
> -	if (len > count)
> -		len = count;
> -	if (copy_to_user(buf, (void*)(tbuf+p), len))
> -		return -EFAULT;
> -	*ppos += len;
> -	return len;
> +	len = sprintf(tbuf, "%lu\n", cd->flush_time);
> +
> +	return simple_read_from_buffer(buf, count, ppos, tbuf, len);
>  }

Please, switch to seq_file:

	seq_printf(m, "%lu\n", cd->flush_time);
	return 0;

and that's everything module have to worry about.

