Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZFWXaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZFWXaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZFWXaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:30:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591AbZFWXaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:30:13 -0400
Date: Tue, 23 Jun 2009 16:30:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: [PATCH v2 1/1] Char: tty, fix tty_port_block_til_ready waiting
Message-Id: <20090623163006.f05b75ee.akpm@linux-foundation.org>
In-Reply-To: <1245311173-1197-1-git-send-email-jirislaby@gmail.com>
References: <1245311173-1197-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 09:46:13 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Use DEFINE_WAIT instead DECLARE_WAITQUEUE, because we use
> prepare/finish_wait since commit
> 3e3b5c087799e536871c8261b05bc28e4783c8da
> (tty: use prepare/finish_wait)
> 
> Otherwise we would oops in finish_wait.
> 

<scratches head for a while>

OK, here's a better changelog:

   Since commit 3e3b5c087799e536871c8261b05bc28e4783c8da ("tty: use
   prepare/finish_wait"), tty_port_block_til_ready() is using
   prepare_to_wait()/finish_wait().  Those functions require that
   the wait_queue_t be initialised with .func=autoremove_wake_function,
   via DEFINE_WAIT().

   But the conversion from DECLARE_WAITQUEUE() to DEFINE_WAIT() was
   not made, so this code will oops in finish_wait().

> 
> diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
> index 62dadfc..4e862a7 100644
> --- a/drivers/char/tty_port.c
> +++ b/drivers/char/tty_port.c
> @@ -193,7 +193,7 @@ int tty_port_block_til_ready(struct tty_port *port,
>  {
>  	int do_clocal = 0, retval;
>  	unsigned long flags;
> -	DECLARE_WAITQUEUE(wait, current);
> +	DEFINE_WAIT(wait);
>  	int cd;
>  
>  	/* block if port is in the process of being closed */

Why is nobody reporting the oopses?
