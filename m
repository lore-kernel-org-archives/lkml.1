Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZGMOFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZGMOFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 10:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbZGMOFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 10:05:01 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53931 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbZGMOFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 10:05:00 -0400
Subject: Re: [PATCH] Fix vc_screenbuf leak via con_init()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090713130921.6441.17011.stgit@pc1117.cambridge.arm.com>
References: <20090713130921.6441.17011.stgit@pc1117.cambridge.arm.com>
Date: Mon, 13 Jul 2009 17:04:58 +0300
Message-Id: <1247493898.14968.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 14:12 +0100, Catalin Marinas wrote:
> Commit a5f4f52e replaced the alloc_bootmem() with kzalloc() but didn't
> set vc_kmalloced to 1 and the memory block is later leaked. The
> corresponding kmemleak trace:
> 
> unreferenced object 0xdf828000 (size 8192):
>   comm "swapper", pid 0, jiffies 4294937296
>   backtrace:
>     [<c006d473>] __save_stack_trace+0x17/0x1c
>     [<c000d869>] log_early+0x55/0x84
>     [<c01cfa4b>] kmemleak_alloc+0x33/0x3c
>     [<c006c013>] __kmalloc+0xd7/0xe4
>     [<c00108c7>] con_init+0xbf/0x1b8
>     [<c0010149>] console_init+0x11/0x20
>     [<c0008797>] start_kernel+0x137/0x1e4
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
> 
> (note that detecting this requires additional kmemleak patches for early
> log stack traces which are planned for the next merging window)
> 
>  drivers/char/vt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> index 7947bd1..f6ac4c2 100644
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -2881,7 +2881,7 @@ static int __init con_init(void)
>  		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
>  		visual_init(vc, currcons, 1);
>  		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
> -		vc->vc_kmalloced = 0;
> +		vc->vc_kmalloced = 1;
>  		vc_init(vc, vc->vc_rows, vc->vc_cols,
>  			currcons || !vc->vc_sw->con_save_screen);
>  	}
> 

We can probably get rid of ->vc_kmalloced completely now that the
bootmem allocator is no longer used by the driver.

