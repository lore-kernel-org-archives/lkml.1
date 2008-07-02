Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbYGBVWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbYGBVWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYGBVU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:20:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760895AbYGBVUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:20:55 -0400
Date: Wed, 2 Jul 2008 14:18:30 -0700
From: Greg KH <greg@kroah.com>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: 2.6.26-rc2 WARNING from usb-serial, and then my gps is dead
Message-ID: <20080702211830.GA26541@kroah.com>
References: <485E984B.1030306@aitel.hist.no> <20080622184253.GB18502@kroah.com> <48622C5E.5020204@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48622C5E.5020204@aitel.hist.no>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 01:30:38PM +0200, Helge Hafting wrote:
> Greg KH wrote:
>> On Sun, Jun 22, 2008 at 08:22:03PM +0200, Helge Hafting wrote:
>>> This is what I got:
>>> ------------[ cut here ]------------
>>> WARNING: at drivers/usb/serial/usb-serial.c:306 serial_write+0x62/0x89 
>>> [usbserial]()
>>> Modules linked in: pl2303 usbserial sbs sbshc coretemp piix pcmcia 
>>> ata_piix iTCO_wdt ata_generic bay hci_usb intel_agp
>>> Pid: 10, comm: events/1 Tainted: G        W 2.6.26-rc2-hh1 #1
>>>
>>> Call Trace:
>>>  [<ffffffff80236b54>] warn_on_slowpath+0x51/0x7a
>>>  [<ffffffff8022c207>] __wake_up+0x38/0x4f
>>>  [<ffffffff8024565c>] __queue_work+0x23/0x33
>>>  [<ffffffff802456c8>] queue_work+0x37/0x40
>>>  [<ffffffffa0045fa3>] :pl2303:pl2303_write+0xf2/0x101
>>>  [<ffffffffa003c368>] :usbserial:serial_write+0x62/0x89
>>>  [<ffffffff803a8e81>] tty_put_char+0x2b/0x2d
>>>  [<ffffffff803ad3ca>] echo_char+0x47/0x60
>>>  [<ffffffff803ade97>] n_tty_receive_buf+0x2b4/0xd76
>>>  [<ffffffff8020a87e>] __switch_to+0xa2/0x396
>>>  [<ffffffff8023028d>] hrtick_set+0x88/0xf6
>>>  [<ffffffff80590b44>] thread_return+0x70/0xb4
>>>  [<ffffffff8023f013>] lock_timer_base+0x26/0x4c
>>>  [<ffffffff803a9abd>] flush_to_ldisc+0xf8/0x185
>>>  [<ffffffff803a99c5>] flush_to_ldisc+0x0/0x185
>>>  [<ffffffff8024520b>] run_workqueue+0x80/0x112
>>>  [<ffffffff80245afe>] worker_thread+0xd9/0xe8
>>>  [<ffffffff80248380>] autoremove_wake_function+0x0/0x2e
>>>  [<ffffffff80245a25>] worker_thread+0x0/0xe8
>>>  [<ffffffff80248264>] kthread+0x47/0x73
>>>  [<ffffffff802318c1>] schedule_tail+0x28/0x5d
>>>  [<ffffffff8020cf88>] child_rip+0xa/0x12
>>>  [<ffffffff8024821d>] kthread+0x0/0x73
>>>  [<ffffffff8020cf7e>] child_rip+0x0/0x12
>>>
>>> ---[ end trace 656e180042992f9e ]---
>>> I looked at the dmesg log because I have had lots of trouble with my gps 
>>> lately. I first suspected the cable, but then I saw this.
>>>
>>> After this, I have to restart gpsd, and perhaps replug the cable to get
>>> things going again. Until it happens again. This is a 64-bit dualcore 
>>> laptop.
>> Ick, that's not nice.
>> Can you enable debugging for the usb-serial core:
>> 	echo 1 > /sys/module/usbserial/parameters/debug
>> and then run whatever program you were running that causes this warning
>> and then send us the kernel log?
>
> USB logging sure creates lots of data.
> 8.4M of log bzipped into 237kB here:
> http://www.aitel.hist.no/~helgehaf/usbtrouble1.log.bz2
>
> This contains:
> * Kernel log all the way from bootup (2.6.26-rc8)
> * An USB incident before I turned USB logging on
> * An USB incident after I turned USB logging on
>
> Almost all of it is these two lines repeating forewer:
> drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
> drivers/usb/serial/usb-serial.c: serial_write_room - port 0
>
> The port numbers change a couple of times throughout the log.

Ah, sorry for the delay, got sidetracked with other bugs...

In looking at this further, it's just a warning that is triggering,
nothing to really be woried about right now.  Alan Cox has done a lot of
work in this area in the tty layer rework for 2.6.27 that should keep
this race from happening in the future (something is calling write_room
on a port that was previously closed, not very nice.)

So you can safely ignore it, it should not be causing any problems, only
showing examples of a flaky connection/hardware.

thanks for your patience,

greg k-h
