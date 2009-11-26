Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbZKZBDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbZKZBDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 20:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759916AbZKZBDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 20:03:40 -0500
Received: from waste.org ([173.11.57.241]:40272 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759919AbZKZBDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 20:03:40 -0500
Subject: Re: [PATCH 1/2] hw_random: core updates to allow more efficient
 drivers
From: Matt Mackall <mpm@selenic.com>
To: Ian Molton <ian.molton@collabora.co.uk>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk>
References: <1259177252.2858.17.camel@calx>
	 <1259195127-20086-1-git-send-email-ian.molton@collabora.co.uk>
	 <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 19:03:23 -0600
Message-ID: <1259197403.2858.88.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 00:25 +0000, Ian Molton wrote:
> 	This patch implements a new method by which hw_random hardware drivers
> can pass data to the core more efficiently, using a shared buffer.
> 
> The old methods have been retained as a compatability layer until all the
> drivers have been updated.
> 
> Signed-off-by: Ian Molton <ian.molton@collabora.co.uk>
> ---
>  drivers/char/hw_random/core.c |  120 ++++++++++++++++++++++++++---------------
>  include/linux/hw_random.h     |    9 ++-
>  2 files changed, 82 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 1573aeb..e179afd 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -47,12 +47,14 @@
>  #define RNG_MODULE_NAME		"hw_random"
>  #define PFX			RNG_MODULE_NAME ": "
>  #define RNG_MISCDEV_MINOR	183 /* official */
> +#define RNG_BUFFSIZE		64
>  
> 
>  static struct hwrng *current_rng;
>  static LIST_HEAD(rng_list);
>  static DEFINE_MUTEX(rng_mutex);
> -
> +static u8 *rng_buffer;

How about just:

static u8 rng_buffer[RNG_BUFFSIZE] __cacheline_aligned;

And lose all the kmalloc and kfree code? The memory use will be smaller,
even when the buffer isn't needed.

> +		if (!data_avail) {
> +			bytes_read = rng_get_data(current_rng, rng_buffer,
> +				RNG_BUFFSIZE, !(filp->f_flags & O_NONBLOCK));

No need to pass rng_buffer to the helper as there's only one with global
scope.

-- 
http://selenic.com : development and support for Mercurial and Linux


