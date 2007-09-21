Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbXIUIJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbXIUIJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbXIUIJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:09:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753127AbXIUIJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:09:10 -0400
Date: Fri, 21 Sep 2007 01:03:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Yinghai.Lu@Sun.COM, bryan.wu@analog.com,
       dilinger@queued.net, kraxel@redhat.com, kraxel@suse.de,
       lethal@linux-sh.org, rgetz@blackfin.uclinux.org, vapier.adi@gmail.com,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] kernel/printk.c: Concerns about the console handover
Message-Id: <20070921010349.2caee558.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64N.0709201749240.30788@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709201749240.30788@blysk.ds.pg.gda.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 18:28:49 +0100 (BST) "Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>  Move the hadover message to after the boot console has been released to 
> avoid bad interactions between it and the real console.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  The 69331af79cf29e26d1231152a172a1a10c2df511 commit of May 8th added a 
> "console handover: ..." message to register_console() that is output 
> during the short period when both the boot and the newly-registered 
> console are registered.
> 
>  This is presumably fine for boot consoles implemented entirely by Linux 
> as they are fully controlled.  But it may produce problems when the boot 
> console is actually implemented as a call to the firmware which may not be 
> quite happy about how the OS driver for the piece of hardware involved 
> controls it.
> 
>  I hit this problem with the DECstation.  Depending on the configuration 
> the fimrware uses a graphics adapter or a predefined serial port for 
> console output -- which device actually that is cannot be reliably 
> determined by Linux, though an approximation may be possible.  Now if the 
> firmware uses the serial port and Linux is asked to use the same serial 
> port for the real console, then this printk() hangs forever in the 
> firmware.  The driver used is drivers/serial/zs.c.
> 
>  The reason is by the time the ->write() call is issued for the boot 
> console as a result of this printk(), the zs.c driver has been initialised 
> and because at the moment the serial port has not been opened, the serial 
> transmitter is disabled.  The firmware polls for the transmit buffer empty 
> condition, but does not enable the module, presumably under the assumption 
> it will not be called once an OS driver has taken control of the device 
> (the register containing the enable bit is write-only anyway, so it would 
> be hard to restore the previous value).  This causes a hang, because once 
> a single character is put into the transmit buffer it will not become 
> empty until the transmitter has been enabled.
> 
>  The serial console as implemented by zs.c handles the case correctly, by 
> enabling the transmitter, outputting what should be output, waiting for 
> the transmit shift register to drain and restoring the state of the 
> transmitter enable (which is held in a shadow variable).
> 
>  I feel a bit uneasy about keeping serial transmitters enabled for lines 
> that have not been opened; I gather others may agree as for example while 
> not explicitly mentioned, I believe it is implied by what is said in 
> Documentation/serial/driver referring to the ->shutdown() call: "Disable 
> the port, [...]" -- with the transmitter enabled a port can hardly be 
> considered fully disabled.  Below is a change which makes the problem 
> disappear for me, but I suppose there was a deliberate reason for placing 
> the printk() where it is now and nowhere else.
> 
>  Any suggestions will be appreciated.
> 
>   Maciej
> 
> patch-mips-2.6.23-rc5-20070904-printk-handover-0
> diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/kernel/printk.c linux-mips-2.6.23-rc5-20070904/kernel/printk.c
> --- linux-mips-2.6.23-rc5-20070904.macro/kernel/printk.c	2007-09-04 04:56:21.000000000 +0000
> +++ linux-mips-2.6.23-rc5-20070904/kernel/printk.c	2007-09-19 21:10:16.000000000 +0000
> @@ -1014,11 +1014,11 @@ void register_console(struct console *co
>  		return;
>  
>  	if (bootconsole && (console->flags & CON_CONSDEV)) {
> +		unregister_console(bootconsole);
> +		console->flags &= ~CON_PRINTBUFFER;
>  		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
>  		       bootconsole->name, bootconsole->index,
>  		       console->name, console->index);
> -		unregister_console(bootconsole);
> -		console->flags &= ~CON_PRINTBUFFER;
>  	} else {
>  		printk(KERN_INFO "console [%s%d] enabled\n",
>  		       console->name, console->index);

It would be useful to have some basic information like: Which kernel
version was this found in?  Which kernel version last worked?

