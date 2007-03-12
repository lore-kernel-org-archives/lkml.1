Return-Path: <linux-kernel-owner+w=401wt.eu-S1030599AbXCLQun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030599AbXCLQun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030659AbXCLQun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:50:43 -0400
Received: from rtr.ca ([64.26.128.89]:3216 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030599AbXCLQuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:50:35 -0400
Message-ID: <45F584D9.4090802@rtr.ca>
Date: Mon, 12 Mar 2007 12:50:33 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45EB9DC6.8010403@rtr.ca> <45F56A2D.9010808@rtr.ca> <200703121606.06601.oneukum@suse.de> <45F56E37.9050506@rtr.ca> <20070312152920.GA29597@kroah.com> <45F579CF.7040802@rtr.ca> <45F57BB8.5010705@rtr.ca> <45F57C52.1010105@rtr.ca> <45F57F63.7010308@rtr.ca>
In-Reply-To: <45F57F63.7010308@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>
> Okay, from that part (above), the problem is obvious:
> in that the "MCT U232 converter now disconnected" appears,
> and then we continue to try and call the driver's method.. Oops!
> 
> The hack patch below "fixes" this, but it really just hides whatever
> the real problem underneath was:
> 
> Signed-off-by:  Mark Lord <mlord@pobox.com>
> ---
> --- linux/include/linux/usb/serial.h.orig    2007-03-12 
> 12:18:48.000000000 -0400
> +++ linux/include/linux/usb/serial.h    2007-03-12 12:18:23.000000000 -0400
> @@ -99,11 +99,19 @@
> /* get and set the port private data pointer helper functions */
> static inline void *usb_get_serial_port_data (struct usb_serial_port *port)
> {
> +    if (!port) {
> +        WARN_ON(1);
> +        return NULL;
> +    }
>     return dev_get_drvdata(&port->dev);
> }
> 
> static inline void usb_set_serial_port_data (struct usb_serial_port 
> *port, void *data)
> {
> +    if (!port) {
> +        WARN_ON(1);
> +        return;
> +    }
>     dev_set_drvdata(&port->dev, data);
> }
> 

Mmmm.. and that same hack also prevents the Oops seen
when I leave ckermit running during suspend/resume(RAM),
giving me this BUG() report now instead:

12:29:51 kernel: pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
12:29:51 kernel: BUG: at include/linux/usb/serial.h:103 usb_get_serial_port_data()
12:29:51 kernel:  [<f8a03254>] pl2303_shutdown+0x95/0xb5 [pl2303]
12:29:51 kernel:  [<f8a23ca1>] destroy_serial+0x89/0x122 [usbserial]
12:29:51 kernel:  [<f8a23c18>] destroy_serial+0x0/0x122 [usbserial]
12:29:51 kernel:  [kref_put+95/110] kref_put+0x5f/0x6e
12:29:51 kernel:  [tty_fasync+60/180] tty_fasync+0x3c/0xb4
12:29:51 kernel:  [release_dev+484/1496] release_dev+0x1e4/0x5d8
12:29:51 kernel:  [find_get_page+21/69] find_get_page+0x15/0x45
12:29:51 kernel:  [filemap_nopage+385/726] filemap_nopage+0x181/0x2d6
12:29:51 kernel:  [pty_write+43/53] pty_write+0x2b/0x35
12:29:51 kernel:  [getnstimeofday+48/216] getnstimeofday+0x30/0xd8
12:29:51 kernel:  [rb_insert_color+74/173] rb_insert_color+0x4a/0xad
12:29:51 kernel:  [enqueue_hrtimer+256/268] enqueue_hrtimer+0x100/0x10c
12:29:51 kernel:  [tty_release+15/24] tty_release+0xf/0x18
12:29:51 kernel:  [__fput+150/336] __fput+0x96/0x150
12:29:51 kernel:  [filp_close+79/86] filp_close+0x4f/0x56
12:29:51 kernel:  [sys_close+117/183] sys_close+0x75/0xb7
12:29:51 kernel:  [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
12:29:51 kernel:  =======================
