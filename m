Return-Path: <linux-kernel-owner+w=401wt.eu-S1763025AbYB0Xf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763025AbYB0Xf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759129AbYB0Xft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:35:49 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758794AbYB0Xfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:35:48 -0500
Date: Wed, 27 Feb 2008 15:34:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: fix sparse shadowed variable warnings in
 cyclades.c
Message-Id: <20080227153448.a559b6c3.akpm@linux-foundation.org>
In-Reply-To: <1203704055.5962.10.camel@brick>
References: <1203704055.5962.10.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 10:14:15 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Nested min() macros.
> drivers/char/cyclades.c:2750:7: warning: symbol '_x' shadows an earlier one
> drivers/char/cyclades.c:2750:7: originally declared here
> drivers/char/cyclades.c:2750:7: warning: symbol '_x' shadows an earlier one
> drivers/char/cyclades.c:2750:7: originally declared here
> drivers/char/cyclades.c:2750:7: warning: symbol '_y' shadows an earlier one
> drivers/char/cyclades.c:2750:7: originally declared here
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/char/cyclades.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
> index e4f579c..f8f4d54 100644
> --- a/drivers/char/cyclades.c
> +++ b/drivers/char/cyclades.c
> @@ -2747,8 +2747,8 @@ static int cy_write(struct tty_struct *tty, const unsigned char *buf, int count)
>  
>  	spin_lock_irqsave(&info->card->card_lock, flags);
>  	while (1) {
> -		c = min(count, min((int)(SERIAL_XMIT_SIZE - info->xmit_cnt - 1),
> -				   (int)(SERIAL_XMIT_SIZE - info->xmit_head)));
> +		c = min(count, (int)(SERIAL_XMIT_SIZE - info->xmit_cnt - 1));
> +		c = min(c, (int)(SERIAL_XMIT_SIZE - info->xmit_head));
>  
>  		if (c <= 0)
>  			break;

Unrelated to your change, but...

We prefer min_t over casts like this (not sure why, but let's be consistent)

The reason for this cast is that all this code is using `int' for the
transfer count (arguably wrong - should use size_t, but that propagates all
the way to tty_operations.write) but cyclades has

#define SERIAL_XMIT_SIZE        (min(PAGE_SIZE, 4096))

which is unsigned on most architectures.

A possibly-sane fix for all of this is to use min_t in the above then nuke
the casts.

