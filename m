Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbZBZWSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbZBZWSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZBZWSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:18:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbZBZWSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:18:02 -0500
Date: Thu, 26 Feb 2009 14:16:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frank Seidel <fseidel@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-isdn@vger.kernel.org, fseidel@suse.de,
       frank@f-seidel.de, jolly@eversberg.eu, kkeil@suse.de,
       smurf@smurf.noris.de, andreas@eversberg.eu, hannes@hanneseder.net
Subject: Re: [PATCH][trivial] mISDN: l1oip - reduce stack memory footprint
Message-Id: <20090226141632.6e3c041d.akpm@linux-foundation.org>
In-Reply-To: <49A569D0.2070705@suse.de>
References: <49A569D0.2070705@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 16:54:56 +0100
Frank Seidel <fseidel@suse.de> wrote:

> From: Frank Seidel <frank@f-seidel.de>
> 
> Applying kernel janitors todos (reduce stack
> footprint where possible) to l1oip mISDN driver.
> (Before 1656 bytes on i386, now 164)
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/isdn/mISDN/l1oip_core.c |   21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> --- a/drivers/isdn/mISDN/l1oip_core.c
> +++ b/drivers/isdn/mISDN/l1oip_core.c
> @@ -663,18 +663,28 @@ l1oip_socket_thread(void *data)
>  	struct iovec iov;
>  	mm_segment_t oldfs;
>  	struct sockaddr_in sin_rx;
> -	unsigned char recvbuf[1500];
> +	unsigned char *recvbuf;
> +	size_t recvbuf_size = 1500;
>  	int recvlen;
>  	struct socket *socket = NULL;
>  	DECLARE_COMPLETION(wait);
>  
> +	/* allocate buffer memory */
> +	recvbuf = kmalloc(recvbuf_size * sizeof(*recvbuf), GFP_KERNEL);

It's rather pointless to multiply by sizeof(*recvbuf) here

> -		iov.iov_len = sizeof(recvbuf);
> +		iov.iov_len = recvbuf_size;
>  		oldfs = get_fs();
>  		set_fs(KERNEL_DS);
> -		recvlen = sock_recvmsg(socket, &msg, sizeof(recvbuf), 0);
> +		recvlen = sock_recvmsg(socket, &msg, recvbuf_size, 0);

but not here.


