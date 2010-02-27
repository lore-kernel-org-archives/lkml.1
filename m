Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966849Ab0B0Bar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 20:30:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51817 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966798Ab0B0Baq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 20:30:46 -0500
Date: Sat, 27 Feb 2010 01:33:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] hvc_console: Fix a race between hvc_close and
 hvc_remove
Message-ID: <20100227013359.5e50f032@lxorguk.ukuu.org.uk>
In-Reply-To: <1267184786-4377-1-git-send-email-amit.shah@redhat.com>
References: <1267184786-4377-1-git-send-email-amit.shah@redhat.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	tty_kref_get(hp->tty);
>  	spin_lock_irqsave(&hp->lock, flags);
>  	tty = hp->tty;
>  
> @@ -830,7 +833,9 @@ int hvc_remove(struct hvc_struct *hp)
>  	 * cleaned up the hvc_struct.
>  	 */
>  	if (tty)
> -		tty_hangup(tty);
> +		tty_vhangup(tty);
> +
> +	tty_kref_put(hp->tty);

You need to deref hp->tty, take the kref under the lock (and indeed do
all assignments to it that way too), then tty_kref_put(tty), otherwise
what stops hp->tty changing during the remove ?

Take a look how tty_port_tty_get() and tty_port.c does it ...

Alan
