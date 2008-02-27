Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbYB0Xak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbYB0Xak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYB0Xab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:30:31 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706AbYB0Xaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:30:30 -0500
Date: Wed, 27 Feb 2008 15:29:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: fix sparse variable shadowing and int as NULL
 pointer in rocket.c
Message-Id: <20080227152948.34b6e295.akpm@linux-foundation.org>
In-Reply-To: <1203702419.5962.8.camel@brick>
References: <1203702419.5962.8.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 09:46:59 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:
>
> Subject: [PATCH] char: fix sparse variable shadowing and int as NULL pointer in rocket.c
>

Please try to make the patch titles big-endian.  This one could have been

char: rocket.c: fix sparse variable shadowing and int as NULL pointer

or even

rocket.c: fix sparse variable shadowing and int as NULL pointer

> Nested min() macros shadow _x, separate into two lines.
> drivers/char/rocket.c:451:7: warning: symbol '_x' shadows an earlier one
> drivers/char/rocket.c:451:7: originally declared here
> drivers/char/rocket.c:451:7: warning: symbol '_x' shadows an earlier one
> drivers/char/rocket.c:451:7: originally declared here
> drivers/char/rocket.c:451:7: warning: symbol '_y' shadows an earlier one
> drivers/char/rocket.c:451:7: originally declared here
> drivers/char/rocket.c:1754:7: warning: symbol '_x' shadows an earlier one
> drivers/char/rocket.c:1754:7: originally declared here
> drivers/char/rocket.c:1754:7: warning: symbol '_x' shadows an earlier one
> drivers/char/rocket.c:1754:7: originally declared here
> drivers/char/rocket.c:1754:7: warning: symbol '_y' shadows an earlier one
> drivers/char/rocket.c:1754:7: originally declared here
> drivers/char/rocket.c:1751:20: warning: Using plain integer as NULL pointer
> 

That's really a sparse glitch.  There's nothing we can sanely do about it.

> ---
>  drivers/char/rocket.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
> index 72f2892..2778d64 100644
> --- a/drivers/char/rocket.c
> +++ b/drivers/char/rocket.c
> @@ -448,7 +448,8 @@ static void rp_do_transmit(struct r_port *info)
>  	while (1) {
>  		if (tty->stopped || tty->hw_stopped)
>  			break;
> -		c = min(info->xmit_fifo_room, min(info->xmit_cnt, XMIT_BUF_SIZE - info->xmit_tail));
> +		c = min(info->xmit_fifo_room, info->xmit_cnt);
> +		c = min(c, XMIT_BUF_SIZE - info->xmit_tail);

Apart from things like that.

Probably this code is cleaner than the old version so let's do it, but it
seems that we need a general fix.

