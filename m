Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYBRUhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYBRUhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYBRUh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:37:28 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:55396 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYBRUh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:37:27 -0500
Message-ID: <47B9ECE0.70000@keyaccess.nl>
Date: Mon, 18 Feb 2008 21:38:56 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in kernel
 and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net>
In-Reply-To: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.6 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-02-08 19:58, David P. Reed wrote:

> --- linux-2.6.orig/include/asm-x86/i8253.h
> +++ linux-2.6/include/asm-x86/i8253.h
> @@ -12,7 +12,25 @@ extern struct clock_event_device *global
>  
>  extern void setup_pit_timer(void);
>  
> -#define inb_pit		inb_p
> -#define outb_pit	outb_p
> +/* accesses to PIT registers need careful delays on some platforms. Define
> +   them here in a common place */
> +static inline unsigned char inb_pit(unsigned int port)
> +{
> +	/* delay for some accesses to PIT on motherboard or in chipset must be
> +	   at least one microsecond, but be safe here. */
> +	unsigned char value = inb(port);
> +	udelay(2);
> +	return value;
> +}

With the remark that (at least) the PIT is accessed at a time that 
microseconds and hence udelay are still a total fiction, this looks obvious 
otherwise.

Now with respect to the original pre port 80 "jmp $+2" I/O delay (which the 
Pentium obsoleted) I suppose it'll probably be okay even without fixing that 
specifically but do note such -- it's a vital part of the problem.

Rene.
