Return-Path: <linux-kernel-owner+w=401wt.eu-S932513AbZLDWiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbZLDWiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZLDWiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:38:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbZLDWiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:38:20 -0500
Date: Fri, 4 Dec 2009 14:38:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: "linux list" <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/2][resend] pid: tighten pidmap spinlock critical
 section by removing kfree()
Message-Id: <20091204143802.17f3fded.akpm@linux-foundation.org>
In-Reply-To: <0e91f1c4ecc5bc5000f729ccb56e9b6e1fbd4bd3.1258805412.git.andre.goddard@gmail.com>
References: <cover.1258805412.git.andre.goddard@gmail.com>
	<0e91f1c4ecc5bc5000f729ccb56e9b6e1fbd4bd3.1258805412.git.andre.goddard@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Dec 2009 12:53:37 -0200
Andr__ Goddard Rosa <andre.goddard@gmail.com> wrote:

> Avoid calling kfree() under pidmap spinlock, calling it afterwards.
> 
> Normally kfree() is fast, but sometimes it can be slow, so avoid
> calling it under the spinlock if we can do it.
> 
> Signed-off-by: Andr__ Goddard Rosa <andre.goddard@gmail.com>
> cc: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  kernel/pid.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index d3f722d..55fd590 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -141,11 +141,12 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>  			 * installing it:
>  			 */
>  			spin_lock_irq(&pidmap_lock);
> -			if (map->page)
> -				kfree(page);
> -			else
> +			if (!map->page) {
>  				map->page = page;
> +				page = NULL;
> +			}
>  			spin_unlock_irq(&pidmap_lock);
> +			kfree(page);
>  			if (unlikely(!map->page))
>  				break;
>  		}

um, OK, but the chances of that kfree() actually being executed are
very small.

