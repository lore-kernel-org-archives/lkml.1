Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYHUDIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYHUDIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbYHUDI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:08:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755869AbYHUDI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:08:28 -0400
Date: Wed, 20 Aug 2008 20:08:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [3/4] add agp_generic_destroy_pages()
Message-Id: <20080820200807.324aa671.akpm@linux-foundation.org>
In-Reply-To: <1219286777.18007.41.camel@sli10-desk.sh.intel.com>
References: <1219286777.18007.41.camel@sli10-desk.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 10:46:17 +0800 Shaohua Li <shaohua.li@intel.com> wrote:

> --- linux.orig/drivers/char/agp/generic.c	2008-08-21 10:01:34.000000000 +0800
> +++ linux/drivers/char/agp/generic.c	2008-08-21 10:01:40.000000000 +0800
> @@ -201,14 +201,22 @@ void agp_free_memory(struct agp_memory *
>  		return;
>  	}
>  	if (curr->page_count != 0) {
> -		for (i = 0; i < curr->page_count; i++) {
> -			curr->memory[i] = (unsigned long)gart_to_virt(curr->memory[i]);
> -			curr->bridge->driver->agp_destroy_page((void *)curr->memory[i],
> -							       AGP_PAGE_DESTROY_UNMAP);
> -		}
> -		for (i = 0; i < curr->page_count; i++) {
> -			curr->bridge->driver->agp_destroy_page((void *)curr->memory[i],
> -							       AGP_PAGE_DESTROY_FREE);
> +		if (curr->bridge->driver->agp_destroy_pages) {
> +			curr->bridge->driver->agp_destroy_pages(curr);
> +		} else {

stylistic nit:

> +
> +			for (i = 0; i < curr->page_count; i++) {
> +				curr->memory[i] = (unsigned long)gart_to_virt(
> +					curr->memory[i]);
> +				curr->bridge->driver->agp_destroy_page(
> +					(void *)curr->memory[i],
> +					AGP_PAGE_DESTROY_UNMAP);
> +			}
> +			for (i = 0; i < curr->page_count; i++) {
> +				curr->bridge->driver->agp_destroy_page(
> +					(void *)curr->memory[i],
> +					AGP_PAGE_DESTROY_FREE);
> +			}

Make the above code a standalone function and call it here.

Then convert all drivers over so their .agp_destroy_pages points at
that new function.

Then remove the `if'.
