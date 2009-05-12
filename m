Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbZELWCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbZELWCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZELWCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:02:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbZELWCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:02:35 -0400
Date: Tue, 12 May 2009 15:00:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Deepak Saxena <dsaxena@plexity.net>
cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: Don't restore NS16550 mode when console suspend
 is disabled
In-Reply-To: <20090512210015.GA25540@plexity.net>
Message-ID: <alpine.LFD.2.01.0905121452190.3343@localhost.localdomain>
References: <20090512210015.GA25540@plexity.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 May 2009, Deepak Saxena wrote:
> 
> Commit b5b82df6, from May 2007, breaks no_console_suspend on the OLPC 
> XO laptop. Basically what happens is that upon returning from resume, 
> serial8250_resume_port() will reconfigure the port for high speed
> mode and all console output will be garbled, making debug of the 
> resume path painful. This patch modifies serial8250_resume_port() to 
> not touch the port in the case where it is the console port and console 
> suspend is disabled.
> 
> Signed-off-by: Deepak Saxena <dsaxena@laptop.org>
> 
> ---
> The OLPC tree has been carrying a workaround for about two years but
> this patch is not the version we've been using. That one can be
> found at http://dev.laptop.org/~dsaxena/patches/console_suspend_old.patch.
> I prefer the approach of handling this in the 8250 driver itself.

Hmm. I already applied this, but then after looking closer, I undid that. 
Why? It looks buggy:

> -	if (up->capabilities & UART_NATSEMI) {
> +	if ((up->capabilities & UART_NATSEMI) && 
> +	     (!uart_console(&up->port) && console_suspend_enabled)) {
>  		unsigned char tmp;

Isn't that second test wrong? Should it not be

	if ((up->capabilities & UART_NATSEMI) &&
		(console_suspend_enabled || !uart_console(&up->port)) {

instead?

In fact, I'd suggest making a helper function called 
"do_suspend_uart(up)", something like

	/*
	 * Suspend the uart port unless it's a console. 
	 *
	 * But suspend even consoles if "console_suspend_enabled"
	 * is set.
	 */
	static inline int do_suspend_uart(struct uart_port *port)
	{
		return console_suspend_enabled || !uart_console(port);
	}

and then make all these things (including the _existing_ cases in 
uart_suspend_port() use that helper function, rather than writing it out.

		Linus
