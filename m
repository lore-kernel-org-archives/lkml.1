Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbZBBXz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbZBBXz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZBBXzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:55:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbZBBXzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:55:13 -0500
Date: Mon, 2 Feb 2009 15:54:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] Fix memory corruption in console selection
Message-Id: <20090202155448.e73cbdbd.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0901301516190.2813@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0901301516190.2813@hs20-bc2-1.build.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 15:27:14 -0500 (EST)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> [ I don't know who is the console maintainer or if there is any, so I'm 
> posting this to Linus ]
> 
> 
> Fix an off-by-two memory error in console selection.
> 
> The loop below goes from sel_start to sel_end (inclusive), so it writes 
> one more character. This one more character was added to the allocated 
> size (+1), but it was not multiplied by an UTF-8 multiplier.
> 
> This patch fixes a memory corruption when UTF-8 console is used and the 
> user selects a few characters, all of them 3-byte in UTF-8 (for example a 
> frame line).
> 
> When memory redzones are enabled, a redzone corruption is reported. When 
> they are not enabled, trashing of random memory occurs.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/char/selection.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.29-rc3-devel/drivers/char/selection.c
> ===================================================================
> --- linux-2.6.29-rc3-devel.orig/drivers/char/selection.c	2009-01-30 21:03:07.000000000 +0100
> +++ linux-2.6.29-rc3-devel/drivers/char/selection.c	2009-01-30 21:03:38.000000000 +0100
> @@ -268,7 +268,7 @@ int set_selection(const struct tiocl_sel
>  
>  	/* Allocate a new buffer before freeing the old one ... */
>  	multiplier = use_unicode ? 3 : 1;  /* chars can take up to 3 bytes */
> -	bp = kmalloc((sel_end-sel_start)/2*multiplier+1, GFP_KERNEL);
> +	bp = kmalloc(((sel_end-sel_start)/2+1)*multiplier, GFP_KERNEL);
>  	if (!bp) {
>  		printk(KERN_WARNING "selection: kmalloc() failed\n");
>  		clear_selection();

The patch is now in mainline for 2.6.29, as
878b8619f711280fd05845e21956434b5e588cc4.

It appears to be applicable to earlier kernels as far back as 2.6.25
(at least).  But the -stable maintainers were not informed of this.

An appropriate way of flagging this is to add

Cc: <stable@kernel.org>

to the changelog.

Please, people - we all need to think about this, to prevent stuff from
falling through cracks.

