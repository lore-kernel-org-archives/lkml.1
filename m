Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbXGZFJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbXGZFJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXGZFJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:09:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41069 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495AbXGZFJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:09:15 -0400
Date: Wed, 25 Jul 2007 22:08:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Char: moxa, fix and optimise empty timer
Message-Id: <20070725220826.3fdb7677.akpm@linux-foundation.org>
In-Reply-To: <31400312111566521886@wsc.cz>
References: <31400312111566521886@wsc.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 23:43:29 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:

> moxa, fix and optimise empty timer
> 
> don't wait and delete empty timer in empty timer function. Also fire next
> empty timer at rounded jiffies to save power.
> 

What is actually being "fixed" here?

> 
> ---
> commit da52793b6347e8b6b048526ce2422e29b20bb335
> tree ad0bee78e45beef89dc740f81e0606d782296542
> parent 3a69b463dcad1ff142f46e8fb74e7dc5a092eb60
> author Jiri Slaby <jirislaby@gmail.com> Wed, 25 Jul 2007 23:42:49 +0200
> committer Jiri Slaby <jirislaby@gmail.com> Wed, 25 Jul 2007 23:42:49 +0200
> 
>  drivers/char/moxa.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
> index ed76f0a..5000b3b 100644
> --- a/drivers/char/moxa.c
> +++ b/drivers/char/moxa.c
> @@ -1040,14 +1040,14 @@ static void check_xmit_empty(unsigned long data)
>  	struct moxa_port *ch;
>  
>  	ch = (struct moxa_port *) data;
> -	del_timer_sync(&moxa_ports[ch->port].emptyTimer);
>  	if (ch->tty && (ch->statusflags & EMPTYWAIT)) {
>  		if (MoxaPortTxQueue(ch->port) == 0) {
>  			ch->statusflags &= ~EMPTYWAIT;
>  			tty_wakeup(ch->tty);
>  			return;
>  		}
> -		mod_timer(&moxa_ports[ch->port].emptyTimer, jiffies + HZ);
> +		mod_timer(&moxa_ports[ch->port].emptyTimer,
> +				round_jiffies(jiffies + HZ));
>  	} else
>  		ch->statusflags &= ~EMPTYWAIT;
>  }

A call to check_xmit_empty() used to guarantee that the timer was no longer
running (if the first `if' succeeds and the second does not), but that is
no longer the case.  You're sure this is correct?

