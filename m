Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZKWSai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZKWSai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbZKWSag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:30:36 -0500
Received: from mga06.intel.com ([134.134.136.21]:3260 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752196AbZKWSa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:30:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,273,1257148800"; 
   d="scan'208";a="469857594"
Date: Mon, 23 Nov 2009 10:30:26 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/8] drivers/usb/host/xhci-mem.c: introduce missing
	kfree
Message-ID: <20091123183026.GB6412@xanatos>
References: <Pine.LNX.4.64.0911211251210.23681@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911211251210.23681@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>

Please CC me on xHCI code cleanups.  Thanks for catching this!

On Sat, Nov 21, 2009 at 12:51:47PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following a kzalloc should free the allocated data.
> 
> The semantic match that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> statement S;
> expression E;
> identifier f,f1,l;
> position p1,p2;
> expression *ptr != NULL;
> @@
> 
> x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
> ...
> if (x == NULL) S
> <... when != x
>      when != if (...) { <+...x...+> }
> (
> x->f1 = E
> |
>  (x->f1 == NULL || ...)
> |
>  f(...,x->f1,...)
> )
> ...>
> (
>  return \(0\|<+...x...+>\|ptr\);
> |
>  return@p2 ...;
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  drivers/usb/host/xhci-mem.c         |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
> index fd05247..33f8157 100644
> --- a/drivers/usb/host/xhci-mem.c
> +++ b/drivers/usb/host/xhci-mem.c
> @@ -779,14 +779,17 @@ struct xhci_command *xhci_alloc_command(struct xhci_hcd *xhci,
>  
>  	command->in_ctx =
>  		xhci_alloc_container_ctx(xhci, XHCI_CTX_TYPE_INPUT, mem_flags);
> -	if (!command->in_ctx)
> +	if (!command->in_ctx) {
> +		kfree(command);
>  		return NULL;
> +	}
>  
>  	if (allocate_completion) {
>  		command->completion =
>  			kzalloc(sizeof(struct completion), mem_flags);
>  		if (!command->completion) {
>  			xhci_free_container_ctx(xhci, command->in_ctx);
> +			kfree(command);
>  			return NULL;
>  		}
>  		init_completion(command->completion);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
