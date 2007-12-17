Return-Path: <linux-kernel-owner+w=401wt.eu-S936099AbXLQMRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936099AbXLQMRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935603AbXLQMQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:16:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:4981 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbXLQMQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:16:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=K0088I9x/6i0i9lsmR2VyNNY9REfrc4s/OtTJL8UUpmiQKyAY+i2216xjMpEYkcX3ON47scTbXIaIkoX8BPLJG1WgUkg9tnaARptIwI53d7Whmu7/bdi4wrkPiZGKIsfX5o5Nb7/BiuAUDMcx1K6OtLYzVmERn/wO+Ie47XzkIg=
Message-ID: <4766684D.40202@gmail.com>
Date: Mon, 17 Dec 2007 13:15:09 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu>
In-Reply-To: <20071217105744.GA14315@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-12-07 11:57, Ingo Molnar wrote:

> thanks Rene! I've added your patch to x86.git. I changed a few things 
> ontop of it, see the additional changelog and delta patch below.

"appropriated it", more. Definitely not going to forgive you for deleting 
that comment.

>  void native_io_delay(void)
>  {
> -	io_delay();
> +	switch (io_delay_type) {

That's the clumsy bit. native_io_delay() used to be an inline outb, now it's 
a switch. Yes, sure, versus an indirect call it's not actually worse, except 
  as an uglification.

> -#ifndef CONFIG_UDELAY_IO_DELAY
> -static int __init dmi_alternate_io_delay_port(const struct dmi_system_id *id)
> +static int __init dmi_io_delay_0xed_port(const struct dmi_system_id *id)
>  {
> -	printk(KERN_NOTICE "%s: using alternate I/O delay port\n", id->ident);
> -	io_delay = alternate_io_delay;
> +	printk(KERN_NOTICE "%s: using 0xed I/O delay port\n", id->ident);
> +	io_delay_type = CONFIG_IO_DELAY_TYPE_0XED;
> +
>  	return 0;
>  }

This isn't correct. DMI shouldn't override the CONFIG choice or someone with 
matching DMI will have a defective CONFIG option. That's why I put all of it 
inside #ifndef.

Rene.


