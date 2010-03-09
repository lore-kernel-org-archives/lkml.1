Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0CIDIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:08:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44984 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0CIDIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:08:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andre Goddard Rosa <andre.goddard@gmail.com>
Subject: Re: [PATCH] coredump: plug a memory leak situation on dump_seek()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, WANG Cong <amwang@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <fe97698815cd081b5ab33a8c25c8b69cd0371a99.1267785456.git.andre.goddard@gmail.com>
References: <fe97698815cd081b5ab33a8c25c8b69cd0371a99.1267785456.git.andre.goddard@gmail.com>
Message-Id: <20100309120706.7CD2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Mar 2010 12:08:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After having started writing the coredump, if filesystem reports an error
> anytime while writing part of the core file, we would leak a memory page
> when bailing out.
> 
> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Looks good.
Thanks, Andre!

  - kosaki

> ---
>  include/linux/coredump.h |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> index b3c91d7..8ba66a9 100644
> --- a/include/linux/coredump.h
> +++ b/include/linux/coredump.h
> @@ -16,6 +16,8 @@ static inline int dump_write(struct file *file, const void *addr, int nr)
>  
>  static inline int dump_seek(struct file *file, loff_t off)
>  {
> +	int ret = 1;
> +
>  	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
>  		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
>  			return 0;
> @@ -29,13 +31,15 @@ static inline int dump_seek(struct file *file, loff_t off)
>  
>  			if (n > PAGE_SIZE)
>  				n = PAGE_SIZE;
> -			if (!dump_write(file, buf, n))
> -				return 0;
> +			if (!dump_write(file, buf, n)) {
> +				ret = 0;
> +				break;
> +			}
>  			off -= n;
>  		}
>  		free_page((unsigned long)buf);
>  	}
> -	return 1;
> +	return ret;
>  }
>  
>  #endif /* _LINUX_COREDUMP_H */
> -- 
> 1.7.0.1.164.gbe2f
> 



