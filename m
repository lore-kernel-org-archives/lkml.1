Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbYJ1BzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbYJ1BzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYJ1BzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:55:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbYJ1By7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:54:59 -0400
Date: Mon, 27 Oct 2008 18:54:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RESEND PATCH] autofs4 - remove string terminator check
Message-Id: <20081027185418.0bfd0fcd.akpm@linux-foundation.org>
In-Reply-To: <20081028011430.4976.320.stgit@zeus.themaw.net>
References: <20081028011430.4976.320.stgit@zeus.themaw.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 10:14:30 +0900 Ian Kent <raven@themaw.net> wrote:

> In a previous patch a comment was made that checking for the existence of
> a NULL terminator in strings copied from userspace wasn't needed as this
> is done in many places in the kernel without problem. This patch removes
> this string terminator check.
> 

ah, OK.  Now I'm worried.

> 
>  fs/autofs4/dev-ioctl.c |   20 --------------------
>  1 files changed, 0 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> index 625abf5..304c1ff 100644
> --- a/fs/autofs4/dev-ioctl.c
> +++ b/fs/autofs4/dev-ioctl.c
> @@ -51,18 +51,6 @@ static int check_name(const char *name)
>  }
>  
>  /*
> - * Check a string doesn't overrun the chunk of
> - * memory we copied from user land.
> - */
> -static int invalid_str(char *str, void *end)
> -{
> -	while ((void *) str <= end)
> -		if (!*str++)
> -			return 0;
> -	return -EINVAL;
> -}
> -
> -/*
>   * Check that the user compiled against correct version of autofs
>   * misc device code.
>   *
> @@ -143,14 +131,6 @@ static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
>  				    cmd);
>  			goto out;
>  		}
> -
> -		err = invalid_str(param->path,
> -				 (void *) ((size_t) param + param->size));
> -		if (err) {
> -			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
> -				    cmd);
> -			goto out;
> -		}
>  	}
>  
>  	err = 0;

What will now happen if userspace passes in a non-null-terminated
string (if that's possible)?

Presumably that isn't possible, or it's never been tested, because
before we check for null-termination we run check_name(), which
_assumes_ null-termination!

The comment over validate_dev_ioctl() will need the "and is terminated"
removed after this change, yes?

