Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbZF2UQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbZF2UQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZF2UQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:16:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36939 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751772AbZF2UQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:16:18 -0400
Date: Mon, 29 Jun 2009 16:16:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Meyer <thomas@m3y3r.de>
cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
In-Reply-To: <1246299186.15821.19.camel@localhost>
Message-ID: <Pine.LNX.4.44L0.0906291558441.17436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Thomas Meyer wrote:

> > > T:  Bus=01 Lev=01 Prnt=01 Port=05 Cnt=02 Dev#= 47 Spd=480 MxCh= 4
> > > D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=02 MxPS=64 #Cfgs=  1
> > > P:  Vendor=04b4 ProdID=6560 Rev= 0.09
> > > C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=100mA
> > > I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=01 Driver=hub
> > > E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms
> > > I:* If#= 0 Alt= 1 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=02 Driver=hub
> > > E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms
> > 
> > This a separate (not built into the keyboard) powered hub, right?
> 
> Yes. And this thing seems to be responsible for the instant resume. Not
> using a USB 2.0 hub, than the problem doesn't occur any more!

> > If you unplug the keyboard but leave the mouse attached, do you still 
> > get the immediate resumes?
> 
> Yes. But not using a USB 2.0 hub, the problem goes away.

It could be a problem with the hub.  But it's worth noting that when 
you don't use the hub, your mouse and your keyboard end up using the 
OHCI controller instead of the EHCI controller.  So it still might be a 
controller issue.

> I guess the USB 2.0 hub does something differently than expected?!
> Hardware bug or linux bug? (But re-plugging the mouse into the USB 2.0
> hub, makes resume work again! Strange, mhh?)

I'd say that takes Linux off the hook.  The OS doesn't distinguish 
between the first mouse-plug-in and the second.  So most likely it's a 
bug in the hub -- but it's hard to be certain.

A good test would be to take the hub, keyboard, and mouse over to a 
different Linux computer and see what happens there.

Another test is to put the hub back in its old place with the keyboard
and mouse (but unplug the Broadcom) and then do:

	echo off >/sys/bus/usb/devices/1-6.2/power/level
	echo off >/sys/bus/usb/devices/1-6.3/power/level

This will cause the keyboard and mouse to be suspended, and a few
seconds later the hub and the root hub will suspend as well.  Repeat 
the commands with "on" instead of "off" to power the devices back on.  
The usbmon log for this test might be interesting.


> My current working setup involves no USB 2.0 hub and it's:
> 
> T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh=10
> B:  Alloc= 39/900 us ( 4%), #Int=  3, #Iso=  0
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 2.06
> S:  Manufacturer=Linux 2.6.30 ohci_hcd
> S:  Product=OHCI Host Controller
> S:  SerialNumber=0000:00:02.0
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
> 
> T:  Bus=02 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  4 Spd=1.5 MxCh= 0
> D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> P:  Vendor=413c ProdID=2003 Rev= 1.00
> S:  Manufacturer=DELL
> S:  Product=DELL USB Keyboard
> C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
> E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
> I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
> E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
> 
> T:  Bus=02 Lev=01 Prnt=01 Port=05 Cnt=02 Dev#=  5 Spd=1.5 MxCh= 0
> D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> P:  Vendor=045e ProdID=0029 Rev= 1.08
> S:  Manufacturer=Microsoft
> S:  Product=Microsoft IntelliMouse® Optical
> C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
> E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=10ms
> 
> T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh=10
> B:  Alloc=  0/800 us ( 0%), #Int=  1, #Iso=  0
> D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0002 Rev= 2.06
> S:  Manufacturer=Linux 2.6.30 ehci_hcd
> S:  Product=EHCI Host Controller
> S:  SerialNumber=0000:00:02.1
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms
> 
> T:  Bus=01 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#= 23 Spd=480 MxCh= 0
> D:  Ver= 2.00 Cls=02(comm.) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=0411 ProdID=00bc Rev= 0.06
> S:  Manufacturer=Broadcom
> S:  Product=WLI-U2-KG125S
> S:  SerialNumber=8057
> C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=02 Prot=ff Driver=rndis_wlan
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_wlan
> E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=125us

Would you like to send a usbmon log showing a suspend/resume cycle with 
this setup (but unplug the Broadcom device first)?

Alan Stern

