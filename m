Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbZJOLGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbZJOLGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761460AbZJOLGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:06:33 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:39882 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762672AbZJOLGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:06:32 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH] hvc_console: returning 0 from put_chars is not an error
Date: Thu, 15 Oct 2009 13:05:47 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc4-self-00094-g80f5069-dirty; KDE/4.3.1; i686; ; )
Cc: linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       brueckner@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1255557226-4403-1-git-send-email-timur@freescale.com>
In-Reply-To: <1255557226-4403-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910151305.47100.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 14 Oktober 2009 23:53:46 schrieben Sie:
> hvc_console_print() calls the HVC client driver's put_chars() callback
> to write some characters to the console.  If the callback returns 0, that
> indicates that no characters were written (perhaps the output buffer is
> full), but hvc_console_print() treats that as an error and discards the
> rest of the buffer.
> 
> So change hvc_console_print() to just loop and call put_chars() again if it
> returns a 0 return code.
> 
> This change makes hvc_console_print() behave more like hvc_push(), which
>  does check for a 0 return code and re-schedules itself.

There is a difference between console and tty, if the console call does not 
return, it might bring the full system to a stop. (if its the preferred console, 
init will stop)

> This patch might fix drivers that return 0 to indicate that they're busy, such 
> as arch/powerpc/platforms/pseries/hvconsole.c. It will break drivers that
> return 0 if their output buffer is full, but where those buffers cannot be
> emptied while the kernel is in a loop.

Yep. I think it really depends on the backend if looping will result in any 
progress or not. My experience wth hvc_console is, that its quite hard to get 
changes tested on all backends. (e.g. XEN, pseries, iseries, virtio_console, 
s390_iucv...), so even if this change turns out to be correct, it should 
probably sit in linux-next for a while. In additon I really dont oversee, what 
backends wil break due to this patch.

The fact that struct console->write returns void indicates that the console 
layer is not interested in errors. We have two policies we can implement:

1. drop console messages if case of congestion but keep the system going
2. dont drop messages and wait, even if the system might come to a complete stop 

Looking at drivers/char/vt.c 
        /* console busy or not yet initialized */
        if (!printable)
                return;
        if (!spin_trylock(&printing_lock))
                return;
could mean that  Linux consoles should not block.

Maybe its time to ask some of the elder magicians (CCing Alan Cox and linux-
kernel) about blocking and error handling in console code.


> --- a/drivers/char/hvc_console.c
> +++ b/drivers/char/hvc_console.c
> @@ -161,7 +161,7 @@ static void hvc_console_print(struct console *co, const
>  char *b, }
>  		} else {
>  			r = cons_ops[index]->put_chars(vtermnos[index], c, i);
> -			if (r <= 0) {
> +			if (r < 0) {
>  				/* throw away chars on error */
>  				i = 0;
>  			} else if (r > 0) {
> 
