Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbYCaX55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbYCaX55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 19:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYCaX5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 19:57:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbYCaX5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:57:48 -0400
Date: Mon, 31 Mar 2008 16:57:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 3/4] Char: ip2, fix sparse warnings
Message-Id: <20080331165718.0fb7c14e.akpm@linux-foundation.org>
In-Reply-To: <1206739124-3875-3-git-send-email-jirislaby@gmail.com>
References: <20080328032449.cbc09f3b.akpm@linux-foundation.org>
	<1206739124-3875-3-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 22:18:43 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> Unlock two grabbed locks on some paths.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/char/ip2/i2lib.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/ip2/i2lib.c b/drivers/char/ip2/i2lib.c
> index 618f5fe..1d5388c 100644
> --- a/drivers/char/ip2/i2lib.c
> +++ b/drivers/char/ip2/i2lib.c
> @@ -643,12 +643,12 @@ i2QueueCommands(int type, i2ChanStrPtr pCh, int timeout, int nCommands,
>  				// Normal Expected path - We still hold LOCK
>  				break; /* from for()- Enough room: goto proceed */
>  			}
> -		}
> -
> -		ip2trace (CHANN, ITRC_QUEUE, 3, 1, totalsize );
> +			ip2trace(CHANN, ITRC_QUEUE, 3, 1, totalsize);
> +			write_unlock_irqrestore(lock_var_p, flags);
> +		} else
> +			ip2trace(CHANN, ITRC_QUEUE, 3, 1, totalsize);
>  
>  		// Prepare to wait for buffers to empty
> -		write_unlock_irqrestore(lock_var_p, flags);
>  		serviceOutgoingFifo(pB);	// Dump what we got
>  
>  		if (timeout == 0) {
> @@ -1834,6 +1834,8 @@ i2StripFifo(i2eBordStrPtr pB)
>  		default: // Neither packet? should be impossible
>  			ip2trace (ITRC_NO_PORT, ITRC_SFIFO, 5, 1,
>  				PTYPE_OF(pB->i2eLeadoffWord) );
> +			write_unlock_irqrestore(&pB->read_fifo_spinlock,
> +					bflags);
>  
>  			break;
>  		}  // End of switch on type of packets

Your tree apparently has a sensible-looking write_unlock_irqrestore(),
whereas mine has a stupid-looking WRITE_UNLOCK_IRQRESTORE().  How did this
happen?

