Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYFYLAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYFYLAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYFYLA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:00:27 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:50105 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYFYLAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:00:25 -0400
Message-ID: <48622546.6070505@aitel.hist.no>
Date: Wed, 25 Jun 2008 13:00:22 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
Organization: HiST
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.26-rc2 WARNING from usb-serial, and then my gps is dead
References: <485E984B.1030306@aitel.hist.no>	<20080622184253.GB18502@kroah.com> <20080622210113.9971488b.akpm@linux-foundation.org>
In-Reply-To: <20080622210113.9971488b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 22 Jun 2008 11:42:53 -0700 Greg KH <greg@kroah.com> wrote:
> 
>> On Sun, Jun 22, 2008 at 08:22:03PM +0200, Helge Hafting wrote:
>>> This is what I got:
>>> ------------[ cut here ]------------
>>> WARNING: at drivers/usb/serial/usb-serial.c:306 serial_write+0x62/0x89 
>>> [usbserial]()
>>> Modules linked in: pl2303 usbserial sbs sbshc coretemp piix pcmcia ata_piix 
>>> iTCO_wdt ata_generic bay hci_usb intel_agp
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
>>
>> Can you enable debugging for the usb-serial core:
>> 	echo 1 > /sys/module/usbserial/parameters/debug

Sorry for taking some time, I've been struggling with the init system.
I now see that the problem still is in 2.6.26-rc8, I will do that
debugging thing next.

>> and then run whatever program you were running that causes this warning
>> and then send us the kernel log?

I run "udev" that starts "gpsd" when I plug in a gps. The gps
is then connected to /dev/ttyUSB0. I then run
"gpxlogger" that simply contact gpsd and prints coordinates to stdout.
I also run "xgps" that contact gpsd in order to show some info about
the gps satellites in use. All software from debian testing.

The problem is triggered by bending the USB cable - likely a cable 
fault. Sometimes I merely get a plain USB device disconnect. (This also
aborts my gps logging as the gps tend to reconnect to /dev/ttyUSB1 
instead of /dev/ttyUSB0, but I guess that is a userland issue, not a 
kernel problem. Or is this a race condition?)


>>
> 
> Also, lots of things have been fixed since 2.6.26-rc2 - there might be
> benefit in retesting 2.6.26-rc7.
> 
> And can you tell us whether this is new behaviour?  Was 2.6.25 OK?

I did not see it with 2.6.25, although the cable may have been OK at 
that time. I can test 2.6.25 after getting some USB debug output.


2.6.26-rc8 dmesg output, if it may help. I have only one pl2303 device.
Still, it reconnects to ttyUSB1 before detaching from ttyUSB0 ???


hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0004
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC 
CONNECT
hub 2-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003801 POWER OWNER sig=j 
CONNECT
hub 2-0:1.0: port 2 not reset yet, waiting 50ms
usb usb5: wakeup_rh (auto-start)
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER 
sig=se0 CSC
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
hub 5-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
usb 5-2: new full speed USB device using uhci_hcd and address 2
usb 5-2: default language 0x0409
usb 5-2: uevent
usb 5-2: usb_probe_device
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: adding 5-2:1.0 (config #1, interface 0)
usb 5-2:1.0: uevent
drivers/usb/core/inode.c: creating file '002'
usb 5-2: New USB device found, idVendor=067b, idProduct=2303
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: USB-Serial Controller
usb 5-2: Manufacturer: Prolific Technology Inc.
hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0004
usbcore: registered new interface driver usbserial
usbserial: USB Serial support registered for generic
usbserial_generic 3-2:1.2: usb_probe_interface
usbserial_generic 3-2:1.2: usb_probe_interface - got id
usbserial_generic 7-1.2:1.0: usb_probe_interface
usbserial_generic 7-1.2:1.0: usb_probe_interface - got id
usbserial_generic 5-2:1.0: usb_probe_interface
usbserial_generic 5-2:1.0: usb_probe_interface - got id
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
usbserial: USB Serial support registered for pl2303
pl2303 5-2:1.0: usb_probe_interface
pl2303 5-2:1.0: usb_probe_interface - got id
pl2303 5-2:1.0: pl2303 converter detected
usb 5-2: pl2303 converter now attached to ttyUSB0
usbcore: registered new interface driver pl2303
pl2303: Prolific PL2303 USB to serial adaptor driver
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 19 us
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:319 
serial_write_room+0x4b/0x60 [usbserial]()
Modules linked in: pl2303 usbserial pcmcia bay intel_agp hci_usb
Pid: 7, comm: events/0 Not tainted 2.6.26-rc8-hh1 #1

Call Trace:
  [<ffffffff80232789>] warn_on_slowpath+0x51/0x8c
  [<ffffffff8022b11a>] check_preempt_wakeup+0xab/0xfa
  [<ffffffff8022a526>] try_to_wake_up+0x108/0x119
  [<ffffffff8022ecce>] hrtick_set+0x8b/0x10a
  [<ffffffff80229494>] __wake_up_common+0x46/0x75
  [<ffffffff8032e741>] __next_cpu+0x19/0x26
  [<ffffffffa001a54c>] :usbserial:serial_write_room+0x4b/0x60
  [<ffffffff8039b178>] opost+0x12/0x1c5
  [<ffffffff8039c6ea>] n_tty_receive_buf+0x2d3/0xda2
  [<ffffffff80331f0c>] rb_insert_color+0x66/0xe2
  [<ffffffff802470f3>] hrtimer_start+0x100/0x122
  [<ffffffff8020a6a1>] __switch_to+0xa0/0x37a
  [<ffffffff8022ece4>] hrtick_set+0xa1/0x10a
  [<ffffffff803977e7>] flush_to_ldisc+0x10e/0x1bf
  [<ffffffff803976d9>] flush_to_ldisc+0x0/0x1bf
  [<ffffffff802411e8>] run_workqueue+0x81/0x10d
  [<ffffffff8024134c>] worker_thread+0xd8/0xe7
  [<ffffffff80244638>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80241274>] worker_thread+0x0/0xe7
  [<ffffffff8024433b>] kthread+0x47/0x73
  [<ffffffff802304a7>] schedule_tail+0x27/0x5c
  [<ffffffff8020cf68>] child_rip+0xa/0x12
  [<ffffffff802442f4>] kthread+0x0/0x73
  [<ffffffff8020cf5e>] child_rip+0x0/0x12

---[ end trace 34089ea06d99be00 ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:306 serial_write+0x6c/0x89 
[usbserial]()
Modules linked in: pl2303 usbserial pcmcia bay intel_agp hci_usb
Pid: 7, comm: events/0 Tainted: G        W 2.6.26-rc8-hh1 #1

Call Trace:
  [<ffffffff80232789>] warn_on_slowpath+0x51/0x8c
  [<ffffffff8022b11a>] check_preempt_wakeup+0xab/0xfa
  [<ffffffff8022a526>] try_to_wake_up+0x108/0x119
  [<ffffffff8022ecce>] hrtick_set+0x8b/0x10a
  [<ffffffff80229494>] __wake_up_common+0x46/0x75
  [<ffffffffa001a5cd>] :usbserial:serial_write+0x6c/0x89
  [<ffffffff80396c3f>] tty_put_char+0x2b/0x2d
  [<ffffffff8039b317>] opost+0x1b1/0x1c5
  [<ffffffff8039c6ea>] n_tty_receive_buf+0x2d3/0xda2
  [<ffffffff80331f0c>] rb_insert_color+0x66/0xe2
  [<ffffffff802470f3>] hrtimer_start+0x100/0x122
  [<ffffffff8020a6a1>] __switch_to+0xa0/0x37a
  [<ffffffff8022ece4>] hrtick_set+0xa1/0x10a
  [<ffffffff803977e7>] flush_to_ldisc+0x10e/0x1bf
  [<ffffffff803976d9>] flush_to_ldisc+0x0/0x1bf
  [<ffffffff802411e8>] run_workqueue+0x81/0x10d
  [<ffffffff8024134c>] worker_thread+0xd8/0xe7
  [<ffffffff80244638>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80241274>] worker_thread+0x0/0xe7
  [<ffffffff8024433b>] kthread+0x47/0x73
  [<ffffffff802304a7>] schedule_tail+0x27/0x5c
  [<ffffffff8020cf68>] child_rip+0xa/0x12
  [<ffffffff802442f4>] kthread+0x0/0x73
  [<ffffffff8020cf5e>] child_rip+0x0/0x12

---[ end trace 34089ea06d99be00 ]---
------------[ cut here ]------------

WARNING: at drivers/usb/serial/usb-serial.c:319 
serial_write_room+0x4b/0x60 [usbserial]()
Modules linked in: pl2303 usbserial pcmcia bay intel_agp hci_usb
Pid: 7, comm: events/0 Tainted: G        W 2.6.26-rc8-hh1 #1

Call Trace:
  [<ffffffff80232789>] warn_on_slowpath+0x51/0x8c
  [<ffffffff80229b98>] __wake_up+0x38/0x4f
  [<ffffffff802417ad>] __queue_work+0x23/0x33
  [<ffffffff80241837>] queue_work+0x47/0x50
  [<ffffffffa0023699>] :pl2303:pl2303_write+0xf2/0xff
  [<ffffffffa001a54c>] :usbserial:serial_write_room+0x4b/0x60
  [<ffffffff8039b178>] opost+0x12/0x1c5
  [<ffffffff8039c6ea>] n_tty_receive_buf+0x2d3/0xda2
  [<ffffffff80331f0c>] rb_insert_color+0x66/0xe2
  [<ffffffff802470f3>] hrtimer_start+0x100/0x122
  [<ffffffff8020a6a1>] __switch_to+0xa0/0x37a
  [<ffffffff8022ece4>] hrtick_set+0xa1/0x10a
  [<ffffffff803977e7>] flush_to_ldisc+0x10e/0x1bf
  [<ffffffff803976d9>] flush_to_ldisc+0x0/0x1bf
  [<ffffffff802411e8>] run_workqueue+0x81/0x10d
  [<ffffffff8024134c>] worker_thread+0xd8/0xe7
  [<ffffffff80244638>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80241274>] worker_thread+0x0/0xe7
  [<ffffffff8024433b>] kthread+0x47/0x73
  [<ffffffff802304a7>] schedule_tail+0x27/0x5c
  [<ffffffff8020cf68>] child_rip+0xa/0x12
  [<ffffffff802442f4>] kthread+0x0/0x73
  [<ffffffff8020cf5e>] child_rip+0x0/0x12

---[ end trace 34089ea06d99be00 ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:306 serial_write+0x6c/0x89 
[usbserial]()
Modules linked in: pl2303 usbserial pcmcia bay intel_agp hci_usb
Pid: 7, comm: events/0 Tainted: G        W 2.6.26-rc8-hh1 #1

Call Trace:
  [<ffffffff80232789>] warn_on_slowpath+0x51/0x8c
  [<ffffffff80229b98>] __wake_up+0x38/0x4f
  [<ffffffff802417ad>] __queue_work+0x23/0x33
  [<ffffffff80241837>] queue_work+0x47/0x50
  [<ffffffffa0023699>] :pl2303:pl2303_write+0xf2/0xff
  [<ffffffffa001a5cd>] :usbserial:serial_write+0x6c/0x89
  [<ffffffff80396c3f>] tty_put_char+0x2b/0x2d
  [<ffffffff8039b317>] opost+0x1b1/0x1c5
  [<ffffffff8039c6ea>] n_tty_receive_buf+0x2d3/0xda2
  [<ffffffff80331f0c>] rb_insert_color+0x66/0xe2
  [<ffffffff802470f3>] hrtimer_start+0x100/0x122
  [<ffffffff8020a6a1>] __switch_to+0xa0/0x37a
  [<ffffffff8022ece4>] hrtick_set+0xa1/0x10a
  [<ffffffff803977e7>] flush_to_ldisc+0x10e/0x1bf
  [<ffffffff803976d9>] flush_to_ldisc+0x0/0x1bf
  [<ffffffff802411e8>] run_workqueue+0x81/0x10d
  [<ffffffff8024134c>] worker_thread+0xd8/0xe7
  [<ffffffff80244638>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80241274>] worker_thread+0x0/0xe7
  [<ffffffff8024433b>] kthread+0x47/0x73
  [<ffffffff802304a7>] schedule_tail+0x27/0x5c
  [<ffffffff8020cf68>] child_rip+0xa/0x12
  [<ffffffff802442f4>] kthread+0x0/0x73
  [<ffffffff8020cf5e>] child_rip+0x0/0x12

---[ end trace 34089ea06d99be00 ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:319 
serial_write_room+0x4b/0x60 [usbserial]()
Modules linked in: pl2303 usbserial pcmcia bay intel_agp hci_usb
Pid: 7, comm: events/0 Tainted: G        W 2.6.26-rc8-hh1 #1

Call Trace:
  [<ffffffff80232789>] warn_on_slowpath+0x51/0x8c
  [<ffffffffa00233eb>] :pl2303:pl2303_send+0x1b7/0x206
  [<ffffffffa0023699>] :pl2303:pl2303_write+0xf2/0xff
  [<ffffffffa001a54c>] :usbserial:serial_write_room+0x4b/0x60
  [<ffffffff8039b178>] opost+0x12/0x1c5
  [<ffffffff8039c6ea>] n_tty_receive_buf+0x2d3/0xda2
  [<ffffffff80331f0c>] rb_insert_color+0x66/0xe2
  [<ffffffff802470f3>] hrtimer_start+0x100/0x122
  [<ffffffff8020a6a1>] __switch_to+0xa0/0x37a
  [<ffffffff8022ece4>] hrtick_set+0xa1/0x10a
  [<ffffffff803977e7>] flush_to_ldisc+0x10e/0x1bf
  [<ffffffff803976d9>] flush_to_ldisc+0x0/0x1bf
  [<ffffffff802411e8>] run_workqueue+0x81/0x10d
  [<ffffffff8024134c>] worker_thread+0xd8/0xe7
  [<ffffffff80244638>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80241274>] worker_thread+0x0/0xe7
  [<ffffffff8024433b>] kthread+0x47/0x73
  [<ffffffff802304a7>] schedule_tail+0x27/0x5c
  [<ffffffff8020cf68>] child_rip+0xa/0x12
  [<ffffffff802442f4>] kthread+0x0/0x73
  [<ffffffff8020cf5e>] child_rip+0x0/0x12

---[ end trace 34089ea06d99be00 ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:306 serial_write+0x6c/0x89 
[usbserial]()
Modules linked in: pl2303 usbserial pcmcia bay intel_agp hci_usb
Pid: 7, comm: events/0 Tainted: G        W 2.6.26-rc8-hh1 #1

Call Trace:
  [<ffffffff80232789>] warn_on_slowpath+0x51/0x8c
  [<ffffffffa00233eb>] :pl2303:pl2303_send+0x1b7/0x206
  [<ffffffffa0023699>] :pl2303:pl2303_write+0xf2/0xff
  [<ffffffffa001a5cd>] :usbserial:serial_write+0x6c/0x89
  [<ffffffff80396c3f>] tty_put_char+0x2b/0x2d
  [<ffffffff8039b317>] opost+0x1b1/0x1c5
  [<ffffffff8039c6ea>] n_tty_receive_buf+0x2d3/0xda2
  [<ffffffff80331f0c>] rb_insert_color+0x66/0xe2
  [<ffffffff802470f3>] hrtimer_start+0x100/0x122
  [<ffffffff8020a6a1>] __switch_to+0xa0/0x37a
  [<ffffffff8022ece4>] hrtick_set+0xa1/0x10a
  [<ffffffff803977e7>] flush_to_ldisc+0x10e/0x1bf
  [<ffffffff803976d9>] flush_to_ldisc+0x0/0x1bf
  [<ffffffff802411e8>] run_workqueue+0x81/0x10d
  [<ffffffff8024134c>] worker_thread+0xd8/0xe7
  [<ffffffff80244638>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80241274>] worker_thread+0x0/0xe7
  [<ffffffff8024433b>] kthread+0x47/0x73
  [<ffffffff802304a7>] schedule_tail+0x27/0x5c
  [<ffffffff8020cf68>] child_rip+0xa/0x12
  [<ffffffff802442f4>] kthread+0x0/0x73
  [<ffffffff8020cf5e>] child_rip+0x0/0x12

---[ end trace 34089ea06d99be00 ]---
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 19 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 19 us
wlan0: RX too short data frame payload
wlan0: RX too short data frame payload
usb 5-2: uhci_result_common: failed with status 520000
usb 5-2: uhci_result_common: failed with status 440000
usb 5-2: uhci_result_common: failed with status 440000
usb 5-2: uhci_result_common: failed with status 440000
usb 5-2: uhci_result_common: failed with status 440000
usb 5-2: uhci_result_common: failed with status 440000
usb 5-2: uhci_result_common: failed with status 440000
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.0: port 2 portsc 0099,00
hub 5-0:1.0: port 2 enable change, status 00000101
hub 5-0:1.0: port 2 disabled by hub (EMI?), re-enabling...
hub 5-0:1.0: port 2, status 0101, change 0002, 12 Mb/s
usb 5-2: USB disconnect, address 2
usb 5-2: unregistering device
usb 5-2: usb_disable_device nuking all URBs
uhci_hcd 0000:00:1d.0: shutdown urb ffff81007c1579c0 ep1in-intr
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 19 us
usb 5-2: unregistering interface 5-2:1.0
pl2303 5-2:1.0: device disconnected
usb 5-2:1.0: uevent
usb 5-2: uevent
usb 5-2: new full speed USB device using uhci_hcd and address 3
usb 5-2: default language 0x0409
usb 5-2: uevent
usb 5-2: usb_probe_device
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: adding 5-2:1.0 (config #1, interface 0)
usb 5-2:1.0: uevent
usbserial_generic 5-2:1.0: usb_probe_interface
usbserial_generic 5-2:1.0: usb_probe_interface - got id
pl2303 5-2:1.0: usb_probe_interface
pl2303 5-2:1.0: usb_probe_interface - got id
pl2303 5-2:1.0: pl2303 converter detected
usb 5-2: pl2303 converter now attached to ttyUSB1
drivers/usb/core/inode.c: creating file '003'
usb 5-2: New USB device found, idVendor=067b, idProduct=2303
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: USB-Serial Controller
usb 5-2: Manufacturer: Prolific Technology Inc.
uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 1, phase 0, 19 us
pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:319 
serial_write_room+0x4b/0x60 [usbserial]()
Modules linked in: pl2303 usbserial pcmcia bay intel_agp hci_usb
Pid: 8, comm: events/1 Tainted: G        W 2.6.26-rc8-hh1 #1

Call Trace:
  [<ffffffff80232789>] warn_on_slowpath+0x51/0x8c
  [<ffffffff8021aad2>] apic_wait_icr_idle+0x16/0x1f
  [<ffffffff8022a526>] try_to_wake_up+0x108/0x119
  [<ffffffff80229494>] __wake_up_common+0x46/0x75
  [<ffffffff8032e741>] __next_cpu+0x19/0x26
  [<ffffffffa001a54c>] :usbserial:serial_write_room+0x4b/0x60
  [<ffffffff8039b178>] opost+0x12/0x1c5
  [<ffffffff8039c6ea>] n_tty_receive_buf+0x2d3/0xda2
  [<ffffffff8020a6a1>] __switch_to+0xa0/0x37a
  [<ffffffff8022ecce>] hrtick_set+0x8b/0x10a
  [<ffffffff803977e7>] flush_to_ldisc+0x10e/0x1bf
  [<ffffffff803976d9>] flush_to_ldisc+0x0/0x1bf
  [<ffffffff802411e8>] run_workqueue+0x81/0x10d
  [<ffffffff8024134c>] worker_thread+0xd8/0xe7
  [<ffffffff80244638>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80241274>] worker_thread+0x0/0xe7
  [<ffffffff8024433b>] kthread+0x47/0x73
  [<ffffffff802304a7>] schedule_tail+0x27/0x5c
  [<ffffffff8020cf68>] child_rip+0xa/0x12
  [<ffffffff802442f4>] kthread+0x0/0x73
  [<ffffffff8020cf5e>] child_rip+0x0/0x12

---[ end trace 34089ea06d99be00 ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:306 serial_write+0x6c/0x89 
[usbserial]()
Modules linked in: pl2303 usbserial pcmcia bay intel_agp hci_usb
Pid: 8, comm: events/1 Tainted: G        W 2.6.26-rc8-hh1 #1

Call Trace:
  [<ffffffff80232789>] warn_on_slowpath+0x51/0x8c
  [<ffffffff8021aad2>] apic_wait_icr_idle+0x16/0x1f
  [<ffffffff8022a526>] try_to_wake_up+0x108/0x119
  [<ffffffff80229494>] __wake_up_common+0x46/0x75
  [<ffffffffa001a5cd>] :usbserial:serial_write+0x6c/0x89
  [<ffffffff80396c3f>] tty_put_char+0x2b/0x2d
  [<ffffffff8039b317>] opost+0x1b1/0x1c5
  [<ffffffff8039c6ea>] n_tty_receive_buf+0x2d3/0xda2
  [<ffffffff8020a6a1>] __switch_to+0xa0/0x37a
  [<ffffffff8022ecce>] hrtick_set+0x8b/0x10a
  [<ffffffff803977e7>] flush_to_ldisc+0x10e/0x1bf
  [<ffffffff803976d9>] flush_to_ldisc+0x0/0x1bf
  [<ffffffff802411e8>] run_workqueue+0x81/0x10d
  [<ffffffff8024134c>] worker_thread+0xd8/0xe7
  [<ffffffff80244638>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80241274>] worker_thread+0x0/0xe7
  [<ffffffff8024433b>] kthread+0x47/0x73
  [<ffffffff802304a7>] schedule_tail+0x27/0x5c
  [<ffffffff8020cf68>] child_rip+0xa/0x12
  [<ffffffff802442f4>] kthread+0x0/0x73
  [<ffffffff8020cf5e>] child_rip+0x0/0x12

---[ end trace 34089ea06d99be00 ]---
uhci_hcd 0000:00:1d.0: release dev 3 ep81-INT, period 1, phase 0, 19 us
wlan0: RX too short data frame payload

(64-bit SMP core2duo laptop, voluntary preempt. dell latitude D830)

Helge Hafting

