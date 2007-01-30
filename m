Return-Path: <linux-kernel-owner+w=401wt.eu-S965383AbXA3NYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965383AbXA3NYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965374AbXA3NYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:24:07 -0500
Received: from mail.screens.ru ([213.234.233.54]:43727 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965378AbXA3NX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:23:58 -0500
Date: Tue, 30 Jan 2007 16:25:59 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: bug reading /proc/sys/kernel/*: only first byte read.
Message-ID: <20070130132559.GA315@tv-sign.ru>
References: <4538C47B.9060808@tls.msk.ru> <20070130022457.d0159eba.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130022457.d0159eba.akpm@osdl.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Andrew Morton wrote:
>
> @@ -1705,18 +1704,38 @@ static int _proc_do_string(void* data, i
>  		((char *) data)[len] = 0;
>  		*ppos += *lenp;
>  	} else {
> -		len = strlen(data);
> +		loff_t pos = *ppos;
> +		const size_t slen = strlen(data);
> +
> +		/*
> +		 * len is the amount of data to copy, and becomes the amount of
> +		 * data which was copied
> +		 */
> +		len = slen;
> +		if (pos > len) {
> +			*lenp = 0;
> +			return 0;
> +		}
>  		if (len > maxlen)
>  			len = maxlen;
>  		if (len > *lenp)
>  			len = *lenp;
> -		if (len)
> -			if(copy_to_user(buffer, data, len))
> -				return -EFAULT;
> -		if (len < *lenp) {
> -			if(put_user('\n', ((char __user *) buffer) + len))
> +		/* Don't copy past the end of the string */
> +		if (len > slen - pos)
> +			len = slen - pos;
> +		data += pos;
> +		/* Copy as much of the string as we can */
> +		if (len) {
> +			if (copy_to_user(buffer, data, len))
>  				return -EFAULT;
> -			len++;
> +		}
> +		/* If we copied the whole string, now write a \n */
> +		if (len + pos == slen) {
> +			if (len + pos < maxlen) {
                        ^^^^^^^^^^^^^^^^^^^^^^^
Shouldn't this be
			if (len < *lenp)

?

> +				if (put_user('\n', (char __user *)buffer + len))
> +					return -EFAULT;
> +				len++;
> +			}
>  		}
>  		*lenp = len;
>  		*ppos += len;

