Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZI3XQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZI3XQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZI3XQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:16:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627AbZI3XQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:16:07 -0400
Date: Wed, 30 Sep 2009 16:16:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: Add an extra bound check on ioctl arguments
Message-Id: <20090930161603.1c7cb1b0.akpm@linux-foundation.org>
In-Reply-To: <20090930131709.7300dff3@infradead.org>
References: <20090930131709.7300dff3@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 13:17:09 +0200
Arjan van de Ven <arjan@infradead.org> wrote:

> 
> >From 90d75780b319153d050bb1c0f3f38ce054775615 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Wed, 30 Sep 2009 13:13:59 +0200
> Subject: [PATCH] floppy: Add an extra bound check on ioctl arguments
> 
> gcc is not convinced that the floppy.c ioctl has sufficient bound checks,
> and frankly, as a human I have a hard time proving the same more or less
> (the size comes from the ioctl argument. humpf. maybe. the code isn't
> very nice)
> 
> This patch adds an explicit check to make 100% sure it's safe, better
> than finding out later that there indeed was a gap.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  drivers/block/floppy.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 5c01f74..0f11a77 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -3497,6 +3497,9 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
>  	    ((cmd & 0x80) && !capable(CAP_SYS_ADMIN)))
>  		return -EPERM;
>  
> +	if (size < 0 || size > sizeof(inparam))
> +		return -EINVAL;

I suspect that if this ever happens, normalize_ioctl() has
malfunctioned and what we have is a kernel bug.

This?

--- a/drivers/block/floppy.c~floppy-add-an-extra-bound-check-on-ioctl-arguments-fix
+++ a/drivers/block/floppy.c
@@ -3497,7 +3497,7 @@ static int fd_ioctl(struct block_device 
 	    ((cmd & 0x80) && !capable(CAP_SYS_ADMIN)))
 		return -EPERM;
 
-	if (size < 0 || size > sizeof(inparam))
+	if (WARN_ON(size < 0 || size > sizeof(inparam)))
 		return -EINVAL;
 
 	/* copyin */
_

