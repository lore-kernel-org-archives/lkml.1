Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZCFWjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZCFWjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZCFWil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:38:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756198AbZCFWik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:38:40 -0500
Date: Fri, 6 Mar 2009 14:37:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       graf.yang@analog.com, cooloney@kernel.org
Subject: Re: [PATCH 02/18] Blackfin Serial Driver: use barrier instead of
 cpu_relax for Blackfin SMP like patch
Message-Id: <20090306143756.738db0ee.akpm@linux-foundation.org>
In-Reply-To: <1236321780-28718-3-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-3-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 14:42:44 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Graf Yang <graf.yang@analog.com>
> 
> We are making a SMP like patch to blackfin, cpu_relax() is replaced by a
> data cache flush function which will count it to a per-cpu counter.
> If this serial function is called too early, the per-cpu data area have
> not been initialized, this call will cause crash.

That's a bug in blackfin architecture support.  The kernel should be
able to call cpu_relax() at any time, surely.  It's a very low-level
and simple thing.

> So we'd like to use barrier() instead of cpu_relax().
> 

barrier() is purely a compiler concept.  We might as well just remove
the cpu_relax() altogether.


>  drivers/serial/bfin_5xx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> index 52ccc27..350bfc4 100644
> --- a/drivers/serial/bfin_5xx.c
> +++ b/drivers/serial/bfin_5xx.c
> @@ -1129,7 +1129,8 @@ static __init void early_serial_putc(struct uart_port *port, int ch)
>  	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
>  
>  	while ((!(UART_GET_LSR(uart) & THRE)) && --timeout)
> -		cpu_relax();
> +		barrier();
> +
>  	UART_PUT_CHAR(uart, ch);
>  }

I grumpily queued this, but it seems all wrong.
