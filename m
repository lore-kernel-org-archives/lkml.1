Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbYHaOYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbYHaOYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbYHaOYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:24:05 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:56318 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbYHaOYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:24:04 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] sunrpc - fixup userspace buffer possible overrun v2
Date: Sun, 31 Aug 2008 16:09:10 +0200
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, bfields@fieldses.org,
       neilb@suse.de
References: <20080831100806.GD7391@lenovo>
In-Reply-To: <20080831100806.GD7391@lenovo>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808311609.12275.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

On Sunday 31 August 2008, Cyrill Gorcunov wrote:
> The conclusion is that proc_do_xprt doesn't check for userside buffer
> size indeed so fix. Also set lenp to number of bytes were really written.

Why not use  simple_read_from_buffer() for the read case and
keep the -EINVAL for the write case.

> Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> CC: David Wagner <daw@cs.berkeley.edu>
> ---
> 
> Please review.
> 
> Index: linux-2.6.git/net/sunrpc/sysctl.c
> ===================================================================
> --- linux-2.6.git.orig/net/sunrpc/sysctl.c	2008-08-31 13:43:46.000000000 +0400
> +++ linux-2.6.git/net/sunrpc/sysctl.c	2008-08-31 13:58:14.000000000 +0400
> @@ -60,23 +60,26 @@ static int proc_do_xprt(ctl_table *table
>  			void __user *buffer, size_t *lenp, loff_t *ppos)
>  {
>  	char tmpbuf[256];
> -	int len;
> +	size_t len;
> +
+ ssize_t ret;
>  	if ((*ppos && !write) || !*lenp) {
>  		*lenp = 0;
>  		return 0;
>  	}
> +
>  	if (write)
>  		return -EINVAL;

        len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
	ret = simple_read_from_buffer(buffer, ppos, tmpbuf, len);
	if (ret >= 0) {
		*lenp = ret;
		ret = 0;
	}

	return ret;
   }


Best Regards

Ingo Oeser
