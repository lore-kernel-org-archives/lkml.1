Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYFVRmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYFVRmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 13:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYFVRl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 13:41:57 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:41047 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYFVRl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 13:41:56 -0400
Message-ID: <485E8F05.3020406@keyaccess.nl>
Date: Sun, 22 Jun 2008 19:42:29 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Stefan Becker <Stefan.Becker@nokia.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
References: <485E8403.1050301@nokia.com>
In-Reply-To: <485E8403.1050301@nokia.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-06-08 18:55, Stefan Becker wrote:

Only adding Alan Stern to the CC...

> Hi,
> 
> [I'm not subscribed to this list, so please CC: me when you answer]
> 
> I get random machine lockups when accessing my USB harddrive with 
> kernels 2.6.24/25. They don't occur with kernel 2.6.23. During testing I 
> figured out that it has something to do with the USB Bluetooth adaptor. 
> If I remove it before the testing I don't get any lockups.
> 
> git bisect resulted in the following bad commit:
> 
> e9df41c5c5899259541dc928872cad4d07b82076 is first bad commit
> commit e9df41c5c5899259541dc928872cad4d07b82076
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Wed Aug 8 11:48:02 2007 -0400
> 
>     USB: make HCDs responsible for managing endpoint queues
> 
>     This patch (as954) implements a suggestion of David Brownell's.  Now
>     the host controller drivers are responsible for linking and unlinking
>     URBs to/from their endpoint queues.  This eliminates the possiblity of
>     strange situations where usbcore thinks an URB is linked but the HCD
>     thinks it isn't.  It also means HCDs no longer have to check for URBs
>     being dequeued before they were fully enqueued.
> [TRUNCATED...]
> 
> 
> I've attached the kernel configuration.
> 
> Test procedure:
> 
> - boot test kernel in single user mode
> - "service rsyslog start"
> - "service messagebus start"
> - "service bluetooth start"
> - connect USB drive
> - "mount /dev/sdb1 /mnt"
> - "dd if=/dev/zero of=/mnt/test bs=10M"
>   BAD: lockup, GOOD: writes until partition is full
> 
> 
> 
> My USB hardware:
> 
> Bus 001 Device 006: ID 04b4:6830 Cypress Semiconductor Corp. USB-2.0 IDE 
> Adapter
> Bus 001 Device 001: ID 1d6b:0002
> Bus 003 Device 002: ID 046d:c001 Logitech, Inc. N48/M-BB48 [FirstMouse 
> Plus]
> Bus 003 Device 001: ID 1d6b:0001
> Bus 002 Device 003: ID 050d:0081 Belkin Components FBT001v2 Bluetooth
> Bus 002 Device 001: ID 1d6b:0001
> 
> 
> My USB controllers:
> 
> $ /sbin/lspci | fgrep USB
> 00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
> Controller (rev 80)
> 00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
> Controller (rev 80)
> 00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82)
> 
> 
> /proc/usb/devices:
> T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
> B:  Alloc= 11/900 us ( 1%), #Int=  1, #Iso=  0
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 2.06
> S:  Manufacturer=Linux 2.6.25.4-10.fc8 uhci_hcd
> S:  Product=UHCI Host Controller
> S:  SerialNumber=0000:00:10.1
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
> 
> T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
> D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> P:  Vendor=046d ProdID=c001 Rev= 4.10
> S:  Manufacturer=Logitech
> S:  Product=USB Mouse
> C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr= 50mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
> E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=10ms
> 
> T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
> B:  Alloc= 45/900 us ( 5%), #Int=  1, #Iso=  1
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 2.06
> S:  Manufacturer=Linux 2.6.25.4-10.fc8 uhci_hcd
> S:  Product=UHCI Host Controller
> S:  SerialNumber=0000:00:10.0
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
> 
> T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  3 Spd=12  MxCh= 0
> D:  Ver= 1.10 Cls=e0(unk. ) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=050d ProdID=0081 Rev= 8.28
> C:* #Ifs= 3 Cfg#= 1 Atr=c0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:* If#= 1 Alt= 2 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> I:* If#= 2 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=00 Driver=(none)
> 
> T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 4
> B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
> D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0002 Rev= 2.06
> S:  Manufacturer=Linux 2.6.25.4-10.fc8 ehci_hcd
> S:  Product=EHCI Host Controller
> S:  SerialNumber=0000:00:10.3
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms
> 
> T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  6 Spd=480 MxCh= 0
> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=04b4 ProdID=6830 Rev= 0.01
> S:  Manufacturer=Cypress Semiconductor
> S:  Product=USB2.0 Storage Device
> S:  SerialNumber=DEF107679C83
> C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
> E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> 
> Regards,
> 
>     Stefan
> 
> ---
> Stefan Becker
> E-Mail: Stefan.Becker@nokia.com
