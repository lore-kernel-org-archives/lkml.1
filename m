Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966532Ab0BZXD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:03:27 -0500
Received: from kroah.org ([198.145.64.141]:58126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966501Ab0BZXD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:03:26 -0500
Date: Fri, 26 Feb 2010 14:11:00 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/5] tty: Add a function to insert a string of
 characters with the same flag
Message-ID: <20100226221100.GA22352@kroah.com>
References: <20100217130604.16008.86393.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217130604.16008.86393.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 01:06:30PM +0000, Alan Cox wrote:
> The USB drivers often want to insert a series of bytes all with the same
> flag set - provide a helper for this case.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/char/tty_buffer.c |   12 +++++++-----
>  include/linux/tty_flip.h  |    7 ++++++-
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
> index 8402eda..af8d977 100644
> --- a/drivers/char/tty_buffer.c
> +++ b/drivers/char/tty_buffer.c
> @@ -231,9 +231,10 @@ int tty_buffer_request_room(struct tty_struct *tty, size_t size)
>  EXPORT_SYMBOL_GPL(tty_buffer_request_room);
>  
>  /**
> - *	tty_insert_flip_string	-	Add characters to the tty buffer
> + *	tty_insert_flip_string_fixed_flag - Add characters to the tty buffer
>   *	@tty: tty structure
>   *	@chars: characters
> + *	@flag: flag value for each character
>   *	@size: size
>   *
>   *	Queue a series of bytes to the tty buffering. All the characters
> @@ -242,18 +243,19 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
>   *	Locking: Called functions may take tty->buf.lock
>   */
>  
> -int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars,
> -				size_t size)
> +int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
> +		const unsigned char *chars, char flag, size_t size)
>  {
>  	int copied = 0;
>  	do {
> +		int goal = min(size - copied, TTY_BUFFER_PAGE);

This variable isn't used in this function.

>  		int space = tty_buffer_request_room(tty, goal);
>  		struct tty_buffer *tb = tty->buf.tail;
>  		/* If there is no space then tb may be NULL */
>  		if (unlikely(space == 0))
>  			break;
>  		memcpy(tb->char_buf_ptr + tb->used, chars, space);
> -		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
> +		memset(tb->flag_buf_ptr + tb->used, flag, space);

Should you have "goal" here instead of "space"?

thanks,

greg k-h
