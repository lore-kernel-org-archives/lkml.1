Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYK2Lsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYK2Lsg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 06:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYK2Ls2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 06:48:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:35643 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYK2Ls1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 06:48:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xzPxsdJ2c5Yph0Zh9ydavLACV9t8SejJLnAQWgtcdMVAe2leGf5+bx4JmhKeCaM9tt
         h424c0/69VZfwc9emTIXzd3275CNF6I25luq97EujqVR0oDqBCI2aAocfSv5NZlewzo3
         spGiIR1NJ5kCCsgHlux/o3B9tkR4moNpq5zCo=
Message-ID: <84144f020811290348x61cb502bn75e20c9024b889cc@mail.gmail.com>
Date: Sat, 29 Nov 2008 13:48:25 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 11/15] kmemleak: Remove some of the kmemleak false positives
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081129104408.16726.77892.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
	 <20081129104408.16726.77892.stgit@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: 1c99f2a81666fc30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,


On Sat, Nov 29, 2008 at 12:44 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> There are allocations for which the main pointer cannot be found but
> they are not memory leaks. This patch fixes some of them. For more
> information on false positives, see Documentation/kmemleak.txt.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/char/vt.c      |    7 +++++++
>  include/linux/percpu.h |    5 +++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> index a5af607..bb024f8 100644
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -104,6 +104,7 @@
>  #include <linux/io.h>
>  #include <asm/system.h>
>  #include <linux/uaccess.h>
> +#include <linux/memleak.h>
>
>  #define MAX_NR_CON_DRIVER 16
>
> @@ -2882,6 +2883,12 @@ static int __init con_init(void)
>         */
>        for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
>                vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
> +               /*
> +                * Kmemleak does not track the memory allocated via
> +                * alloc_bootmem() but this block contains pointers to
> +                * other blocks allocated via kmalloc.
> +                */
> +               memleak_alloc(vc, sizeof(struct vc_data), 1);

Can we add some hooks to alloc_bootmem() to handle this? It's somewhat
unfortunate that we need to annotate driver code.

>                INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
>                visual_init(vc, currcons, 1);
>                vc->vc_screenbuf = (unsigned short *)alloc_bootmem(vc->vc_screenbuf_size);
