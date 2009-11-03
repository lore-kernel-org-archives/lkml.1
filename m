Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZKCAaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZKCAaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 19:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbZKCAa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 19:30:29 -0500
Received: from relais.videotron.ca ([24.201.245.36]:14861 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373AbZKCAa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 19:30:29 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 02 Nov 2009 19:30:33 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, linux-mmc@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, dhowells@redhat.com
Subject: Re: [PATCH 0/6] Clean up the sdio_uart driver and fix the tty code
In-reply-to: <alpine.LFD.2.00.0911021542520.13333@xanadu.home>
Message-id: <alpine.LFD.2.00.0911021731260.13333@xanadu.home>
References: <20091102164039.11877.88825.stgit@localhost.localdomain>
 <alpine.LFD.2.00.0911021243040.13333@xanadu.home>
 <20091102191604.010acbc9@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.0911021542520.13333@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, Nicolas Pitre wrote:

> With this folded in, the card does work with the full series applied.  
> However the kernel is now crashing when the card is pulled out while 
> some process is reading from the device.  This used to behave well 
> before. I don't have time to investigate that one right now though.

OK, here more data points:

My test is to insert GPS card and do a 'cat /dev/ttySDIO0' and watch 
NMEA data scrolling by.

With "sdio_uart: Move the open lock" applied, I can pull the card out 
and the cat process terminates.  However inserting the card back and 
repeating the test again always gives me:

	cat: /dev/ttySDIO0: Input/output error

until I reboot.  Same thing happens if I terminates cat with ^C and 
start it again.

With "sdio_uart: Switch to the open/close helpers" applied, things got 
even worse.  Interrupting cat with ^C still gives the same result as 
above.  But yanking the card out when cat is still running doesn't 
terminate cat unless I ^C it at which point the kernel crashes with a 
BUG().  The backtrace is:

[<c0029c88>] (__bug+0x18/0x24) from [<c02665d0>] (sdio_writeb+0x1c/0x4c)
[<c02665d0>] (sdio_writeb+0x1c/0x4c) from [<c01b4098>] (tty_port_lower_dtr_rts+0x1c/0x20)
[<c01b4098>] (tty_port_lower_dtr_rts+0x1c/0x20) from [<c01b412c>] (tty_port_close_end+0x2c/0x130)
[<c01b412c>] (tty_port_close_end+0x2c/0x130) from [<c01b49a8>] (tty_port_close+0x2c/0x3c)
[<c01b49a8>] (tty_port_close+0x2c/0x3c) from [<c01ae0c4>] (tty_release_dev+0x17c/0x478)
[<c01ae0c4>] (tty_release_dev+0x17c/0x478) from [<c01ae3e8>] (tty_release+0x28/0x4c)
[<c01ae3e8>] (tty_release+0x28/0x4c) from [<c00b5bf0>] (__fput+0x118/0x210)
[<c00b5bf0>] (__fput+0x118/0x210) from [<c00b28b4>] (filp_close+0x70/0x7c)
[<c00b28b4>] (filp_close+0x70/0x7c) from [<c003d0e0>] (put_files_struct+0x80/0xd4)
[<c003d0e0>] (put_files_struct+0x80/0xd4) from [<c003eac0>] (do_exit+0x220/0x714)
[<c003eac0>] (do_exit+0x220/0x714) from [<c003f074>] (do_group_exit+0xc0/0xf4)
[<c003f074>] (do_group_exit+0xc0/0xf4) from [<c004d8d0>] (get_signal_to_deliver+0x3c8/0x428)
[...] (impressive nesting culled)

Only after backing out those 2 patches as wellas "sdio_uart: refcount 
the tty objects" is the correct behavior restored.


Nicolas



[<c004d8d0>] (get_signal_to_deliver+0x3c8/0x428) from [<c0028b34>] (do_notify_resume+0x5c/0x5d0)
[<c0028b34>] (do_notify_resume+0x5c/0x5d0) from [<c0026a88>] (work_pending+0x1c/0x20)





> 
> 
> Nicolas
> 
