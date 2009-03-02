Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbZCBEMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbZCBEMH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 23:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbZCBELy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 23:11:54 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:39460 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433AbZCBELy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 23:11:54 -0500
Date: Mon, 2 Mar 2009 09:41:48 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Adrian Bunk <bunk@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Seidel <frank@f-seidel.de>, kernalert.de@gmail.com
Subject: Re: [PATCH] lkdtm: reduce stack size
Message-ID: <20090302041148.GA7410@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <49AAE94E.8080308@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AAE94E.8080308@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Sun, Mar 01, 2009 at 09:00:14PM +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Reduce stack memory footprint of lkdtm
> (recursive_loop). From 1024 bytes on i386 down
> to <10.
>

The intention here is infact to trigger a stack overflow. This module is
used to test kernel dumping mechanism like kdump. So the expectation is
that the kernel will dump as soon as the stack overflows.
 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/misc/lkdtm.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> --- a/drivers/misc/lkdtm.c
> +++ b/drivers/misc/lkdtm.c
> @@ -225,14 +225,24 @@ static int lkdtm_parse_commandline(void)
> 
>  static int recursive_loop(int a)
>  {
> -	char buf[1024];
> +	char *buf;
> +	int ret;
> +
> +	buf = kmalloc(1024, GFP_KERNEL);
> +	if (!buf) {
> +		printk(KERN_ERR "lkdtm : couldn't allocate buffer\n");
> +		return -ENOMEM;
> +	}
> 
>  	memset(buf,0xFF,1024);
>  	recur_count--;
>  	if (!recur_count)
> -		return 0;
> +		ret = 0;
>  	else
> -        	return recursive_loop(a);
> +		ret = recursive_loop(a);
> +
> +	kfree(buf);
> +	return ret;
>  }
> 
>  void lkdtm_handler(void)

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
