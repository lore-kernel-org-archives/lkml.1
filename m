Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbZC3UiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbZC3UiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbZC3Uh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:37:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757543AbZC3Uhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:37:55 -0400
Date: Mon, 30 Mar 2009 13:35:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] hvc_console: prevent wrapping in hvc_console_print()
Message-Id: <20090330133531.f5d99c09.akpm@linux-foundation.org>
In-Reply-To: <49BF956B.9030109@gmail.com>
References: <49BF956B.9030109@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 13:19:55 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> This was found by code analysis, is it needed?
> ------------------------------>8-------------8<---------------------------------
> If we subtract too much on unsigned i it wraps.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
> index 94e7e3c..d06313c 100644
> --- a/drivers/char/hvc_console.c
> +++ b/drivers/char/hvc_console.c
> @@ -161,10 +161,10 @@ static void hvc_console_print(struct console *co, const char *b,
>  			}
>  		} else {
>  			r = cons_ops[index]->put_chars(vtermnos[index], c, i);
> -			if (r <= 0) {
> +			if (r <= 0 || r > i) {
>  				/* throw away chars on error */
>  				i = 0;
> -			} else if (r > 0) {
> +			} else {
>  				i -= r;
>  				if (i > 0)
>  					memmove(c, c+r, i);

I expect that ->put_chars() will either return a -ve errno or will
return the number of chars which were written, which will be less than
or equal to `i'.

Or maybe I miss your point.

Guys, could we have a MAINTAINERS entry for this driver please?
