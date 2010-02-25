Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814Ab0BYVF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:05:56 -0500
Received: from perec.tyrell.hu ([66.197.149.104]:50540 "EHLO perec.tyrell.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933645Ab0BYVFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:05:55 -0500
Message-ID: <4B86E62E.3090606@maroy.hu>
Date: Thu, 25 Feb 2010 22:05:50 +0100
From: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Sarah Sharp <sarah.a.sharp@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device 8087:0020
References: <Pine.LNX.4.44L0.1002251239140.1686-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002251239140.1686-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> It is the driver for USB-3.0 controllers.  It's relatively new and not 
> as mature as the USB-2.0 drivers.
> 
> I'm a little surprised that it is running on your system.  Why would 
> you have USB-3.0 hardware?

I might - this is a brand new HP Envy 15 laptop, which seems to be 'too
new' for Linux in a number of ways (e.g. video card, with the latest
10.2 official AMD binary driver 'sort of' working, hardware raid
controller for SSD, which only the mainline grub can handle, WiFi card
that is only supported in 2.6.32.x, etc.)

actually, it has 3 USB ports - two of them seem to have these issues.
the third USB port, which is phyisically both a USB and en eSATA port,
seems to work as expected.

> This is something Sarah should look into.  She's the main developer 
> behind xhci-hcd.

thanks for CC'ing her in..


Sarah Sharp wrote:
> USB 3.0 hosts and devices are now available commercially.  I think the
> HP envy laptop has an integrated USB 3.0 host.  Ákos, which host
> controller do you have?  Is it a PCIe add-in card, a PCI express card,
> or a port on a laptop?

see above, these are two ports on the side of the laptop.

> The xHCI driver doesn't support PCI suspend, and it also doesn't support
> suspending devices under the xHCI host.  The xHCI hardware needs to do
> some extra work when a device is suspended, and I haven't added that API
> to the USB core yet.  In short, power management sucks under xHCI. :-/

for suspend, I seem to get along find with unloading / reloading the
xhci kernel module, as a workaround

> Oh, freezes are not good.  I wonder if the xHCI host is taking a long
> time to respond to a hardware command?  Can you turn on
> CONFIG_USB_XHCI_HCD_DEBUGGING and send me the dmesg when you plug in the
> device?

ok, I'll do that..

> Did you plug in the DVD device behind a USB hub?  Or is the hub a part
> of the device?

I didn't use a USB hub. I plugged in the USB DVD right into the USB port
on the laptop. the HP Envy 15 does not have a built-in optical drive,
but you can order an external USB DVD-RW drive as an option. this is
what I have.

> That looks like a rather long polling interval.  Can you post the output
> of `lsusb -vvv -d 058f:6254`?

sure, here you go:

# lsusb -vvv -d 058f:6254

Bus 002 Device 002: ID 058f:6254 Alcor Micro Corp. USB Hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  idVendor           0x058f Alcor Micro Corp.
  idProduct          0x6254 USB Hub
  bcdDevice            1.00
  iManufacturer           0
  iProduct                0
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             3
  wHubCharacteristic 0x0080
    Ganged power switching
    Ganged overcurrent protection
    TT think time 8 FS bits
    Port indicators
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent    100 milli Ampere
  DeviceRemovable    0x02
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0503 highspeed power enable connect
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0001
  Self Powered



though let me remind you that the same long delay happens when I plug in
other devices, like simple USB mice. also, if I plug in the same device
into the third USB port, it seems to work just fine. no 5 second freeze,
etc.

> Can you read the DVD at this point?

yes, after the first plug, it works as expected. after the unplug -
replug, it doesn't work. unless I unload the xhci module, and reload it.

> Did you unmount the DVD before you removed it?  I'm not sure what the
> VFS errors are, but it looks like VFS doesn't like you removing the
> disk.

IMHO it got automatically mounted by gnome... (I saw it on my desktop as
a DVD drive)


Alan Stern wrote:
> You must have plugged it into a different port this time, yes?

I might have used the different of the two proplematic USB ports..


Sarah Sharp wrote:
> True.  I can't tell exactly what's going on without
> CONFIG_USB_XHCI_HCD_DEBUGGING.  It's possible the xHCI host never
> notified the driver of the disconnect, or there's a bug in the xHCI hub
> emulation code.

I'm recompiling the kernel with the above configuration setting, and
will send you an output..

thanks for spending time on this issue...


BTW, any ideas on why suspend works with unloading xhci, but hibernate
not working?


Akos

