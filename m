Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbXFZQxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbXFZQxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbXFZQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:53:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:54905 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072AbXFZQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:53:47 -0400
Message-ID: <46814498.6000002@anagramm.de>
Date: Tue, 26 Jun 2007 18:53:44 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: no luck with DMC TSC-10 touchscreen on USB
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1+b0Kh6jzm1qnWE9fUhBHu+cfSuEydQdXsAl+j
 jNFBcdH5k6VEz6IUpMnoP8d2LxgWYkiOTCG0Wh9V5XDR2K32T3
 cCHPlhRjpY+QR32U46WNQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm writing this to lkml since the linux-usb-users list seems to be stuck
in spam and I didn't receive an answer during the last week.

I have a DMC TSC-103 touchscreen controller on a ISP1563 EHCI/OHCI USB controller
on PCI on an MPC8540 PowerPC. The USB controller is working fine with some mice and keyboards.
The touchscreen itself is also working when I plug it to some other proprietary PC. ;-)
So, the hardware is okay.

Now, the interesting part is:
When I don't add a specific rule to udev and I connect the touchscreen to an USB port,
lsusb shows the TSC-10 as 0afa:03e8, which is correct:
$ lsusb
Bus 2 Device 1: ID 0000:0000
Bus 1 Device 1: ID 0000:0000
Bus 3 Device 5: ID 0afa:03e8
Bus 3 Device 1: ID 0000:0000

When I add
$ cat /etc/udev/rules.d/10-local.rules
BUS=="usb", SYSFS{manufacturer}=="TSC-10 DM", NAME="input/touch"

and unplug/plug the touchscreen, I get indeed a device /dev/input/touch:
$ ls -l /dev/input/
total 0
crw-r--r-- 1 root root  13, 63 Jan  1  1970 mice
crw-rw---- 1 root root 253,  7 Jun 26 18:28 touch

BUT the touchscreen disappears from
$ lsusb
Bus 2 Device 1: ID 0000:0000
Bus 1 Device 1: ID 0000:0000
Bus 3 Device 1: ID 0000:0000

Why does the device disappear from the lsusb output? *confused*

When I want to open /dev/input/touch to dump it's events to the console, it
just:
$ evdump /dev/input/touch
Cannot open device file!
Error: No such device or addres


When I connect some ImPS/2 mouse to the USB, it shows up as

$ lsusb
Bus 2 Device 1: ID 0000:0000
Bus 1 Device 1: ID 0000:0000
Bus 3 Device 28: ID 045e:0095 Kleinweich Corp.
Bus 3 Device 1: ID 0000:0000

$ ls -l /dev/input/
total 0
crw------- 1 root root 13,  64 Jun 26 18:30 event0
crw-r--r-- 1 root root 13,  63 Jan  1  1970 mice
crw-r--r-- 1 root root 13,  32 Jun 26 18:30 mouse0
crw-r--r-- 1 root root 13, 128 Jun 26 18:30 ts0

$ evdump /dev/input/event0
value 1, type 2, code 0
value 0, type 0, code 0
value 1, type 2, code 0
value -1, type 2, code 1
value 0, type 0, code 0
value 1, type 2, code 0
value 0, type 0, code 0
[...]

...it just works.


So, how do I get a working device node when I plug the TSC-10 to USB?
How can I interface to that touchscreen's device event interface?
(I want to get it working in X as a second pointing device along with the
mouse...)

The kernel's usbtouchscreen.c should support that hardware since about 2.6.18.
I am quite sure I am missing something very basic, here...

Thank you in advance!

------------------
Here are some more details:

$ cat evdump.c

#include <stdio.h>
#include <stdlib.h>
#include <linux/input.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
         int evfd;
         struct input_event ev;

         /* one arg: device name */
         if (argc != 2) {
                 fprintf(stderr, "Usage %s <device>!\n", argv[0]);
                 return 1;
         }

         /*evfd = open(argv[1], O_RDONLY | O_NONBLOCK);*/
         evfd = open(argv[1], O_RDONLY);
         if (evfd == -1) {
                 fprintf(stderr, "Cannot open device file!\n");
                 perror("Error");
                 return 1;
         }

         while(1) {
                 read(evfd, &ev, sizeof(struct input_event));
                 printf("value %d, type %d, code %d\n",ev.value,ev.type,ev.code);
         }

         return 0;
}

$ uname -a
Linux fox 2.6.21.5 #2 Thu Jun 28 19:54:40 CEST 2007 ppc e500 GNU/Linux

$ cat /proc/cpuinfo
processor       : 0
cpu             : e500
revision        : 2.0 (pvr 8020 0020)
bogomips        : 831.48
chipset         : 8540
Vendor          : Freescale Semiconductor
Machine         : mpc8540ads
clock           : 833MHz
PVR             : 0x80200020
SVR             : 0x80300020
PLL setting     : 0x5
Memory          : 256 MB

$ gzip -c -d /proc/config.gz | grep "TOUCH"
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_UCB1400 is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_TOUCHSCREEN=y
# CONFIG_USB_TOUCHSCREEN_EGALAX is not set
# CONFIG_USB_TOUCHSCREEN_PANJIT is not set
# CONFIG_USB_TOUCHSCREEN_3M is not set
# CONFIG_USB_TOUCHSCREEN_ITM is not set
# CONFIG_USB_TOUCHSCREEN_ETURBO is not set
# CONFIG_USB_TOUCHSCREEN_GUNZE is not set
CONFIG_USB_TOUCHSCREEN_DMC_TSC10=y
# CONFIG_USB_APPLETOUCH is not set

$ gzip -c -d /proc/config.gz | grep "INPUT"
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=640
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=480
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_TSDEV=y
CONFIG_INPUT_TSDEV_SCREEN_X=640
CONFIG_INPUT_TSDEV_SCREEN_Y=480
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=m
CONFIG_INPUT_KEYBOARD=y
CONFIG_INPUT_MOUSE=y
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_INPUT_MISC is not set
# CONFIG_USB_HIDINPUT_POWERBOOK is not set

$ udevinfo -V
udevinfo, version 096

$ udevinfo -a -p /sys/devices/pci0000:00/0000:00:14.1/usb3/3-1

Udevinfo starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.

   looking at device '/devices/pci0000:00/0000:00:14.1/usb3/3-1':
     KERNEL=="3-1"
     SUBSYSTEM=="usb"
     SYSFS{manufacturer}=="TSC-10 DM"
     SYSFS{quirks}=="0x0"
     SYSFS{maxchild}=="0"
     SYSFS{version}==" 1.00"
     SYSFS{devnum}=="24"
     SYSFS{speed}=="1.5"
     SYSFS{bMaxPacketSize0}=="8"
     SYSFS{bNumConfigurations}=="1"
     SYSFS{bDeviceProtocol}=="ff"
     SYSFS{bDeviceSubClass}=="00"
     SYSFS{bDeviceClass}=="ff"
     SYSFS{bcdDevice}=="0110"
     SYSFS{idProduct}=="03e8"
     SYSFS{idVendor}=="0afa"
     SYSFS{bMaxPower}=="100mA"
     SYSFS{bmAttributes}=="a0"
     SYSFS{bConfigurationValue}=="1"
     SYSFS{bNumInterfaces}==" 1"
     SYSFS{configuration}==""

   looking at parent device '/devices/pci0000:00/0000:00:14.1/usb3':
     ID=="usb3"
     BUS=="usb"
     DRIVER=="usb"
     SYSFS{serial}=="0000:00:14.1"
     SYSFS{product}=="OHCI Host Controller"
     SYSFS{manufacturer}=="Linux 2.6.21.5 ohci_hcd"
     SYSFS{quirks}=="0x0"
     SYSFS{maxchild}=="2"
     SYSFS{version}==" 1.10"
     SYSFS{devnum}=="1"
     SYSFS{speed}=="12"
     SYSFS{bMaxPacketSize0}=="64"
     SYSFS{bNumConfigurations}=="1"
     SYSFS{bDeviceProtocol}=="00"
     SYSFS{bDeviceSubClass}=="00"
     SYSFS{bDeviceClass}=="09"
     SYSFS{bcdDevice}=="0206"
     SYSFS{idProduct}=="0000"
     SYSFS{idVendor}=="0000"
     SYSFS{bMaxPower}=="  0mA"
     SYSFS{bmAttributes}=="e0"
     SYSFS{bConfigurationValue}=="1"
     SYSFS{bNumInterfaces}==" 1"
     SYSFS{configuration}==""

   looking at parent device '/devices/pci0000:00/0000:00:14.1':
     ID=="0000:00:14.1"
     BUS=="pci"
     DRIVER=="ohci_hcd"
     SYSFS{msi_bus}==""
     SYSFS{broken_parity_status}=="0"
     SYSFS{enable}=="1"
     SYSFS{modalias}=="pci:v00001131d00001561sv00001131sd00001561bc0Csc03i10"
     SYSFS{local_cpus}=="1"
     SYSFS{irq}=="51"
     SYSFS{class}=="0x0c0310"
     SYSFS{subsystem_device}=="0x1561"
     SYSFS{subsystem_vendor}=="0x1131"
     SYSFS{device}=="0x1561"
     SYSFS{vendor}=="0x1131"

   looking at parent device '/devices/pci0000:00':
     ID=="pci0000:00"
     BUS==""
     DRIVER==""

-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
